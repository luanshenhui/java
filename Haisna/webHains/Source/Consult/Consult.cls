VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "Consult"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
'########################################
'管理番号：SL-HS-Y0101-002
'修正日  ：2010.08.30
'担当者  ：FJTH)KOMURO
'修正内容：オラクルセッション対応
'########################################
'----------------------------
'修正履歴
'----------------------------
'管理番号：SL-SN-Y0101-612
'修正日　：2013.3.1
'担当者  ：T.Takagi@RD
'修正内容：予約確認メール送信機能追加

Option Explicit

Implements ObjectControl

Private mobjContext             As ObjectContext            'オブジェクトコンテキスト

Private mobjOraSession          As OraSession               'OraSessionオブジェクト
Private mobjOraDb               As OraDatabase              'OraDatabaseオブジェクト

'表示順（受診者一覧（結果入力））
Private Const SORT_DAYID        As String = ""              '当日ＩＤ順
Private Const SORT_BRE_FILMNO   As String = "1"             '胸部フィルム番号順
Private Const SORT_STO_FILMNO   As String = "2"             '胃部フィルム番号順
Private Const SORT_PERID        As String = "3"             '個人ＩＤ順

Private Const BRE_FILMNO_KEY    As String = "BRE_FILMNO"    '胸部フィルム番号
Private Const STO_FILMNO_KEY    As String = "STO_FILMNO"    '胃部フィルム番号

Private Const GRPCD_KEY         As String = "GRPCD"
Private Const JUDCLASSCD_KEY    As String = "JUDCLASSCD"
Private Const PROGRESSCD_KEY    As String = "PROGRESSCD"

'汎用データ抽出検査項目指定モード
Private Const CASE_NOTSELECT    As String = "notselect"     '検査結果を抽出しない
Private Const CASE_ALLSELECT    As String = "allselect"     'すべての検査結果を抽出する
Private Const CASE_SELECT       As String = "select"        '抽出する項目を指定する

'汎用データ抽出指定条件記号
Private Const OPTION_EQ         As String = "1"             '｢と同じ｣
Private Const OPTION_GE         As String = "2"             '｢以上｣
Private Const OPTION_LE         As String = "3"             '｢以下｣

'受診者一覧の表示列情報
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'Private Const COL_TIMEFRA       As Long = 1                 '時間枠
'## 2003.11.18 Del End
Private Const COL_DAYID         As Long = 2                 '当日ＩＤ
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'Private Const COL_CNTLNO        As Long = 3                 '管理番号
'## 2003.11.18 Del End
Private Const COL_COURSE        As Long = 4                 'コース
Private Const COL_NAME          As Long = 5                 '氏名
Private Const COL_KANANAME      As Long = 6                 'カナ氏名
Private Const COL_GENDER        As Long = 7                 '性別
Private Const COL_BIRTH         As Long = 8                 '生年月日
Private Const COL_AGE           As Long = 9                 '受診時年齢
Private Const COL_ORGSNAME      As Long = 10                '団体略称
Private Const COL_RSVNO         As Long = 11                '予約番号
Private Const COL_CSLDATE       As Long = 12                '受診日
Private Const COL_RSVDATE       As Long = 13                '予約日
Private Const COL_ADDITEM       As Long = 14                '追加検査
Private Const COL_RPTDATE       As Long = 15                '受付日
Private Const COL_BOTHNAME      As Long = 16                '個人名称
Private Const COL_PERID         As Long = 17                '個人ＩＤ
Private Const COL_CONSULTITEM   As Long = 18                '受診項目
Private Const COL_ISRSIGN       As Long = 22                '健保記号
Private Const COL_ISRNO         As Long = 23                '健保番号
Private Const COL_SUBCOURSE     As Long = 32                'サブコース
Private Const COL_ENTRY         As Long = 35                '結果入力状態
Private Const COL_RSVSTATUS     As Long = 36                '予約状況
Private Const COL_CARDPRINTDATE As Long = 37                '確認はがき出力日
Private Const COL_FORMPRINTDATE As Long = 38                '一式書式出力日
Private Const COL_RSVGRP        As Long = 39                '予約群
Private Const COL_HASFRIENDS    As Long = 40                'お連れ様の有無

Private Const PREFIX_RSVNO      As String = "RSVNO:"        '検索時の予約番号指定
Private Const PREFIX_PERID      As String = "ID:"           '検索時の個人ＩＤ指定
Private Const PREFIX_BIRTH      As String = "BIRTH:"        '検索時の生年月日指定
'## 2004.01.03 Add By T.Takagi@FSIT 当日ID検索機能追加
Private Const PREFIX_DAYID      As String = "DID:"          '検索時の当日ＩＤ指定
'## 2004.01.03 Add End

'## 2006.08.03 Add By 張 ＯＣＲ番号、ロッカー番号検索機能追加 Start ##
Private Const PREFIX_OCRNO      As String = "OCR:"          '検索時のＯＣＲ番号指定
Private Const PREFIX_LOCKERKEY  As String = "KEY:"          '検索時のロッカー番号指定
'## 2006.08.03 Add By 張 ＯＣＲ番号、ロッカー番号検索機能追加 End   ##


'コンピュータ名を取得する関数の宣言
Private Declare Function GetComputerName Lib "kernel32.dll" Alias "GetComputerNameA" (ByVal lpBuffer As String, nSize As Long) As Long

'## 2003.11.22 Add by K.Kagawa@FFCS
Private Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)
'## 2003.11.22 Add End

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

'## 2004.01.03 Add By T.Takagi@FSIT 当日ID検索機能追加
'
' 機能　　 : 当日ＩＤ条件節の追加
'
' 引数　　 : (In/Out) vntCondition   条件節の集合
' 　　　　   (In)     strBuffer      検索キー
' 　　　　   (In)     lngParamNo     パラメータ番号
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub AppendCondition_DayId(ByRef vntCondition As Variant, ByVal strBuffer As String, ByVal lngParamNo As Long)

    Dim objCommon       As Common           '共通クラス
    Dim strStmt         As String           'SQLステートメント
    Dim strDayId        As String           '個人ＩＤ

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strParamName    As String           'パラメータ名

    '共通クラスのインスタンス作成
    Set objCommon = CreateObject("HainsCommon.Common")

    '先頭４文字が"DID:"である場合は先頭部を取り除いた部分を当日ＩＤとして取得、それ以外は引数値をそのまま使用
    If UCase(Left(strBuffer, Len(PREFIX_DAYID))) = PREFIX_DAYID Then
        strDayId = Right(strBuffer, Len(strBuffer) - Len(PREFIX_DAYID))
    Else
        strDayId = strBuffer
    End If

    'パラメータ追加
    strParamName = "DAYID" & CStr(lngParamNo)
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add strParamName, CLng(strDayId), ORAPARM_INPUT, ORATYPE_NUMBER

    '条件節の編集
    strStmt = "RECEIPT.DAYID = :" & strParamName

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
    Dim strParamName2   As String           'パラメータ名
    
    Dim objCommon       As Common           '共通クラス
    Dim strStmt         As String           'SQLステートメント

    '共通クラスのインスタンス作成
    Set objCommon = CreateObject("HainsCommon.Common")

    '男性指定か女性指定か？
    Select Case UCase(strBuffer)
        
        Case "M", "F"
    
            'パラメータ追加
            strParamName = "PERID" & CStr(lngParamNo)
            strParamName2 = "GENDER" & CStr(lngParamNo)
            Set objOraParam = mobjOraDb.Parameters
            objOraParam.Add strParamName, strBuffer, ORAPARM_INPUT, ORATYPE_VARCHAR2
            objOraParam.Add strParamName2, IIf(UCase(strBuffer) = "M", GENDER_MALE, GENDER_FEMALE), ORAPARM_INPUT, ORATYPE_NUMBER
    
            strStmt = "( PERSON.PERID = :" & strParamName & " OR PERSON.GENDER = :" & strParamName2 & ")"
    
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
    strStmt = "( CONSULT.ISRSIGN = :" & strIsrSign & " AND CONSULT.ISRNO = :" & strIsrNo & ")"
        
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

    '共通クラスのインスタンス作成
    Set objCommon = CreateObject("HainsCommon.Common")

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
    objCommon.AppendArray vntCondition, strStmt
    
End Sub
'## 2006.08.03 Add By 張 ＯＣＲ番号検索機能追加 Start ##
'
' 機能　　 : ＯＣＲ番号条件節の追加
'
' 引数　　 : (In/Out) vntCondition  条件節の集合
' 　　　　   (In)     strBuffer     検索キー
' 　　　　   (In)     lngParamNo    パラメータ番号
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub AppendCondition_OcrNo(ByRef vntCondition As Variant, ByVal strBuffer As String, ByVal lngParamNo As Long)

    Dim objCommon       As Common           '共通クラス
    Dim strStmt         As String           'SQLステートメント
    Dim strOcrNo        As String           'ＯＣＲ番号

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strParamName    As String           'パラメータ名

    '共通クラスのインスタンス作成
    Set objCommon = CreateObject("HainsCommon.Common")

    '先頭４文字が"OCR:"である場合は先頭部を取り除いた部分をＯＣＲ番号として取得、それ以外は引数値をそのまま使用
    If UCase(Left(strBuffer, Len(PREFIX_OCRNO))) = PREFIX_OCRNO Then
        strOcrNo = Right(strBuffer, Len(strBuffer) - Len(PREFIX_OCRNO))
    Else
        strOcrNo = strBuffer
    End If

    'パラメータ追加
    strParamName = "OCRNO" & CStr(lngParamNo)
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add strParamName, "", ORAPARM_INPUT, ORATYPE_VARCHAR2

    objOraParam(strParamName).Value = Trim(strOcrNo)
    strStmt = "RECEIPT.OCRNO = :" & strParamName
    
    '配列に追加
    objCommon.AppendArray vntCondition, strStmt
    
End Sub
'## 2006.08.03 Add By 張 ロッカー番号検索機能追加 Start ##

'
' 機能　　 : ロッカー番号条件節の追加
'
' 引数　　 : (In/Out) vntCondition  条件節の集合
' 　　　　   (In)     strBuffer     検索キー
' 　　　　   (In)     lngParamNo    パラメータ番号
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub AppendCondition_LockerKey(ByRef vntCondition As Variant, ByVal strBuffer As String, ByVal lngParamNo As Long)

    Dim objCommon       As Common           '共通クラス
    Dim strStmt         As String           'SQLステートメント
    Dim strLockerKey     As String           'ロッカー番号

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strParamName    As String           'パラメータ名

    '共通クラスのインスタンス作成
    Set objCommon = CreateObject("HainsCommon.Common")

    '先頭４文字が"KEY:"である場合は先頭部を取り除いた部分をロッカー番号として取得、それ以外は引数値をそのまま使用
    If UCase(Left(strBuffer, Len(PREFIX_LOCKERKEY))) = PREFIX_LOCKERKEY Then
        strLockerKey = Right(strBuffer, Len(strBuffer) - Len(PREFIX_LOCKERKEY))
    Else
        strLockerKey = strBuffer
    End If

    'パラメータ追加
    strParamName = "LOCKERKEY" & CStr(lngParamNo)
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add strParamName, "", ORAPARM_INPUT, ORATYPE_VARCHAR2

    objOraParam(strParamName).Value = Trim(strLockerKey)
    strStmt = "RECEIPT.LOCKERKEY = :" & strParamName
    
    '配列に追加
    objCommon.AppendArray vntCondition, strStmt
    
End Sub

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
    objOraParam.Add strParamName, strBuffer & "%", ORAPARM_INPUT, ORATYPE_VARCHAR2
        
    '複合検索を行う場合はさらにパラメータ追加
    If blnRomeNameMultiple Then
        strParamName2 = "PARTNAME" & CStr(lngParamNo)
        objOraParam.Add strParamName2, strBuffer2 & "%", ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
        
    '複合検索を行わない場合
    If Not blnRomeNameMultiple Then
            
        'パラメータ値の完全一致検索のみ
        strStmt = "PERSON.ROMENAME LIKE :" & strParamName
            
    '複合検索を行う場合
    Else
    
        'パラメータ値の完全一致検索あるいは部分文字列検索
        strStmt = "( PERSON.ROMENAME LIKE :" & strParamName & " OR PERSON.SEARCHRNAME LIKE :" & strParamName2 & " )"
    
    End If
    
    '配列に追加
    Set objCommon = CreateObject("HainsCommon.Common")
    objCommon.AppendArray vntCondition, strStmt
    
    Set objCommon = Nothing
    Set objOraParam = Nothing
        
End Sub

'
' 機能　　 : 予約番号条件節の追加
'
' 引数　　 : (In/Out) vntCondition  条件節の集合
' 　　　　   (In)     strBuffer     検索キー
' 　　　　   (In)     lngParamNo    パラメータ番号
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub AppendCondition_RsvNo(ByRef vntCondition As Variant, ByVal strBuffer As String, ByVal lngParamNo As Long)

    Dim objCommon   As Common   '共通クラス
    Dim strStmt     As String   'SQLステートメント

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strParamName    As String           'パラメータ名

    '共通クラスのインスタンス作成
    Set objCommon = CreateObject("HainsCommon.Common")

    'パラメータ追加
    strParamName = "RSVNO" & CStr(lngParamNo)
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add strParamName, CLng(Right(strBuffer, Len(strBuffer) - Len(PREFIX_RSVNO))), ORAPARM_INPUT, ORATYPE_NUMBER

    '条件節の編集
    strStmt = "CONSULT.RSVNO = :" & strParamName

    '配列に追加
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
' 機能　　 : 受診情報をキャンセルする
'
' 引数　　 : (In)     lngRsvNo      予約番号
' 　　　　   (In)     strUpdUser    更新者
' 　　　　   (In)     lngCancelFlg  キャンセルフラグ
' 　　　　   (Out)    vntMessage    メッセージ
' 　　　　   (In)     blnForce      強制キャンセルフラグ
'
' 戻り値　 : 予約番号
'
' 備考　　 :
'
'## 2004.01.03 Mod By T.Takagi@FSIT 更新者対応
'Public Function CancelConsult(ByVal lngRsvNo As Long, ByVal lngCancelFlg As Long, ByRef vntMessage As Variant, Optional ByVal blnForce As Boolean = False) As Long
Public Function CancelConsult(ByVal lngRsvNo As Long, ByVal strUpdUser As String, ByVal lngCancelFlg As Long, ByRef vntMessage As Variant, Optional ByVal blnForce As Boolean = False) As Long
'## 2004.01.03 Mod End

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    Dim Ret         As Long             '関数戻り値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
'## 2004.01.03 Add By T.Takagi@FSIT 更新者対応
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2004.01.03 Add End
    objOraParam.Add "CANCELFLG", lngCancelFlg, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CANCELFORCE", IIf(blnForce, 1, 0), ORAPARM_INPUT, ORATYPE_NUMBER

    '戻り値(予約番号・メッセージ)のバインド変数定義
    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    objOraParam.Add "MESSAGE", "", ORAPARM_OUTPUT, ORATYPE_VARCHAR2

    '受診情報登録用ストアドパッケージの関数呼び出し
'## 2004.01.03 Mod By T.Takagi@FSIT 更新者対応
'    strStmt = "BEGIN :RET := ConsultPackageLukes.CancelConsult(:RSVNO, :CANCELFLG, :MESSAGE, :CANCELFORCE); END;"
    strStmt = "BEGIN :RET := ConsultPackageLukes.CancelConsult(:RSVNO, :UPDUSER, :CANCELFLG, :MESSAGE, :CANCELFORCE); END;"
'## 2004.01.03 Mod End

    'PL/SQL文の実行
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    '戻り値の取得
    vntMessage = objOraParam("MESSAGE").Value & ""
    Ret = objOraParam("RET").Value

    'トランザクション制御
    If Ret > 0 Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If

    '戻り値の設定
    CancelConsult = Ret

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Consult.CancelConsult"
    
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
' 機能　　 : 受付を取り消す
'
' 引数　　 : (In)     lngRsvNo     予約番号
' 　　　　   (In)     strUpdUser   更新者
' 　　　　   (In)     lngCslYear   受診年
' 　　　　   (In)     lngCslMonth  受診月
' 　　　　   (In)     lngCslDay    受診日
' 　　　　   (Out)    vntMessage   メッセージ
' 　　　　   (In)     blnForce     True指定時は結果の有無に関わらず強制的に削除
'
' 戻り値　 : 予約番号
'
' 備考　　 :
'
'## 2004.01.03 Mod By T.Takagi@FSIT 更新者対応
'Public Function CancelReceipt(
'    ByVal lngRsvNo As Long,
'    ByVal lngCslYear As Long,
'    ByVal lngCslMonth As Long,
'    ByVal lngCslDay As Long,
'    ByRef vntMessage As Variant,
'    Optional ByVal blnForce As Boolean = False
') As Long
Public Function CancelReceipt( _
    ByVal lngRsvNo As Long, _
    ByVal strUpdUser As String, _
    ByVal lngCslYear As Long, _
    ByVal lngCslMonth As Long, _
    ByVal lngCslDay As Long, _
    ByRef vntMessage As Variant, _
    Optional ByVal blnForce As Boolean = False _
) As Long
'## 2004.01.03 Mod End

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    Dim dtmCslDate  As Date             '受診年月日

    Dim Ret         As Long             '関数戻り値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '受診年月日の編集
    dtmCslDate = CDate(CStr(lngCslYear) & "/" & CStr(lngCslMonth) & "/" & CStr(lngCslDay))

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
'## 2004.01.03 Add By T.Takagi@FSIT 更新者対応
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2004.01.03 Add End
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE

    '戻り値のバインド変数定義
    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    objOraParam.Add "MESSAGE", "", ORAPARM_OUTPUT, ORATYPE_VARCHAR2

    '受診情報登録用ストアドパッケージの関数呼び出し
'## 2004.01.03 Mod By T.Takagi@FSIT 更新者対応
'    If blnForce Then
'        strStmt = "BEGIN :RET := ConsultPackageLukes.CancelReceipt(:RSVNO, :CSLDATE, :MESSAGE, 1); END;"
'    Else
'        strStmt = "BEGIN :RET := ConsultPackageLukes.CancelReceipt(:RSVNO, :CSLDATE, :MESSAGE); END;"
'    End If
    If blnForce Then
        strStmt = "BEGIN :RET := ConsultPackageLukes.CancelReceipt(:RSVNO, :UPDUSER, :CSLDATE, :MESSAGE, 1); END;"
    Else
        strStmt = "BEGIN :RET := ConsultPackageLukes.CancelReceipt(:RSVNO, :UPDUSER, :CSLDATE, :MESSAGE); END;"
    End If
'## 2004.01.03 Mod End
    
    'PL/SQL文の実行
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    '戻り値の取得
    vntMessage = objOraParam("MESSAGE").Value & ""
    Ret = objOraParam("RET").Value

    'トランザクション制御
    If Ret > 0 Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    CancelReceipt = Ret

    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Consult.CancelReceipt"
    
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
' 機能　　 : 一括で受付を取り消す
'
' 引数　　 : (In)     strUpdUser    更新者
' 　　　　   (In)     lngCslYear    受診年
' 　　　　   (In)     lngCslMonth   受診月
' 　　　　   (In)     lngCslDay     受診日
' 　　　　   (In)     lngCntlNo     管理番号
' 　　　　   (In)     strCsCd       コースコード
' 　　　　   (In)     blnForce      True指定時は結果の有無に関わらず強制的に削除
'
' 戻り値　 : >=0  取り消した受付情報数
' 　　　　   -1   異常終了
'
' 備考　　 :
'
'## 2004.01.03 Mod By T.Takagi@FSIT 更新者対応
'Public Function CancelReceiptAll(
'    ByVal lngCslYear As Long,
'    ByVal lngCslMonth As Long,
'    ByVal lngCslDay As Long,
'    ByVal lngCntlNo As Long,
'    ByVal strCsCd As String,
'    Optional ByVal blnForce As Boolean = False
') As Long
Public Function CancelReceiptAll( _
    ByVal strUpdUser As String, _
    ByVal lngCslYear As Long, _
    ByVal lngCslMonth As Long, _
    ByVal lngCslDay As Long, _
    ByVal lngCntlNo As Long, _
    ByVal strCsCd As String, _
    Optional ByVal blnForce As Boolean = False _
) As Long
'## 2004.01.03 Mod End

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    Dim dtmCslDate  As Date             '受診年月日

    Dim Ret         As Long             '関数戻り値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '受診年月日の編集
    dtmCslDate = CDate(CStr(lngCslYear) & "/" & CStr(lngCslMonth) & "/" & CStr(lngCslDay))

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
'## 2004.01.03 Add By T.Takagi@FSIT 更新者対応
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2004.01.03 Add End
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "CNTLNO", lngCntlNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CSCD", strCsCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CANCELFORCE", IIf(blnForce, 1, 0), ORAPARM_INPUT, ORATYPE_NUMBER

    '戻り値のバインド変数定義
    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER

    '受診情報登録用ストアドパッケージの関数呼び出し
'## 2004.01.03 Mod By T.Takagi@FSIT 更新者対応
'    strStmt = "BEGIN :RET := ConsultPackageLukes.CancelReceiptAll(:CSLDATE, :CNTLNO, :CSCD, :CANCELFORCE); END;"
    strStmt = "BEGIN :RET := ConsultPackageLukes.CancelReceiptAll(:UPDUSER, :CSLDATE, :CNTLNO, :CSCD, :CANCELFORCE); END;"
'## 2004.01.03 Mod End
    
    'PL/SQL文の実行
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    '戻り値の取得
    Ret = objOraParam("RET").Value

    '戻り値の設定
    CancelReceiptAll = Ret

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクション制御
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    CancelReceiptAll = -1

    'イベントログ書き込み
    WriteErrorLog "Consult.CancelReceiptAll"
    
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

'## 2003.12.13 Add Function by T.Takagi@FSIT
'
' 機能　　 : 受診セットの登録
'
' 引数　　 : (In)     lngRsvNo        予約番号
' 　　　　   (In)     lngCtrPtCd      契約パターンコード
' 　　　　   (In)     vntOptCd        オプションコード
' 　　　　   (In)     vntOptBranchNo  オプション枝番
' 　　　　   (In)     vntConsults     受診要否
' 　　　　   (In)     strIpAddress    ＩＰアドレス
' 　　　　   (In)     strUpdUser      更新者
'            (In)     lngIgnoreFlg    予約枠無視フラグ
' 　　　　   (In)     vntGrpCd        グループコード
' 　　　　   (In)     vntRslCmtCd2    結果コメント２
' 　　　　   (Out)    vntMessage      メッセージ
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function ChangeSet( _
    ByVal lngRsvNo As Long, _
    ByVal lngCtrPtCd As Long, _
    ByRef vntOptCd As Variant, _
    ByRef vntOptBranchNo As Variant, _
    ByRef vntConsults As Variant, _
    ByVal strIpAddress As String, _
    ByVal strUpdUser As String, _
    ByVal lngIgnoreFlg As Long, _
    ByRef vntGrpCd As Variant, _
    ByRef vntRslCmtCd2 As Variant, _
    ByRef vntMessage As Variant _
) As Boolean

    Dim objResult   As Object   '結果情報アクセス用
    
    Dim Ret         As Boolean  '関数戻り値
    Dim Ret2        As Long     '関数戻り値
    Dim Ret3        As Boolean  '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    Do
    
        'オプションコード指定時
        If IsArray(vntOptCd) Then
            
            '受診オプション管理レコードの更新
            Ret2 = UpdateConsult_O(lngRsvNo, lngCtrPtCd, vntOptCd, vntOptBranchNo, vntConsults, strIpAddress, strUpdUser, lngIgnoreFlg, vntMessage)
            If Ret2 <= 0 Then
                Exit Do
            End If
        
        End If
    
        'グループコード指定時
        If IsArray(vntGrpCd) Then
        
            Set objResult = CreateObject("HainsResult.Result")
            
            '検査中止情報の更新
            Ret3 = objResult.UpdateResultForChangeSet(lngRsvNo, strIpAddress, strUpdUser, vntGrpCd, vntRslCmtCd2, vntMessage)

            Set objResult = Nothing

            If Ret3 = False Then
                Exit Do
            End If
        
        End If

        Ret = True
        Exit Do
    Loop
    
    'トランザクション制御
    If Ret = True Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If
    
    '戻り値の設定
    ChangeSet = Ret
    
    Exit Function

ErrorHandle:

    '戻り値の設定
    ChangeSet = False

    'イベントログ書き込み
    WriteErrorLog "Consult.ChangeSet"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 指定予約番号、請求分類の受診オプション管理情報有無をチェック
'
' 引数　　 : (In)     lngRsvNo           予約番号
' 　　　　   (In)     strDmdLineClassCd  請求明細分類コード
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function CheckConsult_O_Isr(ByVal lngRsvNo As Long, ByVal strDmdLineClassCd As String) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント

    Dim objFields       As OraFields        'フィールドオブジェクト
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DMDLINECLASSCD", strDmdLineClassCd, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '指定予約番号、請求分類の受診オプション管理情報有無をチェック
    strStmt = "SELECT CONSULT_O.RSVNO                                    " & vbLf & _
              "  FROM CTRPT_OPT, CONSULT_O                               " & vbLf & _
              " WHERE CONSULT_O.RSVNO       = :RSVNO                     " & vbLf & _
              "   AND CONSULT_O.CTRPTCD     = CTRPT_OPT.CTRPTCD          " & vbLf & _
              "   AND CONSULT_O.OPTCD       = CTRPT_OPT.OPTCD            " & vbLf & _
              "   AND CONSULT_O.OPTBRANCHNO = CTRPT_OPT.OPTBRANCHNO      " & vbLf & _
              "   AND ( CTRPT_OPT.DMDLINECLASSCD    = :DMDLINECLASSCD OR " & vbLf & _
              "         CTRPT_OPT.ISRDMDLINECLASSCD = :DMDLINECLASSCD )  "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードの有無で戻り値を決定
    CheckConsult_O_Isr = Not objOraDyna.EOF

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Consult.CheckConsult_O_Isr"
    
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
' 機能　　 : 汎用データ抽出条件の妥当性チェックを行う
'
' 引数　　 : (In)     lngStrYear            受診年(自)
' 　　　　 : (In)     lngStrMonth           受診月(自)
' 　　　　 : (In)     lngStrDay             受診日(自)
' 　　　　 : (In)     lngEndYear            受診年(至)
' 　　　　 : (In)     lngEndMonth           受診月(至)
' 　　　　 : (In)     lngEndDay             受診日(至)
' 　　　　 : (In)     strStrAgeY            受診時年齢(年)(自)
' 　　　　 : (In)     strStrAgeM            受診時年齢(月)(自)
' 　　　　 : (In)     strEndAgeY            受診時年齢(年)(至)
' 　　　　 : (In)     strEndAgeM            受診時年齢(月)(至)
' 　　　　 : (In)     vntArrItemCd          検査項目コード
' 　　　　 : (In)     vntArrSuffix          検査項目サフィックス
' 　　　　 : (In)     vntArrRslValueFrom    検査結果(FROM側)の配列
' 　　　　 : (In)     vntArrRslMarkFrom     検査結果(FROM側)範囲指定の配列
' 　　　　 : (In)     vntArrRslValueTo      検査結果(TO側)の配列
' 　　　　 : (In)     vntArrRslMarkTo       検査結果(TO側)範囲指定の配列
' 　　　　 : (In)     vntArrJudClassCd      判定分類コードの配列
' 　　　　 : (In)     vntArrJudValueFrom    判定コード(FROM側)の配列
' 　　　　 : (In)     vntArrJudMarkFrom     判定コード(FROM側)範囲指定の配列
' 　　　　 : (In)     vntArrJudValueTo      判定コード(TO側)の配列
' 　　　　 : (In)     vntArrJudMarkTo       判定コード(TO側)範囲指定の配列
' 　　　　 : (Out)    vntStrDate            受診年月日(自)
' 　　　　 : (Out)    vntEndDate            受診年月日(至)
' 　　　　 : (Out)    vntStrAge             受診時年齢(自)
' 　　　　 : (Out)    vntEndAge             受診時年齢(至)
' 　　　　 : (Out)    vntArrRslCondition    検査結果条件(結果タイプ)
' 　　　　 : (Out)    vntArrWeightFrom      判定用重み(FROM側)の配列
' 　　　　 : (Out)    vntArrWeightTo        判定用重み(TO側)の配列
' 　　　　 : (Out)    vntArrJudCondition    検査結果条件
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
Public Function CheckValueDatConsult(ByVal lngStrYear As Long, ByVal lngStrMonth As Long, ByVal lngStrDay As Long, _
                                     ByVal lngEndYear As Long, ByVal lngEndMonth As Long, ByVal lngEndDay As Long, _
                                     ByVal strStrAgeY As String, ByVal strStrAgeM As String, _
                                     ByVal strEndAgeY As String, ByVal strEndAgeM As String, _
                                     ByVal vntArrItemCd As Variant, ByVal vntArrSuffix As Variant, _
                                     ByVal vntArrRslValueFrom As Variant, ByVal vntArrRslMarkFrom As Variant, _
                                     ByVal vntArrRslValueTo As Variant, ByVal vntArrRslMarkTo As Variant, _
                                     ByVal vntArrJudClassCd As Variant, _
                                     ByVal vntArrJudValueFrom As Variant, ByVal vntArrJudMarkFrom As Variant, _
                                     ByVal vntArrJudValueTo As Variant, ByVal vntArrJudMarkTo As Variant, _
                                     ByRef vntStrDate As Variant, ByRef vntEndDate As Variant, _
                                     ByRef vntStrAge As Variant, ByRef vntEndAge As Variant, _
                                     ByRef vntArrRslCondition As Variant, _
                                     ByRef vntArrWeightFrom As Variant, ByRef vntArrWeightTo As Variant, _
                                     ByRef vntArrJudCondition As Variant _
                                    ) As Variant

    Dim vntArrMessage       As Variant      'エラーメッセージの集合
    Dim vntMessage          As Variant      'エラーメッセージ(各ブロック)
    Dim lngArrCount         As Long         '配列vntArrMessageの要素数
    Dim i                   As Long         'インデックス

    '受診歴・個人情報部
    vntMessage = CheckValueDatCslPer(lngStrYear, lngStrMonth, lngStrDay, _
                                     lngEndYear, lngEndMonth, lngEndDay, _
                                     strStrAgeY, strStrAgeM, strEndAgeY, strEndAgeM, _
                                     vntStrDate, vntEndDate, vntStrAge, vntEndAge _
                                    )

    'エラーメッセージを追記
    If IsArray(vntMessage) Then
        '配列をそのまま代入
        vntArrMessage = vntMessage
    End If

    '検査項目部
    vntMessage = CheckValueDatRsl(vntArrItemCd, vntArrSuffix, _
                                  vntArrRslValueFrom, vntArrRslMarkFrom, _
                                  vntArrRslValueTo, vntArrRslMarkTo, _
                                  vntArrRslCondition _
                                 )

    'エラーメッセージを追記
    If IsArray(vntMessage) Then
        If IsEmpty(vntArrMessage) Then
            '配列をそのまま代入
            vntArrMessage = vntMessage
        Else
            '配列を追加
            lngArrCount = UBound(vntArrMessage) + 1
            ReDim Preserve vntArrMessage(lngArrCount + UBound(vntMessage))
            For i = 0 To UBound(vntMessage)
                vntArrMessage(lngArrCount + i) = vntMessage(i)
            Next
        End If
    End If

    '総合判定部
    vntMessage = CheckValueDatJudRsl(vntArrJudClassCd, _
                                     vntArrJudValueFrom, vntArrJudMarkFrom, _
                                     vntArrJudValueTo, vntArrJudMarkTo, _
                                     vntArrWeightFrom, vntArrWeightTo, _
                                     vntArrJudCondition _
                                    )

    'エラーメッセージを追記
    If IsArray(vntMessage) Then
        If IsEmpty(vntArrMessage) Then
            '配列をそのまま代入
            vntArrMessage = vntMessage
        Else
            '配列を追加
            lngArrCount = UBound(vntArrMessage) + 1
            ReDim Preserve vntArrMessage(lngArrCount + UBound(vntMessage))
            For i = 0 To UBound(vntMessage)
                vntArrMessage(lngArrCount + i) = vntMessage(i)
            Next
        End If
    End If

    '戻り値を設定
    CheckValueDatConsult = vntArrMessage

End Function

'
' 機能　　 : 受診情報および個人情報の指定条件の妥当性チェックおよび日付、年齢の編集を行う
'
' 引数　　 : (In)     lngStrYear        受診年(自)
' 　　　　 : (In)     lngStrMonth       受診月(自)
' 　　　　 : (In)     lngStrDay         受診日(自)
' 　　　　 : (In)     lngEndYear        受診年(至)
' 　　　　 : (In)     lngEndMonth       受診月(至)
' 　　　　 : (In)     lngEndDay         受診日(至)
' 　　　　 : (In)     strStrAgeY        受診時年齢(年)(自)
' 　　　　 : (In)     strStrAgeM        受診時年齢(月)(自)
' 　　　　 : (In)     strEndAgeY        受診時年齢(年)(至)
' 　　　　 : (In)     strEndAgeM        受診時年齢(月)(至)
' 　　　　 : (Out)    vntStrDate        受診年月日(自)
' 　　　　 : (Out)    vntEndDate        受診年月日(至)
' 　　　　 : (Out)    vntStrAge         受診時年齢(自)
' 　　　　 : (Out)    vntEndAge         受診時年齢(至)
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
Private Function CheckValueDatCslPer(ByVal lngStrYear As Long, ByVal lngStrMonth As Long, ByVal lngStrDay As Long, _
                                     ByVal lngEndYear As Long, ByVal lngEndMonth As Long, ByVal lngEndDay As Long, _
                                     ByVal strStrAgeY As String, ByVal strStrAgeM As String, _
                                     ByVal strEndAgeY As String, ByVal strEndAgeM As String, _
                                     ByRef vntStrDate As Variant, ByRef vntEndDate As Variant, _
                                     ByRef vntStrAge As Variant, ByRef vntEndAge As Variant _
                                    ) As Variant

    Const DEFAULT_STRAGE    As String = "0"     '受診時年齢未指定時のデフォルト値
    Const DEFAULT_ENDAGE    As String = "999"   '受診時年齢未指定時のデフォルト値

    Const MSG_ERRDATE       As String = "受診日の指定に誤りがあります。"
    Const MSG_ERRPERIOD     As String = "期間の指定が誤っています。"
    Const MSG_ERRAGE        As String = "年齢の範囲指定が誤っています。"

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
    '日付の妥当性チェック
    blnErrDate = False
    'メッセージ本文
    strErrMsg = MSG_ERRDATE
    '年月日(自)のチェック
    strSubMsg = objCommon.CheckDate(STRDATE, lngStrYear, lngStrMonth, lngStrDay, vntStrDate, CHECK_NECESSARY)
    If strSubMsg <> "" Then
        '詳細メッセージの追加
        strErrMsg = strErrMsg & HTML_BR & _
                    "  (" & strSubMsg & ")"
        blnErrDate = True
    End If
    '年月日(至)のチェック
    strSubMsg = objCommon.CheckDate(ENDDATE, lngEndYear, lngEndMonth, lngEndDay, vntEndDate, CHECK_NECESSARY)
    If strSubMsg <> "" Then
        '詳細メッセージの追加
        strErrMsg = strErrMsg & HTML_BR & _
                    "  (" & strSubMsg & ")"
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
        vntStrAge = DEFAULT_STRAGE      '受診時年齢(自)未選択時の扱い
    End If
    '受診時年齢(至)
    If strEndAgeM = "" Then
        strEndAgeM = "0"  '年齢(月)未選択時は"0"扱い
    End If
    If strEndAgeY <> "" Then
        '受診時年齢(至)の編集
        vntEndAge = strEndAgeY & "." & IIf(CLng(strEndAgeM) < 10, "0", "") & strEndAgeM
    Else
        vntEndAge = DEFAULT_ENDAGE      '受診時年齢(至)未選択時の扱い
    End If

    '受診時年齢の範囲チェック
    If CSng(vntStrAge) > CSng(vntEndAge) Then
        'エラーメッセージ追加
        strMessage = MSG_ERRAGE
        objCommon.AppendArray vntArrMessage, strMessage
    End If

    '戻り値の編集
    If IsArray(vntArrMessage) Then
        CheckValueDatCslPer = vntArrMessage
    End If

    Set objCommon = Nothing

End Function

'
' 機能　　 : 汎用データ条件指定時総合判定部指定条件の妥当性チェックを行い検査結果条件(CHECKの有無)を返す
'
' 引数　　 : (In)     vntArrJudClassCd      判定分類コードの配列
' 　　　　 : (In)     vntArrJudValueFrom    判定コード(FROM側)の配列
' 　　　　 : (In)     vntArrJudMarkFrom     判定コード(FROM側)範囲指定の配列
' 　　　　 : (In)     vntArrJudValueTo      判定コード(TO側)の配列
' 　　　　 : (In)     vntArrJudMarkTo       判定コード(TO側)範囲指定の配列
' 　　　　 : (Out)    vntArrWeightFrom      判定用重み(FROM側)の配列
' 　　　　 : (Out)    vntArrWeightTo        判定用重み(TO側)の配列
' 　　　　 : (Out)    vntArrJudCondition    検査結果条件
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
Private Function CheckValueDatJudRsl(ByVal vntArrJudClassCd As Variant, _
                                     ByVal vntArrJudValueFrom As Variant, ByVal vntArrJudMarkFrom As Variant, _
                                     ByVal vntArrJudValueTo As Variant, ByVal vntArrJudMarkTo As Variant, _
                                     ByRef vntArrWeightFrom As Variant, ByRef vntArrWeightTo As Variant, _
                                     ByRef vntArrJudCondition As Variant _
                                    ) As Variant

    Const JUD_CHECK             As String = "CHECK" '条件設定行の戻り値
    Const JUD_SKIP              As String = ""      '条件未設定行の戻り値

    Const MSG_TARGET            As String = "［総合判定］"

    Const MSG_ERRNOJUDCLASS     As String = "番目の総合判定(判定分類)を選択してください。"

    Const MSG_ERRSAMECD         As String = "に対して複数の条件は指定できません。"
    Const MSG_ERRNOOPTION       As String = "の値に対しての条件を指定してください。"
    Const MSG_ERRNOVALUEF       As String = "のFROM側の値を指定してください。"
    Const MSG_ERRNOVALUET       As String = "のTO側の値を指定してください。"
    Const MSG_ERRRANGE          As String = "の範囲の指定に誤りがあります。"
    Const MSG_ERRRANGEB         As String = "の範囲の指定に誤りがあります。(FROM側、TO側の記号が同じです)"
    Const MSG_ERRRANGEF         As String = "のTO側に｢と同じ｣、｢以上｣が設定されているのでFROM側は条件指定できません。"
    Const MSG_ERRRANGET         As String = "のFROM側に｢と同じ｣、｢以下｣が設定されているのでTO側は条件指定できません。"

    Dim objCommon               As Common           '共通クラス
    Dim objJudClass             As Object           '判定分類クラス
    Dim objJud                  As Object           '判定クラス

    Dim vntJudClassCdList       As Variant          '判定分類コードリスト
    Dim vntJudClassNameList     As Variant          '判定分類名リスト
    Dim strWorkJudClassName     As String           '総合判定(判定分類)名

    Dim vntJudCdList            As Variant          '判定コードリスト
    Dim vntWeightList           As Variant          '判定用重みリスト
    Dim vntArrJudWeightFrom()   As Variant          '判定用重み配列(FROM側)
    Dim vntArrJudWeightTo()     As Variant          '判定用重み配列(TO側)
    Dim vntArrCondition()       As Variant          '判定条件の有無(項目未指定時は"")配列

    Dim vntArrMessage           As Variant          'エラーメッセージの集合
    Dim strMessage              As String           'エラーメッセージ
    Dim lngCount                As Long             'レコード数
    Dim lngJudCount             As Long             '条件指定有効項目数
    Dim blnFrFlg                As Boolean          'FROM側フラグ　設定有効ならばTrue、無効ならFalse
    Dim blnToFlg                As Boolean          'TO側フラグ　  設定有効ならばTrue、無効ならFalse
    Dim i, j                    As Long             'インデックス

    '各クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    Set objJudClass = mobjContext.CreateInstance("HainsJudClass.JudClass")
    Set objJud = mobjContext.CreateInstance("HainsJud.Jud")

    Do

        '有効判定分類のカウント
        lngJudCount = 0
        ReDim vntArrJudWeightFrom(UBound(vntArrJudClassCd))
        ReDim vntArrJudWeightTo(UBound(vntArrJudClassCd))
        ReDim vntArrCondition(UBound(vntArrJudClassCd))

        For i = 0 To UBound(vntArrJudClassCd)

            '判定結果条件指定項目のいずれかが指定されているとき
            If vntArrJudValueFrom(i) <> "" Or _
               vntArrJudMarkFrom(i) <> "" Or _
               vntArrJudValueTo(i) <> "" Or _
               vntArrJudMarkTo(i) <> "" Then
                '判定分類があれば
                If vntArrJudClassCd(i) <> "" Then
                    'カウント
                    lngJudCount = lngJudCount + 1
                    '条件フラグ配列を有効にセット
                    vntArrCondition(i) = JUD_CHECK
                '判定分類がなければ
                Else
                    '総合判定(判定分類)未指定のエラー
                    strMessage = MSG_TARGET & CStr(i + 1) & MSG_ERRNOJUDCLASS
                    objCommon.AppendArray vntArrMessage, strMessage
                    '条件フラグ配列を無効にセット
                    vntArrCondition(i) = JUD_SKIP
                End If
            Else
                '条件フラグ配列を無効にセット
                    vntArrCondition(i) = JUD_SKIP
            End If
            '判定用重み配列の初期化
            vntArrJudWeightFrom(i) = ""
            vntArrJudWeightTo(i) = ""

        Next

        '有効な判定分類が無ければチェック終了
        If lngJudCount = 0 Then
            Exit Do
        End If

        '判定分類コード、名称リスト取得
        Call objJudClass.SelectJudClassList(vntJudClassCdList, vntJudClassNameList)
        '判定コード、重みリスト取得
        Call objJud.SelectJudList(vntJudCdList, , , vntWeightList)

        '指定された総合判定項目の妥当性チェック
        For i = 0 To UBound(vntArrJudClassCd)

            '有効行ならチェックする
            If vntArrCondition(i) = JUD_CHECK Then

                '総合判定名称のセット
                j = 0
                Do While j <= UBound(vntJudClassCdList)
                    If CLng(vntJudClassCdList(j)) = CLng(vntArrJudClassCd(i)) Then
                        '総合判定(判定分類)名称の取得
                        strWorkJudClassName = vntJudClassNameList(j)
                        Exit Do
                    End If
                    j = j + 1
                Loop
                '総合判定名称重複のチェック
                If i > 0 Then
                    j = 0
                    Do While j < i
                        If vntArrCondition(j) <> JUD_SKIP And _
                           vntArrJudClassCd(j) = vntArrJudClassCd(i) Then
                            '条件指定の重複はエラー
                            strMessage = MSG_TARGET & strWorkJudClassName & MSG_ERRSAMECD
                            objCommon.AppendArray vntArrMessage, strMessage
                            Exit Do
                        End If
                        j = j + 1
                    Loop
                End If

                '片側ずつ値と記号がそろっているかチェック
                'FROM側
                blnFrFlg = False
                If vntArrJudValueFrom(i) <> "" Then
                    '値入力有り
                    If vntArrJudMarkFrom(i) <> "" Then
                        '値に対する判定用重みをセット
                        j = 0
                        Do While j <= UBound(vntJudCdList)
                            If vntJudCdList(j) = vntArrJudValueFrom(i) Then
                                vntArrJudWeightFrom(i) = vntWeightList(j)
                                Exit Do
                            End If
                            j = j + 1
                        Loop
                        '記号指定有りならFROM側指定有効
                        blnFrFlg = True
                    Else
                        'FROM側記号未指定はエラー
                        strMessage = MSG_TARGET & strWorkJudClassName & MSG_ERRNOOPTION
                        objCommon.AppendArray vntArrMessage, strMessage
                    End If
                Else
                    '値入力なし
                    If vntArrJudMarkFrom(i) <> "" Then
                        'FROM側値未指定はエラー
                        strMessage = MSG_TARGET & strWorkJudClassName & MSG_ERRNOVALUEF
                        objCommon.AppendArray vntArrMessage, strMessage
                    End If
                End If
                'TO側
                blnToFlg = False
                If vntArrJudValueTo(i) <> "" Then
                    '値入力有り
                    If vntArrJudMarkTo(i) <> "" Then
                        '値に対する判定用重みをセット
                        j = 0
                        Do While j <= UBound(vntJudCdList)
                            If vntJudCdList(j) = vntArrJudValueTo(i) Then
                                vntArrJudWeightTo(i) = vntWeightList(j)
                                Exit Do
                            End If
                            j = j + 1
                        Loop
                        '記号指定有りならTO側指定有効
                        blnToFlg = True
                    Else
                        'TO側記号未指定はエラー
                        strMessage = MSG_TARGET & strWorkJudClassName & MSG_ERRNOOPTION
                        objCommon.AppendArray vntArrMessage, strMessage
                    End If
                Else
                    '値入力なし
                    If vntArrJudMarkTo(i) <> "" Then
                        'TO側値未指定はエラー
                        strMessage = MSG_TARGET & strWorkJudClassName & MSG_ERRNOVALUET
                        objCommon.AppendArray vntArrMessage, strMessage
                    End If
                End If

                'FROM、TO両方指定された場合の関連チェック
                If blnFrFlg And blnToFlg Then

                    '記号の範囲チェック
                    If vntArrJudMarkFrom(i) = vntArrJudMarkTo(i) Then
                        '共に同じ記号はエラー
                        strMessage = MSG_TARGET & strWorkJudClassName & MSG_ERRRANGEB
                        objCommon.AppendArray vntArrMessage, strMessage
                    Else
                        If vntArrJudMarkFrom(i) = OPTION_EQ Or _
                           vntArrJudMarkFrom(i) = OPTION_LE Then
                            'TO側範囲指定無効はエラー
                            strMessage = MSG_TARGET & strWorkJudClassName & MSG_ERRRANGET
                            objCommon.AppendArray vntArrMessage, strMessage
                        End If
                        If vntArrJudMarkTo(i) = OPTION_EQ Or _
                           vntArrJudMarkTo(i) = OPTION_GE Then
                            'FROM側範囲指定無効はエラー
                            strMessage = MSG_TARGET & strWorkJudClassName & MSG_ERRRANGEF
                            objCommon.AppendArray vntArrMessage, strMessage
                        End If
                    End If
                    '大小チェック
                    If vntArrJudWeightFrom(i) > vntArrJudWeightTo(i) Then
                        'FROM側がTO側より大きいときは範囲指定エラー
                        strMessage = MSG_TARGET & strWorkJudClassName & MSG_ERRRANGE
                        objCommon.AppendArray vntArrMessage, strMessage
                    End If

                End If

            End If

        Next

        Exit Do

    Loop

    '戻り値の編集
    vntArrWeightFrom = vntArrJudWeightFrom
    vntArrWeightTo = vntArrJudWeightTo
    vntArrJudCondition = vntArrCondition
    If IsArray(vntArrMessage) Then
        CheckValueDatJudRsl = vntArrMessage
    End If

    Set objJud = Nothing
    Set objJudClass = Nothing
    Set objCommon = Nothing

End Function

'
' 機能　　 : 汎用データ条件指定時検査項目部指定条件の妥当性チェックを行い検査結果条件(結果タイプ)を返す
'
' 引数　　 : (In)     vntArrItemCd              検査項目コード
' 　　　　 : (In)     vntArrSuffix              検査項目サフィックス
' 　　　　 : (In)     vntArrRslValueFrom        検査結果(FROM側)の配列
' 　　　　 : (In)     vntArrRslMarkFrom         検査結果(FROM側)範囲指定の配列
' 　　　　 : (In)     vntArrRslValueTo          検査結果(TO側)の配列
' 　　　　 : (In)     vntArrRslMarkTo           検査結果(TO側)範囲指定の配列
' 　　　　 : (Out)    vntArrRslCondition        検査結果条件(結果タイプ)
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
Private Function CheckValueDatRsl(ByVal vntArrItemCd As Variant, ByVal vntArrSuffix As Variant, _
                                  ByVal vntArrRslValueFrom As Variant, ByVal vntArrRslMarkFrom As Variant, _
                                  ByVal vntArrRslValueTo As Variant, ByVal vntArrRslMarkTo As Variant, _
                                  ByRef vntArrRslCondition As Variant _
                                 ) As Variant

    Const RSL_CHECK         As String = "CHECK"     '条件設定行の初期値(結果タイプに置換される)
    Const RSL_SKIP          As String = ""          '条件未設定行の戻り値

    Const MSG_TARGET        As String = "［検査項目］"

    Const MSG_ERRNOITEMCD   As String = "番目の検査項目を選択してください。"

    Const MSG_ERRSAMECD     As String = "に対して複数の条件は指定できません。"
    Const MSG_ERRNOOPTION   As String = "の値に対しての条件を指定してください。"
    Const MSG_ERRNOVALUEF   As String = "のFROM側の値を指定してください。"
    Const MSG_ERRNOVALUET   As String = "のTO側の値を指定してください。"
    Const MSG_ERRNOTNUMERIC As String = "の値は数値を指定してください。"
    Const MSG_ERRRANGE      As String = "の範囲の指定に誤りがあります。"
    Const MSG_ERRRANGEB     As String = "の範囲の指定に誤りがあります。(FROM側、TO側の記号が同じです)"
    Const MSG_ERRRANGEF     As String = "のTO側に｢と同じ｣、｢以上｣が設定されているのでFROM側は条件指定できません。"
    Const MSG_ERRRANGET     As String = "のFROM側に｢と同じ｣、｢以下｣が設定されているのでTO側は条件指定できません。"

    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    Dim strStmtWhere        As String           'SQLステートメント(WHERE句)

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objItemCd           As OraField         '検査項目コード
    Dim objSuffix           As OraField         'サフィックス
    Dim objItemName         As OraField         '検査項目名
    Dim objResultType       As OraField         '結果タイプ

    Dim objCommon           As Common           '共通クラス

    Dim strItemCd()         As String           '検査項目コードの配列
    Dim strSuffix()         As String           'サフィックスの配列
    Dim strItemName()       As String           '検査項目名の配列
    Dim lngResultType()     As Long             '結果タイプの配列

    Dim strCondItemCd       As String           '検査項目コード
    Dim strCondSuffix       As String           '検査項目サフィックス
    Dim strCondition        As String           '条件フラグ

    Dim strWorkItemName     As String           '検査項目名(エラー時表示用)
    Dim vntRslValueFrom     As Variant          'FROM側検査結果値(大小比較用)
    Dim vntRslValueTo       As Variant          'TO側検査結果値(大小比較用)
    Dim vntArrCondition()   As Variant          '結果タイプ(項目未指定時は"")配列

    Dim vntArrMessage       As Variant          'エラーメッセージの集合
    Dim strMessage          As String           'エラーメッセージ
    Dim lngCount            As Long             'レコード数
    Dim lngItemCount        As Long             '条件指定有効項目数
    Dim blnCondition        As Boolean          'WHERE句1行目フラグ　初期値False、1件でも条件があればTrue
    Dim blnNumericFlg       As Boolean          '数値フラグ    数値･計算タイプならばTrue、それ以外はFalse
    Dim blnFrFlg            As Boolean          'FROM側フラグ　設定有効ならばTrue、無効ならFalse
    Dim blnToFlg            As Boolean          'TO側フラグ　  設定有効ならばTrue、無効ならFalse
    Dim i, j                As Long             'インデックス

    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")

    Do

        '有効検査項目のカウントおよびWHERE句の作成
        lngItemCount = 0
        blnCondition = False
        ReDim vntArrCondition(UBound(vntArrItemCd))

        For i = 0 To UBound(vntArrItemCd)

            '検査結果条件指定項目のいずれかが指定されているとき
            If vntArrRslValueFrom(i) <> "" Or _
               vntArrRslMarkFrom(i) <> "" Or _
               vntArrRslValueTo(i) <> "" Or _
               vntArrRslMarkTo(i) <> "" Then
                '検査項目があれば
                If vntArrItemCd(i) <> "" Then
                    '結果タイプ抽出用WHERE句の作成
                    'アプストロフィはOracleの単一引用符と重複するので予め置換
                    strCondItemCd = Replace(Trim(vntArrItemCd(i)), "'", "''")
                    strCondSuffix = Replace(Trim(vntArrSuffix(i)), "'", "''")
                    If Not blnCondition Then
                        '1件目はWHEREから
                        strStmtWhere = " WHERE (ITEMCD = '" & strCondItemCd & "' AND SUFFIX = '" & strCondSuffix & "')  "
                        blnCondition = True
                    Else
                        '2件目以降はORで追記
                        strStmtWhere = strStmtWhere & vbLf & _
                                       "    OR (ITEMCD = '" & strCondItemCd & "' AND SUFFIX = '" & strCondSuffix & "')  "
                    End If
                    lngItemCount = lngItemCount + 1
                    '条件フラグ配列を有効にセット
                    vntArrCondition(i) = RSL_CHECK
                '検査項目がなければ
                Else
                    '検査項目未指定のエラー
                    strMessage = MSG_TARGET & CStr(i + 1) & MSG_ERRNOITEMCD
                    objCommon.AppendArray vntArrMessage, strMessage
                    '条件フラグ配列を無効にセット
                    vntArrCondition(i) = RSL_SKIP
                End If
            Else
                '条件フラグ配列を無効にセット
                vntArrCondition(i) = RSL_SKIP
            End If

        Next

        '有効な検査項目が無ければチェック終了
        If lngItemCount = 0 Then
            Exit Do
        End If

        'エラーハンドラの設定
        On Error GoTo ErrorHandle

        'SQL文の編集
        strStmt = "SELECT ITEMCD, SUFFIX, ITEMNAME, RESULTTYPE                         " & vbLf & _
                  "  FROM ITEM_C                                                       "

        'WHERE句
        strStmt = strStmt & vbLf & strStmtWhere

        strStmt = strStmt & vbLf & _
                  " ORDER BY ITEMCD, SUFFIX                                            "

        '検査項目コードに対する結果タイプの取得
        Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

        'レコードが存在する場合
        If Not objOraDyna.EOF Then

            'オブジェクトの参照設定
            Set objFields = objOraDyna.Fields
            Set objItemCd = objFields("ITEMCD")
            Set objSuffix = objFields("SUFFIX")
            Set objItemName = objFields("ITEMNAME")
            Set objResultType = objFields("RESULTTYPE")

            '配列形式で格納する
            lngCount = 0
            Do Until objOraDyna.EOF
                '配列宣言
                ReDim Preserve strItemCd(lngCount)
                ReDim Preserve strSuffix(lngCount)
                ReDim Preserve strItemName(lngCount)
                ReDim Preserve lngResultType(lngCount)
                'データ格納
                strItemCd(lngCount) = objItemCd.Value & ""
                strSuffix(lngCount) = objSuffix.Value & ""
                strItemName(lngCount) = objItemName.Value & ""
                lngResultType(lngCount) = CLng(objResultType.Value & "")
                lngCount = lngCount + 1
                objOraDyna.MoveNext
            Loop

        End If

        '指定された検査項目の妥当性チェック
        For i = 0 To UBound(vntArrItemCd)

            '有効行ならチェックする
            If vntArrCondition(i) = RSL_CHECK Then

                '検査項目名、結果タイプのセット
                strWorkItemName = ""
                j = 0
                Do While j < lngCount
                    If strItemCd(j) = vntArrItemCd(i) And _
                       strSuffix(j) = vntArrSuffix(i) Then
                        'エラーメッセージ用の検査項目名称をセット
                        strWorkItemName = strItemName(j)
                        '"CHECK"から結果タイプに置き換え
                        vntArrCondition(i) = lngResultType(j)
                        '数値タイプフラグのセット
                        If vntArrCondition(i) = 0 Or _
                           vntArrCondition(i) = 5 Then
                            '数値・計算タイプ
                            blnNumericFlg = True
                        Else
                            '上記以外のタイプ
                            blnNumericFlg = False
                        End If
                        'サーチ終了
                        Exit Do
                    End If
                    j = j + 1
                Loop
                '総合判定名称重複のチェック
                If i > 0 Then
                    j = 0
                    Do While j < i
                        If vntArrCondition(j) <> RSL_SKIP And _
                           vntArrItemCd(j) = vntArrItemCd(i) And _
                           vntArrSuffix(j) = vntArrSuffix(i) Then
                            '条件指定の重複はエラー
                            strMessage = MSG_TARGET & strWorkItemName & MSG_ERRSAMECD
                            objCommon.AppendArray vntArrMessage, strMessage
                            Exit Do
                        End If
                        j = j + 1
                    Loop
                End If

                '片側ずつ値と記号がそろっているかチェック
                'FROM側
                blnFrFlg = False
                If vntArrRslValueFrom(i) <> "" Then
                    '値入力有り
                    If vntArrRslMarkFrom(i) <> "" Then
                        '記号指定有りならFROM側指定有効
                        blnFrFlg = True
                    Else
                        'FROM側記号未指定はエラー
                        strMessage = MSG_TARGET & strWorkItemName & MSG_ERRNOOPTION
                        objCommon.AppendArray vntArrMessage, strMessage
                    End If
                    If blnNumericFlg Then
                        If IsNumeric(vntArrRslValueFrom(i)) Then
                            '大小比較用値をセット
                            vntRslValueFrom = CDbl(vntArrRslValueFrom(i))
                        Else
                            '数値･計算タイプに対する数値以外の入力はエラー
                            strMessage = MSG_TARGET & strWorkItemName & MSG_ERRNOTNUMERIC
                            objCommon.AppendArray vntArrMessage, strMessage
                        End If
                    Else
                        '大小比較用値をセット
                        vntRslValueFrom = Trim(vntArrRslValueFrom(i))
                    End If
                Else
                    '値入力なし
                    If vntArrRslMarkFrom(i) <> "" Then
                        'FROM側値未指定はエラー
                        strMessage = MSG_TARGET & strWorkItemName & MSG_ERRNOVALUEF
                        objCommon.AppendArray vntArrMessage, strMessage
                    End If
                End If
                'TO側
                blnToFlg = False
                If vntArrRslValueTo(i) <> "" Then
                    '値入力有り
                    If vntArrRslMarkTo(i) <> "" Then
                        '記号指定有りならTO側指定有効
                        blnToFlg = True
                    Else
                        'TO側記号未指定はエラー
                        strMessage = MSG_TARGET & strWorkItemName & MSG_ERRNOOPTION
                        objCommon.AppendArray vntArrMessage, strMessage
                    End If
                    If blnNumericFlg Then
                        If IsNumeric(vntArrRslValueTo(i)) Then
                            '大小比較用値をセット
                            vntRslValueTo = CDbl(vntArrRslValueTo(i))
                        Else
                            '数値･計算タイプに対する数値以外の入力はエラー
                            strMessage = MSG_TARGET & strWorkItemName & MSG_ERRNOTNUMERIC
                            objCommon.AppendArray vntArrMessage, strMessage
                        End If
                    Else
                        '大小比較用値をセット
                        vntRslValueTo = Trim(vntArrRslValueTo(i))
                    End If
                Else
                    '値入力なし
                    If vntArrRslMarkTo(i) <> "" Then
                        'TO側値未指定はエラー
                        strMessage = MSG_TARGET & strWorkItemName & MSG_ERRNOVALUET
                        objCommon.AppendArray vntArrMessage, strMessage
                    End If
                End If

                'FROM、TO両方指定された場合の関連チェック
                If blnFrFlg And blnToFlg Then

                    '記号の範囲チェック
                    If vntArrRslMarkFrom(i) = vntArrRslMarkTo(i) Then
                        '共に同じ記号はエラー
                        strMessage = MSG_TARGET & strWorkItemName & MSG_ERRRANGEB
                        objCommon.AppendArray vntArrMessage, strMessage
                    Else
                        If vntArrRslMarkFrom(i) = OPTION_EQ Or _
                           vntArrRslMarkFrom(i) = OPTION_LE Then
                            'TO側範囲指定無効はエラー
                            strMessage = MSG_TARGET & strWorkItemName & MSG_ERRRANGET
                            objCommon.AppendArray vntArrMessage, strMessage
                        End If
                        If vntArrRslMarkTo(i) = OPTION_EQ Or _
                           vntArrRslMarkTo(i) = OPTION_GE Then
                            'FROM側範囲指定無効はエラー
                            strMessage = MSG_TARGET & strWorkItemName & MSG_ERRRANGEF
                            objCommon.AppendArray vntArrMessage, strMessage
                        End If
                    End If
                    '大小チェック
                    If vntRslValueFrom > vntRslValueTo Then
                        'FROM側がTO側より大きいときは範囲指定エラー
                        strMessage = MSG_TARGET & strWorkItemName & MSG_ERRRANGE
                        objCommon.AppendArray vntArrMessage, strMessage
                    End If

                End If

            End If

        Next

        Set objOraDyna = Nothing

        'トランザクションをコミット
        'mobjContext.SetComplete

        Exit Do

    Loop

    '戻り値の編集
    vntArrRslCondition = vntArrCondition
    If IsArray(vntArrMessage) Then
        CheckValueDatRsl = vntArrMessage
    End If

    Set objCommon = Nothing

    'トランザクション制御
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Consult.CheckValueDatRsl"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 汎用データ抽出項目の妥当性チェックを行う
'
' 引数　　 : (In)     strChkDate            受診日
' 　　　　 : (In)     strChkCsCd            コース
' 　　　　 : (In)     strChkOrgCd           受診団体
' 　　　　 : (In)     strChkAge             受診時年齢
' 　　　　 : (In)     strChkJud             総合判定
' 　　　　 : (In)     strChkPerID           個人ＩＤ
' 　　　　 : (In)     strChkName            氏名
' 　　　　 : (In)     strChkBirth           生年月日
' 　　　　 : (In)     strChkGender          性別
' 　　　　 : (In)     strOptResult          検査項目抽出条件
' 　　　　 : (In)     vntArrSelItemCd       検査項目コードの配列
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
Public Function CheckValueDatSelect(ByVal strChkDate As String, ByVal strChkCSCD As String, _
                                    ByVal strChkOrgCd As String, ByVal strChkAge As String, ByVal strChkJud As String, _
                                    ByVal strChkPerID As String, ByVal strChkName As String, _
                                    ByVal strChkBirth As String, ByVal strChkGender As String, _
                                    ByVal strOptResult As String, ByRef vntArrSelItemCd As Variant, _
                                    ByVal strChkOrgBsdCd As String, ByVal strChkOrgRoomCd As String, _
                                    ByVal strChkOrgPostCd As String, ByVal strChkEmpNo As String, _
                                    ByVal strChkPOrgCd As String, ByVal strChkPOrgBsdCd As String, _
                                    ByVal strChkPOrgRoomCd As String, ByVal strChkPOrgPostCd As String, _
                                    ByVal strChkOverTime As String _
                                   ) As Variant

    Const MSG_NOITEM        As String = "検査項目が指定されていません。"
    Const MSG_NOTSELECTED   As String = "抽出項目がありません。"

    Dim objCommon           As Common   '共通クラス

    Dim vntArrMessage       As Variant  'エラーメッセージの集合
    Dim blnItem             As Boolean  '検査項目コード未選択判定用
    Dim i                   As Long     'インデックス

    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")

    '各指定値チェック処理
    Select Case strOptResult

        Case CASE_SELECT                '検査項目指定時の検査項目未指定の判定

            '判定フラグ初期値
            blnItem = False
            '検査項目コードが1件でも選択されていればクリア
            i = 0
            Do Until i > UBound(vntArrSelItemCd)
                If vntArrSelItemCd(i) <> "" Then
                    blnItem = True
                    Exit Do
                End If
                i = i + 1
            Loop

            If Not blnItem Then
                'エラーメッセージ追加
                objCommon.AppendArray vntArrMessage, MSG_NOITEM
            End If

        Case CASE_NOTSELECT             '検査項目未抽出時の抽出データ未指定の判定

            '抽出項目が1件も選択されていなければエラーメッセージ追加
            If strChkDate = "" And _
               strChkCSCD = "" And _
               strChkOrgCd = "" And _
               strChkOrgBsdCd = "" And _
               strChkOrgRoomCd = "" And _
               strChkOrgPostCd = "" And _
               strChkAge = "" And _
               strChkJud = "" And _
               strChkPerID = "" And _
               strChkEmpNo = "" And _
               strChkPOrgCd = "" And _
               strChkPOrgBsdCd = "" And _
               strChkPOrgRoomCd = "" And _
               strChkPOrgPostCd = "" And _
               strChkOverTime = "" And _
               strChkName = "" And _
               strChkBirth = "" And _
               strChkGender = "" Then
                objCommon.AppendArray vntArrMessage, MSG_NOTSELECTED
            End If

    End Select

    '戻り値の編集
    If IsArray(vntArrMessage) Then
        CheckValueDatSelect = vntArrMessage
    End If

    Set objCommon = Nothing

End Function

'
' 機能　　 : 受診者一覧検索用条件節作成
'
' 引数　　 : (In)     strKey          検索キー
'            (Out)    blnExistsRsvNo  検索キーに予約番号が存在するか
'            (Out)    blnExistsDayId  検索キーに当日ＩＤが存在するか
'
' 戻り値　 : 条件節
'
' 備考　　 :
'
''### 2006.08.03 Mod By 張 ＯＣＲ番号、ロッカー番号検索機能追加 Start ###
''## 2004.01.03 Mod By T.Takagi@FSIT 当日ID検索機能追加
''Private Function CreateConditionForDailyList(ByVal strKey As String, ByRef blnExistsRsvNo As Boolean) As String
'Private Function CreateConditionForDailyList(ByVal strKey As String, ByRef blnExistsRsvNo As Boolean, ByRef blnExistsDayId As Boolean) As String
''## 2004.01.03 Mod End
Private Function CreateConditionForDailyList(ByVal strKey As String, ByRef blnExistsRsvNo As Boolean, ByRef blnExistsDayId As Boolean, _
                                                                     ByRef blnExistsOcrNo As Boolean, ByRef blnExistsLockerKey As Boolean) As String
''### 2006.08.03 Mod By 張 ＯＣＲ番号、ロッカー番号検索機能追加 End   ###

    Dim objPerson       As Object   '個人情報アクセス用
    
    Dim vntKey          As Variant  '検索キーの集合
    Dim vntCondition    As Variant  '条件節の集合
    Dim strBuffer       As String   '文字列バッファ
    Dim i               As Long     'インデックス
    
    blnExistsRsvNo = False

    '引数未設定時は何もしない
    If Trim(strKey) = "" Then
        Exit Function
    End If

    '文字列の分割
    vntKey = Array(strKey)
    
    'オブジェクトのインスタンス作成
    Set objPerson = CreateObject("HainsPerson.Person")
    
    '検索キー数分の条件節を追加
    For i = 0 To UBound(vntKey)

        '検索キーのタイプを判別し、条件節に変換して追加
        Select Case True
        
            Case objPerson.IsWide(vntKey(i))    '全角文字が含まれる(半角カナもここに含まれる)
                AppendCondition_Wide vntCondition, vntKey(i), i
        
'            Case objPerson.IsGender(vntKey(i))  '性別
'                AppendCondition_Gender vntCondition, vntKey(i), i

            Case objPerson.IsPerId(vntKey(i))   '個人ＩＤ
                AppendCondition_PerId vntCondition, vntKey(i), i

'## 2004.01.03 Add By T.Takagi@FSIT 当日ID検索機能追加
            Case IsDayId(vntKey(i))             '当日ＩＤ
                AppendCondition_DayId vntCondition, vntKey(i), i
                blnExistsDayId = True
'## 2004.01.03 Add End

            Case objPerson.IsBirth(vntKey(i))   '生年月日
                AppendCondition_Birth vntCondition, vntKey(i), i

            Case IsRsvNo(vntKey(i))             '予約番号
                AppendCondition_RsvNo vntCondition, vntKey(i), i
                blnExistsRsvNo = True

'## 2006.08.03 Add By 張 ＯＣＲ番号、ロッカー番号検索機能追加 Start ##
            
            Case IsOcrNo(vntKey(i))             'ＯＣＲ番号
                AppendCondition_OcrNo vntCondition, vntKey(i), i
                blnExistsOcrNo = True
            
            Case IsLockerKey(vntKey(i))          'ロッカー番号
                AppendCondition_LockerKey vntCondition, vntKey(i), i
                blnExistsLockerKey = True
'## 2006.08.03 Add By 張 ＯＣＲ番号、ロッカー番号検索機能追加 End   ##
            
            Case Else                   '上記以外はローマ字として検索
                AppendCondition_RomeName vntCondition, vntKey(i), i, False
            
        End Select
        
    Next i
    
    Set objPerson = Nothing
    
    'すべての条件節をANDで連結
    CreateConditionForDailyList = Join(vntCondition, " AND ")
    
End Function

'
' 機能　　 : 受診情報を削除する
'
' 引数　　 : (In)     lngRsvNo    予約番号
' 　　　　   (In)     strUpdUser  更新者
' 　　　　   (Out)    vntMessage  メッセージ
'
' 戻り値　 : >0  正常終了
' 　　　　   0   受診情報が存在しない
' 　　　　   -1  非キャンセル者の予約情報を削除しようとした
'
' 備考　　 :
'
'## 2004.01.03 Mod By T.Takagi@FSIT 更新者対応
'Public Function DeleteConsult(ByVal lngRsvNo As Long, ByRef vntMessage As Variant) As Long
Public Function DeleteConsult(ByVal lngRsvNo As Long, ByVal strUpdUser As String, ByRef vntMessage As Variant) As Long
'## 2004.01.03 Mod End

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント

    Dim Ret         As Long             '関数戻り値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
'## 2004.01.03 Add By T.Takagi@FSIT 更新者対応
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2004.01.03 Add End

    '戻り値・メッセージ用のバインド変数定義
    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    objOraParam.Add "MESSAGE", "", ORAPARM_OUTPUT, ORATYPE_VARCHAR2

    '受診情報登録用ストアドパッケージの関数呼び出し
'## 2004.01.03 Mod By T.Takagi@FSIT 更新者対応
'    strStmt = "BEGIN :RET := ConsultPackageLukes.DeleteConsult(:RSVNO, :MESSAGE); END;"
    strStmt = "BEGIN :RET := ConsultPackageLukes.DeleteConsult(:RSVNO, :UPDUSER, :MESSAGE); END;"
'## 2004.01.03 Mod End

    'PL/SQL文の実行
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    '戻り値の取得
    vntMessage = objOraParam("MESSAGE").Value & ""
    Ret = objOraParam("RET").Value

    'トランザクション制御
    If Ret > 0 Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If

    '戻り値の設定
    DeleteConsult = Ret

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Consult.DeleteConsult"
    
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
' 機能　　 : バインド変数値の編集
'
' 引数　　 : (In/Out) objCode     各種コード
' 　　　　   (In/Out) objEditFlg  修正区分
' 　　　　   (In)     vntCode     各種コード
' 　　　　   (In)     vntEditFlg  修正区分
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub EditBindArray(ByRef objCode As OraParamArray, ByRef objEditFlg As OraParamArray, ByRef vntCode As Variant, ByRef vntEditFlg As Variant)

    Dim i   As Long 'インデックス

    '編集値自体が存在しない場合は何もしない
    If IsEmpty(vntCode) Or IsEmpty(vntEditFlg) Then
        Exit Sub
    End If

    '編集値が配列でない場合は添字の０番目に編集
    If Not IsArray(vntCode) Then
        objCode(0) = vntCode
        objEditFlg(0) = vntEditFlg
        Exit Sub
    End If

    '配列数分の編集
    For i = 0 To UBound(vntCode)
        objCode(i) = vntCode(i)
        objEditFlg(i) = vntEditFlg(i)
    Next i

End Sub

'
' 機能　　 : 指定の条件に該当する受診情報テーブル他を読み込みCSVファイルを編集する
'
' 引数　　 : (In)   strFileName             CSVファイル名(物理パス)
' 　　　　 : (In)   strTempFile             作業ファイル名(物理パス)
' 　　　　 : (In)   strChkDate              受診年月日フラグ
' 　　　　 : (In)   strChkCsCd              コースコードフラグ
' 　　　　 : (In)   strChkOrgCd             団体コードフラグ
' 　　　　 : (In)   strChkAge               受診時年齢フラグ
' 　　　　 : (In)   strChkJud               総合判定フラグ
' 　　　　 : (In)   strChkOrgBsdCd          事業部コードフラグ
' 　　　　 : (In)   strChkOrgRoomCd         室部コードフラグ
' 　　　　 : (In)   strChkOrgPostCd         所属コードフラグ
' 　　　　 : (In)   strChkPerID             個人ＩＤフラグ
' 　　　　 : (In)   strChkName              氏名フラグ
' 　　　　 : (In)   strChkBirth             生年月日フラグ
' 　　　　 : (In)   strChkGender            性別フラグ
' 　　　　 : (In)   strChkEmpNo             従業員フラグ
' 　　　　 : (In)   strChkPOrgCd            団体コードフラグ
' 　　　　 : (In)   strChkPOrgBsdCd         事業部コードフラグ
' 　　　　 : (In)   strChkPOrgRoomCd        室部コードフラグ
' 　　　　 : (In)   strChkPOrgPostCd        所属コードフラグ
' 　　　　 : (In)   strChkOverTime          超過時間フラグ
' 　　　　 : (In)   strOptResult            検査項目抽出条件
' 　　　　 : (In)   strChkOption            結果コメント・正常値フラグ
' 　　　　 : (In)   vntArrSelItemCd         検査項目コードの配列
' 　　　　 : (In)   vntArrSelSuffix         検査項目サフィックスの配列
' 　　　　 : (In)   strStrDate              受診年月日(自)
' 　　　　 : (In)   strEndDate              受診年月日(至)
' 　　　　 : (In)   strCsCd                 コースコード
' 　　　　 : (In)   strOrgCd1               団体コード1
' 　　　　 : (In)   strOrgCd2               団体コード2
' 　　　　 : (In)   strStrAge               受診時(自)年齢
' 　　　　 : (In)   strEndAge               受診時(至)年齢
' 　　　　 : (In)   lngGender               性別
' 　　　　 : (In)   vntArrItemCd            検査項目コードの配列
' 　　　　 : (In)   vntArrSuffix            検査項目サフィックスの配列
' 　　　　 : (In)   vntArrRslValueFrom      検査結果(FROM側)の配列
' 　　　　 : (In)   vntArrRslMarkFrom       検査結果(FROM側)範囲指定の配列
' 　　　　 : (In)   vntArrRslValueTo        検査結果(TO側)の配列
' 　　　　 : (In)   vntArrRslMarkTo         検査結果(TO側)範囲指定の配列
' 　　　　 : (In)   vntArrRslCondition      検査結果条件配列(条件未指定時:""、指定時は結果タイプ)
' 　　　　 : (In)   vntArrJudClassCd        判定分類コードの配列
' 　　　　 : (In)   vntArrWeightFrom        判定用重み配列(FROM側)
' 　　　　 : (In)   vntArrJudMarkFrom       判定コード(FROM側)範囲指定の配列
' 　　　　 : (In)   vntArrWeightTo          判定用重み配列(TO側)
' 　　　　 : (In)   vntArrJudMarkTo         判定コード(TO側)範囲指定の配列
' 　　　　 : (In)   vntArrJudCondition      総合判定条件配列(条件未指定時:""、指定時は"CHECK")
' 　　　　 : (In)   lngJudOperation         総合判定条件指定演算子(0:AND、1:OR)
' 　　　　 : (In)   lngJudAll               判定抽出方法(0:すべて、1:指定判定分類のみ)
'
' 戻り値　 : 編集したレコード件数
'
' 備考　　 :
'
Public Function EditCSVDatConsult(ByVal strFileName As String, ByVal strTempFile As String, _
                                  ByVal strChkDate As String, ByVal strChkCSCD As String, _
                                  ByVal strChkOrgCd As String, ByVal strChkAge As String, ByVal strChkJud As String, _
                                  ByVal strChkOrgBsdCd As String, ByVal strChkOrgRoomCd As String, ByVal strChkOrgPostCd As String, _
                                  ByVal strChkPerID As String, ByVal strChkName As String, _
                                  ByVal strChkBirth As String, ByVal strChkGender As String, _
                                  ByVal strChkEmpNo As String, ByVal strChkPOrgCd As String, ByVal strChkPOrgBsdCd As String, _
                                  ByVal strChkPOrgRoomCd As String, ByVal strChkPOrgPostCd As String, ByVal strChkOverTime As String, _
                                  ByVal strOptResult As String, ByVal strChkOption As String, _
                                  ByVal vntArrSelItemCd As Variant, ByVal vntArrSelSuffix As Variant, _
                                  ByVal strStrDate As String, ByVal strEndDate As String, _
                                  ByVal strCsCd As String, ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, _
                                  ByVal strOrgBsdCd As String, ByVal strOrgRoomCd As String, _
                                  ByVal strOrgPostCd1 As String, ByVal strOrgPostCd2 As String, ByVal strSubCsCd As String, _
                                  ByVal strStrAge As String, ByVal strEndAge As String, ByVal lngGender As Long, _
                                  ByVal vntArrItemCd As Variant, ByVal vntArrSuffix As Variant, _
                                  ByVal vntArrRslValueFrom As Variant, ByVal vntArrRslMarkFrom As Variant, _
                                  ByVal vntArrRslValueTo As Variant, ByVal vntArrRslMarkTo As Variant, _
                                  ByVal vntArrRslCondition As Variant, ByVal vntArrJudClassCd As Variant, _
                                  ByVal vntArrWeightFrom As Variant, ByVal vntArrJudMarkFrom As Variant, _
                                  ByVal vntArrWeightTo As Variant, ByVal vntArrJudMarkTo As Variant, _
                                  ByVal vntArrJudCondition As Variant, _
                                  ByVal lngJudOperation As Long, ByVal lngJudAll As Long _
                                 ) As Variant

    Const CHK_ON            As String = "on"    'チェック時の値
    Const JUDCLASSROW       As Long = 3         '総合判定の1件あたりの項目数

    Dim objJudClass         As Object       '判定分類クラス

    Dim vntArrRsvNo         As Variant      '抽出対象候補となるRsvNoの配列
    Dim vntArrRsvNo2        As Variant      '検査結果条件で絞り込まれた抽出対象となるRsvNoの配列

    Dim strLine             As String       '出力文字列(1行)
    Dim strBuf              As String       '出力バッファ(作業用)

    Dim lngDataCount        As Long         'レコード件数(CSVファイルのデータ行数)
    Dim blnRsvNoSkipFlg     As Boolean      '検査結果による該当予約番号の処理スキップフラグ
    Dim blnCslPerFlg        As Boolean      '受診歴情報および個人情報の抽出対象有無フラグ
    Dim lngRslCount         As Long         '検査結果で2次抽出した検査結果レコード件数
    Dim lngRsvNoCount       As Long         '抽出対象となるRsvNoの件数
    Dim lngJudRslMax        As Long         '抽出されたRsvNoに対する総合判定の最大件数
    Dim lngRslMax           As Long         '抽出されたRsvNoに対する検査結果の最大件数

    Dim vntArrCslPer        As Variant      '受診歴情報、個人情報部の取得データ配列
    Dim vntArrJudRsl        As Variant      '総合判定部の取得データ配列
    Dim vntArrRsl           As Variant      '検査項目部の取得データ配列

    Dim strLineCslPer       As String       '受診歴情報、個人情報部の出力文字列
    Dim strLineJudRsl       As String       '総合判定部の出力文字列
    Dim strLineRsl          As String       '検査項目部の出力文字列

    Dim lngFileNumber1      As Long         'ファイル番号
    Dim lngFileNumber2      As Long         'ファイル番号

    Dim vntJudClassCd       As Variant      '判定分類コード
    Dim vntJudClassName     As Variant      '判定分類名称

    Dim i                   As Long         'インデックス
    
    Dim dtmStrDate          As Date         '超過勤務時間の出力範囲(今月から1年前まで)
    Dim dtmEndDate          As Date         ' 　〃
    Dim vntArrHeadRsl       As Variant      '検査項目名の配列

    '各クラスのインスタンス作成
    Set objJudClass = mobjContext.CreateInstance("HainsJudClass.JudClass")

    '初期処理
    lngJudRslMax = 0
    lngRslMax = 0
    lngDataCount = 0

    '受診歴情報と個人情報が指定されているとき、抽出対象有無フラグの設定
    If strChkDate = CHK_ON Or _
       strChkCSCD = CHK_ON Or _
       strChkOrgCd = CHK_ON Or _
       strChkOrgBsdCd = CHK_ON Or _
       strChkOrgRoomCd = CHK_ON Or _
       strChkOrgPostCd = CHK_ON Or _
       strChkAge = CHK_ON Or _
       strChkPerID = CHK_ON Or _
       strChkName = CHK_ON Or _
       strChkBirth = CHK_ON Or _
       strChkGender = CHK_ON Or _
       strChkEmpNo = CHK_ON Or _
       strChkPOrgCd = CHK_ON Or _
       strChkPOrgBsdCd = CHK_ON Or _
       strChkPOrgRoomCd = CHK_ON Or _
       strChkPOrgPostCd = CHK_ON Or _
       strChkOverTime = CHK_ON Then
        blnCslPerFlg = True
    Else
        blnCslPerFlg = False
    End If

    Do
        If strOptResult = CASE_ALLSELECT Then
            'グループ９９９の検査項目を取得し、検査項目配列に設定
            Call SelectAllRslItem(vntArrSelItemCd, vntArrSelSuffix)
            '検査項目指定に置き換える
            strOptResult = CASE_SELECT
        End If
                
        '抽出条件に一致する予約番号の抽出
        vntArrRsvNo = Empty
        vntArrRsvNo = SelectDatRsvNoList(strStrDate, strEndDate, strCsCd, strSubCsCd, strOrgCd1, strOrgCd2, _
                                         strOrgBsdCd, strOrgRoomCd, strOrgPostCd1, strOrgPostCd2, _
                                         strStrAge, strEndAge, lngGender, vntArrItemCd, vntArrSuffix, _
                                         vntArrRslCondition, _
                                         vntArrJudClassCd, _
                                         vntArrWeightFrom, vntArrJudMarkFrom, vntArrWeightTo, vntArrJudMarkTo, _
                                         vntArrJudCondition, _
                                         lngJudOperation _
                                        )

        '該当データが無かったとき処理終了
        If IsEmpty(vntArrRsvNo) Then
            Exit Do
        End If

        'ファイルオープン
        lngFileNumber1 = FreeFile
        Open strTempFile For Output As #lngFileNumber1

        '検査結果条件による抽出予約番号の絞込み、および検査結果データ行の編集
        lngRsvNoCount = 0
        vntArrRsvNo2 = Empty
        For i = 0 To UBound(vntArrRsvNo)
            
            Do
                vntArrRsl = SelectDatRsl(vntArrRsvNo(i), _
                                         strOptResult, strChkOption, _
                                         vntArrItemCd, vntArrSuffix, _
                                         vntArrRslValueFrom, vntArrRslMarkFrom, vntArrRslValueTo, vntArrRslMarkTo, _
                                         vntArrRslCondition, _
                                         vntArrSelItemCd, vntArrSelSuffix, _
                                         blnRsvNoSkipFlg, lngRslCount _
                                        )

                '検査結果の抽出条件に合致しなければ該当予約番号の以降の処理をスキップ
                If blnRsvNoSkipFlg Then
                    Exit Do
                End If

                'RsvNoの格納
                If IsEmpty(vntArrRsvNo2) Then
                    vntArrRsvNo2 = Array(vntArrRsvNo(i))
                Else
                    ReDim Preserve vntArrRsvNo2(lngRsvNoCount)
                    vntArrRsvNo2(lngRsvNoCount) = vntArrRsvNo(i)
                End If
                lngRsvNoCount = lngRsvNoCount + 1

                '検査結果が抽出対象となっているとき抽出データの編集処理
                If strOptResult <> CASE_NOTSELECT Then

                    '検査結果抽出データが存在するとき出力文字列を編集、無ければ空文字行をセット
                    If Not IsEmpty(vntArrRsl) Then
                        strLineRsl = Join(vntArrRsl, ",")
                    Else
                        strLineRsl = ""
                    End If

                    '作業ファイルに出力
                    Print #lngFileNumber1, strLineRsl

                    '抽出データ件数の最大値チェック・更新
                    If lngRslCount > lngRslMax Then
                        lngRslMax = lngRslCount
                    End If

                End If

                Exit Do
            Loop
        
        Next i

        '作業ファイルクローズ
        Close #lngFileNumber1

        '該当データが無かったとき処理終了
        If IsEmpty(vntArrRsvNo2) Then
            Exit Do
        End If

        '総合判定が抽出データとして指定されているとき
        If strChkJud = CHK_ON Then
            
            '総合判定件数の最大値を取得
            lngJudRslMax = objJudClass.SelectJudClassList(vntJudClassCd, vntJudClassName)

        End If

        'ファイルオープン
        lngFileNumber1 = FreeFile
        Open strTempFile For Input As #lngFileNumber1           '作業ファイルオープン
        lngFileNumber2 = FreeFile
        Open strFileName For Output As #lngFileNumber2          'CSVファイルオープン

        '見出し行の編集、およびファイル出力
        strLine = ""
        '受診歴情報および個人情報部
        If blnCslPerFlg Then
            If strChkDate = CHK_ON Then
                strLine = strLine & IIf(strLine = "", "", ",") & "受診日"
            End If
            If strChkCSCD = CHK_ON Then
                strLine = strLine & IIf(strLine = "", "", ",") & "コースコード"
            End If
            If strChkOrgCd = CHK_ON Then
                strLine = strLine & IIf(strLine = "", "", ",") & "受診時団体コード"
            End If
            If strChkOrgBsdCd = CHK_ON Then
                strLine = strLine & IIf(strLine = "", "", ",") & "受診時事業部コード"
            End If
            If strChkOrgRoomCd = CHK_ON Then
                strLine = strLine & IIf(strLine = "", "", ",") & "受診時室部コード"
            End If
            If strChkOrgPostCd = CHK_ON Then
                strLine = strLine & IIf(strLine = "", "", ",") & "受診時所属コード"
            End If
            If strChkOrgCd = CHK_ON Then
                strLine = strLine & IIf(strLine = "", "", ",") & "受診時団体"
            End If
            If strChkOrgBsdCd = CHK_ON Then
                strLine = strLine & IIf(strLine = "", "", ",") & "受診時事業部"
            End If
            If strChkOrgRoomCd = CHK_ON Then
                strLine = strLine & IIf(strLine = "", "", ",") & "受診時室部"
            End If
            If strChkOrgPostCd = CHK_ON Then
                strLine = strLine & IIf(strLine = "", "", ",") & "受診時所属"
            End If
            If strChkAge = CHK_ON Then
                strLine = strLine & IIf(strLine = "", "", ",") & "受診時年齢"
            End If
            If strChkPOrgCd = CHK_ON Then
                strLine = strLine & IIf(strLine = "", "", ",") & "団体コード"
            End If
            If strChkPOrgBsdCd = CHK_ON Then
                strLine = strLine & IIf(strLine = "", "", ",") & "事業部コード"
            End If
            If strChkPOrgRoomCd = CHK_ON Then
                strLine = strLine & IIf(strLine = "", "", ",") & "室部コード"
            End If
            If strChkPOrgPostCd = CHK_ON Then
                strLine = strLine & IIf(strLine = "", "", ",") & "所属コード"
            End If
            If strChkPOrgCd = CHK_ON Then
                strLine = strLine & IIf(strLine = "", "", ",") & "団体"
            End If
            If strChkPOrgBsdCd = CHK_ON Then
                strLine = strLine & IIf(strLine = "", "", ",") & "事業部"
            End If
            If strChkPOrgRoomCd = CHK_ON Then
                strLine = strLine & IIf(strLine = "", "", ",") & "室部"
            End If
            If strChkPOrgPostCd = CHK_ON Then
                strLine = strLine & IIf(strLine = "", "", ",") & "所属"
            End If
            If strChkEmpNo = CHK_ON Then
                strLine = strLine & IIf(strLine = "", "", ",") & "従業員番号"
            End If
            If strChkPerID = CHK_ON Then
                strLine = strLine & IIf(strLine = "", "", ",") & "個人ＩＤ"
            End If
            If strChkName = CHK_ON Then
                strLine = strLine & IIf(strLine = "", "", ",") & "姓,名"
            End If
            If strChkBirth = CHK_ON Then
                strLine = strLine & IIf(strLine = "", "", ",") & "生年月日"
            End If
            If strChkGender = CHK_ON Then
                strLine = strLine & IIf(strLine = "", "", ",") & "性別"
            End If
            If strChkOverTime = CHK_ON Then
                '今月から過去１２ヶ月分を展開
                dtmStrDate = CDate(Format(Now, "yyyy/mm") & "/01")
                dtmEndDate = DateAdd("M", 1, dtmStrDate)
                strBuf = ""
                For i = 1 To 12
                    dtmEndDate = DateAdd("M", -1, dtmEndDate)
                    strBuf = Format(dtmEndDate, " yyyy/mm")
                    strLine = strLine & IIf(strLine = "", "", ",") & strBuf
                Next i
            End If
        End If
        '総合判定部
        If lngJudRslMax > 0 Then
            '総合判定部の最大件数分見出し作成
            For i = 1 To lngJudRslMax
                strLine = strLine & IIf(strLine = "", "", ",") & _
                            "判定分類名称(" & CStr(i) & "),判定コード(" & CStr(i) & "),略称(" & CStr(i) & ")"
            Next
        End If
        '検査結果項目部
        If lngRslMax > 0 Then
            '検査結果項目部の見出し取得（検査項目名)
            vntArrHeadRsl = SelectHeadRsl(vntArrSelItemCd, vntArrSelSuffix, lngRslCount)
            
            '検査結果項目部の最大件数分見出し作成
            For i = LBound(vntArrHeadRsl) To UBound(vntArrHeadRsl)
                strLine = strLine & IIf(strLine = "", "", ",") & vntArrHeadRsl(i)
                '結果コメント抽出指定があれば見出し追加
                If strChkOption = CHK_ON Then
                    strLine = strLine & _
                            ",結果コメント1(" & CStr(i) & "),結果コメント名1(" & CStr(i) & ")," & _
                            "結果コメント2(" & CStr(i) & "),結果コメント名2(" & CStr(i) & ")," & _
                            "正常値フラグ(" & CStr(i) & ")"
                End If
            Next
        End If

        '見出し行をファイルに出力
        Print #lngFileNumber2, strLine

        'データ行の編集、およびファイル出力
        For i = 0 To UBound(vntArrRsvNo2)

            '受診歴情報と個人情報が指定されているとき、受診歴情報と個人情報の抽出
            If blnCslPerFlg Then
                vntArrCslPer = SelectDatCslPer(dtmStrDate, dtmEndDate, vntArrRsvNo2(i), _
                                               strChkDate, strChkCSCD, _
                                               strChkOrgCd, strChkOrgBsdCd, _
                                               strChkOrgRoomCd, strChkOrgPostCd, _
                                               strChkAge, strChkEmpNo, _
                                               strChkPerID, strChkName, _
                                               strChkBirth, strChkGender, _
                                               strChkPOrgCd, strChkPOrgBsdCd, _
                                               strChkPOrgRoomCd, strChkPOrgPostCd, _
                                               strChkOverTime _
                                              )
                '出力文字列の編集
                strLineCslPer = Join(vntArrCslPer, ",")
            End If

            '総合判定が抽出指定されているとき
            If strChkJud = CHK_ON And lngJudRslMax > 0 Then
                
                '総合判定情報の抽出
                vntArrJudRsl = SelectDatJudRsl(vntArrRsvNo2(i), lngJudAll, vntArrJudCondition, vntArrJudClassCd, vntArrWeightFrom, vntArrJudMarkFrom, vntArrWeightTo, vntArrJudMarkTo)

                '最大件数に配列をそろえる
                If IsEmpty(vntArrJudRsl) Then
                    ReDim vntArrJudRsl(lngJudRslMax * JUDCLASSROW - 1)
                Else
                    ReDim Preserve vntArrJudRsl(lngJudRslMax * JUDCLASSROW - 1)
                End If
                
                '出力文字列の編集
                strLineJudRsl = Join(vntArrJudRsl, ",")
            
            End If

            '出力データの編集
            strLine = ""
            '受診歴情報および個人情報
            If blnCslPerFlg Then
                strLine = strLine & IIf(strLine = "", "", ",") & strLineCslPer
            End If
            '総合判定
            If strChkJud = CHK_ON And lngJudRslMax > 0 Then
                strLine = strLine & IIf(strLine = "", "", ",") & strLineJudRsl
            End If
            '検査結果情報
            If strOptResult <> CASE_NOTSELECT Then
                '作業ファイルから１行読み出し、検査結果情報が存在すればデータ追加
                Line Input #lngFileNumber1, strBuf
                If strBuf <> "" Then
                    strLine = strLine & IIf(strLine = "", "", ",") & strBuf
                End If
            End If

            'データ１行をファイルに出力
            Print #lngFileNumber2, strLine
            lngDataCount = lngDataCount + 1

        Next

        'ファイルクローズ
        Close #lngFileNumber1
        Close #lngFileNumber2

        Exit Do
    Loop

    '作業ファイル削除
    On Error Resume Next
    Kill strTempFile

    '戻り値の設定
    EditCSVDatConsult = lngDataCount

End Function
'
' 機能　　 : サブコース用取得用のSQLステートメント編集
'
' 引数　　 :
'
' 戻り値　 : SQLステートメント
'
' 備考　　 :
'
Private Function EditSelectSubCourseStatement()

    Dim strStmt As String   'SQLステートメント

    '指定予約番号の受診オプション管理情報をもとに受診サブコースを取得する
    '(受診情報のコースコードと同値のサブコースは除く)
    strStmt = "SELECT DISTINCT                                           " & vbLf & _
              "       CTRPT_OPT.CSCD, COURSE_P.WEBCOLOR, COURSE_P.CSNAME " & vbLf & _
              "  FROM COURSE_P, CTRPT_OPT, CONSULT_O                     " & vbLf & _
              " WHERE CONSULT_O.RSVNO       = :RSVNO                     " & vbLf & _
              "   AND CONSULT_O.CTRPTCD     = CTRPT_OPT.CTRPTCD          " & vbLf & _
              "   AND CONSULT_O.OPTCD       = CTRPT_OPT.OPTCD            " & vbLf & _
              "   AND CONSULT_O.OPTBRANCHNO = CTRPT_OPT.OPTBRANCHNO      "
              
    strStmt = strStmt & vbLf & _
              "   AND CTRPT_OPT.CSCD != ( SELECT CSCD                      " & vbLf & _
              "                             FROM CONSULT                   " & vbLf & _
              "                            WHERE RSVNO = CONSULT_O.RSVNO ) " & vbLf & _
              "   AND CTRPT_OPT.CSCD  = COURSE_P.CSCD                      "

    '戻り値の設定
    EditSelectSubCourseStatement = strStmt
    
End Function

'
' 機能　　 : 受診者一覧のORDER BY句を作成する
'
' 引数　　 : (In)     lngSortKey     ソートキー
' 　　　　   (In)     lngSortType    ソート順(0:昇順、1:降順)
' 　　　　   (In)     vntPrintField  出力項目
'
' 戻り値　 : ORDER BY句
'
' 備考　　 :
'
Private Function EditSortOrder(ByVal lngSortKey As Long, ByVal lngSortType As Long, ByVal vntPrintField As Variant) As String

    Dim strStmt         As String   'SQLステートメント

    Dim lngSortOrder()  As Long     '作業用ソート順配列
    Dim lngSortCount    As Long     'ソート対象項目数
    
    Dim strSortType     As String   '昇順・降順の指定
    
    Dim blnNotNull      As Boolean  'NOT NULL項目か
    Dim blnAddName      As Boolean  '氏名を追加したか
    Dim blnEdit         As Boolean  '項目を編集したか
    
    Dim i               As Long     'インデックス

    'まず指定されたソートキーが先頭に来る
    ReDim Preserve lngSortOrder(lngSortCount)
    lngSortOrder(lngSortCount) = lngSortKey
    lngSortCount = lngSortCount + 1

    '指定されたソートキーを飛ばして出力項目を順次追加
    For i = 0 To UBound(vntPrintField)
        If IsNumeric(vntPrintField(i)) Then
            If CLng(vntPrintField(i)) <> lngSortKey Then
                ReDim Preserve lngSortOrder(lngSortCount)
                lngSortOrder(lngSortCount) = CLng(vntPrintField(i))
                lngSortCount = lngSortCount + 1
            End If
        End If
    Next i

    'ソート順ごとのキーワード設定
    strSortType = IIf(lngSortType = 1, " DESC", "")

    '各ソートキーごとに対応する列名を追加
    For i = 0 To lngSortCount - 1
    
        '各種フラグの初期化
        blnNotNull = False
        blnEdit = True
    
        '列名追加処理
        Select Case lngSortOrder(i)
            
            Case COL_DAYID
                strStmt = strStmt & "DAYID" & strSortType
            
            Case COL_COURSE
                strStmt = strStmt & "CSCD" & strSortType
            
            Case COL_NAME, COL_KANANAME, COL_BOTHNAME
                If Not blnAddName Then
                    strStmt = strStmt & "LASTKNAME" & strSortType & ", FIRSTNAME" & strSortType
                    blnNotNull = True
                Else
                    blnEdit = False
                End If
                
            Case COL_GENDER
                strStmt = strStmt & "GENDER" & strSortType
                blnNotNull = True
            
            Case COL_BIRTH
                strStmt = strStmt & "BIRTH" & strSortType
                blnNotNull = True
            
            Case COL_AGE
                strStmt = strStmt & "AGE" & strSortType
            
            Case COL_ORGSNAME
                strStmt = strStmt & "ORGKNAME" & strSortType
            
            Case COL_RSVNO
                strStmt = strStmt & "RSVNO" & strSortType
            
            Case COL_CSLDATE
                strStmt = strStmt & "CSLDATE" & strSortType
                strStmt = strStmt & " NULLS " & IIf(lngSortType = 0, "LAST", "FIRST")
                blnNotNull = True
            
            Case COL_RSVDATE
                strStmt = strStmt & "RSVDATE" & strSortType
            
            Case COL_ADDITEM
                blnEdit = False
            
            Case COL_RPTDATE
                blnEdit = False
            
            Case COL_PERID
                strStmt = strStmt & "PERID" & strSortType
                blnNotNull = True
            
            Case COL_CONSULTITEM
                blnEdit = False
            
            Case COL_ISRSIGN
                strStmt = strStmt & "ISRSIGN" & strSortType
            
            Case COL_ISRNO
                strStmt = strStmt & "ISRNO" & strSortType
            
            Case COL_SUBCOURSE
                blnEdit = False
            
            Case COL_ENTRY
                blnEdit = False
    
            Case COL_RSVSTATUS
                strStmt = strStmt & "RSVSTATUS" & strSortType
    
            Case COL_CARDPRINTDATE
                strStmt = strStmt & "CARDPRINTDATE" & strSortType
    
            Case COL_FORMPRINTDATE
                strStmt = strStmt & "FORMPRINTDATE" & strSortType
    
            Case COL_RSVGRP
                strStmt = strStmt & "RSVGRPCD" & strSortType
    
            Case COL_HASFRIENDS
                blnEdit = False
    
            Case Else
                blnEdit = False
            
        End Select

        '項目が編集された場合
        If blnEdit Then

            'NULLが許される項目の場合はNULL列のソート方法を追加
            If Not blnNotNull Then
                strStmt = strStmt & " NULLS " & IIf(lngSortType = 0, "FIRST", "LAST")
            End If

            'カンマを連結
            strStmt = strStmt & ","

        End If
        
    Next i
    
    '何も編集されなかった場合は処理を終了する
    If strStmt = "" Then
        Exit Function
    End If
    
    '最後部のカンマを取り除き、ORDER BY句の編集を完了とする
    strStmt = "ORDER BY " & Left(strStmt, Len(strStmt) - 1)

    '戻り値の設定
    EditSortOrder = strStmt

End Function

'
' 機能　　 : 指定検査項目の依頼有無をチェック
'
' 引数　　 : (In)     lngRsvNo   予約番号
' 　　　　   (In)     strItemCd  検査項目コード
'
' 戻り値　 : True   依頼あり
' 　　　　   False  依頼なし、または異常終了
'
' 備考　　 :
'
Public Function ExistsItem(ByVal lngRsvNo As Long, ByVal strItemCd As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    Dim Ret         As Long             '関数戻り値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ITEMCD", strItemCd, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '戻り値のバインド変数定義
    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    
    '受診情報登録用ストアドパッケージの関数呼び出し
'## 2003.11.18 Mod by T.Takagi@FSIT 呼び先変更
'    strStmt = "BEGIN :RET := ConsultPackage.ExistsItem(:RSVNO, :ITEMCD); END;"
    strStmt = "BEGIN :RET := ConsultPackageLukes.ExistsItem(:RSVNO, :ITEMCD); END;"
'## 2003.11.18 Mod End

    'PL/SQL文の実行
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    Ret = CLng("0" & objOraParam("RET").Value)
    
    '戻り値の設定
    ExistsItem = (Ret > 0)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Consult.ExistsItem"
    
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
' 機能　　 : 引数値の要素数を取得
'
' 引数　　 : (In)     vntValue  任意のVariant値
'
' 戻り値　 : 要素数
'
' 備考　　 :
'
Private Function GetElementCount(ByVal vntValue As Variant) As Long

    Dim lngCount    As Long '要素数

    Do
        'オプションコード未指定時はZERO
        If IsEmpty(vntValue) Then
            lngCount = 0
            Exit Do
        End If

        '配列形式でない場合は1
        If Not IsArray(vntValue) Then
            lngCount = 1
            Exit Do
        End If

        '配列形式の場合は要素数とする
        lngCount = UBound(vntValue) + 1

        Exit Do
    Loop

    GetElementCount = lngCount

End Function

'
' 機能　　 : 指定条件を満たす受診情報の予約番号を取得
'
' 引数　　 : (In)     dtmCslDate  受診日
' 　　　　   (In)     strPerId    個人ＩＤ
' 　　　　   (In)     strCsCd     コースコード
' 　　　　   (In)     strDiv      区分("01":受診年月日・コース・個人ＩＤをキーとする受診情報の予約番号を取得
' 　　　　                        　　 "02":受診年月日・コース・個人ＩＤをキーとする１次健診受診情報の２次健診予約番号を取得)
'
' 戻り値　 : 予約番号
'
' 備考　　 :
'
Public Function GetRsvNo(ByVal dtmCslDate As Date, ByVal strPerId, ByVal strCsCd As String, Optional ByVal strDiv As String = "") As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strBasedStmt        As String           'SQLステートメント
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRsvNo            As OraField         '予約番号

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSCD", strCsCd, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '検索条件を満たす受診情報の予約番号を取得するSQLステートメントの作成
    strBasedStmt = "SELECT PERID, RSVNO       " & vbLf & _
                   "  FROM CONSULT            " & vbLf & _
                   " WHERE CSLDATE = :CSLDATE " & vbLf & _
                   "   AND PERID   = :PERID   " & vbLf & _
                   "   AND CSCD    = :CSCD    "

    '各区分ごとの処理分岐
    Select Case strDiv
        
        '受診年月日・コース・個人ＩＤをキーとする受診情報の予約番号を取得する場合
        Case "", "01"
        
            '１次健診の場合はＯＣＲ用受診日できく
            strStmt = "SELECT PERID, RSVNO          " & vbLf & _
                      "  FROM CONSULT               " & vbLf & _
                      " WHERE OCRCSLDATE = :CSLDATE " & vbLf & _
                      "   AND PERID      = :PERID   " & vbLf & _
                      "   AND CSCD       = :CSCD    "
    
        '受診年月日・コース・個人ＩＤをキーとする１次健診受診情報の２次健診予約番号を取得する場合
        Case "02"
    
            '先に作成したSQLで取得される予約番号を１次健診予約番号として持つ受診情報を取得
            strStmt = "SELECT RSVNO FROM CONSULT WHERE ( PERID, FIRSTRSVNO ) IN ( " & strBasedStmt & ")"
        
        'それ以外はエラー
        Case Else
            Err.Raise 1000, , "区分の値が不正です。"
            
    End Select
    
    '検索条件を満たす受診情報テーブルのレコードを取得
     Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then
   
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
    
        '戻り値の設定
        GetRsvNo = CLng(objRsvNo.Value)
        
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
    WriteErrorLog "Consult.GetRsvNo"
    
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
' 機能　　 : バーコード文字列から予約番号を取得する
'
' 引数　　 : (In)     strBarCodeStream  バーコード文字列
'
' 戻り値　 : >0  予約番号
' 　　　　   0   受診情報が存在しない
' 　　　　   -1  バーコード文字列が存在しない
' 　　　　   -2  文字列が不正
' 　　　　   -3  受診年月日が日付として認識できない
' 　　　　   -4  区分の値が不正
'
' 備考　　 :
'
Public Function GetRsvNoFromBarCode(ByVal strBarCodeStream As String) As Long

    Dim strCslDate  As String   '受診年月日
    Dim strCsCd     As String   'コースコード
    Dim strDiv      As String   '区分
    Dim strPerId    As String   '個人ＩＤ

    Dim Ret         As Long     '関数戻り値
    
    Do
        'バーコード値が存在しない場合は何もしない
        If strBarCodeStream = "" Then
            Ret = -1
            Exit Do
        End If

        Select Case Len(strBarCodeStream)
            
            '９桁以下の場合、予約番号が指定されたとみなし、チェックを行う
            Case Is <= 9

                '数値チェック
                If IsNumeric(strBarCodeStream) = False Then
                    Ret = -2
                    Exit Do
                End If
    
                '存在チェック
                If SelectConsult(CLng(strBarCodeStream)) = False Then
                    Ret = 0
                    Exit Do
                End If
    
                '戻り値としてセット
                Ret = CLng(strBarCodeStream)
                
            '(バーコード値は受診年月日(8桁)＋コースコード(4桁)＋区分(2桁)＋個人ＩＤ(1桁以上)で構成。よってここでは最低15桁以上存在する必要あり。)
            Case Is >= 15

                '受診年月日・コースコード・区分・個人ＩＤ値の取得
                strCslDate = Mid(strBarCodeStream, 1, 8)
                strCsCd = Mid(strBarCodeStream, 9, 4)
                strDiv = Mid(strBarCodeStream, 13, 2)
                strPerId = Right(strBarCodeStream, Len(strBarCodeStream) - 14)

                '日付形式に編集
                strCslDate = Left(strCslDate, 4) & "/" & Mid(strCslDate, 5, 2) & "/" & Right(strCslDate, 2)

                '受診年月日が日付として認識できない場合はエラー
                If Not IsDate(strCslDate) Then
                    Ret = -3
                    Exit Do
                End If

                '区分は"01"、"02"のみ許可
                If strDiv <> "01" And strDiv <> "02" Then
                    Ret = -4
                    Exit Do
                End If

                '指定条件を満たす受診情報の予約番号を取得
                Ret = GetRsvNo(strCslDate, strPerId, strCsCd, strDiv)
        
            Case Else
                Ret = -2
        
        End Select
        
        Exit Do
    Loop
    
    '戻り値の設定
    GetRsvNoFromBarCode = Ret
    
End Function

'
' 機能　　 : 受診情報テーブルレコードを挿入する
'
' 引数　　 : (In)     dtmCslDate         受診日
' 　　　　   (In)     strPerId           個人ＩＤ
' 　　　　   (In)     strCsCd            コースコード
' 　　　　   (In)     strOrgCd1          団体コード１
' 　　　　   (In)     strOrgCd2          団体コード２
' 　　　　   (In)     lngRsvGrpCd        予約群コード
' 　　　　   (In)     strAge             受診時年齢
' 　　　　   (In)     strUpdUser         更新者
' 　　　　   (In)     lngCtrPtCd         契約パターンコード
' 　　　　   (In)     strFirstRsvNo      １次健診予約番号
' 　　　　   (In)     strFreeDiv         フリー区分
' 　　　　   (In)     strFreeComment     フリーコメント
' 　　　　   (In)     strCslDivCd        受診区分コード
' 　　　　   (In)     lngRsvStatus       予約状況
' 　　　　   (In)     lngPrtOnSave       保存時印刷
' 　　　　   (In)     strCardAddrDiv     確認はがき宛先
' 　　　　   (In)     lngCardOutEng      確認はがき英文出力
' 　　　　   (In)     strFormAddrDiv     一式書式宛先
' 　　　　   (In)     lngFormOutEng      一式書式英文出力
' 　　　　   (In)     strReportAddrDiv   成績書宛先
' 　　　　   (In)     lngReportOurEng    成績書英文出力
' 　　　　   (In)     strVolunteer       ボランティア
' 　　　　   (In)     strVolunteerName   ボランティア名
' 　　　　   (In)     strCollectTicket   利用券回収
' 　　　　   (In)     lngIssueCslTicket  診察券発行
' 　　　　   (In)     strBillPrint       請求書出力
' 　　　　   (In)     strIsrSign         保険証記号
' 　　　　   (In)     strIsrNo           保険証番号
' 　　　　   (In)     strIsrManNo        保険者番号
' 　　　　   (In)     strEmpNo           社員番号
' 　　　　   (In)     strIntroductor     紹介者
' 　　　　   (In)     vntOptCd           オプションコード
' 　　　　   (In)     vntOptBranchNo     オプション枝番
' 　　　　   (In)     lngMode            受付処理モード(0:受付しない、1:最終番号の次IDで受付、2:欠番を検索して発番、3:ID直接指定)
' 　　　　   (In)     lngDayId           当日ＩＤ(受付処理モード=3の場合のみ有効)
' 　　　　   (Out)    vntMessage         メッセージ
'            (In)     lngIgnoreFlg       予約枠無視フラグ
' 　　　　   (In)     strIpAddress       ＩＰアドレス
' 　　　　   (In)     strSendMailDiv     予約確認メール送信先
'
' 戻り値　 : 予約番号
'
' 備考　　 :
'
'#### 2013.3.1 SL-SN-Y0101-612 UPD START ####
'Public Function InsertConsult(
'    ByVal dtmCslDate As Date, ByVal strPerId As String,
'    ByVal strCsCd As String, ByVal strOrgCd1 As String,
'    ByVal strOrgCd2 As String, ByVal lngRsvGrpCd As Long,
'    ByVal strAge As String, ByVal strUpdUser As String,
'    ByVal lngCtrPtCd As Long, ByVal strFirstRsvNo As String,
'    ByVal strFreeDiv As String, ByVal strFreeComment As String,
'    ByVal strCslDivCd As String, ByVal lngRsvStatus As Long,
'    ByVal lngPrtOnSave As Long, ByVal strCardAddrDiv As String,
'    ByVal lngCardOutEng As Long, ByVal strFormAddrDiv As String,
'    ByVal lngFormOutEng As Long, ByVal strReportAddrDiv As String,
'    ByVal lngReportOurEng As Long, ByVal strVolunteer As String,
'    ByVal strVolunteerName As String, ByVal strCollectTicket As String,
'    ByVal lngIssueCslTicket As Long, ByVal strBillPrint As String,
'    ByVal strIsrSign As String, ByVal strIsrNo As String,
'    ByVal strIsrManNo As String, ByVal strEmpNo As String,
'    ByVal strIntroductor As String, ByRef vntOptCd As Variant,
'    ByRef vntOptBranchNo As Variant, ByVal lngMode As Long,
'    ByVal lngDayId As Long, ByRef vntMessage As Variant,
'    ByVal lngIgnoreFlg As Long,
'    ByVal strIpAddress As String
') As Long
Public Function InsertConsult( _
    ByVal dtmCslDate As Date, ByVal strPerId As String, _
    ByVal strCsCd As String, ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, ByVal lngRsvGrpCd As Long, _
    ByVal strAge As String, ByVal strUpdUser As String, _
    ByVal lngCtrPtCd As Long, ByVal strFirstRsvNo As String, _
    ByVal strFreeDiv As String, ByVal strFreeComment As String, _
    ByVal strCslDivCd As String, ByVal lngRsvStatus As Long, _
    ByVal lngPrtOnSave As Long, ByVal strCardAddrDiv As String, _
    ByVal lngCardOutEng As Long, ByVal strFormAddrDiv As String, _
    ByVal lngFormOutEng As Long, ByVal strReportAddrDiv As String, _
    ByVal lngReportOurEng As Long, ByVal strVolunteer As String, _
    ByVal strVolunteerName As String, ByVal strCollectTicket As String, _
    ByVal lngIssueCslTicket As Long, ByVal strBillPrint As String, _
    ByVal strIsrSign As String, ByVal strIsrNo As String, _
    ByVal strIsrManNo As String, ByVal strEmpNo As String, _
    ByVal strIntroductor As String, ByRef vntOptCd As Variant, _
    ByRef vntOptBranchNo As Variant, ByVal lngMode As Long, _
    ByVal lngDayId As Long, ByRef vntMessage As Variant, _
    ByVal lngIgnoreFlg As Long, _
    ByVal strIpAddress As String, _
    Optional ByVal strSendMailDiv As String _
) As Long
'#### 2013.3.1 SL-SN-Y0101-612 UPD END   ####

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント

    Dim objOptCd        As OraParamArray    'オプションコード
    Dim objOptBranchNo  As OraParamArray    'オプション枝番

    Dim lngOptCount     As Long             'オプション検査数

    Dim lngArraySize    As Long             'バインド配列のサイズ
    Dim Ret             As Long             '関数戻り値
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'オプション数の取得
    lngOptCount = GetElementCount(vntOptCd)

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSCD", strCsCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RSVGRPCD", lngRsvGrpCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "AGE", strAge, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "FIRSTRSVNO", IIf(strFirstRsvNo <> "", CLng("0" & strFirstRsvNo), Null), ORAPARM_INPUT, ORATYPE_NUMBER
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'    objOraParam.Add "FREEDIV", strFreeDiv, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "FREECOMMENT", StrConv(strFreeComment, vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2003.11.18 Del End
    objOraParam.Add "CSLDIVCD", strCslDivCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RSVSTATUS", lngRsvStatus, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "PRTONSAVE", lngPrtOnSave, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CARDADDRDIV", IIf(strCardAddrDiv <> "", CLng("0" & strCardAddrDiv), Null), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CARDOUTENG", lngCardOutEng, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "FORMADDRDIV", IIf(strFormAddrDiv <> "", CLng("0" & strFormAddrDiv), Null), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "FORMOUTENG", lngFormOutEng, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "REPORTADDRDIV", IIf(strReportAddrDiv <> "", CLng("0" & strReportAddrDiv), Null), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "REPORTOURENG", lngReportOurEng, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "VOLUNTEER", IIf(strVolunteer <> "", CLng("0" & strVolunteer), Null), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "VOLUNTEERNAME", StrConv(strVolunteerName, vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "COLLECTTICKET", IIf(strCollectTicket <> "", CLng("0" & strCollectTicket), Null), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ISSUECSLTICKET", lngIssueCslTicket, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BILLPRINT", IIf(strBillPrint <> "", CLng("0" & strBillPrint), Null), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ISRSIGN", strIsrSign, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ISRNO", strIsrNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ISRMANNO", strIsrManNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "EMPNO", strEmpNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "INTRODUCTOR", strIntroductor, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "MODE", lngMode, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DAYID", lngDayId, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "IGNOREFLG", lngIgnoreFlg, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "IPADDRESS", strIpAddress, ORAPARM_INPUT, ORATYPE_VARCHAR2
'#### 2013.3.1 SL-SN-Y0101-612 ADD START ####
    objOraParam.Add "SENDMAILDIV", CLng("0" & Trim(strSendMailDiv)), ORAPARM_INPUT, ORATYPE_NUMBER
'#### 2013.3.1 SL-SN-Y0101-612 ADD END   ####

    'オプション検査のバインド変数定義
    lngArraySize = IIf(lngOptCount < 1, 1, lngOptCount)
    objOraParam.AddTable "OPTCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, 4
    objOraParam.AddTable "OPTBRANCHNO", ORAPARM_INPUT, ORATYPE_NUMBER, lngArraySize, 2
    objOraParam.Add "OPTCOUNT", lngOptCount, ORAPARM_INPUT, ORATYPE_NUMBER

    '戻り値(予約番号・メッセージ)のバインド変数定義
    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    objOraParam.Add "MESSAGE", "", ORAPARM_OUTPUT, ORATYPE_VARCHAR2

    'オブジェクトの参照設定
    Set objOptCd = objOraParam("OPTCD")
    Set objOptBranchNo = objOraParam("OPTBRANCHNO")

    'オプションコードの編集
    Do
        
        'オプションコードが存在しない場合は何もしない
        If lngOptCount <= 0 Or IsEmpty(vntOptCd) Then
            Exit Do
        End If
        
        '編集値が配列でない場合は添字の０番目に編集
        If Not IsArray(vntOptCd) Then
            objOptCd(0) = CStr(vntOptCd)
            objOptBranchNo(0) = CLng(vntOptBranchNo)
            Exit Do
        End If

        '配列数分の編集
        For i = 0 To UBound(vntOptCd)
            objOptCd(i) = CStr(vntOptCd(i))
            objOptBranchNo(i) = CLng(vntOptBranchNo(i))
        Next i
        
        Exit Do
    Loop

    '受診情報登録用ストアドパッケージの関数呼び出し
'#### 2013.3.1 SL-SN-Y0101-612 UPD START ####
''## 2003.11.18 Mod by T.Takagi@FSIT 不要項目削除
''    strStmt = "BEGIN                                                            " & vbLf & _
''              "    :RET := ConsultPackageLukes.InsertConsult(                   " & vbLf & _
''              "                :CSLDATE,        :PERID,         :CSCD,          " & vbLf & _
''              "                :ORGCD1,         :ORGCD2,        :RSVGRPCD,      " & vbLf & _
''              "                :AGE,            :UPDUSER,       :CTRPTCD,       " & vbLf & _
''              "                :FIRSTRSVNO,     :FREEDIV,       :FREECOMMENT,   " & vbLf & _
''              "                :CSLDIVCD,       :RSVSTATUS,     :PRTONSAVE,     " & vbLf & _
''              "                :CARDADDRDIV,    :CARDOUTENG,    :FORMADDRDIV,   " & vbLf & _
''              "                :FORMOUTENG,     :REPORTADDRDIV, :REPORTOURENG,  " & vbLf & _
''              "                :VOLUNTEER,      :VOLUNTEERNAME, :COLLECTTICKET, " & vbLf & _
''              "                :ISSUECSLTICKET, :BILLPRINT,     :ISRSIGN,       " & vbLf & _
''              "                :ISRNO,          :ISRMANNO,      :EMPNO,         " & vbLf & _
''              "                :INTRODUCTOR,    :OPTCD,         :OPTBRANCHNO,   " & vbLf & _
''              "                :OPTCOUNT,       :MODE,          :DAYID,         " & vbLf & _
''              "                :MESSAGE,        :IGNOREFLG,     :IPADDRESS      " & vbLf & _
''              "            );                                                   " & vbLf & _
''              "END;                                                             "
'    strStmt = "BEGIN                                                            " & vbLf & _
'              "    :RET := ConsultPackageLukes.InsertConsult(                   " & vbLf & _
'              "                :CSLDATE,        :PERID,         :CSCD,          " & vbLf & _
'              "                :ORGCD1,         :ORGCD2,        :RSVGRPCD,      " & vbLf & _
'              "                :AGE,            :UPDUSER,       :CTRPTCD,       " & vbLf & _
'              "                :FIRSTRSVNO,                                     " & vbLf & _
'              "                :CSLDIVCD,       :RSVSTATUS,     :PRTONSAVE,     " & vbLf & _
'              "                :CARDADDRDIV,    :CARDOUTENG,    :FORMADDRDIV,   " & vbLf & _
'              "                :FORMOUTENG,     :REPORTADDRDIV, :REPORTOURENG,  " & vbLf & _
'              "                :VOLUNTEER,      :VOLUNTEERNAME, :COLLECTTICKET, " & vbLf & _
'              "                :ISSUECSLTICKET, :BILLPRINT,     :ISRSIGN,       " & vbLf & _
'              "                :ISRNO,          :ISRMANNO,      :EMPNO,         " & vbLf & _
'              "                :INTRODUCTOR,    :OPTCD,         :OPTBRANCHNO,   " & vbLf & _
'              "                :OPTCOUNT,       :MODE,          :DAYID,         " & vbLf & _
'              "                :MESSAGE,        :IGNOREFLG,     :IPADDRESS      " & vbLf & _
'              "            );                                                   " & vbLf & _
'              "END;                                                             "
''## 2003.11.18 Mod End
    strStmt = "BEGIN                                                            " & vbLf & _
              "    :RET := ConsultPackageLukes.InsertConsult(                   " & vbLf & _
              "                :CSLDATE,        :PERID,         :CSCD,          " & vbLf & _
              "                :ORGCD1,         :ORGCD2,        :RSVGRPCD,      " & vbLf & _
              "                :AGE,            :UPDUSER,       :CTRPTCD,       " & vbLf & _
              "                :FIRSTRSVNO,                                     " & vbLf & _
              "                :CSLDIVCD,       :RSVSTATUS,     :PRTONSAVE,     " & vbLf & _
              "                :CARDADDRDIV,    :CARDOUTENG,    :FORMADDRDIV,   " & vbLf & _
              "                :FORMOUTENG,     :REPORTADDRDIV, :REPORTOURENG,  " & vbLf & _
              "                :VOLUNTEER,      :VOLUNTEERNAME, :COLLECTTICKET, " & vbLf & _
              "                :ISSUECSLTICKET, :BILLPRINT,     :ISRSIGN,       " & vbLf & _
              "                :ISRNO,          :ISRMANNO,      :EMPNO,         " & vbLf & _
              "                :INTRODUCTOR,    :OPTCD,         :OPTBRANCHNO,   " & vbLf & _
              "                :OPTCOUNT,       :MODE,          :DAYID,         " & vbLf & _
              "                :MESSAGE,        :IGNOREFLG,     :IPADDRESS,     " & vbLf & _
              "                :SENDMAILDIV                                     " & vbLf & _
              "            );                                                   " & vbLf & _
              "END;                                                             "
'#### 2013.3.1 SL-SN-Y0101-612 UPD END   ####

    'PL/SQL文の実行
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    '戻り値の取得
    vntMessage = objOraParam("MESSAGE").Value & ""
    Ret = objOraParam("RET").Value

    'トランザクション制御
    If Ret > 0 Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If

    '戻り値の設定
    InsertConsult = Ret

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Consult.InsertConsult"
    
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

'## 2003.11.18 Del by T.Takagi@FSIT 聖路加未対応メソッドのため削除
'
' 機能　　 : 検体番号管理テーブルレコードを挿入する
'
' 引数　　 : (In)     dtmCslDate      受診日
' 　　　　   (In)     lngTestTubeNo   検体番号
' 　　　　   (In)     lngSepOrderDiv  オーダ分割区分
' 　　　　   (In)     lngRsvNo        予約番号
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
'Public Function InsertTestTubeMng(ByVal dtmCslDate As Date, ByVal lngTestTubeNo As Long, ByVal lngSepOrderDiv As Long, ByVal lngRsvNo As Long) As Boolean
'
'    Dim objOraParam As OraParameters    'OraParametersオブジェクト
'    Dim strStmt     As String           'SQLステートメント
'
'    'エラーハンドラの設定
'    On Error GoTo ErrorHandle
'
'    'キー値及び更新値の設定
'    Set objOraParam = mobjOraDb.Parameters
'    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
'    objOraParam.Add "TESTTUBENO", lngTestTubeNo, ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "SEPORDERDIV", lngSepOrderDiv, ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
'
'    '検体番号管理テーブルレコードを挿入する
'    strStmt = "INSERT INTO TESTTUBEMNG ( CSLDATE, TESTTUBENO, SEPORDERDIV, RSVNO ) VALUES ( :CSLDATE, :TESTTUBENO, :SEPORDERDIV, :RSVNO )"
'
'    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
'
'    'バインド変数の削除
'    Do Until objOraParam.Count <= 0
'        objOraParam.Remove (objOraParam.Count - 1)
'    Loop
'
'    'トランザクションをコミット
'    mobjContext.SetComplete
'
'    '戻り値の設定
'    InsertTestTubeMng = True
'
'    Exit Function
'
'ErrorHandle:
'
'    InsertTestTubeMng = False
'
'    'イベントログ書き込み
'    WriteErrorLog "Consult.InsertTestTubeMng"
'
'    'エラー発生時はトランザクションをアボートに設定
'    mobjContext.SetAbort
'
'    'エラーをもう一回引き起こす
'    Err.Raise Err.Number, Err.Source, Err.Description
'
'End Function

'## 2004.01.03 Add By T.Takagi@FSIT 当日ID検索機能追加
'
' 機能　　 : 検索キーが当日ＩＤ指定かをチェック
'
' 引数　　 : (In)     strBuffer  検索キー
'
' 戻り値　 :
'
' 備考　　 :
'
Private Function IsDayId(ByVal strBuffer As String) As Boolean

    Dim strBuffer2  As String   '文字列バッファ
    Dim Ret         As Boolean  '関数戻り値
    Dim i           As Long     'インデックス
    
    Ret = True
    
    Do
    
        '先頭４文字が"DID:"の場合
        If UCase(Left(strBuffer, Len(PREFIX_DAYID))) = PREFIX_DAYID Then
            
            '接頭子を除外
            strBuffer2 = Right(strBuffer, Len(strBuffer) - Len(PREFIX_DAYID))
            If strBuffer2 = "" Then
                Ret = False
                Exit Do
            End If
            
            'すべての文字列が数字であるかをチェック
            For i = 1 To Len(strBuffer2)
                If InStr("0123456789", Mid(strBuffer2, i, 1)) <= 0 Then
                    Ret = False
                    Exit Do
                End If
            Next i
            
            Exit Do
        End If
        
        '４桁以外の場合は当日ＩＤ指定とみなさない
        If Len(strBuffer) <> LENGTH_RECEIPT_DAYID Then
            Ret = False
        End If
        
        'すべての文字列が数字であるかをチェック
'## 2004.01.04 Mod By T.Takagi@FSIT 当日ID検索機能追加
'        For i = 1 To Len(strBuffer2)
'            If InStr("0123456789", Mid(strBuffer2, i, 1)) <= 0 Then
        For i = 1 To Len(strBuffer)
            If InStr("0123456789", Mid(strBuffer, i, 1)) <= 0 Then
'## 2004.01.04 Mod End
                Ret = False
                Exit Do
            End If
        Next i
        
        Exit Do
    Loop
        
    IsDayId = Ret
        
End Function

'
' 機能　　 : 指定予約番号の受診情報が指定受付日にて受付済みかをチェック
'
' 引数　　 : (In)     lngRsvNo    予約番号
' 　　　　   (In)     dtmCslDate  受診日(受付日)
'
' 戻り値　 : 指定受付日の当日ＩＤ(未受付時は０)
'
' 備考　　 :
'
Public Function IsReceipt(ByVal lngRsvNo As Long, ByVal dtmCslDate As Date) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント

    Dim objFields   As OraFields        'フィールドオブジェクト
    Dim objDayId    As OraField         '当日ＩＤ

    Dim lngDayId    As Long             '当日ＩＤ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE

    '検索条件を満たす受付情報テーブルのレコードを取得
    strStmt = "SELECT DAYID              " & vbLf & _
              "  FROM RECEIPT            " & vbLf & _
              " WHERE CSLDATE = :CSLDATE " & vbLf & _
              "   AND RSVNO   = :RSVNO   "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objDayId = objFields("DAYID")
        
        '当日ＩＤの取得
        lngDayId = objDayId.Value

    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    IsReceipt = lngDayId

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    IsReceipt = -1
    
    'イベントログ書き込み
    WriteErrorLog "Consult.IsReceipt"
    
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
' 機能　　 : 検索キーが個人ＩＤ指定かをチェック
'
' 引数　　 : (In)     strBuffer  検索キー
'
' 戻り値　 :
'
' 備考　　 :
'
Private Function IsRsvNo(ByVal strBuffer As String) As Boolean

    Dim strRsvNo    As String   '予約番号
    Dim lngRsvNo    As Long     '予約番号
    Dim i           As Long     'インデックス
    
    '先頭６文字が"RSVNO:"でなければ予約番号指定ではない
    If UCase(Left(strBuffer, Len(PREFIX_RSVNO))) <> PREFIX_RSVNO Then
        Exit Function
    End If
    
    '残りの文字列が数字列でなければ予約番号指定ではない
    strRsvNo = Trim(Right(strBuffer, Len(strBuffer) - Len(PREFIX_RSVNO)))
    If strRsvNo = "" Then
        Exit Function
    End If
    
    For i = 1 To Len(strRsvNo)
        If InStr("0123456789", Mid(strRsvNo, i, 1)) <= 0 Then
            Exit Function
        End If
    Next i
    
    'Long型に変換できなければ予約番号指定とみなさない
    On Error GoTo ErrorHandle
    
    lngRsvNo = CLng(strRsvNo)
    
    IsRsvNo = True

    Exit Function
    
ErrorHandle:

    IsRsvNo = False

    On Error GoTo 0

End Function

'
' 機能　　 : 検索キーがＯＣＲ番号指定かをチェック
'
' 引数　　 : (In)     strBuffer  検索キー
'
' 戻り値　 :
'
' 備考　　 :
'
Private Function IsOcrNo(ByVal strBuffer As String) As Boolean

    Dim strOcrNo    As String   'OCR番号
    Dim lngOcrNo    As Long     'OCR番号
    Dim i           As Long     'インデックス
    
    '先頭４文字が"OCR:"でなければOCR番号指定ではない
    If UCase(Left(strBuffer, Len(PREFIX_OCRNO))) <> PREFIX_OCRNO Then
        Exit Function
    End If
    
    '残りの文字列が数字列でなければOCR番号指定ではない
    strOcrNo = Trim(Right(strBuffer, Len(strBuffer) - Len(PREFIX_RSVNO)))
    If strOcrNo = "" Then
        Exit Function
    End If
    
    For i = 1 To Len(strOcrNo)
        If InStr("0123456789", Mid(strOcrNo, i, 1)) <= 0 Then
            Exit Function
        End If
    Next i
    
    'Long型に変換できなければOCR番号指定とみなさない
    On Error GoTo ErrorHandle
    
    lngOcrNo = CLng(strOcrNo)
    
    IsOcrNo = True

    Exit Function
    
ErrorHandle:

    IsOcrNo = False

    On Error GoTo 0

End Function
'
' 機能　　 : 検索キーがロッカー番号指定かをチェック
'
' 引数　　 : (In)     strBuffer  検索キー
'
' 戻り値　 :
'
' 備考　　 :
'
Private Function IsLockerKey(ByVal strBuffer As String) As Boolean

    Dim strLockerKey As String   'ロッカー番号
    Dim lngLockerKey As Long     'ロッカー番号
    Dim i            As Long     'インデックス
    
    '先頭４文字が"KEY:"でなければロッカー番号指定ではない
    If UCase(Left(strBuffer, Len(PREFIX_LOCKERKEY))) <> PREFIX_LOCKERKEY Then
        Exit Function
    End If
    
    '残りの文字列が数字列でなければロッカー番号指定ではない
    strLockerKey = Trim(Right(strBuffer, Len(strBuffer) - Len(PREFIX_LOCKERKEY)))
    If strLockerKey = "" Then
        Exit Function
    End If
    
    For i = 1 To Len(strLockerKey)
        If InStr("0123456789", Mid(strLockerKey, i, 1)) <= 0 Then
            Exit Function
        End If
    Next i
    
    'Long型に変換できなければロッカー番号指定とみなさない
    On Error GoTo ErrorHandle
    
    lngLockerKey = CLng(strLockerKey)
    
    IsLockerKey = True

    Exit Function
    
ErrorHandle:

    IsLockerKey = False

    On Error GoTo 0

End Function


'
' 機能　　 : １件単位の受付を行う
'
' 引数　　 : (In)     lngRsvNo      予約番号
' 　　　　   (In)     lngCslYear    受診年
' 　　　　   (In)     lngCslMonth   受診月
' 　　　　   (In)     lngCslDay     受診日
' 　　　　   (In)     strUpdUser    更新者
' 　　　　   (In)     lngMode       受付処理モード(0:受付しない、1:最終番号の次IDで受付、2:欠番を検索して発番、3:ID直接指定)
' 　　　　   (In)     lngCntlNo     管理番号
' 　　　　   (In)     lngDayId      当日ＩＤ(受付処理モード=3の場合のみ有効)
' 　　　　   (In)     strIpAddress  ＩＰアドレス
' 　　　　   (Out)    vntMessage    メッセージ
'
' 戻り値　 : 当日ＩＤ
'
' 備考　　 :
'
Public Function Receipt( _
    ByVal lngRsvNo As Long, _
    ByVal lngCslYear As Long, _
    ByVal lngCslMonth As Long, _
    ByVal lngCslDay As Long, _
    ByVal strUpdUser As String, _
    ByVal lngMode As Long, _
    ByVal lngCntlNo As Long, _
    ByVal lngDayId As Long, _
    ByVal strIpAddress As String, _
    ByRef vntMessage As Variant _
) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    Dim dtmCslDate  As Date             '受診年月日
    
    Dim Ret         As Long             '関数戻り値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '受診年月日の編集
    dtmCslDate = CDate(CStr(lngCslYear) & "/" & CStr(lngCslMonth) & "/" & CStr(lngCslDay))
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "MODE", lngMode, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CNTLNO", lngCntlNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DAYID", lngDayId, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "IPADDRESS", strIpAddress, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '戻り値のバインド変数定義
    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    objOraParam.Add "MESSAGE", "", ORAPARM_OUTPUT, ORATYPE_VARCHAR2

    '受診情報登録用ストアドパッケージの関数呼び出し
    strStmt = "BEGIN :RET := ConsultPackageLukes.ReceiptSingle(:RSVNO, :CSLDATE, :UPDUSER, :MODE, :CNTLNO, :DAYID, :IPADDRESS, :MESSAGE); END;"

    'PL/SQL文の実行
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    '戻り値の取得
    vntMessage = objOraParam("MESSAGE").Value & ""
    Ret = objOraParam("RET").Value

    'トランザクション制御
    If Ret > 0 Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If

    '戻り値の設定
    Receipt = Ret

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Consult.Receipt"
    
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
' 機能　　 : 一括受付を行う
'
' 引数　　 : (In)     lngMode       受付処理モード(1:最終番号の次IDで受付、2:欠番を検索して発番)
' 　　　　   (In)     lngCslYear    受診年
' 　　　　   (In)     lngCslMonth   受診月
' 　　　　   (In)     lngCslDay     受診日
' 　　　　   (In)     lngCntlNo     管理番号
' 　　　　   (In)     strCsCd       コースコード
' 　　　　   (In)     strIpAddress  ＩＰアドレス
' 　　　　   (In)     strUpdUser    更新者
'
' 戻り値　 : >=0  受付処理件数
' 　　　　   -1   異常終了
'
' 備考　　 :
'
Public Function ReceiptAll( _
    ByVal lngMode As Long, _
    ByVal lngCslYear As Long, _
    ByVal lngCslMonth As Long, _
    ByVal lngCslDay As Long, _
    ByVal lngCntlNo As Long, _
    ByVal strCsCd As String, _
    ByVal strIpAddress As String, _
    ByVal strUpdUser As String _
) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    Dim dtmCslDate  As Date             '受診年月日

    Dim Ret         As Long             '関数戻り値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '受診年月日の編集
    dtmCslDate = CDate(CStr(lngCslYear) & "/" & CStr(lngCslMonth) & "/" & CStr(lngCslDay))

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "MODE", lngMode, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "CNTLNO", lngCntlNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CSCD", IIf(strCsCd <> "", strCsCd, Null), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "IPADDRESS", strIpAddress, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '戻り値のバインド変数定義
    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER

    '受診情報登録用ストアドパッケージの関数呼び出し
    strStmt = "BEGIN :RET := ConsultPackageLukes.ReceiptAll(:MODE, :CSLDATE, :CNTLNO, :CSCD, :IPADDRESS, :UPDUSER); END;"

    'PL/SQL文の実行
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    '戻り値の取得
    Ret = objOraParam("RET").Value

    'トランザクション制御
    If Ret >= 0 Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If

    '戻り値の設定
    ReceiptAll = Ret

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    Exit Function

ErrorHandle:

    ReceiptAll = -1

    'イベントログ書き込み
    WriteErrorLog "Consult.ReceiptAll"
    
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
' 機能　　 : キャンセル受診情報を復元する
'
' 引数　　 : (In)     lngRsvNo      予約番号
' 　　　　   (In)     strUpdUser    更新者
' 　　　　   (Out)    vntMessage    メッセージ
'            (In)     lngIgnoreFlg  予約枠無視フラグ
'
' 戻り値　 : >0  正常終了
' 　　　　   0   受診情報が存在しない
' 　　　　   -1  契約情報が存在しない
' 　　　　   -2  枠溢れ
'
' 備考　　 :
'
Public Function RestoreConsult(ByVal lngRsvNo As Long, ByVal strUpdUser As String, ByRef vntMessage As Variant, Optional ByVal lngIgnoreFlg As Long = 0) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント

    Dim Ret         As Long             '関数戻り値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "UPDUSER", Trim(strUpdUser), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "IGNOREFLG", lngIgnoreFlg, ORAPARM_INPUT, ORATYPE_NUMBER

    '戻り値・メッセージ用のバインド変数定義
    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    objOraParam.Add "MESSAGE", "", ORAPARM_OUTPUT, ORATYPE_VARCHAR2

    '受診情報登録用ストアドパッケージの関数呼び出し
    strStmt = "BEGIN :RET := ConsultPackageLukes.RestoreConsult(:RSVNO, :UPDUSER, :MESSAGE, :IGNOREFLG); END;"

    'PL/SQL文の実行
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    '戻り値の取得
    vntMessage = objOraParam("MESSAGE").Value & ""
    Ret = objOraParam("RET").Value

    'トランザクション制御
    If Ret > 0 Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If

    '戻り値の設定
    RestoreConsult = Ret

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Consult.RestoreConsult"
    
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
' 機能　　 : 指定予約番号の受診情報を取得する
'
' 引数　　 : (In)     lngRsvNo            予約番号
' 　　　　   (In/Out) vntCancelFlg        キャンセルフラグ
' 　　　　   (Out)    vntCslDate          受診日
' 　　　　   (Out)    vntPerId            個人ＩＤ
' 　　　　   (Out)    vntCsCd             コースコード
' 　　　　   (Out)    vntCsName           コース名
' 　　　　   (Out)    vntOrgCd1           団体コード1
' 　　　　   (Out)    vntOrgCd2           団体コード2
' 　　　　   (Out)    vntOrgName          団体名称
' 　　　　   (Out)    vntTimeFra          時間枠
' 　　　　   (Out)    vntRsvDate          予約日
' 　　　　   (Out)    vntAge              受診時年齢
' 　　　　   (Out)    vntUpdDate          (受診情報の)更新日時
' 　　　　   (Out)    vntUpdUser          更新者
' 　　　　   (Out)    vntUpdUserName      更新者名
' 　　　　   (Out)    vntReportPrintDate  成績書出力日
' 　　　　   (Out)    vntReportVersion    版数
' 　　　　   (Out)    vntRecogNo          承認番号
' 　　　　   (Out)    vntGovNo            政府管掌受付番号
' 　　　　   (Out)    vntFirstRsvno       １次健診の予約番号
' 　　　　   (Out)    vntFirstCslDate     １次健診の受診日
' 　　　　   (Out)    vntFirstCsName      １次健診のコース名
' 　　　　   (Out)    vntFreeDiv          フリー区分
' 　　　　   (Out)    vntFreeComment      フリーコメント
' 　　　　   (Out)    vntDayId            当日ＩＤ
' 　　　　   (Out)    vntReportDocNo      成績書文書番号
' 　　　　   (Out)    vntReportOrderNo    成績書オーダ番号
' 　　　　   (In)     blnLock             レコードロックを行うか
' 　　　　   (Out)    vntCslDateFixFlg    受診日確定フラグ
' 　　　　   (Out)    vntOcrCslDate       OCR用受診日
' 　　　　   (Out)    vntOrgSName         団体略称
' 　　　　   (Out)    vntOrgBsdCd         事業部コード
' 　　　　   (Out)    vntOrgBsdName       事業部名称
' 　　　　   (Out)    vntOrgRoomCd        室部コード
' 　　　　   (Out)    vntOrgRoomName      室部名称
' 　　　　   (Out)    vntOrgPostCd        所属部署コード
' 　　　　   (Out)    vntOrgPostName      所属名称
' 　　　　   (Out)    vntIsrSign          受診時健保記号
' 　　　　   (Out)    vntIsrNo            受診時健保番号
' 　　　　   (Out)    vntQuePrintDate     問診票出力日
' 　　　　   (Out)    vntCtrPtCd          契約パターンコード
' 　　　　   (Out)    vntRptUpdDate       (受付情報の)更新日時
' 　　　　   (Out)    vntLastName         姓
' 　　　　   (Out)    vntFirstName     　 名
' 　　　　   (Out)    vntLastKName        カナ姓
' 　　　　   (Out)    vntFirstKName    　 カナ名
' 　　　　   (Out)    vntBirth            生年月日
' 　　　　   (Out)    vntGender           性別
' 　　　　   (Out)    vntDoctorCd         医師コード
' 　　　　   (Out)    vntDoctorName       医師名称
' 　　　　   (Out)    vntCameraCslDate    胃カメラ受診日
' 　　　　   (Out)    vntSpare1           予備１(患者番号)
' 　　　　   (Out)    vntCslDivCd         受診区分コード
' 　　　　   (Out)    vntRsvGrpCd         予約群コード
' 　　　　   (Out)    vntCslCount         受診回数
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectConsult( _
    ByVal lngRsvNo As Long, _
    Optional ByRef vntCancelFlg As Variant, _
    Optional ByRef vntCslDate As Variant, Optional ByRef vntPerId As Variant, Optional ByRef vntCsCd As Variant, Optional ByRef vntCsName As Variant, _
    Optional ByRef vntOrgCd1 As Variant, Optional ByRef vntOrgCd2 As Variant, Optional ByRef vntOrgName As Variant, Optional ByRef vntTimeFra As Variant, _
    Optional ByRef vntRsvDate As Variant, Optional ByRef vntAge As Variant, Optional ByRef vntUpdDate As Variant, Optional ByRef vntUpdUser As Variant, _
    Optional ByRef vntUpdUserName As Variant, Optional ByRef vntReportPrintDate As Variant, Optional ByRef vntReportVersion As Variant, Optional ByRef vntRecogNo As Variant, _
    Optional ByRef vntGovNo As Variant, Optional ByRef vntFirstRsvNo As Variant, Optional ByRef vntFirstCslDate As Variant, Optional ByRef vntFirstCsName As Variant, _
    Optional ByRef vntFreeDiv As Variant, Optional ByRef vntFreeComment As Variant, Optional ByRef vntDayId As Variant, Optional ByRef vntReportDocNo As Variant, _
    Optional ByRef vntReportOrderNo As Variant, Optional ByVal blnLock As Boolean = False, Optional ByRef vntCslDateFixFlg As Variant, Optional ByRef vntOcrCslDate As Variant, _
    Optional ByRef vntOrgSName As Variant, Optional ByRef vntOrgBsdCd As Variant, Optional ByRef vntOrgBsdName As Variant, Optional ByRef vntOrgRoomCd As Variant, _
    Optional ByRef vntOrgRoomName As Variant, Optional ByRef vntOrgPostCd As Variant, Optional ByRef vntOrgPostName As Variant, Optional ByRef vntIsrSign As Variant, _
    Optional ByRef vntIsrNo As Variant, Optional ByRef vntQuePrintDate As Variant, Optional ByRef vntCtrPtCd As Variant, _
    Optional ByRef vntRptUpdDate As Variant, Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant, Optional ByRef vntLastKName As Variant, _
    Optional ByRef vntFirstKName As Variant, Optional ByRef vntBirth As Variant, Optional ByRef vntGender As Variant, Optional ByRef vntDoctorCd As Variant, _
    Optional ByRef vntDoctorName As Variant, Optional ByRef vntCameraCslDate As Variant, Optional ByRef vntSpare1 As Variant, Optional ByRef vntCslDivCd As Variant, _
    Optional ByRef vntRsvGrpCd As Variant, Optional ByRef vntCslCount As Variant _
) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objCancelFlg        As OraField         'キャンセルフラグ
    Dim objCslDate          As OraField         '受診日
    Dim objPerId            As OraField         '個人ＩＤ
    Dim objCsCd             As OraField         'コースコード
    Dim objCsName           As OraField         'コース名
    Dim objOrgCd1           As OraField         '団体コード1
    Dim objOrgCd2           As OraField         '団体コード2
    Dim objOrgName          As OraField         '団体名称
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'    Dim objTimeFra          As OraField         '時間枠
'## 2003.11.18 Del End
    Dim objRsvDate          As OraField         '予約日
    Dim objAge              As OraField         '受診時年齢
    Dim objUpdDate          As OraField         '(受診情報の)更新日時
    Dim objUpdUser          As OraField         '更新者(ユーザID)
    Dim objUpdUserName      As OraField         '更新者(ユーザ名)
    Dim objReportPrintDate  As OraField         '成績書出力日
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'    Dim objReportVersion    As OraField         '成績書版数
'    Dim objRecogNo          As OraField         '承認番号
'    Dim objGovNo            As OraField         '政府管掌受付番号
'## 2003.11.18 Del End
    Dim objFirstRsvNo       As OraField         '１次健診の予約番号
    Dim objFirstCslDate     As OraField         '１次健診の受診日
    Dim objFirstCsName      As OraField         '１次健診のコース名
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'    Dim objFreeDiv          As OraField         'フリー区分
'    Dim objFreeComment      As OraField         'フリーコメント
'## 2003.11.18 Del End
    Dim objDayId            As OraField         '当日ＩＤ
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'    Dim objReportDocNo      As OraField         '成績書文書番号
'    Dim objReportOrderNo    As OraField         '成績書オーダ番号
'    Dim objCslDateFixFlg    As OraField         '受診日確定フラグ
'    Dim objOcrCslDate       As OraField         'OCR用受診日
'## 2003.11.18 Del End
    Dim objOrgSName         As OraField         '団体略称
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'    Dim objOrgBsdCd         As OraField         '事業部コード
'    Dim objOrgBsdName       As OraField         '事業部名称
'    Dim objOrgRoomCd        As OraField         '室部コード
'    Dim objOrgRoomName      As OraField         '室部名称
'    Dim objOrgPostCd        As OraField         '所属部署コード
'    Dim objOrgPostName      As OraField         '所属名称
'## 2003.11.18 Del End
    Dim objIsrSign          As OraField         '受診時健保記号
    Dim objIsrNo            As OraField         '受診時健保番号
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'    Dim objQuePrintDate     As OraField         '問診票出力日
'## 2003.11.18 Del End
    Dim objCtrPtCd          As OraField         '契約パターンコード
    Dim objRptUpdDate       As OraField         '(受付情報の)更新日時
    Dim objLastName         As OraField         '姓
    Dim objFirstName        As OraField         '名
    Dim objLastKName        As OraField         'カナ姓
    Dim objFirstKName       As OraField         'カナ名
    Dim objBirth            As OraField         '生年月日
    Dim objGender           As OraField         '性別
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'    Dim objDoctorCd         As OraField         '医師コード
'    Dim objDoctorName       As OraField         '医師名称
'    Dim objCameraCslDate    As OraField         '胃カメラ受診日
'## 2003.11.18 Del End
    Dim objSpare1           As OraField         '予備１(患者番号)
    Dim objCslDivCd         As OraField         '受診区分コード
    Dim objRsvGrpCd         As OraField         '予約群コード
    Dim objCslCount         As OraField         '受診回数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntCslDate) Then vntCslDate = Empty
    If Not IsMissing(vntPerId) Then vntPerId = Empty
    If Not IsMissing(vntCsCd) Then vntCsCd = Empty
    If Not IsMissing(vntCsName) Then vntCsName = Empty
    If Not IsMissing(vntOrgCd1) Then vntOrgCd1 = Empty
    If Not IsMissing(vntOrgCd2) Then vntOrgCd2 = Empty
    If Not IsMissing(vntOrgName) Then vntOrgName = Empty
    If Not IsMissing(vntTimeFra) Then vntTimeFra = Empty
    If Not IsMissing(vntRsvDate) Then vntRsvDate = Empty
    If Not IsMissing(vntAge) Then vntAge = Empty
    If Not IsMissing(vntUpdDate) Then vntUpdDate = Empty
    If Not IsMissing(vntUpdUser) Then vntUpdUser = Empty
    If Not IsMissing(vntUpdUserName) Then vntUpdUserName = Empty
    If Not IsMissing(vntReportPrintDate) Then vntReportPrintDate = Empty
    If Not IsMissing(vntReportVersion) Then vntReportVersion = Empty
    If Not IsMissing(vntRecogNo) Then vntRecogNo = Empty
    If Not IsMissing(vntGovNo) Then vntGovNo = Empty
    If Not IsMissing(vntFirstRsvNo) Then vntFirstRsvNo = Empty
    If Not IsMissing(vntFirstCslDate) Then vntFirstCslDate = Empty
    If Not IsMissing(vntFirstCsName) Then vntFirstCsName = Empty
    If Not IsMissing(vntFreeDiv) Then vntFreeDiv = Empty
    If Not IsMissing(vntFreeComment) Then vntFreeComment = Empty
    If Not IsMissing(vntDayId) Then vntDayId = Empty
    If Not IsMissing(vntReportDocNo) Then vntReportDocNo = Empty
    If Not IsMissing(vntReportOrderNo) Then vntReportOrderNo = Empty
    If Not IsMissing(vntCslDateFixFlg) Then vntCslDateFixFlg = Empty
    If Not IsMissing(vntOcrCslDate) Then vntOcrCslDate = Empty
    If Not IsMissing(vntOrgSName) Then vntOrgSName = Empty
    If Not IsMissing(vntOrgBsdCd) Then vntOrgBsdCd = Empty
    If Not IsMissing(vntOrgBsdName) Then vntOrgBsdName = Empty
    If Not IsMissing(vntOrgRoomCd) Then vntOrgRoomCd = Empty
    If Not IsMissing(vntOrgRoomName) Then vntOrgRoomName = Empty
    If Not IsMissing(vntOrgPostCd) Then vntOrgPostCd = Empty
    If Not IsMissing(vntOrgPostName) Then vntOrgPostName = Empty
    If Not IsMissing(vntIsrSign) Then vntIsrSign = Empty
    If Not IsMissing(vntIsrNo) Then vntIsrNo = Empty
    If Not IsMissing(vntQuePrintDate) Then vntQuePrintDate = Empty
    If Not IsMissing(vntCtrPtCd) Then vntCtrPtCd = Empty
    If Not IsMissing(vntRptUpdDate) Then vntRptUpdDate = Empty
    If Not IsMissing(vntLastName) Then vntLastName = Empty
    If Not IsMissing(vntFirstName) Then vntFirstName = Empty
    If Not IsMissing(vntLastKName) Then vntLastKName = Empty
    If Not IsMissing(vntFirstKName) Then vntFirstKName = Empty
    If Not IsMissing(vntBirth) Then vntBirth = Empty
    If Not IsMissing(vntGender) Then vntGender = Empty
    If Not IsMissing(vntDoctorCd) Then vntDoctorCd = Empty
    If Not IsMissing(vntDoctorName) Then vntDoctorName = Empty
    If Not IsMissing(vntCameraCslDate) Then vntCameraCslDate = Empty
    If Not IsMissing(vntSpare1) Then vntSpare1 = Empty
    If Not IsMissing(vntCslDivCd) Then vntCslDivCd = Empty
    If Not IsMissing(vntRsvGrpCd) Then vntRsvGrpCd = Empty
    If Not IsMissing(vntCslCount) Then vntCslCount = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    If Not IsMissing(vntCancelFlg) Then
        If vntCancelFlg <> "" Then
            objOraParam.Add "CANCELFLG", vntCancelFlg, ORAPARM_INPUT, ORATYPE_NUMBER
        End If
    End If

    '検索条件を満たす受診情報テーブルのレコードを取得
'## 2003.11.18 Mod by T.Takagi@FSIT 不要項目削除
'    strStmt = "SELECT CONSULT.CSLDATE,                    " & vbLf & _
'              "       CONSULT.CANCELFLG,                  " & vbLf & _
'              "       CONSULT.PERID,                      " & vbLf & _
'              "       CONSULT.CSCD,                       " & vbLf & _
'              "       CONSULT.ORGCD1,                     " & vbLf & _
'              "       CONSULT.ORGCD2,                     " & vbLf & _
'              "       CONSULT.TIMEFRA,                    " & vbLf & _
'              "       CONSULT.RSVDATE,                    " & vbLf & _
'              "       TO_CHAR(CONSULT.AGE, '999.99') AGE, " & vbLf & _
'              "       CONSULT.UPDDATE,                    " & vbLf & _
'              "       CONSULT.UPDUSER,                    " & vbLf & _
'              "       CONSULT.REPORTPRINTDATE,            " & vbLf & _
'              "       CONSULT.REPORTVERSION,              " & vbLf & _
'              "       CONSULT.RECOGNO,                    " & vbLf & _
'              "       CONSULT.GOVNO,                      " & vbLf & _
'              "       CONSULT.FIRSTRSVNO,                 " & vbLf & _
'              "       CONSULT.FREEDIV,                    " & vbLf & _
'              "       CONSULT.FREECOMMENT,                " & vbLf & _
'              "       CONSULT.CANCELFLG,                  " & vbLf & _
'              "       CONSULT.REPORTDOCNO,                " & vbLf & _
'              "       CONSULT.REPORTORDERNO,              "
'
'    strStmt = strStmt & vbLf & _
'              "       CONSULT.CSLDATEFIXFLG,      " & vbLf & _
'              "       CONSULT.OCRCSLDATE,         " & vbLf & _
'              "       CONSULT.ORGBSDCD,           " & vbLf & _
'              "       CONSULT.ORGROOMCD,          " & vbLf & _
'              "       CONSULT.ORGPOSTCD,          " & vbLf & _
'              "       CONSULT.ISRSIGN,            " & vbLf & _
'              "       CONSULT.ISRNO,              " & vbLf & _
'              "       CONSULT.QUEPRINTDATE,       " & vbLf & _
'              "       CONSULT.CTRPTCD,            " & vbLf & _
'              "       ORG.ORGSNAME,               " & vbLf & _
'              "       ORGBSD.ORGBSDNAME,          " & vbLf & _
'              "       ORGROOM.ORGROOMNAME,        " & vbLf & _
'              "       ORGPOST.ORGPOSTNAME,        " & vbLf & _
'              "       RECEIPT.UPDDATE RPTUPDDATE, " & vbLf & _
'              "       PERSON.LASTNAME,            " & vbLf & _
'              "       PERSON.FIRSTNAME,           " & vbLf & _
'              "       PERSON.LASTKNAME,           " & vbLf & _
'              "       PERSON.FIRSTKNAME,          " & vbLf & _
'              "       PERSON.BIRTH,               " & vbLf & _
'              "       PERSON.GENDER,              " & vbLf & _
'              "       CONSULT.DOCTORCD,           " & vbLf & _
'              "       DOCTOR.USERNAME DOCTORNAME, " & vbLf & _
'              "       CONSULT.CAMERACSLDATE,      " & vbLf & _
'              "       PERSON.SPARE1,              "
    strStmt = "SELECT CONSULT.CSLDATE,                    " & vbLf & _
              "       CONSULT.CANCELFLG,                  " & vbLf & _
              "       CONSULT.PERID,                      " & vbLf & _
              "       CONSULT.CSCD,                       " & vbLf & _
              "       CONSULT.ORGCD1,                     " & vbLf & _
              "       CONSULT.ORGCD2,                     " & vbLf & _
              "       CONSULT.RSVDATE,                    " & vbLf & _
              "       TO_CHAR(CONSULT.AGE, '999.99') AGE, " & vbLf & _
              "       CONSULT.UPDDATE,                    " & vbLf & _
              "       CONSULT.UPDUSER,                    " & vbLf & _
              "       CONSULT.REPORTPRINTDATE,            " & vbLf & _
              "       CONSULT.FIRSTRSVNO,                 " & vbLf & _
              "       CONSULT.CANCELFLG,                  "

    strStmt = strStmt & vbLf & _
              "       CONSULT.ISRSIGN,            " & vbLf & _
              "       CONSULT.ISRNO,              " & vbLf & _
              "       CONSULT.CTRPTCD,            " & vbLf & _
              "       ORG.ORGSNAME,               " & vbLf & _
              "       RECEIPT.UPDDATE RPTUPDDATE, " & vbLf & _
              "       PERSON.LASTNAME,            " & vbLf & _
              "       PERSON.FIRSTNAME,           " & vbLf & _
              "       PERSON.LASTKNAME,           " & vbLf & _
              "       PERSON.FIRSTKNAME,          " & vbLf & _
              "       PERSON.BIRTH,               " & vbLf & _
              "       PERSON.GENDER,              " & vbLf & _
              "       PERSON.SPARE1,              "
'## 2003.11.18 Mod End

    strStmt = strStmt & vbLf & _
              "       COURSE_P.CSNAME,                   " & vbLf & _
              "       ORG.ORGNAME,                       " & vbLf & _
              "       HAINSUSER.USERNAME,                " & vbLf & _
              "       RECEIPT.DAYID,                     " & vbLf & _
              "       FIRSTCONSULT.CSLDATE FIRSTCSLDATE, " & vbLf & _
              "       FIRSTCOURSE.CSNAME   FIRSTCSNAME,  " & vbLf & _
              "       CONSULT.CSLDIVCD,                  " & vbLf & _
              "       CONSULT.RSVGRPCD,                  " & vbLf & _
              "       PERSON.CSLCOUNT                    "

'## 2003.11.18 Mod by T.Takagi@FSIT 不要項目削除
'    strStmt = strStmt & vbLf & _
'              "  FROM HAINSUSER DOCTOR,                          " & vbLf & _
'              "       PERSON,                                    " & vbLf & _
'              "       COURSE_P FIRSTCOURSE,                      " & vbLf & _
'              "       CONSULT  FIRSTCONSULT,                     " & vbLf & _
'              "       ORGPOST, ORGROOM, ORGBSD,                  " & vbLf & _
'              "       HAINSUSER, ORG, COURSE_P, RECEIPT, CONSULT " & vbLf & _
'              " WHERE CONSULT.RSVNO     = :RSVNO                 "
    strStmt = strStmt & vbLf & _
              "  FROM PERSON,                                    " & vbLf & _
              "       COURSE_P FIRSTCOURSE,                      " & vbLf & _
              "       CONSULT  FIRSTCONSULT,                     " & vbLf & _
              "       HAINSUSER, ORG, COURSE_P, RECEIPT, CONSULT " & vbLf & _
              " WHERE CONSULT.RSVNO     = :RSVNO                 "
'## 2003.11.18 Mod End

    'キャンセルフラグ指定時は条件節に追加
    If Not IsMissing(vntCancelFlg) Then
        If vntCancelFlg <> "" Then
            strStmt = strStmt & vbLf & _
              "   AND CONSULT.CANCELFLG = :CANCELFLG "
        End If
    End If

    strStmt = strStmt & vbLf & _
              "   AND CONSULT.CSCD       = COURSE_P.CSCD         " & vbLf & _
              "   AND CONSULT.ORGCD1     = ORG.ORGCD1            " & vbLf & _
              "   AND CONSULT.ORGCD2     = ORG.ORGCD2            " & vbLf & _
              "   AND CONSULT.UPDUSER    = HAINSUSER.USERID(+)   " & vbLf & _
              "   AND CONSULT.FIRSTRSVNO = FIRSTCONSULT.RSVNO(+) " & vbLf & _
              "   AND FIRSTCONSULT.CSCD  = FIRSTCOURSE.CSCD(+)   " & vbLf & _
              "   AND CONSULT.RSVNO      = RECEIPT.RSVNO(+)      " & vbLf & _
              "   AND CONSULT.CSLDATE    = RECEIPT.CSLDATE(+)    "

'## 2003.11.18 Mod by T.Takagi@FSIT 不要項目削除
'    strStmt = strStmt & vbLf & _
'              "   AND CONSULT.ORGCD1     = ORGBSD.ORGCD1     " & vbLf & _
'              "   AND CONSULT.ORGCD2     = ORGBSD.ORGCD2     " & vbLf & _
'              "   AND CONSULT.ORGBSDCD   = ORGBSD.ORGBSDCD   " & vbLf & _
'              "   AND CONSULT.ORGCD1     = ORGROOM.ORGCD1    " & vbLf & _
'              "   AND CONSULT.ORGCD2     = ORGROOM.ORGCD2    " & vbLf & _
'              "   AND CONSULT.ORGBSDCD   = ORGROOM.ORGBSDCD  " & vbLf & _
'              "   AND CONSULT.ORGROOMCD  = ORGROOM.ORGROOMCD " & vbLf & _
'              "   AND CONSULT.ORGCD1     = ORGPOST.ORGCD1    " & vbLf & _
'              "   AND CONSULT.ORGCD2     = ORGPOST.ORGCD2    " & vbLf & _
'              "   AND CONSULT.ORGBSDCD   = ORGPOST.ORGBSDCD  " & vbLf & _
'              "   AND CONSULT.ORGROOMCD  = ORGPOST.ORGROOMCD " & vbLf & _
'              "   AND CONSULT.ORGPOSTCD  = ORGPOST.ORGPOSTCD " & vbLf & _
'              "   AND CONSULT.PERID      = PERSON.PERID      " & vbLf & _
'              "   AND CONSULT.DOCTORCD   = DOCTOR.USERID(+)  "
    strStmt = strStmt & vbLf & _
              "   AND CONSULT.PERID      = PERSON.PERID "
'## 2003.11.18 Mod End

    'レコードロック指定
    If blnLock Then
        strStmt = strStmt & vbLf & _
          "   FOR UPDATE"
    End If

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCancelFlg = objFields("CANCELFLG")
        Set objCslDate = objFields("CSLDATE")
        Set objPerId = objFields("PERID")
        Set objCsCd = objFields("CSCD")
        Set objCsName = objFields("CSNAME")
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objOrgName = objFields("ORGNAME")
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'        Set objTimeFra = objFields("TIMEFRA")
'## 2003.11.18 Del End
        Set objRsvDate = objFields("RSVDATE")
        Set objAge = objFields("AGE")
        Set objUpdDate = objFields("UPDDATE")
        Set objUpdUser = objFields("UPDUSER")
        Set objUpdUserName = objFields("USERNAME")
        Set objReportPrintDate = objFields("REPORTPRINTDATE")
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'        Set objReportVersion = objFields("REPORTVERSION")
'        Set objRecogNo = objFields("RECOGNO")
'        Set objGovNo = objFields("GOVNO")
'## 2003.11.18 Del End
        Set objFirstRsvNo = objFields("FIRSTRSVNO")
        Set objFirstCslDate = objFields("FIRSTCSLDATE")
        Set objFirstCsName = objFields("FIRSTCSNAME")
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'        Set objFreeDiv = objFields("FREEDIV")
'        Set objFreeComment = objFields("FREECOMMENT")
'## 2003.11.18 Del End
        Set objDayId = objFields("DAYID")
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'        Set objReportDocNo = objFields("REPORTDOCNO")
'        Set objReportOrderNo = objFields("REPORTORDERNO")
'        Set objCslDateFixFlg = objFields("CSLDATEFIXFLG")
'        Set objOcrCslDate = objFields("OCRCSLDATE")
'## 2003.11.18 Del End
        Set objOrgSName = objFields("ORGSNAME")
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'        Set objOrgBsdCd = objFields("ORGBSDCD")
'        Set objOrgBsdName = objFields("ORGBSDNAME")
'        Set objOrgRoomCd = objFields("ORGROOMCD")
'        Set objOrgRoomName = objFields("ORGROOMNAME")
'        Set objOrgPostCd = objFields("ORGPOSTCD")
'        Set objOrgPostName = objFields("ORGPOSTNAME")
'## 2003.11.18 Del End
        Set objIsrSign = objFields("ISRSIGN")
        Set objIsrNo = objFields("ISRNO")
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'        Set objQuePrintDate = objFields("QUEPRINTDATE")
'## 2003.11.18 Del End
        Set objCtrPtCd = objFields("CTRPTCD")
        Set objRptUpdDate = objFields("RPTUPDDATE")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastKName = objFields("LASTKNAME")
        Set objFirstKName = objFields("FIRSTKNAME")
        Set objBirth = objFields("BIRTH")
        Set objGender = objFields("GENDER")
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'        Set objDoctorCd = objFields("DOCTORCD")
'        Set objDoctorName = objFields("DOCTORNAME")
'        Set objCameraCslDate = objFields("CAMERACSLDATE")
'## 2003.11.18 Del End
        Set objSpare1 = objFields("SPARE1")
        Set objCslDivCd = objFields("CSLDIVCD")
        Set objRsvGrpCd = objFields("RSVGRPCD")
        Set objCslCount = objFields("CSLCOUNT")

        '戻り値の設定

        If Not IsMissing(vntCancelFlg) Then
            If vntCancelFlg = "" Then
                vntCancelFlg = objCancelFlg.Value
            End If
        End If

        If Not IsMissing(vntCslDate) Then vntCslDate = objCslDate.Value
        If Not IsMissing(vntPerId) Then vntPerId = objPerId.Value
        If Not IsMissing(vntCsCd) Then vntCsCd = objCsCd.Value
        If Not IsMissing(vntCsName) Then vntCsName = objCsName.Value
        If Not IsMissing(vntOrgCd1) Then vntOrgCd1 = objOrgCd1.Value
        If Not IsMissing(vntOrgCd2) Then vntOrgCd2 = objOrgCd2.Value
        If Not IsMissing(vntOrgName) Then vntOrgName = objOrgName.Value
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'        If Not IsMissing(vntTimeFra) Then vntTimeFra = objTimeFra.Value
'## 2003.11.18 Del End
        If Not IsMissing(vntRsvDate) Then vntRsvDate = objRsvDate.Value
        If Not IsMissing(vntAge) Then vntAge = Trim(objAge.Value)
        If Not IsMissing(vntUpdDate) Then vntUpdDate = objUpdDate.Value & ""
        If Not IsMissing(vntUpdUser) Then vntUpdUser = objUpdUser.Value & ""
        If Not IsMissing(vntUpdUserName) Then vntUpdUserName = objUpdUserName.Value & ""
        If Not IsMissing(vntReportPrintDate) Then vntReportPrintDate = objReportPrintDate.Value & ""
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'        If Not IsMissing(vntReportVersion) Then vntReportVersion = objReportVersion.Value & ""
'        If Not IsMissing(vntRecogNo) Then vntRecogNo = objRecogNo.Value & ""
'        If Not IsMissing(vntGovNo) Then vntGovNo = objGovNo.Value & ""
'## 2003.11.18 Del End
        If Not IsMissing(vntFirstRsvNo) Then vntFirstRsvNo = objFirstRsvNo.Value & ""
        If Not IsMissing(vntFirstCslDate) Then vntFirstCslDate = objFirstCslDate.Value & ""
        If Not IsMissing(vntFirstCsName) Then vntFirstCsName = objFirstCsName.Value & ""
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'        If Not IsMissing(vntFreeDiv) Then vntFreeDiv = objFreeDiv.Value & ""
'        If Not IsMissing(vntFreeComment) Then vntFreeComment = objFreeComment.Value & ""
'## 2003.11.18 Del End
        If Not IsMissing(vntDayId) Then vntDayId = objDayId.Value & ""
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'        If Not IsMissing(vntReportDocNo) Then vntReportDocNo = objReportDocNo.Value & ""
'        If Not IsMissing(vntReportOrderNo) Then vntReportOrderNo = objReportOrderNo.Value & ""
'        If Not IsMissing(vntCslDateFixFlg) Then vntCslDateFixFlg = objCslDateFixFlg.Value & ""
'        If Not IsMissing(vntOcrCslDate) Then vntOcrCslDate = objOcrCslDate.Value & ""
'## 2003.11.18 Del End
        If Not IsMissing(vntOrgSName) Then vntOrgSName = objOrgSName.Value & ""
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'        If Not IsMissing(vntOrgBsdCd) Then vntOrgBsdCd = objOrgBsdCd.Value & ""
'        If Not IsMissing(vntOrgBsdName) Then vntOrgBsdName = objOrgBsdName.Value & ""
'        If Not IsMissing(vntOrgRoomCd) Then vntOrgRoomCd = objOrgRoomCd.Value & ""
'        If Not IsMissing(vntOrgRoomName) Then vntOrgRoomName = objOrgRoomName.Value & ""
'        If Not IsMissing(vntOrgPostCd) Then vntOrgPostCd = objOrgPostCd.Value & ""
'        If Not IsMissing(vntOrgPostName) Then vntOrgPostName = objOrgPostName.Value & ""
'## 2003.11.18 Del End
        If Not IsMissing(vntIsrSign) Then vntIsrSign = objIsrSign.Value & ""
        If Not IsMissing(vntIsrNo) Then vntIsrNo = objIsrNo.Value & ""
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'        If Not IsMissing(vntQuePrintDate) Then vntQuePrintDate = objQuePrintDate.Value & ""
'## 2003.11.18 Del End
        If Not IsMissing(vntCtrPtCd) Then vntCtrPtCd = objCtrPtCd.Value & ""
        If Not IsMissing(vntRptUpdDate) Then vntRptUpdDate = objRptUpdDate.Value & ""
        If Not IsMissing(vntLastName) Then vntLastName = objLastName.Value & ""
        If Not IsMissing(vntFirstName) Then vntFirstName = objFirstName.Value & ""
        If Not IsMissing(vntLastKName) Then vntLastKName = objLastKName.Value & ""
        If Not IsMissing(vntFirstKName) Then vntFirstKName = objFirstKName.Value & ""
        If Not IsMissing(vntBirth) Then vntBirth = objBirth.Value & ""
        If Not IsMissing(vntGender) Then vntGender = objGender.Value & ""
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'        If Not IsMissing(vntDoctorCd) Then vntDoctorCd = objDoctorCd.Value & ""
'        If Not IsMissing(vntDoctorName) Then vntDoctorName = objDoctorName.Value & ""
'        If Not IsMissing(vntCameraCslDate) Then vntCameraCslDate = objCameraCslDate.Value & ""
'## 2003.11.18 Del End
        If Not IsMissing(vntSpare1) Then vntSpare1 = objSpare1.Value & ""
        If Not IsMissing(vntCslDivCd) Then vntCslDivCd = objCslDivCd.Value & ""
        If Not IsMissing(vntRsvGrpCd) Then vntRsvGrpCd = objRsvGrpCd.Value & ""
        If Not IsMissing(vntCslCount) Then vntCslCount = objCslCount.Value & ""
        
        SelectConsult = True

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
    WriteErrorLog "Consult.SelectConsult"
    
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
' 機能　　 : 検索条件を満たす受診者の一覧を取得する(枠予約用)
'
' 引数　　 : (In)     lngStrRsvNo    開始予約番号
' 　　　　   (In)     lngEndRsvNo    終了予約番号
' 　　　　   (Out)    vntRsvNo       予約番号
' 　　　　   (Out)    vntCslDate     受診日
' 　　　　   (Out)    vntWebColor    webカラー
' 　　　　   (Out)    vntCsName      コース名
' 　　　　   (Out)    vntPerId       個人ＩＤ
' 　　　　   (Out)    vntLastName    姓
' 　　　　   (Out)    vntFirstName   名
' 　　　　   (Out)    vntLastKName   カナ姓
' 　　　　   (Out)    vntFirstKName  カナ名
' 　　　　   (Out)    vntGender      性別
' 　　　　   (Out)    vntBirth       生年月日
' 　　　　   (Out)    vntAge         年齢
' 　　　　   (Out)    vntOrgCd1      団体コード１
' 　　　　   (Out)    vntOrgCd2      団体コード２
' 　　　　   (Out)    vntOrgSName    団体略称
' 　　　　   (Out)    vntOptName     オプション名
' 　　　　   (Out)    vntRsvGrpName  予約群名称
' 　　　　   (Out)    vntCompPerId   同伴者個人ＩＤ
' 　　　　   (Out)    vntHasFriends  お連れ様情報の有無
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
'## 2003.11.28 Mod By T.Takagi@FSIT 同伴者個人ＩＤ、お連れ様情報の有無を追加
'Public Function SelectConsultListForFraRsv(
'    ByVal lngStrRsvNo As Long,
'    ByVal lngEndRsvNo As Long,
'    Optional ByRef vntRsvNo As Variant,
'    Optional ByRef vntCslDate As Variant,
'    Optional ByRef vntWebColor As Variant,
'    Optional ByRef vntCsName As Variant,
'    Optional ByRef vntPerId As Variant,
'    Optional ByRef vntLastName As Variant,
'    Optional ByRef vntFirstName As Variant,
'    Optional ByRef vntLastKName As Variant,
'    Optional ByRef vntFirstKName As Variant,
'    Optional ByRef vntGender As Variant,
'    Optional ByRef vntBirth As Variant,
'    Optional ByRef vntAge As Variant,
'    Optional ByRef vntOrgCd1 As Variant,
'    Optional ByRef vntOrgCd2 As Variant,
'    Optional ByRef vntOrgSName As Variant,
'    Optional ByRef vntOptName As Variant,
'    Optional ByRef vntRsvGrpName As Variant
') As Long
Public Function SelectConsultListForFraRsv( _
    ByVal lngStrRsvNo As Long, _
    ByVal lngEndRsvNo As Long, _
    Optional ByRef vntRsvNo As Variant, _
    Optional ByRef vntCslDate As Variant, _
    Optional ByRef vntWebColor As Variant, _
    Optional ByRef vntCsName As Variant, _
    Optional ByRef vntPerId As Variant, _
    Optional ByRef vntLastName As Variant, _
    Optional ByRef vntFirstName As Variant, _
    Optional ByRef vntLastKName As Variant, _
    Optional ByRef vntFirstKName As Variant, _
    Optional ByRef vntGender As Variant, _
    Optional ByRef vntBirth As Variant, _
    Optional ByRef vntAge As Variant, _
    Optional ByRef vntOrgCd1 As Variant, _
    Optional ByRef vntOrgCd2 As Variant, _
    Optional ByRef vntOrgSName As Variant, _
    Optional ByRef vntOptName As Variant, _
    Optional ByRef vntRsvGrpName As Variant, _
    Optional ByRef vntCompPerId As Variant, _
    Optional ByRef vntHasFriends As Variant _
) As Long
'## 2003.11.28 Mod End

    Dim objOraParam                 As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna                  As OraDynaset       'ダイナセット
    Dim strStmt                     As String           'SQLステートメント

    Dim objFields                   As OraFields        'フィールドオブジェクト
    Dim objRsvNo                    As OraField         '予約番号
    Dim objCslDate                  As OraField         '受診日
    Dim objWebColor                 As OraField         'webカラー
    Dim objCsName                   As OraField         'コース名
    Dim objPerId                    As OraField         '個人ＩＤ
    Dim objLastName                 As OraField         '姓
    Dim objFirstName                As OraField         '名
    Dim objLastKName                As OraField         'カナ姓
    Dim objFirstKName               As OraField         'カナ名
    Dim objGender                   As OraField         '性別
    Dim objBirth                    As OraField         '生年月日
    Dim objAge                      As OraField         '年齢
    Dim objOrgCd1                   As OraField         '団体コード１
    Dim objOrgCd2                   As OraField         '団体コード２
    Dim objOrgSName                 As OraField         '団体略称
    Dim objOptName                  As OraField         'オプション名
    Dim objRsvGrpName               As OraField         '予約群名称
'## 2003.11.28 Add By T.Takagi@FSIT 同伴者個人ＩＤ、お連れ様情報の有無を追加
    Dim objCompPerId                As OraField         '同伴者個人ＩＤ
    Dim objHasFriends               As OraField         'お連れ様情報の有無
'## 2003.11.28 Add End

    Dim vntArrRsvNo()               As Variant          '予約番号の配列
    Dim vntArrCslDate()             As Variant          '受診日の配列
    Dim vntArrWebColor()            As Variant          'webカラーの配列
    Dim vntArrCsName()              As Variant          'コース名の配列
    Dim vntArrPerId()               As Variant          '個人ＩＤの配列
    Dim vntArrLastName()            As Variant          '姓の配列
    Dim vntArrFirstName()           As Variant          '名の配列
    Dim vntArrLastKName()           As Variant          'カナ姓の配列
    Dim vntArrFirstKName()          As Variant          'カナ名の配列
    Dim vntArrGender()              As Variant          '性別の配列
    Dim vntArrBirth()               As Variant          '生年月日の配列
    Dim vntArrAge()                 As Variant          '年齢の配列
    Dim vntArrOrgCd1()              As Variant          '団体コード１の配列
    Dim vntArrOrgCd2()              As Variant          '団体コード２の配列
    Dim vntArrOrgSName()            As Variant          '団体略称の配列
    Dim vntArrOptName()             As Variant          'コース略称の配列
    Dim vntArrRsvGrpName()          As Variant          'オプション名の配列
'## 2003.11.28 Add By T.Takagi@FSIT 同伴者個人ＩＤ、お連れ様情報の有無を追加
    Dim vntArrCompPerId()           As Variant          '同伴者個人ＩＤの配列
    Dim vntArrHasFriends()          As Variant          'お連れ様情報の有無の配列
'## 2003.11.28 Add End
    Dim lngCount                    As Long             'レコード数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If Not IsMissing(vntCslDate) Then vntCslDate = Empty
    If Not IsMissing(vntWebColor) Then vntWebColor = Empty
    If Not IsMissing(vntCsName) Then vntCsName = Empty
    If Not IsMissing(vntPerId) Then vntPerId = Empty
    If Not IsMissing(vntLastName) Then vntLastName = Empty
    If Not IsMissing(vntFirstName) Then vntFirstName = Empty
    If Not IsMissing(vntLastKName) Then vntLastKName = Empty
    If Not IsMissing(vntFirstKName) Then vntFirstKName = Empty
    If Not IsMissing(vntGender) Then vntGender = Empty
    If Not IsMissing(vntBirth) Then vntBirth = Empty
    If Not IsMissing(vntAge) Then vntAge = Empty
    If Not IsMissing(vntOrgCd1) Then vntOrgCd1 = Empty
    If Not IsMissing(vntOrgCd2) Then vntOrgCd2 = Empty
    If Not IsMissing(vntOrgSName) Then vntOrgSName = Empty
    If Not IsMissing(vntOptName) Then vntOptName = Empty
    If Not IsMissing(vntRsvGrpName) Then vntRsvGrpName = Empty
'## 2003.11.28 Add By T.Takagi@FSIT 同伴者個人ＩＤ、お連れ様情報の有無を追加
    If Not IsMissing(vntCompPerId) Then vntCompPerId = Empty
    If Not IsMissing(vntHasFriends) Then vntHasFriends = Empty
'## 2003.11.28 Add End
    lngCount = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "STRRSVNO", lngStrRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ENDRSVNO", lngEndRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER

    '指定予約番号範囲の受診者一覧を取得
'## 2003.11.28 Mod By T.Takagi@FSIT 同伴者個人ＩＤ、お連れ様情報の有無を追加
'    strStmt = "SELECT CONSULT.RSVNO,     CONSULT.CSLDATE, COURSE_P.WEBCOLOR, CTRPT.CSNAME,      " & vbLf & _
'              "       CONSULT.PERID,     PERSON.LASTNAME, PERSON.FIRSTNAME,  PERSON.LASTKNAME,  " & vbLf & _
'              "       PERSON.FIRSTKNAME, PERSON.GENDER,   PERSON.BIRTH,      CONSULT.AGE,       " & vbLf & _
'              "       CONSULT.ORGCD1,    CONSULT.ORGCD2,  ORG.ORGSNAME,      RSVGRP.RSVGRPNAME, " & vbLf & _
'              "       CONSULTPACKAGELUKES.GETOPTNAMELISTFORFRARSV(CONSULT.RSVNO) OPTNAME        " & vbLf & _
'              "  FROM RSVGRP, ORG, PERSON, CTRPT, COURSE_P, CONSULT                             " & vbLf & _
'              " WHERE CONSULT.RSVNO BETWEEN :STRRSVNO AND :ENDRSVNO                             " & vbLf & _
'              "   AND CONSULT.CSCD     = COURSE_P.CSCD                                          " & vbLf & _
'              "   AND CONSULT.CTRPTCD  = CTRPT.CTRPTCD                                          " & vbLf & _
'              "   AND CONSULT.PERID    = PERSON.PERID                                           " & vbLf & _
'              "   AND CONSULT.ORGCD1   = ORG.ORGCD1                                             " & vbLf & _
'              "   AND CONSULT.ORGCD2   = ORG.ORGCD2                                             " & vbLf & _
'              "   AND CONSULT.RSVGRPCD = RSVGRP.RSVGRPCD                                        " & vbLf & _
'              " ORDER BY CONSULT.RSVNO                                                          "
    strStmt = "SELECT CONSULT.RSVNO,     CONSULT.CSLDATE, COURSE_P.WEBCOLOR, CTRPT.CSNAME,      " & vbLf & _
              "       CONSULT.PERID,     PERSON.LASTNAME, PERSON.FIRSTNAME,  PERSON.LASTKNAME,  " & vbLf & _
              "       PERSON.FIRSTKNAME, PERSON.GENDER,   PERSON.BIRTH,      CONSULT.AGE,       " & vbLf & _
              "       CONSULT.ORGCD1,    CONSULT.ORGCD2,  ORG.ORGSNAME,      RSVGRP.RSVGRPNAME, " & vbLf & _
              "       CONSULTPACKAGELUKES.GETOPTNAMELISTFORFRARSV(CONSULT.RSVNO) OPTNAME,       " & vbLf & _
              "       PERSON.COMPPERID,                                                         " & vbLf & _
              "       ( SELECT COUNT(*)                                                         " & vbLf & _
              "           FROM FRIENDS                                                          " & vbLf & _
              "          WHERE RSVNO = CONSULT.RSVNO ) HASFRIENDS                               " & vbLf & _
              "  FROM RSVGRP, ORG, PERSON, CTRPT, COURSE_P, CONSULT                             " & vbLf & _
              " WHERE CONSULT.RSVNO BETWEEN :STRRSVNO AND :ENDRSVNO                             " & vbLf & _
              "   AND CONSULT.CSCD     = COURSE_P.CSCD                                          " & vbLf & _
              "   AND CONSULT.CTRPTCD  = CTRPT.CTRPTCD                                          " & vbLf & _
              "   AND CONSULT.PERID    = PERSON.PERID                                           " & vbLf & _
              "   AND CONSULT.ORGCD1   = ORG.ORGCD1                                             " & vbLf & _
              "   AND CONSULT.ORGCD2   = ORG.ORGCD2                                             " & vbLf & _
              "   AND CONSULT.RSVGRPCD = RSVGRP.RSVGRPCD                                        " & vbLf & _
              " ORDER BY CONSULT.RSVNO                                                          "
'## 2003.11.28 Mod End
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objCslDate = objFields("CSLDATE")
        Set objWebColor = objFields("WEBCOLOR")
        Set objCsName = objFields("CSNAME")
        Set objPerId = objFields("PERID")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastKName = objFields("LASTKNAME")
        Set objFirstKName = objFields("FIRSTKNAME")
        Set objGender = objFields("GENDER")
        Set objBirth = objFields("BIRTH")
        Set objAge = objFields("AGE")
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objOrgSName = objFields("ORGSNAME")
        Set objOptName = objFields("OPTNAME")
        Set objRsvGrpName = objFields("RSVGRPNAME")
'## 2003.11.28 Add By T.Takagi@FSIT 同伴者個人ＩＤ、お連れ様情報の有無を追加
        Set objCompPerId = objFields("COMPPERID")
        Set objHasFriends = objFields("HASFRIENDS")
'## 2003.11.28 Add End

        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrCslDate(lngCount)
            ReDim Preserve vntArrWebColor(lngCount)
            ReDim Preserve vntArrCsName(lngCount)
            ReDim Preserve vntArrPerId(lngCount)
            ReDim Preserve vntArrLastName(lngCount)
            ReDim Preserve vntArrFirstName(lngCount)
            ReDim Preserve vntArrLastKName(lngCount)
            ReDim Preserve vntArrFirstKName(lngCount)
            ReDim Preserve vntArrGender(lngCount)
            ReDim Preserve vntArrBirth(lngCount)
            ReDim Preserve vntArrAge(lngCount)
            ReDim Preserve vntArrOrgCd1(lngCount)
            ReDim Preserve vntArrOrgCd2(lngCount)
            ReDim Preserve vntArrOrgSName(lngCount)
            ReDim Preserve vntArrOptName(lngCount)
            ReDim Preserve vntArrRsvGrpName(lngCount)
'## 2003.11.28 Add By T.Takagi@FSIT 同伴者個人ＩＤ、お連れ様情報の有無を追加
            ReDim Preserve vntArrCompPerId(lngCount)
            ReDim Preserve vntArrHasFriends(lngCount)
'## 2003.11.28 Add End
            vntArrRsvNo(lngCount) = objRsvNo.Value & ""
            vntArrCslDate(lngCount) = objCslDate.Value & ""
            vntArrWebColor(lngCount) = objWebColor.Value & ""
            vntArrCsName(lngCount) = objCsName.Value & ""
            vntArrPerId(lngCount) = objPerId.Value & ""
            vntArrLastName(lngCount) = objLastName.Value & ""
            vntArrFirstName(lngCount) = objFirstName.Value & ""
            vntArrLastKName(lngCount) = objLastKName.Value & ""
            vntArrFirstKName(lngCount) = objFirstKName.Value & ""
            vntArrGender(lngCount) = objGender.Value & ""
            vntArrBirth(lngCount) = objBirth.Value & ""
            vntArrAge(lngCount) = objAge.Value & ""
            vntArrOrgCd1(lngCount) = objOrgCd1.Value & ""
            vntArrOrgCd2(lngCount) = objOrgCd2.Value & ""
            vntArrOrgSName(lngCount) = objOrgSName.Value & ""
            vntArrOptName(lngCount) = objOptName.Value & ""
            vntArrRsvGrpName(lngCount) = objRsvGrpName.Value & ""
'## 2003.11.28 Add By T.Takagi@FSIT 同伴者個人ＩＤ、お連れ様情報の有無を追加
            vntArrCompPerId(lngCount) = objCompPerId.Value & ""
            vntArrHasFriends(lngCount) = IIf(CLng(objHasFriends.Value) > 0, "1", "")
'## 2003.11.28 Add End
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        If Not IsMissing(vntRsvNo) Then vntRsvNo = vntArrRsvNo
        If Not IsMissing(vntCslDate) Then vntCslDate = vntArrCslDate
        If Not IsMissing(vntWebColor) Then vntWebColor = vntArrWebColor
        If Not IsMissing(vntCsName) Then vntCsName = vntArrCsName
        If Not IsMissing(vntPerId) Then vntPerId = vntArrPerId
        If Not IsMissing(vntLastName) Then vntLastName = vntArrLastName
        If Not IsMissing(vntFirstName) Then vntFirstName = vntArrFirstName
        If Not IsMissing(vntLastKName) Then vntLastKName = vntArrLastKName
        If Not IsMissing(vntFirstKName) Then vntFirstKName = vntArrFirstKName
        If Not IsMissing(vntGender) Then vntGender = vntArrGender
        If Not IsMissing(vntBirth) Then vntBirth = vntArrBirth
        If Not IsMissing(vntAge) Then vntAge = vntArrAge
        If Not IsMissing(vntOrgCd1) Then vntOrgCd1 = vntArrOrgCd1
        If Not IsMissing(vntOrgCd2) Then vntOrgCd2 = vntArrOrgCd2
        If Not IsMissing(vntOrgSName) Then vntOrgSName = vntArrOrgSName
        If Not IsMissing(vntOptName) Then vntOptName = vntArrOptName
        If Not IsMissing(vntRsvGrpName) Then vntRsvGrpName = vntArrRsvGrpName
'## 2003.11.28 Add By T.Takagi@FSIT 同伴者個人ＩＤ、お連れ様情報の有無を追加
        If Not IsMissing(vntCompPerId) Then vntCompPerId = vntArrCompPerId
        If Not IsMissing(vntHasFriends) Then vntHasFriends = vntArrHasFriends
'## 2003.11.28 Add End
        
    End If

'## 2003.11.28 Add By T.Takagi@FSIT
    Set objRsvNo = Nothing
    Set objCslDate = Nothing
    Set objWebColor = Nothing
    Set objCsName = Nothing
    Set objPerId = Nothing
    Set objLastName = Nothing
    Set objFirstName = Nothing
    Set objLastKName = Nothing
    Set objFirstKName = Nothing
    Set objGender = Nothing
    Set objBirth = Nothing
    Set objAge = Nothing
    Set objOrgCd1 = Nothing
    Set objOrgCd2 = Nothing
    Set objOrgSName = Nothing
    Set objOptName = Nothing
    Set objRsvGrpName = Nothing
    Set objCompPerId = Nothing
    Set objHasFriends = Nothing
    Set objFields = Nothing
    Set objOraDyna = Nothing
'## 2003.11.28 Add End

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

'## 2003.11.28 Add By T.Takagi@FSIT
    Set objOraParam = Nothing
'## 2003.11.28 Add End

    '戻り値の設定
    SelectConsultListForFraRsv = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectConsultListForFraRsv = -1

    'イベントログ書き込み
    WriteErrorLog "Consult.SelectConsultListForFraRsv"
    
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
'## 2004.01.16 Add Function By T.Takagi@FSIT 更新履歴表示機能追加
Public Function SelectConsultLog( _
    ByVal lngRsvNo As Long, _
    ByVal lngSeq As Long, _
    Optional ByRef vntUpdDate As Variant, _
    Optional ByRef vntUpdUser As Variant, _
    Optional ByRef vntUserName As Variant, _
    Optional ByRef vntCslInfo As Variant _
) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objUpdDate          As OraField         '更新日
    Dim objUpdUser          As OraField         'ユーザＩＤ
    Dim objUserName         As OraField         'ユーザ名
    Dim objCslInfo          As OraField         '予約更新情報
    
    Dim objCLob             As OraClob          'OraCLobオブジェクト
    Dim vntWkCslInfo        As Variant          '予約更新情報
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntUpdDate) Then vntUpdDate = Empty
    If Not IsMissing(vntUpdUser) Then vntUpdUser = Empty
    If Not IsMissing(vntUserName) Then vntUserName = Empty
    If Not IsMissing(vntCslInfo) Then vntCslInfo = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SEQ", lngSeq, ORAPARM_INPUT, ORATYPE_NUMBER

    strStmt = "SELECT CONSULT_LOG.UPDDATE, CONSULT_LOG.UPDUSER, " & vbLf & _
              "       CONSULT_LOG.CSLINFO, HAINSUSER.USERNAME   " & vbLf & _
              "  FROM HAINSUSER, CONSULT_LOG                    " & vbLf & _
              " WHERE CONSULT_LOG.RSVNO   = :RSVNO              " & vbLf & _
              "   AND CONSULT_LOG.SEQ     = :SEQ                " & vbLf & _
              "   AND CONSULT_LOG.UPDUSER = HAINSUSER.USERID(+) "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objUpdDate = objFields("UPDDATE")
        Set objUpdUser = objFields("UPDUSER")
        Set objUserName = objFields("USERNAME")
        Set objCslInfo = objFields("CSLINFO")

        'CLOBデータの取り出し
        Set objCLob = objCslInfo.Value
        objCLob.Read vntWkCslInfo
        
        'XMLの宣言部はここでは取り除く
        vntWkCslInfo = Replace(vntWkCslInfo, "<?xml version=""1.0""?>", "")
        
        '戻り値の設定
        If Not IsMissing(vntUpdDate) Then vntUpdDate = objUpdDate.Value & ""
        If Not IsMissing(vntUpdUser) Then vntUpdUser = objUpdUser.Value & ""
        If Not IsMissing(vntUserName) Then vntUserName = objUserName.Value & ""
        If Not IsMissing(vntCslInfo) Then vntCslInfo = vntWkCslInfo

        SelectConsultLog = True

        Set objCLob = Nothing
        Set objUpdDate = Nothing
        Set objUpdUser = Nothing
        Set objUserName = Nothing
        Set objCslInfo = Nothing
        Set objFields = Nothing
        
    End If

    Set objOraDyna = Nothing
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Consult.SelectConsultLog"
    
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

'## 2004.01.16 Add Function By T.Takagi@FSIT 更新履歴表示機能追加
Public Function SelectConsultLogList( _
    ByVal dtmStrDate As Date, _
    ByVal dtmEndDate As Date, _
    ByVal lngRsvNo As Long, _
    ByVal strUpdUser As String, _
    ByVal lngOrderByItem As Long, _
    ByVal lngOrderByMode As Long, _
    ByVal lngStartPos As Long, _
    ByVal lngGetCount As Long, _
    ByRef vntRsvNo As Variant, _
    ByRef vntSeq As Variant, _
    ByRef vntUpdDate As Variant, _
    ByRef vntUpdUser As Variant, _
    ByRef vntUserName As Variant, _
    ByRef vntCslInfo As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    Dim strOrderByClause    As String           'ORDER BY句
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRsvNo            As OraField         '予約番号
    Dim objSeq              As OraField         'SEQ
    Dim objUpdDate          As OraField         '更新日
    Dim objUpdUser          As OraField         'ユーザＩＤ
    Dim objUserName         As OraField         'ユーザ名
    Dim objCslInfo          As OraField         '予約更新情報

    Dim vntArrRsvNo()       As Variant          '予約番号の配列
    Dim vntArrSeq()         As Variant          'SEQの配列
    Dim vntArrUpdDate()     As Variant          '更新日の配列
    Dim vntArrUpdUser()     As Variant          'ユーザＩＤの配列
    Dim vntArrUserName()    As Variant          'ユーザ名の配列
    Dim vntArrCslInfo()     As Variant          '予約更新情報の配列
    Dim lngCount            As Long             'レコード数

    Dim dtmDate             As Date             '更新日
    Dim lngPhase            As Long             '取得フェイズ(0:件数のみ、1:実データ)
    Dim i                   As Long             'インデックス

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    vntRsvNo = Empty
    vntSeq = Empty
    vntUpdDate = Empty
    vntUpdUser = Empty
    vntUserName = Empty
    vntCslInfo = Empty
    lngCount = 0

    '開始日より終了日が過去であれば値を交換
    If dtmStrDate > dtmEndDate Then
        dtmDate = dtmStrDate
        dtmStrDate = dtmEndDate
        dtmEndDate = dtmDate
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "STRDATE", dtmStrDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDDATE", dtmEndDate + 1, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "RSVNO", IIf(lngRsvNo > 0, lngRsvNo, Null), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "UPDUSER", IIf(strUpdUser <> "", strUpdUser, Null), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "STARTPOS", lngStartPos, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ENDPOS", (lngStartPos + lngGetCount - 1), ORAPARM_INPUT, ORATYPE_NUMBER

    '条件節の編集

    '件数取得と実データ取得という２回分のSQL発行
    For lngPhase = 0 To 1
        
        Select Case lngPhase
        
            Case 0  '件数取得の場合
            
'## 2004.10.27 Mod By T.Takagi@FSIT 更新履歴への遷移追加(チューニング)
'                strStmt = "SELECT COUNT(*)                                                 " & vbLf & _
'                          "  FROM CONSULT_LOG                                              " & vbLf & _
'                          " WHERE CONSULT_LOG.UPDDATE >= :STRDATE                          " & vbLf & _
'                          "   AND CONSULT_LOG.UPDDATE <  :ENDDATE                          " & vbLf & _
'                          "   AND CONSULT_LOG.RSVNO   = NVL(:RSVNO,   CONSULT_LOG.RSVNO)   " & vbLf & _
'                          "   AND CONSULT_LOG.UPDUSER = NVL(:UPDUSER, CONSULT_LOG.UPDUSER) "
                strStmt = "SELECT COUNT(*)                                                 " & vbLf & _
                          "  FROM CONSULT_LOG                                              " & vbLf & _
                          " WHERE CONSULT_LOG.UPDDATE >= :STRDATE                          " & vbLf & _
                          "   AND CONSULT_LOG.UPDDATE <  :ENDDATE                          " & vbLf & _
                          "   AND CONSULT_LOG.UPDUSER = NVL(:UPDUSER, CONSULT_LOG.UPDUSER) "
                
                If lngRsvNo > 0 Then
                    strStmt = strStmt & vbLf & _
                          "   AND CONSULT_LOG.RSVNO   = :RSVNO "
                End If
'## 2004.10.27 Mod End

            Case 1  '実データ取得の場合
        
'## 2004.10.27 Mod By T.Takagi@FSIT 更新履歴への遷移追加(チューニング)
'                strStmt = "SELECT LOGLIST.RSVNO, LOGLIST.SEQ, LOGLIST.UPDDATE, LOGLIST.UPDUSER, LOGLIST.USERNAME, CONSULT_LOG.CSLINFO " & vbLf & _
'                          "  FROM CONSULT_LOG,                                                                                        " & vbLf & _
'                          "       ( SELECT ROWNUM ROWSEQ, RSVNO, SEQ, UPDDATE, UPDUSER, USERNAME                                      " & vbLf & _
'                          "           FROM ( SELECT CONSULT_LOG.RSVNO, CONSULT_LOG.SEQ, CONSULT_LOG.UPDDATE, CONSULT_LOG.UPDUSER,     " & vbLf & _
'                          "                         HAINSUSER.USERNAME                                                                " & vbLf & _
'                          "                    FROM HAINSUSER, CONSULT_LOG                                                            " & vbLf & _
'                          "                   WHERE CONSULT_LOG.UPDDATE >= :STRDATE                                                   " & vbLf & _
'                          "                     AND CONSULT_LOG.UPDDATE <  :ENDDATE                                                   " & vbLf & _
'                          "                     AND CONSULT_LOG.RSVNO   = NVL(:RSVNO, CONSULT_LOG.RSVNO)                              " & vbLf & _
'                          "                     AND CONSULT_LOG.UPDUSER = NVL(:UPDUSER, CONSULT_LOG.UPDUSER)                          " & vbLf & _
'                          "                     AND CONSULT_LOG.UPDUSER = HAINSUSER.USERID                                            "
                strStmt = "SELECT LOGLIST.RSVNO, LOGLIST.SEQ, LOGLIST.UPDDATE, LOGLIST.UPDUSER, LOGLIST.USERNAME, CONSULT_LOG.CSLINFO " & vbLf & _
                          "  FROM CONSULT_LOG,                                                                                        " & vbLf & _
                          "       ( SELECT ROWNUM ROWSEQ, RSVNO, SEQ, UPDDATE, UPDUSER, USERNAME                                      " & vbLf & _
                          "           FROM ( SELECT CONSULT_LOG.RSVNO, CONSULT_LOG.SEQ, CONSULT_LOG.UPDDATE, CONSULT_LOG.UPDUSER,     " & vbLf & _
                          "                         HAINSUSER.USERNAME                                                                " & vbLf & _
                          "                    FROM HAINSUSER, CONSULT_LOG                                                            " & vbLf & _
                          "                   WHERE CONSULT_LOG.UPDDATE >= :STRDATE                                                   " & vbLf & _
                          "                     AND CONSULT_LOG.UPDDATE <  :ENDDATE                                                   " & vbLf & _
                          "                     AND CONSULT_LOG.UPDUSER = NVL(:UPDUSER, CONSULT_LOG.UPDUSER)                          " & vbLf & _
                          "                     AND CONSULT_LOG.UPDUSER = HAINSUSER.USERID                                            "

                If lngRsvNo > 0 Then
                    strStmt = strStmt & vbLf & _
                          "                     AND CONSULT_LOG.RSVNO   = :RSVNO "
                End If
'## 2004.10.27 Mod End

                'ソート項目の設定
                Select Case lngOrderByItem
                    Case 1      'ユーザＩＤ、更新日、予約番号順
                        strOrderByClause = " ORDER BY HAINSUSER.USERNAME XXX, CONSULT_LOG.UPDDATE XXX, CONSULT_LOG.RSVNO XXX "
                    Case 2      '予約番号、更新日、ユーザＩＤ順
                        strOrderByClause = " ORDER BY CONSULT_LOG.RSVNO XXX, CONSULT_LOG.UPDDATE XXX, HAINSUSER.USERNAME XXX "
                    Case Else   '更新日、ユーザＩＤ、予約番号順
                        strOrderByClause = " ORDER BY CONSULT_LOG.UPDDATE XXX, HAINSUSER.USERNAME XXX, CONSULT_LOG.RSVNO XXX "
                End Select
                          
                'ソート順の設定
                strOrderByClause = Replace(strOrderByClause, "XXX", IIf(lngOrderByMode = 1, "DESC", "ASC"))
                          
                strStmt = strStmt & vbLf & strOrderByClause
                
                strStmt = strStmt & vbLf & _
                          "                )                        " & vbLf & _
                          "       ) LOGLIST                         " & vbLf & _
                          " WHERE LOGLIST.RSVNO = CONSULT_LOG.RSVNO " & vbLf & _
                          "   AND LOGLIST.SEQ   = CONSULT_LOG.SEQ   "

                If lngStartPos > 0 And lngGetCount > 0 Then
                    strStmt = strStmt & vbLf & _
                          "   AND LOGLIST.ROWSEQ BETWEEN :STARTPOS AND :ENDPOS "
                End If
                
                strStmt = strStmt & vbLf & _
                          " ORDER BY LOGLIST.ROWSEQ "

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
            Set objRsvNo = objFields("RSVNO")
            Set objSeq = objFields("SEQ")
            Set objUpdDate = objFields("UPDDATE")
            Set objUpdUser = objFields("UPDUSER")
            Set objUserName = objFields("USERNAME")
            Set objCslInfo = objFields("CSLINFO")
        
            '配列形式で格納する
            i = 0
            Do Until objOraDyna.EOF
                ReDim Preserve vntArrRsvNo(i)
                ReDim Preserve vntArrSeq(i)
                ReDim Preserve vntArrUpdDate(i)
                ReDim Preserve vntArrUpdUser(i)
                ReDim Preserve vntArrUserName(i)
                ReDim Preserve vntArrCslInfo(i)
                vntArrRsvNo(i) = objRsvNo.Value & ""
                vntArrSeq(i) = objSeq.Value & ""
                vntArrUpdDate(i) = objUpdDate.Value & ""
                vntArrUpdUser(i) = objUpdUser.Value & ""
                vntArrUserName(i) = objUserName.Value & ""
'                vntArrCslInfo(i) = objCslInfo.Value & ""
                vntArrCslInfo(i) = ""
                i = i + 1
                objOraDyna.MoveNext
            Loop
            
            '戻り値の設定
            vntRsvNo = vntArrRsvNo
            vntSeq = vntArrSeq
            vntUpdDate = vntArrUpdDate
            vntUpdUser = vntArrUpdUser
            vntUserName = vntArrUserName
            vntCslInfo = vntArrCslInfo
            
            Exit Do
        Loop
        
        '件数取得にて０件の場合は処理を終了する
        If lngPhase = 0 And lngCount = 0 Then
            Exit For
        End If
        
    Next lngPhase

    'トランザクションをコミット
    mobjContext.SetComplete

    Set objRsvNo = Nothing
    Set objSeq = Nothing
    Set objUpdDate = Nothing
    Set objUpdUser = Nothing
    Set objUserName = Nothing
    Set objCslInfo = Nothing
    Set objFields = Nothing
    Set objOraDyna = Nothing
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    Set objOraParam = Nothing
    
    '戻り値の設定
    SelectConsultLogList = lngCount

    Exit Function

ErrorHandle:

    SelectConsultLogList = -1

    'イベントログ書き込み
    WriteErrorLog "Consult.SelectConsultLogList"
    
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
' 機能　　 : 指定予約番号の出力情報を取得する
'
' 引数　　 : (In)     lngRsvNo            予約番号
' 　　　　   (Out)    dtmLetterDate       確認はがき出力日時
' 　　　　   (Out)    dtmFormDate       　一式書式出力日時
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectConsultPrintStatus( _
    ByVal lngRsvNo As Long, _
    Optional ByRef vntCardPrintDate As Variant, _
    Optional ByRef vntFormPrintDate As Variant _
) As Boolean

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objCancelFlg        As OraField         'キャンセルフラグ
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objRsvNo            As OraField         '予約番号
    Dim objCardPrintDate    As OraField         '確認はがき出力日時
    Dim objFormPrintDate    As OraField         '一式書式出力日時

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntCardPrintDate) Then vntCardPrintDate = Empty
    If Not IsMissing(vntFormPrintDate) Then vntFormPrintDate = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER

    '検索条件を満たす受診情報テーブルのレコードを取得
    strStmt = "SELECT CARDPRINTDATE, FORMPRINTDATE " & vbLf & _
              "  FROM CONSULT                      " & vbLf & _
              " WHERE RSVNO = :RSVNO               "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCardPrintDate = objFields("CARDPRINTDATE")
        Set objFormPrintDate = objFields("FORMPRINTDATE")

        '戻り値の設定

        If Not IsMissing(vntCardPrintDate) Then vntCardPrintDate = objCardPrintDate.Value & ""
        If Not IsMissing(vntFormPrintDate) Then vntFormPrintDate = objFormPrintDate.Value & ""

        SelectConsultPrintStatus = True

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
    WriteErrorLog "Consult.SelectConsultPrintStatus"

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
' 機能　　 : はがき出力日時、一式書式出力日時を更新する
'
' 引数   　: (In)     lngRsvNo             予約番号
'     　　 : (In)     vntCardPrintDate     はがき出力日時
'        　: (In)     vntFormPrintDate     一式書式出力日時

'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
Public Function UpdateConsultPrintStatus( _
    ByVal lngRsvNo As Long, _
    ByVal vntCardPrintDate As Variant, _
    ByVal vntFormPrintDate As Variant _
) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
 
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER

    If vntCardPrintDate = "" Then
        objOraParam.Add "CARDPRINTDATE", Null, ORAPARM_INPUT, ORATYPE_DATE
    Else
        objOraParam.Add "CARDPRINTDATE", vntCardPrintDate, ORAPARM_INPUT, ORATYPE_DATE
    End If

    If vntFormPrintDate = "" Then
        objOraParam.Add "FORMPRINTDATE", Null, ORAPARM_INPUT, ORATYPE_DATE
    Else
        objOraParam.Add "FORMPRINTDATE", vntFormPrintDate, ORAPARM_INPUT, ORATYPE_DATE
    End If
    
    '出力日レコードの更新
    strStmt = "UPDATE CONSULT        " & vbLf & _
              "   SET CARDPRINTDATE = :CARDPRINTDATE, " & vbLf & _
              "       FORMPRINTDATE = :FORMPRINTDATE  " & vbLf & _
              " WHERE RSVNO         = :RSVNO          "
          
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete

    '戻り値の設定
    UpdateConsultPrintStatus = True

    Exit Function

ErrorHandle:

    UpdateConsultPrintStatus = False

    'イベントロ\\\グ書き込み
    WriteErrorLog "Consult.UpdateConsultPrintStatus"

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
' 機能　　 : 指定予約番号の受診時追加グループ情報を取得する
'
' 引数　　 : (In)     lngRsvNo    予約番号
' 　　　　   (Out)    vntGrpCd    グループコード
' 　　　　   (Out)    vntGrpName  グループ名
' 　　　　   (Out)    vntEditFlg  修正区分
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectConsult_G(ByVal lngRsvNo As Long, ByRef vntGrpCd As Variant, ByRef vntGrpName As Variant, ByRef vntEditFlg As Variant) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント

    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objGrpCd        As OraField         'グループコード
    Dim objGrpName      As OraField         'グループ名
    Dim objEditFlg      As OraField         '修正区分

    Dim vntArrGrpCd()   As Variant          'グループコードの配列
    Dim vntArrGrpName() As Variant          'グループ名の配列
    Dim vntArrEditFlg() As Variant          '修正区分の配列
    Dim lngCount        As Long             'レコード数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    vntGrpCd = Empty
    vntGrpName = Empty
    vntEditFlg = Empty
    lngCount = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER

    '指定予約番号の受診時追加グループ情報を取得する
    strStmt = "SELECT CONSULT_G.GRPCD, CONSULT_G.EDITFLG, " & vbLf & _
              "       GRP_P.GRPNAME                       " & vbLf & _
              "  FROM GRP_P, CONSULT_G                    " & vbLf & _
              " WHERE CONSULT_G.RSVNO = :RSVNO            " & vbLf & _
              "   AND CONSULT_G.GRPCD = GRP_P.GRPCD       " & vbLf & _
              " ORDER BY CONSULT_G.RSVNO, CONSULT_G.GRPCD "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objGrpCd = objFields("GRPCD")
        Set objGrpName = objFields("GRPNAME")
        Set objEditFlg = objFields("EDITFLG")

        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrGrpCd(lngCount)
            ReDim Preserve vntArrGrpName(lngCount)
            ReDim Preserve vntArrEditFlg(lngCount)
            vntArrGrpCd(lngCount) = objGrpCd.Value & ""
            vntArrGrpName(lngCount) = objGrpName.Value & ""
            vntArrEditFlg(lngCount) = objEditFlg.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        vntGrpCd = vntArrGrpCd
        vntGrpName = vntArrGrpName
        vntEditFlg = vntArrEditFlg

    End If

    'バインド変数の削除
    objOraParam.Remove "RSVNO"

    '戻り値の設定
    SelectConsult_G = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectConsult_G = -1

    'イベントログ書き込み
    WriteErrorLog "Consult.SelectConsult_G"
    
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
' 機能　　 : 検索条件を満たす受診者の個人情報を取得する
'
' 引数　　 : (In)     strRsvNo        予約番号
' 　　　　 : (Out)    strPerId        個人ＩＤ
' 　　　　 : (Out)    strCslDate      受診日
' 　　　　 : (Out)    strCsCd         コースコード
' 　　　　 : (Out)    strCsName       コース名
' 　　　　 : (Out)    strLastName     姓
' 　　　　 : (Out)    strFirstName  　名
' 　　　　 : (Out)    strLastKName    カナ姓
' 　　　　 : (Out)    strFirstKName 　カナ名
' 　　　　 : (Out)    strBirth        生年月日
' 　　　　 : (Out)    strAge          年齢
' 　　　　 : (Out)    strGender       性別
' 　　　　 : (Out)    strGenderName   性別名称
' 　　　　 : (Out)    vntDayId        当日ＩＤ
' 　　　　 : (Out)    vntDoctorCd     医師コード（省略可能）
' 　　　　 : (Out)    vntDoctorName   医師名称（省略可能）
'
' 戻り値　 : メッセージ
'
' 備考　　 :
'
Public Function SelectOcrConsult(ByVal strRsvNo As String, _
                                 ByRef strPerId As String, _
                                 ByRef strCslDate As String, _
                                 ByRef strCsName As String, _
                                 ByRef strLastName As String, _
                                 ByRef strFirstName As String, _
                                 ByRef strLastKName As String, _
                                 ByRef strFirstKName As String, _
                                 ByRef strBirth As String, _
                                 ByRef strAge As String, _
                                 ByRef strGender As String, _
                                 ByRef strGenderName As String, _
                                 ByRef strOrgName As String _
                                ) As String

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント

    Dim objCommon       As Common           '共通クラス

    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objPerId        As OraField         '個人ＩＤ
    Dim objCslDate      As OraField         '受診日
    Dim objCsName       As OraField         'コース名
    Dim objLastName     As OraField         '姓
    Dim objFirstName    As OraField         '名
    Dim objLastKName    As OraField         'カナ姓
    Dim objFirstKName   As OraField         'カナ名
    Dim objBirth        As OraField         '生年月日
    Dim objAge          As OraField         '年齢
    Dim objGender       As OraField         '性別
    Dim objGenderName   As OraField         '性別名称
    Dim objOrgName      As OraField         '受診団体名称

    Dim strMessage      As String           'エラーメッセージ

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    SelectOcrConsult = ""

    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")

    '予約番号チェック
    strMessage = objCommon.CheckNumeric("予約番号", strRsvNo, LENGTH_CONSULT_RSVNO, CHECK_NECESSARY)
    If strMessage <> "" Then
        SelectOcrConsult = strMessage
        Exit Function
    End If

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", Trim(strRsvNo), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CANCELFLG", CStr(CONSULT_USED), ORAPARM_INPUT, ORATYPE_NUMBER

    '検索条件を満たす受診者情報のレコードを取得
    strStmt = "SELECT CN.PERID,    CN.CSLDATE,  CP.CSNAME,    P.LASTNAME,  " & vbLf & _
              "       P.FIRSTNAME, P.LASTKNAME, P.FIRSTKNAME, P.BIRTH,      " & vbLf & _
              "       CN.AGE,      P.GENDER,                                " & vbLf & _
              "       DECODE(P.GENDER, '1', '男性', '2', '女性')  D_GENDER, " & vbLf & _
              "       OG.ORGNAME                                            " & vbLf & _
              "  FROM CONSULT CN,  PERSON P, COURSE_P CP, ORG OG            " & vbLf & _
              " WHERE CN.RSVNO     = :RSVNO                                 " & vbLf & _
              "   AND CN.CANCELFLG = :CANCELFLG                             " & vbLf & _
              "   AND CN.PERID     = P.PERID                                " & vbLf & _
              "   AND CN.CSCD      = CP.CSCD                                " & vbLf & _
              "   AND CN.ORGCD1    = OG.ORGCD1                              " & vbLf & _
              "   AND CN.ORGCD2    = OG.ORGCD2                              "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields

        Set objPerId = objFields("PERID")
        Set objCslDate = objFields("CSLDATE")
        Set objCsName = objFields("CSNAME")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastKName = objFields("LASTKNAME")
        Set objFirstKName = objFields("FIRSTKNAME")
        Set objBirth = objFields("BIRTH")
        Set objAge = objFields("AGE")
        Set objGender = objFields("GENDER")
        Set objGenderName = objFields("D_GENDER")
        Set objOrgName = objFields("ORGNAME")

        '戻り値の設定
        strPerId = objPerId.Value
        strCslDate = objCslDate.Value
        strCsName = objCsName.Value & ""
        strLastName = objLastName.Value & ""
        strFirstName = objFirstName.Value & ""
        strLastKName = objLastKName.Value & ""
        strFirstKName = objFirstKName.Value & ""
        strBirth = objBirth.Value
        strAge = Format(objAge.Value, "#0.00")
        strGender = objGender.Value
        strGenderName = objGenderName.Value & ""
        strOrgName = objOrgName.Value & ""
    Else
        SelectOcrConsult = "受診者情報に存在しない受診番号です。"
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
    WriteErrorLog "Consult.SelectOcrConsult"
    
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
' 機能　　 : オーダ発行済みの受診情報一覧を取得する
'
' 引数　　 : (In)     dtmCslDate        受診日（検査日）
' 　　　　   (In)     vntInCsCd         コースコード
' 　　　　   (In)     vntOnlyInsItem    TRUE:検体検査情報のみ取得、それ以外:全て取得
' 　　　　   (Out)    vntRsvNo          予約番号
' 　　　　   (Out)    vntCslDate        受診日（予約上の受診日）
' 　　　　   (Out)    vntPerId          個人ＩＤ
' 　　　　   (Out)    vntCsCd           コースコード
' 　　　　   (Out)    vntCsName         コース名
' 　　　　   (Out)    vntOrgCd1         団体コード１
' 　　　　   (Out)    vntOrgCd2         団体コード２
' 　　　　   (Out)    vntOrgName        団体名
' 　　　　   (Out)    vntLastName       名前（性）
' 　　　　   (Out)    vntFirstName      名前（名）
' 　　　　   (Out)    vntLastKName      名前（性）
' 　　　　   (Out)    vntFirstKName     名前（名）
' 　　　　   (Out)    vntGender         性別
' 　　　　   (Out)    vntAge            受診時年齢
' 　　　　   (Out)    vntBirth          生年月日
' 　　　　   (Out)    vntDayID          当日ＩＤ
' 　　　　   (Out)    vntOrderNo        オーダNo
' 　　　　   (Out)    vntDocCd          文書コード
' 　　　　   (Out)    vntDocTytle       文書種別名
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectOrderedConsult(ByVal dtmCslDate As Date, _
                                     Optional ByVal vntInCsCd As Variant, _
                                     Optional ByVal vntOnlyInsItem As Variant, _
                                     Optional ByRef vntRsvNo As Variant, _
                                     Optional ByRef vntCslDate As Variant, _
                                     Optional ByRef vntPerId As Variant, _
                                     Optional ByRef vntCsCd As Variant, _
                                     Optional ByRef vntCsName As Variant, _
                                     Optional ByRef vntOrgCd1 As Variant, _
                                     Optional ByRef vntOrgCd2 As Variant, _
                                     Optional ByRef vntOrgName As Variant, _
                                     Optional ByRef vntLastName As Variant, _
                                     Optional ByRef vntFirstName As Variant, _
                                     Optional ByRef vntLastKName As Variant, _
                                     Optional ByRef vntFirstKName As Variant, _
                                     Optional ByRef vntGender As Variant, _
                                     Optional ByRef vntAge As Variant, _
                                     Optional ByRef vntBirth As Variant, _
                                     Optional ByRef vntDayId As Variant, _
                                     Optional ByRef vntOrderNo As Variant, _
                                     Optional ByRef vntDocCd As Variant, _
                                     Optional ByRef vntDocTytle As Variant) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRsvNo            As OraField         '予約番号
    Dim objCslDate          As OraField         '受診日（予約上の受診日）
    Dim objPerId            As OraField         '個人ＩＤ
    Dim objCsCd             As OraField         'コースコード
    Dim objCsName           As OraField         'コース名
    Dim objOrgCd1           As OraField         '団体コード１
    Dim objOrgCd2           As OraField         '団体コード２
    Dim objOrgName          As OraField         '団体名
    Dim objLastName         As OraField         '名前（性）
    Dim objFirstName        As OraField         '名前（名）
    Dim objLastKName        As OraField         '名前（性）
    Dim objFirstKName       As OraField         '名前（名）
    Dim objGender           As OraField         '性別
    Dim objAge              As OraField         '受診時年齢
    Dim objBirth            As OraField         '生年月日
    Dim objDayId            As OraField         '当日ＩＤ
    Dim objOrderNo          As OraField         'オーダ番号
    Dim objDocCd            As OraField         '文書種別コード
    Dim objDocTitle         As OraField         '文書種別名

    Dim vntArrRsvNo()       As Variant         '予約番号
    Dim vntArrCslDate()     As Variant         '受診日（予約上の受診日）
    Dim vntArrPerId()       As Variant         '個人ＩＤ
    Dim vntArrCsCd()        As Variant         'コースコード
    Dim vntArrCsName()      As Variant         'コース名
    Dim vntArrOrgCd1()      As Variant         '団体コード１
    Dim vntArrOrgCd2()      As Variant         '団体コード２
    Dim vntArrOrgName()     As Variant         '団体名
    Dim vntArrLastName()    As Variant         '名前（性）
    Dim vntArrFirstName()   As Variant         '名前（名）
    Dim vntArrLastKName()   As Variant         '名前（性）
    Dim vntArrFirstKName()  As Variant         '名前（名）
    Dim vntArrGender()      As Variant         '性別
    Dim vntArrAge()         As Variant         '受診時年齢
    Dim vntArrBirth()       As Variant         '生年月日
    Dim vntArrDayId()       As Variant         '当日ＩＤ
    Dim vntArrOrderNo()     As Variant         'オーダ番号
    Dim vntArrDocCd()       As Variant         '文書種別コード
    Dim vntArrDocTitle()    As Variant         '文書種別名

    Dim lngCount        As Long             'レコード数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    lngCount = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE

    '指定日のオーダ発行済み受診情報一覧を取得
    strStmt = "SELECT DISTINCT RECEIPT.DAYID, RECEIPT.RSVNO, CONSULT.CSLDATE, CONSULT.PERID, CONSULT.CSCD, COURSE_P.CSNAME, " & vbLf & _
              "       FREE.FREENAME DOCTITLE, ORDEREDDOC.ORDERNO, ORDEREDDOC.DOCCD," & vbLf & _
              "       CONSULT.ORGCD1, CONSULT.ORGCD2, ORG.ORGNAME, PERSON.LASTNAME, PERSON.FIRSTNAME," & vbLf & _
              "       PERSON.LASTKNAME, PERSON.FIRSTKNAME," & vbLf & _
              "       PERSON.GENDER, CONSULT.AGE, PERSON.BIRTH" & vbLf & _
              "  FROM ORG ORG, COURSE_P COURSE_P, PERSON PERSON, CONSULT CONSULT, " & vbLf & _
              "       FREE FREE, ORDEREDDOC ORDEREDDOC, RECEIPT RECEIPT" & vbLf & _
              " WHERE RECEIPT.CSLDATE  = :CSLDATE" & vbLf & _
              "   AND ORDEREDDOC.RSVNO = RECEIPT.RSVNO" & vbLf & _
              "   AND CONSULT.RSVNO    = RECEIPT.RSVNO" & vbLf

    'コースコードの指定がされている場合は、条件追加
    If IsMissing(vntInCsCd) = False Then
        If Trim(vntInCsCd) <> "" Then
            objOraParam.Add "CSCD", vntInCsCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
            strStmt = strStmt & _
                      "   AND CONSULT.CSCD = :CSCD" & vbLf
        End If
    End If

    '検体検査のみの指定がされている場合は、条件追加
    If IsMissing(vntOnlyInsItem) = False Then
        If vntOnlyInsItem = True Then
            strStmt = strStmt & _
              "   AND FREE.FREEFIELD1  = '1'" & vbLf
        End If
    End If

    strStmt = strStmt & _
              "   AND FREE.FREECD      = ORDEREDDOC.DOCCD" & vbLf & _
              "   AND PERSON.PERID     = CONSULT.PERID" & vbLf & _
              "   AND COURSE_P.CSCD    = CONSULT.CSCD" & vbLf & _
              "   AND ORG.ORGCD1       = CONSULT.ORGCD1" & vbLf & _
              "   AND ORG.ORGCD2       = CONSULT.ORGCD2" & vbLf & _
              " ORDER BY RECEIPT.DAYID"

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objCslDate = objFields("CSLDATE")
        Set objPerId = objFields("PERID")
        Set objCsCd = objFields("CSCD")
        Set objCsName = objFields("CSNAME")
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objOrgName = objFields("ORGNAME")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastKName = objFields("LASTKNAME")
        Set objFirstKName = objFields("FIRSTKNAME")
        Set objGender = objFields("GENDER")
        Set objAge = objFields("AGE")
        Set objBirth = objFields("BIRTH")
        Set objDayId = objFields("DAYID")
        Set objOrderNo = objFields("ORDERNO")
        Set objDocCd = objFields("DOCCD")
        Set objDocTitle = objFields("DOCTITLE")

        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrCslDate(lngCount)
            ReDim Preserve vntArrPerId(lngCount)
            ReDim Preserve vntArrCsCd(lngCount)
            ReDim Preserve vntArrCsName(lngCount)
            ReDim Preserve vntArrOrgCd1(lngCount)
            ReDim Preserve vntArrOrgCd2(lngCount)
            ReDim Preserve vntArrOrgName(lngCount)
            ReDim Preserve vntArrLastName(lngCount)
            ReDim Preserve vntArrFirstName(lngCount)
            ReDim Preserve vntArrLastKName(lngCount)
            ReDim Preserve vntArrFirstKName(lngCount)
            ReDim Preserve vntArrGender(lngCount)
            ReDim Preserve vntArrAge(lngCount)
            ReDim Preserve vntArrBirth(lngCount)
            ReDim Preserve vntArrDayId(lngCount)
            ReDim Preserve vntArrOrderNo(lngCount)
            ReDim Preserve vntArrDocCd(lngCount)
            ReDim Preserve vntArrDocTitle(lngCount)
            
            vntArrRsvNo(lngCount) = objRsvNo.Value & ""
            vntArrCslDate(lngCount) = objCslDate.Value & ""
            vntArrPerId(lngCount) = objPerId.Value & ""
            vntArrCsCd(lngCount) = objCsCd.Value & ""
            vntArrCsName(lngCount) = objCsName.Value & ""
            vntArrOrgCd1(lngCount) = objOrgCd1.Value & ""
            vntArrOrgCd2(lngCount) = objOrgCd2.Value & ""
            vntArrOrgName(lngCount) = objOrgName.Value & ""
            vntArrLastName(lngCount) = objLastName.Value & ""
            vntArrFirstName(lngCount) = objFirstName.Value & ""
            vntArrLastKName(lngCount) = objLastKName.Value & ""
            vntArrFirstKName(lngCount) = objFirstKName.Value & ""
            vntArrGender(lngCount) = objGender.Value & ""
            vntArrAge(lngCount) = objAge.Value & ""
            vntArrBirth(lngCount) = objBirth.Value & ""
            
            vntArrDayId(lngCount) = objDayId.Value & ""
            vntArrOrderNo(lngCount) = objOrderNo.Value & ""
            vntArrDocCd(lngCount) = objDocCd.Value & ""
            vntArrDocTitle(lngCount) = objDocTitle.Value & ""
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        
        Loop

        '戻り値の設定
        If IsMissing(vntRsvNo) = False Then vntRsvNo = vntArrRsvNo
        If IsMissing(vntCslDate) = False Then vntCslDate = vntArrCslDate
        If IsMissing(vntPerId) = False Then vntPerId = vntArrPerId
        If IsMissing(vntCsCd) = False Then vntCsCd = vntArrCsCd
        If IsMissing(vntCsName) = False Then vntCsName = vntArrCsName
        If IsMissing(vntOrgCd1) = False Then vntOrgCd1 = vntArrOrgCd1
        If IsMissing(vntOrgCd2) = False Then vntOrgCd2 = vntArrOrgCd2
        If IsMissing(vntOrgName) = False Then vntOrgName = vntArrOrgName
        If IsMissing(vntLastName) = False Then vntLastName = vntArrLastName
        If IsMissing(vntFirstName) = False Then vntFirstName = vntArrFirstName
        If IsMissing(vntLastKName) = False Then vntLastKName = vntArrLastKName
        If IsMissing(vntFirstKName) = False Then vntFirstKName = vntArrFirstKName
        If IsMissing(vntGender) = False Then vntGender = vntArrGender
        If IsMissing(vntAge) = False Then vntAge = vntArrAge
        If IsMissing(vntBirth) = False Then vntBirth = vntArrBirth
        If IsMissing(vntDayId) = False Then vntDayId = vntArrDayId
        If IsMissing(vntOrderNo) = False Then vntOrderNo = vntArrOrderNo
        If IsMissing(vntDocCd) = False Then vntDocCd = vntArrDocCd
        If IsMissing(vntDocTytle) = False Then vntDocTytle = vntArrDocTitle

    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    SelectOrderedConsult = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectOrderedConsult = -1

    'イベントログ書き込み
    WriteErrorLog "Consult.SelectOrderedConsult"
    
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
' 機能　　 : 指定予約番号の受診時追加検査項目情報を取得する
'
' 引数　　 : (In)     lngRsvNo        予約番号
' 　　　　   (Out)    vntItemCd       検査項目コード
' 　　　　   (Out)    vntRequestName  依頼項目名
' 　　　　   (Out)    vntEditFlg      修正区分
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectConsult_I(ByVal lngRsvNo As Long, ByRef vntItemCd As Variant, ByRef vntRequestName As Variant, ByRef vntEditFlg As Variant) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objItemCd           As OraField         '検査項目コード
    Dim objRequestName      As OraField         '依頼項目名
    Dim objEditFlg          As OraField         '修正区分

    Dim vntArrItemCd()      As Variant          '検査項目コードの配列
    Dim vntArrRequestName() As Variant          '依頼項目名の配列
    Dim vntArrEditFlg()     As Variant          '修正区分の配列
    Dim lngCount            As Long             'レコード数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    vntItemCd = Empty
    vntRequestName = Empty
    vntEditFlg = Empty
    lngCount = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER

    '指定予約番号の受診時追加検査項目情報を取得する
    strStmt = "SELECT CONSULT_I.ITEMCD, CONSULT_I.EDITFLG, " & vbLf & _
              "       ITEM_P.REQUESTNAME                   " & vbLf & _
              "  FROM ITEM_P, CONSULT_I                    " & vbLf & _
              " WHERE CONSULT_I.RSVNO  = :RSVNO            " & vbLf & _
              "   AND CONSULT_I.ITEMCD = ITEM_P.ITEMCD     " & vbLf & _
              " ORDER BY CONSULT_I.RSVNO, CONSULT_I.ITEMCD "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objItemCd = objFields("ITEMCD")
        Set objRequestName = objFields("REQUESTNAME")
        Set objEditFlg = objFields("EDITFLG")

        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrItemCd(lngCount)
            ReDim Preserve vntArrRequestName(lngCount)
            ReDim Preserve vntArrEditFlg(lngCount)
            vntArrItemCd(lngCount) = objItemCd.Value & ""
            vntArrRequestName(lngCount) = objRequestName.Value & ""
            vntArrEditFlg(lngCount) = objEditFlg.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        vntItemCd = vntArrItemCd
        vntRequestName = vntArrRequestName
        vntEditFlg = vntArrEditFlg

    End If

    'バインド変数の削除
    objOraParam.Remove "RSVNO"

    '戻り値の設定
    SelectConsult_I = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectConsult_I = -1

    'イベントログ書き込み
    WriteErrorLog "Consult.SelectConsult_I"
    
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
' 機能　　 : 指定予約番号の受診オプション管理情報を取得する
'
' 引数　　 : (In)     lngRsvNo        予約番号
' 　　　　   (Out)    vntOptCd        オプションコード
' 　　　　   (Out)    vntOptBranchNo  オプション枝番
' 　　　　   (Out)    vntOptName      オプション名
' 　　　　   (Out)    vntSetClassCd   セット分類コード
' 　　　　   (Out)    vntOptSName     オプション略称
' 　　　　   (Out)    vntSetColor     セットカラー
' 　　　　   (In)     lngHideKbn      指定画面の非表示項目を除く
' 　　　　                              (1:予約枠画面、2:予約画面、3:受付画面、4:問診画面)
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectConsult_O( _
    ByVal lngRsvNo As Long, _
    ByRef vntOptCd As Variant, _
    ByRef vntOptBranchNo As Variant, _
    Optional ByRef vntOptName As Variant, _
    Optional ByRef vntSetClassCd As Variant, _
    Optional ByRef vntOptSName As Variant, _
    Optional ByRef vntSetColor As Variant, _
    Optional ByVal lngHideKbn As Variant = 0 _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objOptCd            As OraField         'オプションコード
    Dim objOptBranchNo      As OraField         'オプション枝番
    Dim objOptName          As OraField         'オプション名
    Dim objSetClassCd       As OraField         'セット分類コード
    Dim objOptSName         As OraField         'オプション略称
    Dim objSetColor         As OraField         'セットカラー

    Dim vntArrOptCd()       As Variant          'オプションコードの配列
    Dim vntArrOptBranchNo() As Variant          'オプション枝番の配列
    Dim vntArrOptName()     As Variant          'オプション名の配列
    Dim vntArrSetClassCd()  As Variant          'セット分類コードの配列
    Dim vntArrOptSName()    As Variant          'オプション略称の配列
    Dim vntArrSetColor()    As Variant          'セットカラーの配列
    Dim lngCount            As Long             'レコード数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    vntOptCd = Empty
    vntOptBranchNo = Empty
    If Not IsMissing(vntOptName) Then vntOptName = Empty
    If Not IsMissing(vntSetClassCd) Then vntSetClassCd = Empty
    If Not IsMissing(vntOptSName) Then vntOptSName = Empty
    If Not IsMissing(vntSetColor) Then vntSetColor = Empty
    lngCount = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER

    '指定予約番号の受診オプション管理情報を取得する
    strStmt = "SELECT CONSULT_O.OPTCD,   CONSULT_O.OPTBRANCHNO,                   " & vbLf & _
              "       CTRPT_OPT.OPTNAME, CTRPT_OPT.SETCLASSCD, CTRPT_OPT.OPTSNAME," & vbLf & _
              "       CTRPT_OPT.SETCOLOR                                          " & vbLf & _
              "  FROM CTRPT_OPT, CONSULT_O, CTRPT_OPTGRP                          " & vbLf & _
              " WHERE CONSULT_O.RSVNO       = :RSVNO                              " & vbLf & _
              "   AND CONSULT_O.CTRPTCD     = CTRPT_OPT.CTRPTCD                   " & vbLf & _
              "   AND CONSULT_O.OPTCD       = CTRPT_OPT.OPTCD                     " & vbLf & _
              "   AND CONSULT_O.OPTBRANCHNO = CTRPT_OPT.OPTBRANCHNO               " & vbLf & _
              "   AND CTRPT_OPT.CTRPTCD     = CTRPT_OPTGRP.CTRPTCD                " & vbLf & _
              "   AND CTRPT_OPT.OPTCD       = CTRPT_OPTGRP.OPTCD                  "
    
    '画面非表示を除く？
    If lngHideKbn = 1 Then      '予約枠画面
        strStmt = strStmt & vbLf & _
              "   AND CTRPT_OPTGRP.HIDERSVFRA IS NULL                             "
    ElseIf lngHideKbn = 2 Then  '予約画面
        strStmt = strStmt & vbLf & _
              "   AND CTRPT_OPTGRP.HIDERSV IS NULL                                "
    ElseIf lngHideKbn = 3 Then  '受付画面
        strStmt = strStmt & vbLf & _
              "   AND CTRPT_OPTGRP.HIDERPT IS NULL                                "
    ElseIf lngHideKbn = 4 Then  '問診画面
        strStmt = strStmt & vbLf & _
              "   AND CTRPT_OPTGRP.HIDEQUESTION IS NULL                           "
    End If
    
    strStmt = strStmt & vbLf & _
              " ORDER BY CONSULT_O.RSVNO, CONSULT_O.OPTCD, CONSULT_O.OPTBRANCHNO  "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objOptCd = objFields("OPTCD")
        Set objOptBranchNo = objFields("OPTBRANCHNO")
        Set objOptName = objFields("OPTNAME")
        Set objSetClassCd = objFields("SETCLASSCD")
        Set objOptSName = objFields("OPTSNAME")
        Set objSetColor = objFields("SETCOLOR")

        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrOptCd(lngCount)
            ReDim Preserve vntArrOptBranchNo(lngCount)
            ReDim Preserve vntArrOptName(lngCount)
            ReDim Preserve vntArrSetClassCd(lngCount)
            ReDim Preserve vntArrOptSName(lngCount)
            ReDim Preserve vntArrSetColor(lngCount)
            vntArrOptCd(lngCount) = objOptCd.Value & ""
            vntArrOptBranchNo(lngCount) = objOptBranchNo.Value & ""
            vntArrOptName(lngCount) = objOptName.Value & ""
            vntArrSetClassCd(lngCount) = objSetClassCd.Value & ""
            vntArrOptSName(lngCount) = objOptSName.Value & ""
            vntArrSetColor(lngCount) = objSetColor.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        vntOptCd = vntArrOptCd
        vntOptBranchNo = vntArrOptBranchNo
        If Not IsMissing(vntOptName) Then vntOptName = vntArrOptName
        If Not IsMissing(vntSetClassCd) Then vntSetClassCd = vntArrSetClassCd
        If Not IsMissing(vntOptSName) Then vntOptSName = vntArrOptSName
        If Not IsMissing(vntSetColor) Then vntSetColor = vntArrSetColor
    
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    SelectConsult_O = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectConsult_O = -1

    'イベントログ書き込み
    WriteErrorLog "Consult.SelectConsult_O"
    
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
' 機能　　 : 指定予約番号の受診オプション管理情報をもとに受診サブコースを取得する
'
' 引数　　 : (In)     lngRsvNo  予約番号
' 　　　　   (Out)    vntCsName  コース名
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectConsult_O_SubCourse(ByVal lngRsvNo As Long, ByRef vntCsName As Variant) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント

    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objCsName       As OraField         'コース名

    Dim vntArrCsName()  As Variant          'コース名の配列
    Dim lngCount        As Long             'レコード数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    vntCsName = Empty
    lngCount = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER

    'サブコース用取得用のSQLステートメント編集
    strStmt = EditSelectSubCourseStatement()

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCsName = objFields("CSNAME")

        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrCsName(lngCount)
            vntArrCsName(lngCount) = objCsName.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        vntCsName = vntArrCsName

    End If

    'バインド変数の削除
    objOraParam.Remove "RSVNO"

    '戻り値の設定
    SelectConsult_O_SubCourse = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectConsult_O_SubCourse = -1

    'イベントログ書き込み
    WriteErrorLog "Consult.SelectConsult_O_SubCourse"
    
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
' 機能　　 : 受診情報テーブルから受診付属情報を読み込む
'
' 引数　　 : (In)     lngRsvNo           予約番号
' 　　　　   (Out)    vntRsvStatus       予約状況
' 　　　　   (Out)    vntPrtOnSave       保存時印刷
' 　　　　   (Out)    vntCardAddrDiv     確認はがき宛先
' 　　　　   (Out)    vntCardOutEng      確認はがき英文出力
' 　　　　   (Out)    vntFormAddrDiv     一式書式宛先
' 　　　　   (Out)    vntFormOutEng      一式書式英文出力
' 　　　　   (Out)    vntReportAddrDiv   成績書宛先
' 　　　　   (Out)    vntReportOurEng    成績書英文出力
' 　　　　   (Out)    vntVolunteer       ボランティア
' 　　　　   (Out)    vntVolunteerName   ボランティア名
' 　　　　   (Out)    vntCollectTicket   利用券回収
' 　　　　   (Out)    vntIssueCslTicket  診察券発行
' 　　　　   (Out)    vntBillPrint       請求書出力
' 　　　　   (Out)    vntIsrSign         保険証記号
' 　　　　   (Out)    vntIsrNo           保険証番号
' 　　　　   (Out)    vntIsrManNo        保険者番号
' 　　　　   (Out)    vntEmpNo           社員番号
' 　　　　   (Out)    vntIntroductor     紹介者
' 　　　　   (Out)    vntCancelFlg       キャンセルフラグ
'## 2004.11.04 Add By T.Takagi@FSIT 前回受診日追加
' 　　　　   (Out)    vntLastCslDate     前回受診日
'## 2004.11.04 Add End
' 　　　　   (Out)    vntSendMailDiv      予約確認メール送信先
' 　　　　   (Out)    vntSendMailDate     予約確認メール送信日時
' 　　　　   (Out)    vntSendMailUserName 予約確認メール送信者名
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
'#### 2013.3.1 SL-SN-Y0101-612 UPD START ####
''## 2004.11.04 Mod By T.Takagi@FSIT 前回受診日追加
''Public Function SelectConsultDetail(
''    ByVal lngRsvNo As Long,
''    Optional ByRef vntRsvStatus As Variant,
''    Optional ByRef vntPrtOnSave As Variant,
''    Optional ByRef vntCardAddrDiv As Variant,
''    Optional ByRef vntCardOutEng As Variant,
''    Optional ByRef vntFormAddrDiv As Variant,
''    Optional ByRef vntFormOutEng As Variant,
''    Optional ByRef vntReportAddrDiv As Variant,
''    Optional ByRef vntReportOurEng As Variant,
''    Optional ByRef vntVolunteer As Variant,
''    Optional ByRef vntVolunteerName As Variant,
''    Optional ByRef vntCollectTicket As Variant,
''    Optional ByRef vntIssueCslTicket As Variant,
''    Optional ByRef vntBillPrint As Variant,
''    Optional ByRef vntIsrSign As Variant,
''    Optional ByRef vntIsrNo As Variant,
''    Optional ByRef vntIsrManNo As Variant,
''    Optional ByRef vntEmpNo As Variant,
''    Optional ByRef vntIntroductor As Variant,
''    Optional ByRef vntCancelFlg As Variant
'') As Boolean
'Public Function SelectConsultDetail(
'    ByVal lngRsvNo As Long,
'    Optional ByRef vntRsvStatus As Variant,
'    Optional ByRef vntPrtOnSave As Variant,
'    Optional ByRef vntCardAddrDiv As Variant,
'    Optional ByRef vntCardOutEng As Variant,
'    Optional ByRef vntFormAddrDiv As Variant,
'    Optional ByRef vntFormOutEng As Variant,
'    Optional ByRef vntReportAddrDiv As Variant,
'    Optional ByRef vntReportOurEng As Variant,
'    Optional ByRef vntVolunteer As Variant,
'    Optional ByRef vntVolunteerName As Variant,
'    Optional ByRef vntCollectTicket As Variant,
'    Optional ByRef vntIssueCslTicket As Variant,
'    Optional ByRef vntBillPrint As Variant,
'    Optional ByRef vntIsrSign As Variant,
'    Optional ByRef vntIsrNo As Variant,
'    Optional ByRef vntIsrManNo As Variant,
'    Optional ByRef vntEmpNo As Variant,
'    Optional ByRef vntIntroductor As Variant,
'    Optional ByRef vntCancelFlg As Variant,
'    Optional ByRef vntLastCslDate As Variant
') As Boolean
''## 2004.11.04 Mod End
Public Function SelectConsultDetail( _
    ByVal lngRsvNo As Long, _
    Optional ByRef vntRsvStatus As Variant, _
    Optional ByRef vntPrtOnSave As Variant, _
    Optional ByRef vntCardAddrDiv As Variant, _
    Optional ByRef vntCardOutEng As Variant, _
    Optional ByRef vntFormAddrDiv As Variant, _
    Optional ByRef vntFormOutEng As Variant, _
    Optional ByRef vntReportAddrDiv As Variant, _
    Optional ByRef vntReportOurEng As Variant, _
    Optional ByRef vntVolunteer As Variant, _
    Optional ByRef vntVolunteerName As Variant, _
    Optional ByRef vntCollectTicket As Variant, _
    Optional ByRef vntIssueCslTicket As Variant, _
    Optional ByRef vntBillPrint As Variant, _
    Optional ByRef vntIsrSign As Variant, _
    Optional ByRef vntIsrNo As Variant, _
    Optional ByRef vntIsrManNo As Variant, _
    Optional ByRef vntEmpNo As Variant, _
    Optional ByRef vntIntroductor As Variant, _
    Optional ByRef vntCancelFlg As Variant, _
    Optional ByRef vntLastCslDate As Variant, _
    Optional ByRef vntSendMailDiv As Variant, Optional ByRef vntSendMailDate As Variant, Optional ByRef vntSendMailUserName As Variant _
) As Boolean
'#### 2013.3.1 SL-SN-Y0101-612 UPD END   ####

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRsvStatus        As OraField         '予約状況
    Dim objPrtOnSave        As OraField         '保存時印刷
    Dim objCardAddrDiv      As OraField         '確認はがき宛先
    Dim objCardOutEng       As OraField         '確認はがき英文出力
    Dim objFormAddrDiv      As OraField         '一式書式宛先
    Dim objFormOutEng       As OraField         '一式書式英文出力
    Dim objReportAddrDiv    As OraField         '成績書宛先
    Dim objReportOurEng     As OraField         '成績書英文出力
    Dim objVolunteer        As OraField         'ボランティア
    Dim objVolunteerName    As OraField         'ボランティア名
    Dim objCollectTicket    As OraField         '利用券回収
    Dim objIssueCslTicket   As OraField         '診察券発行
    Dim objBillPrint        As OraField         '請求書出力
    Dim objIsrSign          As OraField         '保険証記号
    Dim objIsrNo            As OraField         '保険証番号
    Dim objIsrManNo         As OraField         '保険者番号
    Dim objEmpNo            As OraField         '社員番号
    Dim objIntroductor      As OraField         '紹介者
    Dim objCancelFlg        As OraField         'キャンセルフラグ
'## 2004.11.04 Add By T.Takagi@FSIT 前回受診日追加
    Dim objLastCslDate      As OraField         '前回受診日
'## 2004.11.04 Add End
'#### 2013.3.1 SL-SN-Y0101-612 ADD START ####
    Dim objSendMailDiv      As OraField         '予約確認メール送信先
    Dim objSendMailDate     As OraField         '予約確認メール送信日時
    Dim objSendMailUserName As OraField         '予約確認メール送信者名
'#### 2013.3.1 SL-SN-Y0101-612 ADD END   ####

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理

    If Not IsMissing(vntRsvStatus) Then vntRsvStatus = Empty
    If Not IsMissing(vntPrtOnSave) Then vntPrtOnSave = Empty
    If Not IsMissing(vntCardAddrDiv) Then vntCardAddrDiv = Empty
    If Not IsMissing(vntCardOutEng) Then vntCardOutEng = Empty
    If Not IsMissing(vntFormAddrDiv) Then vntFormAddrDiv = Empty
    If Not IsMissing(vntFormOutEng) Then vntFormOutEng = Empty
    If Not IsMissing(vntReportAddrDiv) Then vntReportAddrDiv = Empty
    If Not IsMissing(vntReportOurEng) Then vntReportOurEng = Empty
    If Not IsMissing(vntVolunteer) Then vntVolunteer = Empty
    If Not IsMissing(vntVolunteerName) Then vntVolunteerName = Empty
    If Not IsMissing(vntCollectTicket) Then vntCollectTicket = Empty
    If Not IsMissing(vntIssueCslTicket) Then vntIssueCslTicket = Empty
    If Not IsMissing(vntBillPrint) Then vntBillPrint = Empty
    If Not IsMissing(vntIsrSign) Then vntIsrSign = Empty
    If Not IsMissing(vntIsrNo) Then vntIsrNo = Empty
    If Not IsMissing(vntIsrManNo) Then vntIsrManNo = Empty
    If Not IsMissing(vntEmpNo) Then vntEmpNo = Empty
    If Not IsMissing(vntIntroductor) Then vntIntroductor = Empty
    If Not IsMissing(vntCancelFlg) Then vntCancelFlg = Empty
'## 2004.11.04 Add By T.Takagi@FSIT 前回受診日追加
    If Not IsMissing(vntLastCslDate) Then vntLastCslDate = Empty
'## 2004.11.04 Add End
'#### 2013.3.1 SL-SN-Y0101-612 ADD START ####
    If Not IsMissing(vntSendMailDiv) Then vntSendMailDiv = Empty
    If Not IsMissing(vntSendMailDate) Then vntSendMailDate = Empty
    If Not IsMissing(vntSendMailUserName) Then vntSendMailUserName = Empty
'#### 2013.3.1 SL-SN-Y0101-612 ADD END   ####

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER

    '検索条件を満たす受診情報テーブルのレコードを取得
'#### 2013.3.1 SL-SN-Y0101-612 UPD START ####
''## 2004.11.04 Mod By T.Takagi@FSIT 前回受診日追加
''    strStmt = "SELECT RSVSTATUS,     PRTONSAVE,     CARDADDRDIV,    " & vbLf & _
''              "       CARDOUTENG,    FORMADDRDIV,   FORMOUTENG,     " & vbLf & _
''              "       REPORTADDRDIV, REPORTOURENG,  VOLUNTEER,      " & vbLf & _
''              "       VOLUNTEERNAME, COLLECTTICKET, ISSUECSLTICKET, " & vbLf & _
''              "       BILLPRINT,     ISRSIGN,       ISRNO,          " & vbLf & _
''              "       ISRMANNO,      EMPNO,         INTRODUCTOR,    " & vbLf & _
''              "       CANCELFLG                                     " & vbLf & _
''              "  FROM CONSULT                                       " & vbLf & _
''              " WHERE CONSULT.RSVNO = :RSVNO                        "
'    strStmt = "SELECT RSVSTATUS,     PRTONSAVE,     CARDADDRDIV,    " & vbLf & _
'              "       CARDOUTENG,    FORMADDRDIV,   FORMOUTENG,     " & vbLf & _
'              "       REPORTADDRDIV, REPORTOURENG,  VOLUNTEER,      " & vbLf & _
'              "       VOLUNTEERNAME, COLLECTTICKET, ISSUECSLTICKET, " & vbLf & _
'              "       BILLPRINT,     ISRSIGN,       ISRNO,          " & vbLf & _
'              "       ISRMANNO,      EMPNO,         INTRODUCTOR,    " & vbLf & _
'              "       CANCELFLG,     LASTCSLDATE                    " & vbLf & _
'              "  FROM CONSULT                                       " & vbLf & _
'              " WHERE CONSULT.RSVNO = :RSVNO                        "
''## 2004.11.04 Mod End
    strStmt = "SELECT CONSULT.RSVSTATUS,     CONSULT.PRTONSAVE,     CONSULT.CARDADDRDIV,    " & vbLf & _
              "       CONSULT.CARDOUTENG,    CONSULT.FORMADDRDIV,   CONSULT.FORMOUTENG,     " & vbLf & _
              "       CONSULT.REPORTADDRDIV, CONSULT.REPORTOURENG,  CONSULT.VOLUNTEER,      " & vbLf & _
              "       CONSULT.VOLUNTEERNAME, CONSULT.COLLECTTICKET, CONSULT.ISSUECSLTICKET, " & vbLf & _
              "       CONSULT.BILLPRINT,     CONSULT.ISRSIGN,       CONSULT.ISRNO,          " & vbLf & _
              "       CONSULT.ISRMANNO,      CONSULT.EMPNO,         CONSULT.INTRODUCTOR,    " & vbLf & _
              "       CONSULT.CANCELFLG,     CONSULT.LASTCSLDATE,                           " & vbLf & _
              "       CONSULT.SENDMAILDIV,   CONSULT.SENDMAILDATE,  HAINSUSER.USERNAME      " & vbLf & _
              "  FROM HAINSUSER, CONSULT                                                    " & vbLf & _
              " WHERE CONSULT.RSVNO        = :RSVNO                                         " & vbLf & _
              "   AND CONSULT.SENDMAILUSER = HAINSUSER.USERID(+)                            "
'#### 2013.3.1 SL-SN-Y0101-612 UPD END   ####

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvStatus = objFields("RSVSTATUS")
        Set objPrtOnSave = objFields("PRTONSAVE")
        Set objCardAddrDiv = objFields("CARDADDRDIV")
        Set objCardOutEng = objFields("CARDOUTENG")
        Set objFormAddrDiv = objFields("FORMADDRDIV")
        Set objFormOutEng = objFields("FORMOUTENG")
        Set objReportAddrDiv = objFields("REPORTADDRDIV")
        Set objReportOurEng = objFields("REPORTOURENG")
        Set objVolunteer = objFields("VOLUNTEER")
        Set objVolunteerName = objFields("VOLUNTEERNAME")
        Set objCollectTicket = objFields("COLLECTTICKET")
        Set objIssueCslTicket = objFields("ISSUECSLTICKET")
        Set objBillPrint = objFields("BILLPRINT")
        Set objIsrSign = objFields("ISRSIGN")
        Set objIsrNo = objFields("ISRNO")
        Set objIsrManNo = objFields("ISRMANNO")
        Set objEmpNo = objFields("EMPNO")
        Set objIntroductor = objFields("INTRODUCTOR")
        Set objCancelFlg = objFields("CANCELFLG")
'## 2004.11.04 Add By T.Takagi@FSIT 前回受診日追加
        Set objLastCslDate = objFields("LASTCSLDATE")
'## 2004.11.04 Add End
'#### 2013.3.1 SL-SN-Y0101-612 ADD START ####
        Set objSendMailDiv = objFields("SENDMAILDIV")
        Set objSendMailDate = objFields("SENDMAILDATE")
        Set objSendMailUserName = objFields("USERNAME")
'#### 2013.3.1 SL-SN-Y0101-612 ADD END   ####

        If Not IsMissing(vntRsvStatus) Then vntRsvStatus = objRsvStatus.Value & ""
        If Not IsMissing(vntPrtOnSave) Then vntPrtOnSave = objPrtOnSave.Value & ""
        If Not IsMissing(vntCardAddrDiv) Then vntCardAddrDiv = objCardAddrDiv.Value & ""
        If Not IsMissing(vntCardOutEng) Then vntCardOutEng = objCardOutEng.Value & ""
        If Not IsMissing(vntFormAddrDiv) Then vntFormAddrDiv = objFormAddrDiv.Value & ""
        If Not IsMissing(vntFormOutEng) Then vntFormOutEng = objFormOutEng.Value & ""
        If Not IsMissing(vntReportAddrDiv) Then vntReportAddrDiv = objReportAddrDiv.Value & ""
        If Not IsMissing(vntReportOurEng) Then vntReportOurEng = objReportOurEng.Value & ""
        If Not IsMissing(vntVolunteer) Then vntVolunteer = objVolunteer.Value & ""
        If Not IsMissing(vntVolunteerName) Then vntVolunteerName = objVolunteerName.Value & ""
        If Not IsMissing(vntCollectTicket) Then vntCollectTicket = objCollectTicket.Value & ""
        If Not IsMissing(vntIssueCslTicket) Then vntIssueCslTicket = objIssueCslTicket.Value & ""
        If Not IsMissing(vntBillPrint) Then vntBillPrint = objBillPrint.Value & ""
        If Not IsMissing(vntIsrSign) Then vntIsrSign = objIsrSign.Value & ""
        If Not IsMissing(vntIsrNo) Then vntIsrNo = objIsrNo.Value & ""
        If Not IsMissing(vntIsrManNo) Then vntIsrManNo = objIsrManNo.Value & ""
        If Not IsMissing(vntEmpNo) Then vntEmpNo = objEmpNo.Value & ""
        If Not IsMissing(vntIntroductor) Then vntIntroductor = objIntroductor.Value & ""
        If Not IsMissing(vntCancelFlg) Then vntCancelFlg = objCancelFlg.Value & ""
'## 2004.11.04 Add By T.Takagi@FSIT 前回受診日追加
        If Not IsMissing(vntLastCslDate) Then vntLastCslDate = objLastCslDate.Value & ""
'## 2004.11.04 Add End
'#### 2013.3.1 SL-SN-Y0101-612 ADD START ####
        If Not IsMissing(vntSendMailDiv) Then vntSendMailDiv = objSendMailDiv.Value & ""
        If Not IsMissing(vntSendMailDate) Then vntSendMailDate = objSendMailDate.Value & ""
        If Not IsMissing(vntSendMailUserName) Then vntSendMailUserName = objSendMailUserName.Value & ""
'#### 2013.3.1 SL-SN-Y0101-612 ADD END   ####

        SelectConsultDetail = True

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
    WriteErrorLog "Consult.SelectConsultDetail"

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
' 機能　　 : バーコードのキーをもとに受診情報を取得する
'
' 引数　　 : (In)     dtmCslDate      受付日（バーコード）
' 　　　　   (In)     strPerId        個人ＩＤ（バーコード）
' 　　　　   (In)     vntInCsCd       コースコード（バーコード）
' 　　　　   (Out)    vntDayId        当日ＩＤ
' 　　　　   (Out)    vntRsvNo        予約番号
' 　　　　   (Out)    vntCslDate      (受診情報の)受診日
' 　　　　   (Out)    vntPerID        個人ＩＤ
' 　　　　   (Out)    vntLastName     姓
' 　　　　   (Out)    vntFirstName  　名
' 　　　　   (Out)    vntLastKName    カナ姓
' 　　　　   (Out)    vntFirstKName 　カナ名
' 　　　　   (Out)    vntBirth        生年月日
' 　　　　   (Out)    vntGender       性別
' 　　　　   (Out)    vntCsCd         コースコード
' 　　　　   (Out)    vntCsName       コース名
' 　　　　   (Out)    vntAge          受診時年齢
' 　　　　   (Out)    vntDoctorCd     判定医師コード
' 　　　　   (Out)    vntDoctorName   判定医師名
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectConsultForBarcode( _
    ByVal dtmCslDate As Date, _
    ByVal strPerId As String, _
    ByVal vntInCsCd As Variant, _
    Optional ByRef vntDayId As Variant, _
    Optional ByRef vntRsvNo As Variant, _
    Optional ByRef vntCslDate As Variant, _
    Optional ByRef vntPerId As Variant, _
    Optional ByRef vntLastName As Variant, _
    Optional ByRef vntFirstName As Variant, _
    Optional ByRef vntLastKName As Variant, _
    Optional ByRef vntFirstKName As Variant, _
    Optional ByRef vntBirth As Variant, _
    Optional ByRef vntGender As Variant, _
    Optional ByRef vntCsCd As Variant, _
    Optional ByRef vntCsName As Variant, _
    Optional ByRef vntAge As Variant, _
    Optional ByRef vntDoctorCd As Variant, _
    Optional ByRef vntDoctorName As Variant _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント

    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objDayId        As OraField         '当日ＩＤ
    Dim objRsvNo        As OraField         '予約番号
    Dim objCslDate      As OraField         '受診日
    Dim objPerId        As OraField         '個人ＩＤ
    Dim objLastName     As OraField         '姓
    Dim objFirstName    As OraField         '名
    Dim objLastKName    As OraField         'カナ姓
    Dim objFirstKName   As OraField         'カナ名
    Dim objBirth        As OraField         '生年月日
    Dim objGender       As OraField         '性別
    Dim objCsCd         As OraField         'コースコード
    Dim objCsName       As OraField         'コース名
    Dim objAge          As OraField         '受診時年齢
    Dim objDoctorCd     As OraField         '判定医師コード
    Dim objDoctorName   As OraField         '判定医師名

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntDayId) Then vntDayId = Empty
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If Not IsMissing(vntCslDate) Then vntCslDate = Empty
    If Not IsMissing(vntPerId) Then vntPerId = Empty
    If Not IsMissing(vntLastName) Then vntLastName = Empty
    If Not IsMissing(vntFirstName) Then vntFirstName = Empty
    If Not IsMissing(vntLastKName) Then vntLastKName = Empty
    If Not IsMissing(vntFirstKName) Then vntFirstKName = Empty
    If Not IsMissing(vntBirth) Then vntBirth = Empty
    If Not IsMissing(vntGender) Then vntGender = Empty
    If Not IsMissing(vntCsCd) Then vntCsCd = Empty
    If Not IsMissing(vntCsName) Then vntCsName = Empty
    If Not IsMissing(vntAge) Then vntAge = Empty
    If Not IsMissing(vntDoctorCd) Then vntDoctorCd = Empty
    If Not IsMissing(vntDoctorName) Then vntDoctorName = Empty
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSCD", vntInCsCd, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '検索条件を満たす受診情報テーブルのレコードを取得
    strStmt = "SELECT RECEIPT.DAYID,                      " & vbLf & _
              "       RECEIPT.RSVNO,                      " & vbLf & _
              "       CONSULT.CSLDATE,                    " & vbLf & _
              "       CONSULT.PERID,                      " & vbLf & _
              "       CONSULT.CSCD,                       " & vbLf & _
              "       TO_CHAR(CONSULT.AGE, '999.99') AGE, " & vbLf & _
              "       CONSULT.DOCTORCD,                   " & vbLf & _
              "       PERSON.LASTNAME,                    " & vbLf & _
              "       PERSON.FIRSTNAME,                   " & vbLf & _
              "       PERSON.LASTKNAME,                   " & vbLf & _
              "       PERSON.FIRSTKNAME,                  " & vbLf & _
              "       PERSON.BIRTH,                       " & vbLf & _
              "       PERSON.GENDER,                      " & vbLf & _
              "       COURSE_P.CSNAME,                    " & vbLf & _
              "       HAINSUSER.USERNAME                  "

    'FROM句の設定
    strStmt = strStmt & vbLf & _
              "  FROM HAINSUSER, " & vbLf & _
              "       COURSE_P,  " & vbLf & _
              "       PERSON,    " & vbLf & _
              "       CONSULT,   " & vbLf & _
              "       RECEIPT    "

    'バーコードのキー情報を元に受診情報を取得し、その受診情報をもとに各種情報を結合
    strStmt = strStmt & vbLf & _
              " WHERE CONSULT.CSLDATE  = :CSLDATE            " & vbLf & _
              "   AND CONSULT.PERID    = :PERID              " & vbLf & _
              "   AND CONSULT.CSCD     = :CSCD               " & vbLf & _
              "   AND RECEIPT.RSVNO    = CONSULT.RSVNO       " & vbLf & _
              "   AND CONSULT.PERID    = PERSON.PERID        " & vbLf & _
              "   AND CONSULT.CSCD     = COURSE_P.CSCD       " & vbLf & _
              "   AND CONSULT.DOCTORCD = HAINSUSER.USERID(+) "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objDayId = objFields("DAYID")
        Set objRsvNo = objFields("RSVNO")
        Set objCslDate = objFields("CSLDATE")
        Set objPerId = objFields("PERID")
        Set objCsCd = objFields("CSCD")
        Set objAge = objFields("AGE")
        Set objDoctorCd = objFields("DOCTORCD")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastKName = objFields("LASTKNAME")
        Set objFirstKName = objFields("FIRSTKNAME")
        Set objBirth = objFields("BIRTH")
        Set objGender = objFields("GENDER")
        Set objCsName = objFields("CSNAME")
        Set objDoctorName = objFields("USERNAME")
        
        '戻り値の設定
        If Not IsMissing(vntDayId) Then vntDayId = objDayId.Value
        If Not IsMissing(vntRsvNo) Then vntRsvNo = CLng(objRsvNo.Value)
        If Not IsMissing(vntCslDate) Then vntCslDate = CDate(objCslDate.Value)
        If Not IsMissing(vntPerId) Then vntPerId = objPerId.Value
        If Not IsMissing(vntLastName) Then vntLastName = objLastName.Value
        If Not IsMissing(vntFirstName) Then vntFirstName = objFirstName.Value & ""
        If Not IsMissing(vntLastKName) Then vntLastKName = objLastKName.Value
        If Not IsMissing(vntFirstKName) Then vntFirstKName = objFirstKName.Value & ""
        If Not IsMissing(vntBirth) Then vntBirth = CDate(objBirth.Value)
        If Not IsMissing(vntGender) Then vntGender = CLng(objGender.Value)
        If Not IsMissing(vntCsCd) Then vntCsCd = objCsCd.Value
        If Not IsMissing(vntCsName) Then vntCsName = objCsName.Value
        If Not IsMissing(vntAge) Then vntAge = objAge.Value
        If Not IsMissing(vntDoctorCd) Then vntDoctorCd = objDoctorCd.Value & ""
        If Not IsMissing(vntDoctorName) Then vntDoctorName = objDoctorName.Value & ""

        SelectConsultForBarcode = True

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
    WriteErrorLog "Consult.SelectConsultForBarcode"
    
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
' 機能　　 : 受付情報をもとに受診情報を取得する
'
' 引数　　 : (In)     dtmCslDate      (受付情報の)受診日
' 　　　　   (In)     vntCntlNo       管理番号
' 　　　　   (In)     lngDayId        当日ＩＤ
' 　　　　   (Out)    vntRsvNo        予約番号
' 　　　　   (Out)    vntCslDate      (受診情報の)受診日
' 　　　　   (Out)    vntPerID        個人ＩＤ
' 　　　　   (Out)    vntLastName     姓
' 　　　　   (Out)    vntFirstName  　名
' 　　　　   (Out)    vntLastKName    カナ姓
' 　　　　   (Out)    vntFirstKName 　カナ名
' 　　　　   (Out)    vntBirth        生年月日
' 　　　　   (Out)    vntGender       性別
' 　　　　   (Out)    vntCsCd         コースコード
' 　　　　   (Out)    vntCsName       コース名
' 　　　　   (Out)    vntAge          受診時年齢
' 　　　　   (Out)    vntDoctorCd     判定医師コード
' 　　　　   (Out)    vntDoctorName   判定医師名
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectConsultFromReceipt( _
    ByVal dtmCslDate As Date, _
    ByVal vntCntlNo As Variant, _
    ByVal lngDayId As Long, _
    Optional ByRef vntRsvNo As Variant, _
    Optional ByRef vntCslDate As Variant, _
    Optional ByRef vntPerId As Variant, _
    Optional ByRef vntLastName As Variant, _
    Optional ByRef vntFirstName As Variant, _
    Optional ByRef vntLastKName As Variant, _
    Optional ByRef vntFirstKName As Variant, _
    Optional ByRef vntBirth As Variant, _
    Optional ByRef vntGender As Variant, _
    Optional ByRef vntCsCd As Variant, _
    Optional ByRef vntCsName As Variant, _
    Optional ByRef vntAge As Variant, _
    Optional ByRef vntDoctorCd As Variant, _
    Optional ByRef vntDoctorName As Variant _
) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント

    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objRsvNo        As OraField         '予約番号
    Dim objCslDate      As OraField         '受診日
    Dim objPerId        As OraField         '個人ＩＤ
    Dim objLastName     As OraField         '姓
    Dim objFirstName    As OraField         '名
    Dim objLastKName    As OraField         'カナ姓
    Dim objFirstKName   As OraField         'カナ名
    Dim objBirth        As OraField         '生年月日
    Dim objGender       As OraField         '性別
    Dim objCsCd         As OraField         'コースコード
    Dim objCsName       As OraField         'コース名
    Dim objAge          As OraField         '受診時年齢
'    Dim objDoctorCd     As OraField         '判定医師コード
'    Dim objDoctorName   As OraField         '判定医師名

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    
    '管理番号のデフォルト値設定
    vntCntlNo = CLng("0" & vntCntlNo)
    
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If Not IsMissing(vntCslDate) Then vntCslDate = Empty
    If Not IsMissing(vntPerId) Then vntPerId = Empty
    If Not IsMissing(vntLastName) Then vntLastName = Empty
    If Not IsMissing(vntFirstName) Then vntFirstName = Empty
    If Not IsMissing(vntLastKName) Then vntLastKName = Empty
    If Not IsMissing(vntFirstKName) Then vntFirstKName = Empty
    If Not IsMissing(vntBirth) Then vntBirth = Empty
    If Not IsMissing(vntGender) Then vntGender = Empty
    If Not IsMissing(vntCsCd) Then vntCsCd = Empty
    If Not IsMissing(vntCsName) Then vntCsName = Empty
    If Not IsMissing(vntAge) Then vntAge = Empty
    If Not IsMissing(vntDoctorCd) Then vntDoctorCd = Empty
    If Not IsMissing(vntDoctorName) Then vntDoctorName = Empty
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "CNTLNO", vntCntlNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DAYID", lngDayId, ORAPARM_INPUT, ORATYPE_NUMBER

    '検索条件を満たす受診情報テーブルのレコードを取得
'    strStmt = "SELECT RECEIPT.RSVNO,                      " & vbLf & _
'              "       CONSULT.CSLDATE,                    " & vbLf & _
'              "       CONSULT.PERID,                      " & vbLf & _
'              "       CONSULT.CSCD,                       " & vbLf & _
'              "       TO_CHAR(CONSULT.AGE, '999.99') AGE, " & vbLf & _
'              "       CONSULT.DOCTORCD,                   " & vbLf & _
'              "       PERSON.LASTNAME,                    " & vbLf & _
'              "       PERSON.FIRSTNAME,                   " & vbLf & _
'              "       PERSON.LASTKNAME,                   " & vbLf & _
'              "       PERSON.FIRSTKNAME,                  " & vbLf & _
'              "       PERSON.BIRTH,                       " & vbLf & _
'              "       PERSON.GENDER,                      " & vbLf & _
'              "       COURSE_P.CSNAME,                    " & vbLf & _
'              "       HAINSUSER.USERNAME                  "
    strStmt = "SELECT RECEIPT.RSVNO,                      " & vbLf & _
              "       CONSULT.CSLDATE,                    " & vbLf & _
              "       CONSULT.PERID,                      " & vbLf & _
              "       CONSULT.CSCD,                       " & vbLf & _
              "       TO_CHAR(CONSULT.AGE, '999.99') AGE, " & vbLf & _
              "       PERSON.LASTNAME,                    " & vbLf & _
              "       PERSON.FIRSTNAME,                   " & vbLf & _
              "       PERSON.LASTKNAME,                   " & vbLf & _
              "       PERSON.FIRSTKNAME,                  " & vbLf & _
              "       PERSON.BIRTH,                       " & vbLf & _
              "       PERSON.GENDER,                      " & vbLf & _
              "       COURSE_P.CSNAME                     "

    'FROM句の設定
'    strStmt = strStmt & vbLf & _
'              "  FROM HAINSUSER, " & vbLf & _
'              "       COURSE_P,  " & vbLf & _
'              "       PERSON,    " & vbLf & _
'              "       CONSULT,   " & vbLf & _
'              "       RECEIPT    "
    strStmt = strStmt & vbLf & _
              "  FROM COURSE_P,  " & vbLf & _
              "       PERSON,    " & vbLf & _
              "       CONSULT,   " & vbLf & _
              "       RECEIPT    "

    '受付情報を元に受診情報を取得し、その受診情報をもとに各種情報を結合
'    strStmt = strStmt & vbLf & _
'              " WHERE RECEIPT.CSLDATE  = :CSLDATE            " & vbLf & _
'              "   AND RECEIPT.CNTLNO   = :CNTLNO             " & vbLf & _
'              "   AND RECEIPT.DAYID    = :DAYID              " & vbLf & _
'              "   AND RECEIPT.RSVNO    = CONSULT.RSVNO       " & vbLf & _
'              "   AND CONSULT.PERID    = PERSON.PERID        " & vbLf & _
'              "   AND CONSULT.CSCD     = COURSE_P.CSCD       " & vbLf & _
'              "   AND CONSULT.DOCTORCD = HAINSUSER.USERID(+) "
    strStmt = strStmt & vbLf & _
              " WHERE RECEIPT.CSLDATE  = :CSLDATE            " & vbLf & _
              "   AND RECEIPT.CNTLNO   = :CNTLNO             " & vbLf & _
              "   AND RECEIPT.DAYID    = :DAYID              " & vbLf & _
              "   AND RECEIPT.RSVNO    = CONSULT.RSVNO       " & vbLf & _
              "   AND CONSULT.PERID    = PERSON.PERID        " & vbLf & _
              "   AND CONSULT.CSCD     = COURSE_P.CSCD       "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objCslDate = objFields("CSLDATE")
        Set objPerId = objFields("PERID")
        Set objCsCd = objFields("CSCD")
        Set objAge = objFields("AGE")
'        Set objDoctorCd = objFields("DOCTORCD")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastKName = objFields("LASTKNAME")
        Set objFirstKName = objFields("FIRSTKNAME")
        Set objBirth = objFields("BIRTH")
        Set objGender = objFields("GENDER")
        Set objCsName = objFields("CSNAME")
'        Set objDoctorName = objFields("USERNAME")
        
        '戻り値の設定
        If Not IsMissing(vntRsvNo) Then vntRsvNo = CLng(objRsvNo.Value)
        If Not IsMissing(vntCslDate) Then vntCslDate = CDate(objCslDate.Value)
        If Not IsMissing(vntPerId) Then vntPerId = objPerId.Value
        If Not IsMissing(vntLastName) Then vntLastName = objLastName.Value
        If Not IsMissing(vntFirstName) Then vntFirstName = objFirstName.Value & ""
        If Not IsMissing(vntLastKName) Then vntLastKName = objLastKName.Value
        If Not IsMissing(vntFirstKName) Then vntFirstKName = objFirstKName.Value & ""
        If Not IsMissing(vntBirth) Then vntBirth = CDate(objBirth.Value)
        If Not IsMissing(vntGender) Then vntGender = CLng(objGender.Value)
        If Not IsMissing(vntCsCd) Then vntCsCd = objCsCd.Value
        If Not IsMissing(vntCsName) Then vntCsName = objCsName.Value
        If Not IsMissing(vntAge) Then vntAge = objAge.Value
'        If Not IsMissing(vntDoctorCd) Then vntDoctorCd = objDoctorCd.Value & ""
'        If Not IsMissing(vntDoctorName) Then vntDoctorName = objDoctorName.Value & ""

        SelectConsultFromReceipt = True

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
    WriteErrorLog "Consult.SelectConsultFromReceipt"
    
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
' 機能　　 : 指定された個人ＩＤの受診歴一覧を取得する
'
' 引数　　 : (In)     strPerId            個人ＩＤ
' 　　　　   (In)     dtmCslDate          受診日(指定受診日以前の受診歴を取得対象とする)
' 　　　　   (In)     blnReceptOnly       True指定時は受付済み受診情報のみを取得対象とする
' 　　　　   (In)     blnFirstCourseOnly  True指定時は１次健診のみを取得対象とする
' 　　　　   (In)     lngGetRowCount      取得件数(未指定時は全件)
' 　　　　   (Out)    vntRsvNo            予約番号
' 　　　　   (Out)    vntCslDate          受診日
' 　　　　   (Out)    vntCsCd             コースコード
' 　　　　   (Out)    vntCsName           コース名
' 　　　　   (Out)    vntAge              受診時年齢
' 　　　　   (Out)    vntCsSName          コース略称
' 　　　　   (Out)    vntWebColor         webカラー
' 　　　　   (Out)    vntOrgSName         団体略称
' 　　　　   (Out)    vntCslDivName       受診区分名
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectConsultHistory( _
    ByVal strPerId As String, _
    Optional ByVal dtmCslDate As Date = 0, _
    Optional ByVal blnReceptOnly As Boolean = False, _
    Optional ByVal blnFirstCourseOnly As Boolean = False, _
    Optional ByVal lngGetRowCount As Long = 0, _
    Optional ByRef vntRsvNo As Variant, _
    Optional ByRef vntCslDate As Variant, _
    Optional ByRef vntCsCd As Variant, _
    Optional ByRef vntCsName As Variant, _
    Optional ByRef vntAge As Variant, _
    Optional ByRef vntCsSName As Variant, _
    Optional ByRef vntWebColor As Variant, _
    Optional ByRef vntOrgSName As Variant, _
    Optional ByRef vntCslDivName As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRsvNo            As OraField         '予約番号
    Dim objCslDate          As OraField         '受診日
    Dim objCsCd             As OraField         'コースコード
    Dim objCsName           As OraField         'コース名
    Dim objAge              As OraField         '受診時年齢
    Dim objCsSName          As OraField         'コース略称
    Dim objWebColor         As OraField         'webカラー
    Dim objOrgSName         As OraField         '団体略称
    Dim objCslDivName       As OraField         '受診区分名

    Dim vntArrRsvNo()       As Variant          '予約番号の配列
    Dim vntArrCslDate()     As Variant          '受診日の配列
    Dim vntArrCsCd()        As Variant          'コースコードの配列
    Dim vntArrCsName()      As Variant          'コース名の配列
    Dim vntArrAge()         As Variant          '受診時年齢の配列
    Dim vntArrCsSName()     As Variant          'コース略称の配列
    Dim vntArrWebColor()    As Variant          'webカラーの配列
    Dim vntArrOrgSName()    As Variant          '団体略称の配列
    Dim vntArrCslDivName()  As Variant          '受診区分名の配列
    Dim lngCount            As Long             'レコード数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If Not IsMissing(vntCslDate) Then vntCslDate = Empty
    If Not IsMissing(vntCsCd) Then vntCsCd = Empty
    If Not IsMissing(vntCsName) Then vntCsName = Empty
    If Not IsMissing(vntAge) Then vntAge = Empty
    If Not IsMissing(vntCsSName) Then vntCsSName = Empty
    If Not IsMissing(vntWebColor) Then vntWebColor = Empty
    If Not IsMissing(vntOrgSName) Then vntOrgSName = Empty
    If Not IsMissing(vntCslDivName) Then vntCslDivName = Empty
    lngCount = 0

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSLDATE", IIf(dtmCslDate > 0, dtmCslDate, "2200/12/31"), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "CHECKDAYID", IIf(blnReceptOnly, 0, -1), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SECONDFLG", IIf(blnFirstCourseOnly, 0, Null), ORAPARM_INPUT, ORATYPE_NUMBER

    '指定された個人ＩＤの受診歴一覧を取得する
    strStmt = "SELECT HISTORY.RSVNO,    HISTORY.CSLDATE,   HISTORY.CSCD,    " & vbLf & _
              "       HISTORY.AGE,      HISTORY.CSNAME,    HISTORY.CSSNAME, " & vbLf & _
              "       HISTORY.WEBCOLOR, HISTORY.SECONDFLG, HISTORY.DAYID,   " & vbLf & _
              "       ORG.ORGSNAME,     CSLDIV.CSLDIVNAME                   " & vbLf & _
              "  FROM CSLDIV, ORG,                                          " & vbLf & _
              "       ( SELECT CONSULT.PERID,     CONSULT.RSVNO,            " & vbLf & _
              "                CONSULT.CSLDATE,   CONSULT.CSCD,             " & vbLf & _
              "                CONSULT.AGE,       CONSULT.ORGCD1,           " & vbLf & _
              "                CONSULT.ORGCD2,    CONSULT.CSLDIVCD,         " & vbLf & _
              "                COURSE_P.CSNAME,   COURSE_P.CSSNAME,         " & vbLf & _
              "                COURSE_P.WEBCOLOR, COURSE_P.SECONDFLG,       " & vbLf & _
              "                RECEIPT.DAYID,                               " & vbLf & _
              "                NVL(RECEIPT.DAYID, 0) CHECKDAYID             " & vbLf & _
              "           FROM RECEIPT, COURSE_P, CONSULT                   " & vbLf & _
              "          WHERE CONSULT.PERID     = :PERID                   " & vbLf & _
              "            AND CONSULT.CANCELFLG = 0                        " & vbLf & _
              "            AND CONSULT.CSCD      = COURSE_P.CSCD            " & vbLf & _
              "            AND CONSULT.RSVNO     = RECEIPT.RSVNO(+)         " & vbLf & _
              "            AND CONSULT.CSLDATE   = RECEIPT.CSLDATE(+)       " & vbLf & _
              "       ) HISTORY                                             "

    '条件節
    strStmt = strStmt & vbLf & _
              " WHERE HISTORY.CSLDATE    <= :CSLDATE                           " & vbLf & _
              "   AND HISTORY.CHECKDAYID  > :CHECKDAYID                        " & vbLf & _
              "   AND HISTORY.SECONDFLG   = NVL(:SECONDFLG, HISTORY.SECONDFLG) " & vbLf & _
              "   AND HISTORY.ORGCD1      = ORG.ORGCD1                         " & vbLf & _
              "   AND HISTORY.ORGCD2      = ORG.ORGCD2                         " & vbLf & _
              "   AND HISTORY.CSLDIVCD    = CSLDIV.CSLDIVCD                    "

    '受診日の降順、当日ＩＤの降順、コースコードの昇順に取得
    strStmt = strStmt & vbLf & _
              " ORDER BY HISTORY.PERID,                 " & vbLf & _
              "          HISTORY.CSLDATE DESC,          " & vbLf & _
              "          HISTORY.DAYID DESC NULLS LAST, " & vbLf & _
              "          HISTORY.CSCD                   "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objCslDate = objFields("CSLDATE")
        Set objCsCd = objFields("CSCD")
        Set objCsName = objFields("CSNAME")
        Set objAge = objFields("AGE")
        Set objCsSName = objFields("CSSNAME")
        Set objWebColor = objFields("WEBCOLOR")
        Set objOrgSName = objFields("ORGSNAME")
        Set objCslDivName = objFields("CSLDIVNAME")

        'レコードの検索
        Do Until objOraDyna.EOF

            '配列形式で格納する
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrCslDate(lngCount)
            ReDim Preserve vntArrCsCd(lngCount)
            ReDim Preserve vntArrCsName(lngCount)
            ReDim Preserve vntArrAge(lngCount)
            ReDim Preserve vntArrCsSName(lngCount)
            ReDim Preserve vntArrWebColor(lngCount)
            ReDim Preserve vntArrOrgSName(lngCount)
            ReDim Preserve vntArrCslDivName(lngCount)
            vntArrRsvNo(lngCount) = objRsvNo.Value & ""
            vntArrCslDate(lngCount) = objCslDate.Value & ""
            vntArrCsCd(lngCount) = objCsCd.Value & ""
            vntArrCsName(lngCount) = objCsName.Value & ""
            vntArrAge(lngCount) = objAge.Value & ""
            vntArrCsSName(lngCount) = objCsSName.Value & ""
            vntArrWebColor(lngCount) = objWebColor.Value & ""
            vntArrOrgSName(lngCount) = objOrgSName.Value & ""
            vntArrCslDivName(lngCount) = objCslDivName.Value & ""
            lngCount = lngCount + 1

            '取得件数指定時、要取得件数に達した場合はレコード検索を終了する
            If lngGetRowCount > 0 And lngCount >= lngGetRowCount Then
                Exit Do
            End If

            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        If Not IsMissing(vntRsvNo) Then vntRsvNo = vntArrRsvNo
        If Not IsMissing(vntCslDate) Then vntCslDate = vntArrCslDate
        If Not IsMissing(vntCsCd) Then vntCsCd = vntArrCsCd
        If Not IsMissing(vntCsName) Then vntCsName = vntArrCsName
        If Not IsMissing(vntAge) Then vntAge = vntArrAge
        If Not IsMissing(vntCsSName) Then vntCsSName = vntArrCsSName
        If Not IsMissing(vntWebColor) Then vntWebColor = vntArrWebColor
        If Not IsMissing(vntOrgSName) Then vntOrgSName = vntArrOrgSName
        If Not IsMissing(vntCslDivName) Then vntCslDivName = vntArrCslDivName
    
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    SelectConsultHistory = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectConsultHistory = -1

    'イベントログ書き込み
    WriteErrorLog "Consult.SelectConsultHistory"
    
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
' 機能　　 : 検索条件を満たす受診者の一覧を取得する
'
' 引数　　 : (In)     dtmCslDate                    受診日
' 　　　　   (In)     lngCntlNo                     管理番号
' 　　　　   (In)     strCsCd                       コースコード
' 　　　　   (In)     vntStrDayId                   開始当日ＩＤ
' 　　　　   (In)     vntEndDayId                   終了当日ＩＤ
' 　　　　   (In)     vntGrpCd                      グループコード
' 　　　　   (In)     lngStartPos                   開始位置
' 　　　　   (In)     lngGetCount                   取得件数
' 　　　　   (In)     strSortKey                    ソート順
' 　　　　   (In)     blnNeedUnReceiptConsult       未受付者取得フラグ
' 　　　　   (In)     blnBadJudgemnetOnly           異常判定所持者取得フラグ
' 　　　　   (In)     blnNotCompletedJudgemnetOnly  判定未完了者取得フラグ
' 　　　　   (In)     vntEntryStatus                結果入力状態("1":未検査未完了者のみ、"2":検査完了者のみ)
' 　　　　   (Out)    vntRsvNo                      予約番号
' 　　　　   (Out)    vntDayId                      当日ＩＤ
' 　　　　   (Out)    vntWebColor                   webカラー
' 　　　　   (Out)    vntCsName                     コース名
' 　　　　   (Out)    vntPerId                      個人ＩＤ
' 　　　　   (Out)    vntLastName                   姓
' 　　　　   (Out)    vntFirstName                  名
' 　　　　   (Out)    vntLastKName                  カナ姓
' 　　　　   (Out)    vntFirstKName                 カナ名
' 　　　　   (Out)    vntGender                     性別
' 　　　　   (Out)    vntBirth                      生年月日
' 　　　　   (Out)    vntCslDate                    受診情報の受診日
' 　　　　   (Out)    vntAge                        年齢
' 　　　　   (Out)    vntOrgSName                   団体略称
' 　　　　   (Out)    vntSpare1                     予備１(東急版ではここに患者番号が格納される)
' 　　　　   (Out)    vntCsSName                    コース略称
' 　　　　   (Out)    vntFilmNo                     フィルム番号
' 　　　　   (Out)    vntFilmDate                   撮影日
' 　　　　   (Out)    vntEntriedJudgement           判定入力状態
' 　　　　   (Out)    vntVolunteer                  ボランティア
' 　　　　   (Out)    vntVolunteerName              ボランティア名
'## 2004.01.06 Add By T.Takagi@FSIT 予約群追加
' 　　　　   (Out)    strRsvGrpCd                   予約群コード
' 　　　　   (Out)    vntRsvGrpName                 予約群名称
'## 2004.01.06 Add End
'## 2004.01.09 Add By T.Takagi@FSIT 来院関連追加
' 　　　　   (Out)    blnComeOnly                   True時は来院者のみ取得(このときblnNeedUnReceiptConsult値は無効)
'## 2004.01.09 Add End
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
'## 2004.01.06 Mod By T.Takagi@FSIT 予約群追加
'Public Function SelectConsultList(
'    ByVal dtmCslDate As Date, ByVal lngCntlNo As Long, ByVal strCsCd As String,
'    Optional ByVal vntStrDayId As Variant,
'    Optional ByVal vntEndDayId As Variant,
'    Optional ByVal vntGrpCd As Variant,
'    Optional ByVal lngStartPos As Long = 0,
'    Optional ByVal lngGetCount As Long = 0,
'    Optional ByVal strSortKey As String = SORT_DAYID,
'    Optional ByVal blnNeedUnReceiptConsult As Boolean = False,
'    Optional ByVal blnBadJudgemnetOnly As Boolean = False,
'    Optional ByVal blnNotCompletedJudgemnetOnly As Boolean = False,
'    Optional ByVal vntEntryStatus As Variant,
'    Optional ByRef vntRsvNo As Variant, Optional ByRef vntDayId As Variant,
'    Optional ByRef vntWebColor As Variant, Optional ByRef vntCsName As Variant,
'    Optional ByRef vntPerId As Variant,
'    Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant,
'    Optional ByRef vntLastKName As Variant, Optional ByRef vntFirstKName As Variant,
'    Optional ByRef vntGender As Variant, Optional ByRef vntBirth As Variant,
'    Optional ByRef vntCslDate As Variant, Optional ByRef vntAge As Variant,
'    Optional ByRef vntOrgSName As Variant,
'    Optional ByRef vntSpare1 As Variant, Optional ByRef vntCsSName As Variant,
'    Optional ByRef vntFilmNo As Variant, Optional ByRef vntFilmDate As Variant,
'    Optional ByRef vntEntriedJudgement As Variant,
'    Optional ByRef vntVolunteer As Variant, Optional ByRef vntVolunteerName As Variant
') As Long
'## 2004.01.09 Mod By T.Takagi@FSIT 来院関連追加
'Public Function SelectConsultList(
'    ByVal dtmCslDate As Date, ByVal lngCntlNo As Long, ByVal strCsCd As String,
'    Optional ByVal vntStrDayId As Variant, Optional ByVal vntEndDayId As Variant,
'    Optional ByVal vntGrpCd As Variant,
'    Optional ByVal lngStartPos As Long = 0,
'    Optional ByVal lngGetCount As Long = 0,
'    Optional ByVal strSortKey As String = SORT_DAYID,
'    Optional ByVal blnNeedUnReceiptConsult As Boolean = False,
'    Optional ByVal blnBadJudgemnetOnly As Boolean = False,
'    Optional ByVal blnNotCompletedJudgemnetOnly As Boolean = False,
'    Optional ByVal vntEntryStatus As Variant,
'    Optional ByRef vntRsvNo As Variant, Optional ByRef vntDayId As Variant,
'    Optional ByRef vntWebColor As Variant, Optional ByRef vntCsName As Variant,
'    Optional ByRef vntPerId As Variant,
'    Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant,
'    Optional ByRef vntLastKName As Variant, Optional ByRef vntFirstKName As Variant,
'    Optional ByRef vntGender As Variant, Optional ByRef vntBirth As Variant,
'    Optional ByRef vntCslDate As Variant, Optional ByRef vntAge As Variant,
'    Optional ByRef vntOrgSName As Variant,
'    Optional ByRef vntSpare1 As Variant, Optional ByRef vntCsSName As Variant,
'    Optional ByRef vntFilmNo As Variant, Optional ByRef vntFilmDate As Variant,
'    Optional ByRef vntEntriedJudgement As Variant,
'    Optional ByRef vntVolunteer As Variant, Optional ByRef vntVolunteerName As Variant,
'    Optional ByVal strRsvGrpCd As String, Optional ByRef vntRsvGrpName As Variant
') As Long
Public Function SelectConsultList( _
    ByVal dtmCslDate As Date, ByVal lngCntlNo As Long, ByVal strCsCd As String, _
    Optional ByVal vntStrDayId As Variant, Optional ByVal vntEndDayId As Variant, _
    Optional ByVal vntGrpCd As Variant, _
    Optional ByVal lngStartPos As Long = 0, Optional ByVal lngGetCount As Long = 0, _
    Optional ByVal strSortKey As String = SORT_DAYID, _
    Optional ByVal blnNeedUnReceiptConsult As Boolean = False, _
    Optional ByVal blnBadJudgemnetOnly As Boolean = False, _
    Optional ByVal blnNotCompletedJudgemnetOnly As Boolean = False, _
    Optional ByVal vntEntryStatus As Variant, _
    Optional ByRef vntRsvNo As Variant, Optional ByRef vntDayId As Variant, _
    Optional ByRef vntWebColor As Variant, Optional ByRef vntCsName As Variant, _
    Optional ByRef vntPerId As Variant, _
    Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant, _
    Optional ByRef vntLastKName As Variant, Optional ByRef vntFirstKName As Variant, _
    Optional ByRef vntGender As Variant, Optional ByRef vntBirth As Variant, _
    Optional ByRef vntCslDate As Variant, Optional ByRef vntAge As Variant, _
    Optional ByRef vntOrgSName As Variant, _
    Optional ByRef vntSpare1 As Variant, Optional ByRef vntCsSName As Variant, _
    Optional ByRef vntFilmNo As Variant, Optional ByRef vntFilmDate As Variant, _
    Optional ByRef vntEntriedJudgement As Variant, _
    Optional ByRef vntVolunteer As Variant, Optional ByRef vntVolunteerName As Variant, _
    Optional ByVal strRsvGrpCd As String, Optional ByRef vntRsvGrpName As Variant, _
    Optional ByVal blnComeOnly As Boolean _
) As Long
'## 2004.01.09 Mod End
'## 2004.01.06 Mod End

    Const ENTRYSTATUS_NOT_COMPLETED As String = "1"
    Const ENTRYSTATUS_COMPLETED     As String = "2"
    
    Dim objCommon                   As Common           '共通クラス
    
    Dim objOraParam                 As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna                  As OraDynaset       'ダイナセット
    Dim strStmt                     As String           'SQLステートメント

    Dim objFields                   As OraFields        'フィールドオブジェクト
    Dim objRsvNo                    As OraField         '予約番号
    Dim objDayId                    As OraField         '当日ＩＤ
    Dim objPerId                    As OraField         '個人ＩＤ
    Dim objCslDate                  As OraField         '受診日
    Dim objAge                      As OraField         '年齢
    Dim objWebColor                 As OraField         'webカラー
    Dim objCsName                   As OraField         'コース名
    Dim objLastName                 As OraField         '姓
    Dim objFirstName                As OraField         '名
    Dim objLastKName                As OraField         'カナ姓
    Dim objFirstKName               As OraField         'カナ名
    Dim objGender                   As OraField         '性別
    Dim objBirth                    As OraField         '生年月日
    Dim objOrgSName                 As OraField         '団体略称
    Dim objSpare1                   As OraField         '予備１
    Dim objCsSName                  As OraField         'コース略称
    Dim objFilmNo                   As OraField         'フィルム番号
    Dim objFilmDate                 As OraField         '撮影日
    Dim objEntriedJudgement         As OraField         '判定入力状態
    Dim objVolunteer                As OraField         'ボランティア
    Dim objVolunteerName            As OraField         'ボランティア名
'## 2004.01.06 Add By T.Takagi@FSIT 予約群追加
    Dim objRsvGrpName               As OraField         '予約群名称
'## 2004.01.06 Add End

    Dim vntArrRsvNo()               As Variant          '予約番号の配列
    Dim vntArrDayId()               As Variant          '当日ＩＤの配列
    Dim vntArrPerId()               As Variant          '個人ＩＤの配列
    Dim vntArrCslDate()             As Variant          '受診日の配列
    Dim vntArrAge()                 As Variant          '年齢の配列
    Dim vntArrWebColor()            As Variant          'webカラーの配列
    Dim vntArrCsName()              As Variant          'コース名の配列
    Dim vntArrLastName()            As Variant          '姓の配列
    Dim vntArrFirstName()           As Variant          '名の配列
    Dim vntArrLastKName()           As Variant          'カナ姓の配列
    Dim vntArrFirstKName()          As Variant          'カナ名の配列
    Dim vntArrGender()              As Variant          '性別の配列
    Dim vntArrBirth()               As Variant          '生年月日の配列
    Dim vntArrOrgSName()            As Variant          '団体略称の配列
    Dim vntArrSpare1()              As Variant          '予備１の配列
    Dim vntArrCsSName()             As Variant          'コース略称の配列
    Dim vntArrFilmNo()              As Variant          'フィルム番号の配列
    Dim vntArrFilmDate()            As Variant          '撮影日の配列
    Dim vntArrEntriedJudgement()    As Variant          '判定入力状態の配列
    Dim vntArrVolunteer()           As Variant          'ボランティアの配列
    Dim vntArrVolunteerName()       As Variant          'ボランティア名の配列
'## 2004.01.06 Add By T.Takagi@FSIT 予約群追加
    Dim vntArrRsvGrpName()          As Variant          '予約群名称
'## 2004.01.06 Add End
    Dim lngCount                    As Long             'レコード数

    Dim strBadWeight                As String           '異常判定の重み値

    Dim i                           As Long             'インデックス

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'オブジェクトのインスタンス作成
    Set objCommon = New Common

    '初期処理
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If Not IsMissing(vntDayId) Then vntDayId = Empty
    If Not IsMissing(vntWebColor) Then vntWebColor = Empty
    If Not IsMissing(vntCsName) Then vntCsName = Empty
    If Not IsMissing(vntPerId) Then vntPerId = Empty
    If Not IsMissing(vntLastName) Then vntLastName = Empty
    If Not IsMissing(vntFirstName) Then vntFirstName = Empty
    If Not IsMissing(vntLastKName) Then vntLastKName = Empty
    If Not IsMissing(vntFirstKName) Then vntFirstKName = Empty
    If Not IsMissing(vntGender) Then vntGender = Empty
    If Not IsMissing(vntBirth) Then vntBirth = Empty
    If Not IsMissing(vntCslDate) Then vntCslDate = Empty
    If Not IsMissing(vntAge) Then vntAge = Empty
    If Not IsMissing(vntOrgSName) Then vntOrgSName = Empty
    If Not IsMissing(vntSpare1) Then vntSpare1 = Empty
    If Not IsMissing(vntCsSName) Then vntCsSName = Empty
    If Not IsMissing(vntFilmNo) Then vntFilmNo = Empty
    If Not IsMissing(vntFilmDate) Then vntFilmDate = Empty
    If Not IsMissing(vntEntriedJudgement) Then vntEntriedJudgement = Empty
    If Not IsMissing(vntVolunteer) Then vntVolunteer = Empty
    If Not IsMissing(vntVolunteerName) Then vntVolunteerName = Empty
'## 2004.01.06 Add By T.Takagi@FSIT 予約群追加
    If Not IsMissing(vntRsvGrpName) Then vntRsvGrpName = Empty
'## 2004.01.06 Add End
    lngCount = 0

    '異常判定の重み値を取得
    strBadWeight = objCommon.SelectJudBadWeight()
                
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "CNTLNO", lngCntlNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CSCD", strCsCd, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '開始当日ＩＤが指定されている場合
    If Not IsMissing(vntStrDayId) Then
        objOraParam.Add "STRDAYID", CLng(vntStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    
    '終了当日ＩＤが指定されている場合
    If Not IsMissing(vntEndDayId) Then
        objOraParam.Add "ENDDAYID", CLng(vntEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    
    'グループコードが指定されている場合
    If Not IsMissing(vntGrpCd) Then
        objOraParam.Add "GRPCD", Trim(vntGrpCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    
    objOraParam.Add "FREECD", IIf(strSortKey = SORT_DAYID Or strSortKey = SORT_PERID, "", strSortKey), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
'## 2004.01.06 Add By T.Takagi@FSIT 予約群追加
    '予約群指定時
    If strRsvGrpCd <> "" Then
        objOraParam.Add "RSVGRPCD", CLng(strRsvGrpCd), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
'## 2004.01.06 Add End
    
    '指定条件を満たす受診情報を取得する
    strStmt = "SELECT BASEDCONSULT.RSVNO, BASEDCONSULT.DAYID,        " & vbLf & _
              "       BASEDCONSULT.PERID, BASEDCONSULT.CSLDATE,      " & vbLf & _
              "       TRIM(TO_CHAR(BASEDCONSULT.AGE, '999.99')) AGE, " & vbLf & _
              "       COURSE_P.WEBCOLOR,  COURSE_P.CSNAME,           " & vbLf & _
              "       PERSON.LASTNAME,    PERSON.FIRSTNAME,          " & vbLf & _
              "       PERSON.LASTKNAME,   PERSON.FIRSTKNAME,         " & vbLf & _
              "       PERSON.GENDER,      PERSON.BIRTH,              " & vbLf & _
              "       ORG.ORGSNAME,       FILMMNG.FILMNO             "

    strStmt = RTrim(strStmt) & ", " & vbLf & _
              "       FILMMNG.FILMDATE "

    strStmt = RTrim(strStmt) & ", " & vbLf & _
              "       PERSON.SPARE1, COURSE_P.CSSNAME "

    If Not IsMissing(vntEntriedJudgement) Then
        strStmt = RTrim(strStmt) & ", " & vbLf & _
              "       CheckResultPackage.CheckExistsNoJudgement(BASEDCONSULT.RSVNO) ENTRIEDJUDGEMENT "
    Else
        strStmt = RTrim(strStmt) & ", " & vbLf & _
              "       '' ENTRIEDJUDGEMENT "
    End If

    strStmt = RTrim(strStmt) & ", " & vbLf & _
              "       BASEDCONSULT.VOLUNTEER, BASEDCONSULT.VOLUNTEERNAME "

'## 2004.01.06 Add By T.Takagi@FSIT 予約群追加
    strStmt = RTrim(strStmt) & ", " & vbLf & _
              "       RSVGRP.RSVGRPNAME "
'## 2004.01.06 Add End

    'コース・個人・団体は最後に結合するため、ここで指定
'## 2004.01.06 Mod By T.Takagi@FSIT 予約群追加
'    strStmt = strStmt & vbLf & _
'              "  FROM FILMMNG, ORG, PERSON, COURSE_P, "
    strStmt = strStmt & vbLf & _
              "  FROM RSVGRP, FILMMNG, ORG, PERSON, COURSE_P, "
'## 2004.01.06 Mod End
    
    'ここからは指定された受診日で受付されている受診情報取得処理
    strStmt = strStmt & vbLf & _
              "       ( SELECT RECEIPT.RSVNO,   RECEIPT.DAYID,  " & vbLf & _
              "                CONSULT.PERID,   CONSULT.CSCD,   " & vbLf & _
              "                CONSULT.CSLDATE, CONSULT.ORGCD1, " & vbLf & _
              "                CONSULT.ORGCD2,  CONSULT.AGE,    " & vbLf & _
              "                CONSULT.VOLUNTEER, CONSULT.VOLUNTEERNAME, "

    'フィルム番号管理テーブルを結合するための撮影機器区分を取得
    strStmt = strStmt & vbLf & _
              "                ( SELECT NVL(FREEFIELD6, ' ') " & vbLf & _
              "                    FROM FREE                 " & vbLf & _
              "                   WHERE FREECD = :FREECD     " & vbLf & _
              "                ) FILMMNGDIV                  "

'## 2004.01.06 Add By T.Takagi@FSIT 予約群追加
    strStmt = RTrim(strStmt) & ", " & vbLf & _
              "                CONSULT.RSVGRPCD "
'## 2004.01.06 Add End

    'FROM句(フィルム番号は検査結果情報より取得する)
    strStmt = strStmt & vbLf & _
              "           FROM CONSULT, RECEIPT "
    
    'まず指定条件を満たす受付情報を取得
    strStmt = strStmt & vbLf & _
              "          WHERE RECEIPT.CSLDATE = :CSLDATE " & vbLf & _
              "            AND RECEIPT.CNTLNO  = :CNTLNO  "

    '開始当日ＩＤが指定されている場合は条件節に追加
    If Not IsMissing(vntStrDayId) Then
        strStmt = strStmt & vbLf & _
              "            AND RECEIPT.DAYID  >= :STRDAYID "
    End If
    
    '終了当日ＩＤが指定されている場合は条件節に追加
    If Not IsMissing(vntEndDayId) Then
        strStmt = strStmt & vbLf & _
              "            AND RECEIPT.DAYID  <= :ENDDAYID "
    End If
    
'## 2004.01.09 Add By T.Takagi@FSIT 来院関連追加
    '来院者のみ取得する場合は条件節に追加
    If blnComeOnly Then
        strStmt = strStmt & vbLf & _
              "            AND RECEIPT.COMEDATE IS NOT NULL "
    End If
'## 2004.01.09 Add End
    
    '指定条件を満たす受付情報に受診情報を結合
    strStmt = strStmt & vbLf & _
              "            AND RECEIPT.RSVNO   = CONSULT.RSVNO "
    
    'コースコード指定時は条件節に追加
    If Trim(strCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "            AND CONSULT.CSCD = :CSCD "
    End If
    
    'グループコードが指定されている場合
    If Not IsMissing(vntGrpCd) Then

        'グループ内検査項目を受診項目として所有する受診情報のみを対象
        strStmt = strStmt & vbLf & _
              "            AND ( EXISTS ( SELECT RSL.RSVNO                         " & vbLf & _
              "                             FROM ITEM_P, GRP_I, RSL                " & vbLf & _
              "                            WHERE RSL.RSVNO     = RECEIPT.RSVNO     " & vbLf & _
              "                              AND GRP_I.GRPCD   = :GRPCD            " & vbLf & _
              "                              AND RSL.ITEMCD    = GRP_I.ITEMCD      " & vbLf & _
              "                              AND RSL.SUFFIX    = GRP_I.SUFFIX      " & vbLf & _
              "                              AND GRP_I.ITEMCD  = ITEM_P.ITEMCD     " & vbLf & _
              "                              AND ITEM_P.RSLQUE = " & RSLQUE_R & ") "

        'グループ内検査項目に問診項目が存在すれば無条件対象
        strStmt = strStmt & vbLf & _
              "                  OR                                                  " & vbLf & _
              "                  EXISTS ( SELECT GRP_I.GRPCD                         " & vbLf & _
              "                             FROM ITEM_P, GRP_I                       " & vbLf & _
              "                            WHERE GRP_I.GRPCD   = :GRPCD              " & vbLf & _
              "                              AND GRP_I.ITEMCD  = ITEM_P.ITEMCD       " & vbLf & _
              "                              AND ITEM_P.RSLQUE = " & RSLQUE_Q & ") ) "
    
    End If
    
    '異常判定を持つ受診者のみを取得する場合
    If blnBadJudgemnetOnly Then
        
        '現在登録されている判定情報の判定結果が異常とみなされるならば対象とする
        strStmt = strStmt & vbLf & _
              "            AND EXISTS ( SELECT JUDRSL.RSVNO                           " & vbLf & _
              "                           FROM JUD, JUDRSL                            " & vbLf & _
              "                          WHERE JUDRSL.RSVNO  = RECEIPT.RSVNO          " & vbLf & _
              "                            AND JUDRSL.JUDCD  = JUD.JUDCD              " & vbLf & _
              "                            AND JUD.WEIGHT   >= " & strBadWeight & " ) "
    
    End If
    
    '判定未完了者のみを取得する場合
    If blnNotCompletedJudgemnetOnly Then
        strStmt = strStmt & vbLf & _
              "            AND CheckResultPackage.CheckExistsNoJudgement(RECEIPT.RSVNO) > 0 "
    End If

'## 2004.01.06 Add By T.Takagi@FSIT 予約群追加
    '予約群指定時
    If strRsvGrpCd <> "" Then
        strStmt = strStmt & vbLf & _
              "            AND CONSULT.RSVGRPCD = :RSVGRPCD "
    End If
'## 2004.01.06 Add End

    '検査完了・未完了のチェック
    Do
    
        '引数未指定時は何もしない
        If IsMissing(vntEntryStatus) Then
            Exit Do
        End If
        
        '検査完了・未完了をチェックしない場合は何もしない
        If vntEntryStatus <> ENTRYSTATUS_NOT_COMPLETED And vntEntryStatus <> ENTRYSTATUS_COMPLETED Then
            Exit Do
        End If

        strStmt = strStmt & vbLf & _
              "            AND CheckResultPackage.CheckExistsNoResult(RECEIPT.RSVNO) = " & IIf(vntEntryStatus = ENTRYSTATUS_NOT_COMPLETED, "1", "0")

        Exit Do
    Loop

    '以下は未受付の受診情報を抽出する処理
    Do
    
'## 2004.01.09 Add By T.Takagi@FSIT 来院関連追加
        '来院者のみ取得する場合は何もしない
        If blnComeOnly Then
            Exit Do
        End If
'## 2004.01.09 Add End
    
        '未受付の受診情報を含めない場合は何もしない
        If Not blnNeedUnReceiptConsult Then
            Exit Do
        End If
    
        '当日ＩＤが指定されている場合は何もしない
        If Not IsMissing(vntStrDayId) Or Not IsMissing(vntEndDayId) Then
            Exit Do
        End If
        
        '未受付であれば当然異常判定(というか判定自体)を所有しないため、抽出非対象とする
        If blnBadJudgemnetOnly Then
            Exit Do
        End If
        
        '未受付であれば判定自体を所有しないため、判定未完云々で抽出制御する必要はない
        If blnNotCompletedJudgemnetOnly Then
            Exit Do
        End If
        
        '検査完了・未完了は受付後の受診情報に対して行うチェックのため、本条件指定時は未受付の受診情報はチェックしない
        If Not IsMissing(vntEntryStatus) Then
            If vntEntryStatus = ENTRYSTATUS_NOT_COMPLETED Or vntEntryStatus = ENTRYSTATUS_COMPLETED Then
                Exit Do
            End If
        End If
        
        'これより抽出する受診情報は先に抽出した受付情報とは排反(双方に含まれるデータが互いに存在しない)ため、UNION ALL結合する
        strStmt = strStmt & vbLf & _
              "          UNION ALL "

        '指定された受診日の受診情報を取得(当日ＩＤ、フィルム番号については当然存在しないのでNULLを返させる)
        strStmt = strStmt & vbLf & _
                  "     SELECT CONSULT.RSVNO,   RECEIPT.DAYID,  " & vbLf & _
                  "            CONSULT.PERID,   CONSULT.CSCD,   " & vbLf & _
                  "            CONSULT.CSLDATE, CONSULT.ORGCD1, " & vbLf & _
                  "            CONSULT.ORGCD2,  CONSULT.AGE,    " & vbLf & _
                  "                CONSULT.VOLUNTEER, CONSULT.VOLUNTEERNAME, " & vbLf & _
                  "            ' ' FILMMNGDIV                   "

'## 2004.01.06 Add By T.Takagi@FSIT 予約群追加
        strStmt = RTrim(strStmt) & ", " & vbLf & _
                  "                CONSULT.RSVGRPCD "
'## 2004.01.06 Add End
        
        'FROM句(フィルム番号は検査結果情報より取得する)
        strStmt = strStmt & vbLf & _
                  "       FROM RECEIPT, " & vbLf & _
                  "            CONSULT  "

        'まず指定された受診日の非キャンセル受診情報を対象とする
        strStmt = strStmt & vbLf & _
                 "       WHERE CONSULT.CSLDATE   = :CSLDATE         " & vbLf & _
                 "         AND CONSULT.CANCELFLG = " & CONSULT_USED
                 
        '未受付受診情報を抽出するため、受付情報の存在しないレコードを対象とさせる
        strStmt = strStmt & vbLf & _
                 "         AND CONSULT.CSLDATE = RECEIPT.CSLDATE(+) " & vbLf & _
                 "         AND CONSULT.RSVNO   = RECEIPT.RSVNO(+)   " & vbLf & _
                 "         AND RECEIPT.DAYID  IS NULL               "
                 
        'コースコード指定時は条件節に追加
        If Trim(strCsCd) <> "" Then
            strStmt = strStmt & vbLf & _
                 "         AND CONSULT.CSCD = :CSCD "
        End If
                 
'## 2004.01.06 Add By T.Takagi@FSIT 予約群追加
    '予約群指定時
    If strRsvGrpCd <> "" Then
        strStmt = strStmt & vbLf & _
              "            AND CONSULT.RSVGRPCD = :RSVGRPCD "
    End If
'## 2004.01.06 Add End
                 
        Exit Do
    Loop
    
    '冒頭のFROM句の括弧閉じ
    strStmt = strStmt & vbLf & _
              "       ) BASEDCONSULT "
    
    'コース・個人・団体の各情報を結合
    strStmt = strStmt & vbLf & _
              " WHERE BASEDCONSULT.CSCD   = COURSE_P.CSCD " & vbLf & _
              "   AND BASEDCONSULT.PERID  = PERSON.PERID  " & vbLf & _
              "   AND BASEDCONSULT.ORGCD1 = ORG.ORGCD1    " & vbLf & _
              "   AND BASEDCONSULT.ORGCD2 = ORG.ORGCD2    "
    
    strStmt = strStmt & vbLf & _
              "   AND BASEDCONSULT.RSVNO      = FILMMNG.RSVNO(+)      " & vbLf & _
              "   AND BASEDCONSULT.FILMMNGDIV = FILMMNG.FILMMNGDIV(+) "
    
'## 2004.01.06 Add By T.Takagi@FSIT 予約群追加
    strStmt = strStmt & vbLf & _
              "   AND BASEDCONSULT.RSVGRPCD = RSVGRP.RSVGRPCD "
'## 2004.01.06 Add End
    
    'ソート順の指定
    Select Case strSortKey
        
        '個人ＩＤ順
        Case SORT_PERID
            strStmt = strStmt & vbLf & _
              " ORDER BY BASEDCONSULT.PERID, BASEDCONSULT.CSCD "
    
        '当日ＩＤ順の場合
        Case SORT_DAYID
            strStmt = strStmt & vbLf & _
              " ORDER BY BASEDCONSULT.DAYID NULLS LAST, BASEDCONSULT.CSCD, BASEDCONSULT.ORGCD1, BASEDCONSULT.ORGCD2, BASEDCONSULT.PERID "
        
        Case Else
            strStmt = strStmt & vbLf & _
              " ORDER BY FILMMNG.FILMNO NULLS LAST,BASEDCONSULT.DAYID NULLS LAST, BASEDCONSULT.CSCD, BASEDCONSULT.ORGCD1, BASEDCONSULT.ORGCD2, BASEDCONSULT.PERID "
        
    End Select
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objDayId = objFields("DAYID")
        Set objPerId = objFields("PERID")
        Set objCslDate = objFields("CSLDATE")
        Set objAge = objFields("AGE")
        Set objWebColor = objFields("WEBCOLOR")
        Set objCsName = objFields("CSNAME")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastKName = objFields("LASTKNAME")
        Set objFirstKName = objFields("FIRSTKNAME")
        Set objGender = objFields("GENDER")
        Set objBirth = objFields("BIRTH")
        Set objOrgSName = objFields("ORGSNAME")
        Set objSpare1 = objFields("SPARE1")
        Set objCsSName = objFields("CSSNAME")
        Set objFilmNo = objFields("FILMNO")
        Set objFilmDate = objFields("FILMDATE")
        Set objEntriedJudgement = objFields("ENTRIEDJUDGEMENT")
        Set objVolunteer = objFields("VOLUNTEER")
        Set objVolunteerName = objFields("VOLUNTEERNAME")
'## 2004.01.06 Add By T.Takagi@FSIT 予約群追加
        Set objRsvGrpName = objFields("RSVGRPNAME")
'## 2004.01.06 Add End

        '配列形式で格納する
        Do Until objOraDyna.EOF
            
            'レコード数をカウント
            lngCount = lngCount + 1
            
            Do
                '現在のレコード位置が開始位置より前であれば取得しない
                If lngStartPos > 0 And lngCount < lngStartPos Then
                    Exit Do
                End If
                
                '現在のレコード位置が開始位置から取得件数分の間に存在しなければ何もしない
                If lngGetCount > 0 And lngCount > lngStartPos + lngGetCount - 1 Then
                    Exit Do
                End If
                
                '配列に追加
                ReDim Preserve vntArrRsvNo(i)
                ReDim Preserve vntArrDayId(i)
                ReDim Preserve vntArrPerId(i)
                ReDim Preserve vntArrCslDate(i)
                ReDim Preserve vntArrAge(i)
                ReDim Preserve vntArrWebColor(i)
                ReDim Preserve vntArrCsName(i)
                ReDim Preserve vntArrLastName(i)
                ReDim Preserve vntArrFirstName(i)
                ReDim Preserve vntArrLastKName(i)
                ReDim Preserve vntArrFirstKName(i)
                ReDim Preserve vntArrGender(i)
                ReDim Preserve vntArrBirth(i)
                ReDim Preserve vntArrOrgSName(i)
                ReDim Preserve vntArrSpare1(i)
                ReDim Preserve vntArrCsSName(i)
                ReDim Preserve vntArrFilmNo(i)
                ReDim Preserve vntArrFilmDate(i)
                ReDim Preserve vntArrEntriedJudgement(i)
                ReDim Preserve vntArrVolunteer(i)
                ReDim Preserve vntArrVolunteerName(i)
'## 2004.01.06 Add By T.Takagi@FSIT 予約群追加
                ReDim Preserve vntArrRsvGrpName(i)
'## 2004.01.06 Add End
                vntArrRsvNo(i) = objRsvNo.Value & ""
                vntArrDayId(i) = objDayId.Value & ""
                vntArrPerId(i) = objPerId.Value & ""
                vntArrCslDate(i) = objCslDate.Value & ""
                vntArrAge(i) = objAge.Value & ""
                vntArrWebColor(i) = objWebColor.Value & ""
                vntArrCsName(i) = objCsName.Value & ""
                vntArrLastName(i) = objLastName.Value & ""
                vntArrFirstName(i) = objFirstName.Value & ""
                vntArrLastKName(i) = objLastKName.Value & ""
                vntArrFirstKName(i) = objFirstKName.Value & ""
                vntArrGender(i) = objGender.Value & ""
                vntArrBirth(i) = objBirth.Value & ""
                vntArrOrgSName(i) = objOrgSName.Value & ""
                vntArrSpare1(i) = objSpare1.Value & ""
                vntArrCsSName(i) = objCsSName.Value & ""
                vntArrFilmNo(i) = objFilmNo.Value & ""
                vntArrFilmDate(i) = objFilmDate.Value & ""
                vntArrEntriedJudgement(i) = objEntriedJudgement.Value & ""
                vntArrVolunteer(i) = objVolunteer.Value & ""
                vntArrVolunteerName(i) = objVolunteerName.Value & ""
'## 2004.01.06 Add By T.Takagi@FSIT 予約群追加
                vntArrRsvGrpName(i) = objRsvGrpName.Value & ""
'## 2004.01.06 Add End
                
                i = i + 1
                Exit Do
            Loop
            
            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        If Not IsMissing(vntRsvNo) Then vntRsvNo = vntArrRsvNo
        If Not IsMissing(vntDayId) Then vntDayId = vntArrDayId
        If Not IsMissing(vntWebColor) Then vntWebColor = vntArrWebColor
        If Not IsMissing(vntCsName) Then vntCsName = vntArrCsName
        If Not IsMissing(vntPerId) Then vntPerId = vntArrPerId
        If Not IsMissing(vntLastName) Then vntLastName = vntArrLastName
        If Not IsMissing(vntFirstName) Then vntFirstName = vntArrFirstName
        If Not IsMissing(vntLastKName) Then vntLastKName = vntArrLastKName
        If Not IsMissing(vntFirstKName) Then vntFirstKName = vntArrFirstKName
        If Not IsMissing(vntGender) Then vntGender = vntArrGender
        If Not IsMissing(vntBirth) Then vntBirth = vntArrBirth
        If Not IsMissing(vntCslDate) Then vntCslDate = vntArrCslDate
        If Not IsMissing(vntAge) Then vntAge = vntArrAge
        If Not IsMissing(vntOrgSName) Then vntOrgSName = vntArrOrgSName
        If Not IsMissing(vntSpare1) Then vntSpare1 = vntArrSpare1
        If Not IsMissing(vntCsSName) Then vntCsSName = vntArrCsSName
        If Not IsMissing(vntFilmNo) Then vntFilmNo = vntArrFilmNo
        If Not IsMissing(vntFilmDate) Then vntFilmDate = vntArrFilmDate
        If Not IsMissing(vntEntriedJudgement) Then vntEntriedJudgement = vntArrEntriedJudgement
        If Not IsMissing(vntVolunteer) Then vntVolunteer = vntArrVolunteer
        If Not IsMissing(vntVolunteerName) Then vntVolunteerName = vntArrVolunteerName
'## 2004.01.06 Add By T.Takagi@FSIT 予約群追加
        If Not IsMissing(vntRsvGrpName) Then vntRsvGrpName = vntArrRsvGrpName
'## 2004.01.06 Add End
        
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    SelectConsultList = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectConsultList = -1

    'イベントログ書き込み
    WriteErrorLog "Consult.SelectConsultList"
    
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
' 機能　　 : 検索条件を満たす受診者の一覧を取得する
'
' 引数　　 : (In)     dtmCslDate                    受診日
' 　　　　   (In)     lngCntlNo                     管理番号
' 　　　　   (In)     strCsCd                       コースコード
' 　　　　   (In)     vntStrDayId                   開始当日ＩＤ
' 　　　　   (In)     vntEndDayId                   終了当日ＩＤ
' 　　　　   (In)     vntGrpCd                      グループコード
' 　　　　   (In)     lngStartPos                   開始位置
' 　　　　   (In)     lngGetCount                   取得件数
' 　　　　   (In)     strSortKey                    ソート順
' 　　　　   (In)     blnNeedUnReceiptConsult       未受付者取得フラグ
' 　　　　   (In)     blnBadJudgemnetOnly           異常判定所持者取得フラグ
' 　　　　   (In)     blnNotCompletedJudgemnetOnly  判定未完了者取得フラグ
' 　　　　   (In)     vntEntryStatus                結果入力状態("1":未検査未完了者のみ、"2":検査完了者のみ)
' 　　　　   (Out)    vntRsvNo                      予約番号
' 　　　　   (Out)    vntDayId                      当日ＩＤ
' 　　　　   (Out)    vntWebColor                   webカラー
' 　　　　   (Out)    vntCsName                     コース名
' 　　　　   (Out)    vntPerId                      個人ＩＤ
' 　　　　   (Out)    vntLastName                   姓
' 　　　　   (Out)    vntFirstName                  名
' 　　　　   (Out)    vntLastKName                  カナ姓
' 　　　　   (Out)    vntFirstKName                 カナ名
' 　　　　   (Out)    vntGender                     性別
' 　　　　   (Out)    vntBirth                      生年月日
' 　　　　   (Out)    vntCslDate                    受診情報の受診日
' 　　　　   (Out)    vntAge                        年齢
' 　　　　   (Out)    vntOrgSName                   団体略称
' 　　　　   (Out)    vntSpare1                     予備１(東急版ではここに患者番号が格納される)
' 　　　　   (Out)    vntCsSName                    コース略称
' 　　　　   (Out)    vntFilmNo                     フィルム番号
' 　　　　   (Out)    vntFilmDate                   撮影日
' 　　　　   (Out)    vntEntriedJudgement           判定入力状態
' 　　　　   (Out)    vntEntriedJudgementM          判定入力状態(手動分）
' 　　　　   (Out)    vntVolunteer                  ボランティア
' 　　　　   (Out)    vntVolunteerName              ボランティア名
' 　　　　   (Out)    strRsvGrpCd                   予約群コード
' 　　　　   (Out)    vntRsvGrpName                 予約群名称
' 　　　　   (Out)    blnComeOnly                   True時は来院者のみ取得(このときblnNeedUnReceiptConsult値は無効)
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'

'## 2016.08.12 張 自動判定処理実施有無追加 STR ##
'Public Function SelectConsultListProgress( _
'    ByVal dtmCslDate As Date, ByVal lngCntlNo As Long, ByVal strCsCd As String, _
'    Optional ByVal vntStrDayId As Variant, Optional ByVal vntEndDayId As Variant, _
'    Optional ByVal vntGrpCd As Variant, _
'    Optional ByVal lngStartPos As Long = 0, Optional ByVal lngGetCount As Long = 0, _
'    Optional ByVal strSortKey As String = SORT_DAYID, _
'    Optional ByVal blnNeedUnReceiptConsult As Boolean = False, _
'    Optional ByVal blnBadJudgemnetOnly As Boolean = False, _
'    Optional ByVal blnNotCompletedJudgemnetOnly As Boolean = False, _
'    Optional ByVal vntEntryStatus As Variant, _
'    Optional ByRef vntRsvNo As Variant, Optional ByRef vntDayId As Variant, _
'    Optional ByRef vntWebColor As Variant, Optional ByRef vntCsName As Variant, _
'    Optional ByRef vntPerId As Variant, _
'    Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant, _
'    Optional ByRef vntLastKName As Variant, Optional ByRef vntFirstKName As Variant, _
'    Optional ByRef vntGender As Variant, Optional ByRef vntBirth As Variant, _
'    Optional ByRef vntCslDate As Variant, Optional ByRef vntAge As Variant, _
'    Optional ByRef vntOrgSName As Variant, _
'    Optional ByRef vntSpare1 As Variant, Optional ByRef vntCsSName As Variant, _
'    Optional ByRef vntFilmNo As Variant, Optional ByRef vntFilmDate As Variant, _
'    Optional ByRef vntEntriedJudgement As Variant, Optional ByRef vntEntriedJudgementM As Variant, _
'    Optional ByRef vntVolunteer As Variant, Optional ByRef vntVolunteerName As Variant, _
'    Optional ByVal strRsvGrpCd As String, Optional ByRef vntRsvGrpName As Variant, _
'    Optional ByVal blnComeOnly As Boolean _
') As Long

Public Function SelectConsultListProgress( _
    ByVal dtmCslDate As Date, ByVal lngCntlNo As Long, ByVal strCsCd As String, _
    Optional ByVal vntStrDayId As Variant, Optional ByVal vntEndDayId As Variant, _
    Optional ByVal vntGrpCd As Variant, _
    Optional ByVal lngStartPos As Long = 0, Optional ByVal lngGetCount As Long = 0, _
    Optional ByVal strSortKey As String = SORT_DAYID, _
    Optional ByVal blnNeedUnReceiptConsult As Boolean = False, _
    Optional ByVal blnBadJudgemnetOnly As Boolean = False, _
    Optional ByVal blnNotCompletedJudgemnetOnly As Boolean = False, _
    Optional ByVal vntEntryStatus As Variant, _
    Optional ByRef vntRsvNo As Variant, Optional ByRef vntDayId As Variant, _
    Optional ByRef vntWebColor As Variant, Optional ByRef vntCsName As Variant, _
    Optional ByRef vntPerId As Variant, _
    Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant, _
    Optional ByRef vntLastKName As Variant, Optional ByRef vntFirstKName As Variant, _
    Optional ByRef vntGender As Variant, Optional ByRef vntBirth As Variant, _
    Optional ByRef vntCslDate As Variant, Optional ByRef vntAge As Variant, _
    Optional ByRef vntOrgSName As Variant, _
    Optional ByRef vntSpare1 As Variant, Optional ByRef vntCsSName As Variant, _
    Optional ByRef vntFilmNo As Variant, Optional ByRef vntFilmDate As Variant, _
    Optional ByRef vntEntriedJudgement As Variant, Optional ByRef vntEntriedJudgementM As Variant, _
    Optional ByRef vntVolunteer As Variant, Optional ByRef vntVolunteerName As Variant, _
    Optional ByVal strRsvGrpCd As String, Optional ByRef vntRsvGrpName As Variant, _
    Optional ByRef vntMensetsuState As Variant, Optional ByVal blnComeOnly As Boolean _
) As Long
'## 2016.08.12 張 自動判定処理実施有無追加 END ##

    Const ENTRYSTATUS_NOT_COMPLETED As String = "1"
    Const ENTRYSTATUS_COMPLETED     As String = "2"
    
    Dim objCommon                   As Common           '共通クラス
    
    Dim objOraParam                 As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna                  As OraDynaset       'ダイナセット
    Dim strStmt                     As String           'SQLステートメント

    Dim objFields                   As OraFields        'フィールドオブジェクト
    Dim objRsvNo                    As OraField         '予約番号
    Dim objDayId                    As OraField         '当日ＩＤ
    Dim objPerId                    As OraField         '個人ＩＤ
    Dim objCslDate                  As OraField         '受診日
    Dim objAge                      As OraField         '年齢
    Dim objWebColor                 As OraField         'webカラー
    Dim objCsName                   As OraField         'コース名
    Dim objLastName                 As OraField         '姓
    Dim objFirstName                As OraField         '名
    Dim objLastKName                As OraField         'カナ姓
    Dim objFirstKName               As OraField         'カナ名
    Dim objGender                   As OraField         '性別
    Dim objBirth                    As OraField         '生年月日
    Dim objOrgSName                 As OraField         '団体略称
    Dim objSpare1                   As OraField         '予備１
    Dim objCsSName                  As OraField         'コース略称
    Dim objFilmNo                   As OraField         'フィルム番号
    Dim objFilmDate                 As OraField         '撮影日
    Dim objEntriedJudgement         As OraField         '判定入力状態
    Dim objEntriedJudgementM        As OraField         '判定入力状態(手動）
    Dim objVolunteer                As OraField         'ボランティア
    Dim objVolunteerName            As OraField         'ボランティア名
'## 2004.01.06 Add By T.Takagi@FSIT 予約群追加
    Dim objRsvGrpName               As OraField         '予約群名称
'## 2004.01.06 Add End

'## 2016.08.12 張 自動判定処理実施有無追加 STR ##
    Dim objMensetsuState            As OraField         '自動判定処理実施有無（処理済み：可能、未処理：不可能）
'## 2016.08.12 張 自動判定処理実施有無追加 END ##

    Dim vntArrRsvNo()               As Variant          '予約番号の配列
    Dim vntArrDayId()               As Variant          '当日ＩＤの配列
    Dim vntArrPerId()               As Variant          '個人ＩＤの配列
    Dim vntArrCslDate()             As Variant          '受診日の配列
    Dim vntArrAge()                 As Variant          '年齢の配列
    Dim vntArrWebColor()            As Variant          'webカラーの配列
    Dim vntArrCsName()              As Variant          'コース名の配列
    Dim vntArrLastName()            As Variant          '姓の配列
    Dim vntArrFirstName()           As Variant          '名の配列
    Dim vntArrLastKName()           As Variant          'カナ姓の配列
    Dim vntArrFirstKName()          As Variant          'カナ名の配列
    Dim vntArrGender()              As Variant          '性別の配列
    Dim vntArrBirth()               As Variant          '生年月日の配列
    Dim vntArrOrgSName()            As Variant          '団体略称の配列
    Dim vntArrSpare1()              As Variant          '予備１の配列
    Dim vntArrCsSName()             As Variant          'コース略称の配列
    Dim vntArrFilmNo()              As Variant          'フィルム番号の配列
    Dim vntArrFilmDate()            As Variant          '撮影日の配列
    Dim vntArrEntriedJudgement()    As Variant          '判定入力状態の配列
    Dim vntArrEntriedJudgementM()   As Variant          '判定入力状態の配列(手動）
    Dim vntArrVolunteer()           As Variant          'ボランティアの配列
    Dim vntArrVolunteerName()       As Variant          'ボランティア名の配列
'## 2004.01.06 Add By T.Takagi@FSIT 予約群追加
    Dim vntArrRsvGrpName()          As Variant          '予約群名称
'## 2004.01.06 Add End
    
'## 2016.08.12 張 自動判定処理実施有無追加 STR ##
    Dim vntArrMensetsuState()       As Variant          '自動判定処理実施有無（処理済み：可能、未処理：不可能）
'## 2016.08.12 張 自動判定処理実施有無追加 END ##
    
    Dim lngCount                    As Long             'レコード数

    Dim strBadWeight                As String           '異常判定の重み値

    Dim i                           As Long             'インデックス

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'オブジェクトのインスタンス作成
    Set objCommon = New Common

    '初期処理
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If Not IsMissing(vntDayId) Then vntDayId = Empty
    If Not IsMissing(vntWebColor) Then vntWebColor = Empty
    If Not IsMissing(vntCsName) Then vntCsName = Empty
    If Not IsMissing(vntPerId) Then vntPerId = Empty
    If Not IsMissing(vntLastName) Then vntLastName = Empty
    If Not IsMissing(vntFirstName) Then vntFirstName = Empty
    If Not IsMissing(vntLastKName) Then vntLastKName = Empty
    If Not IsMissing(vntFirstKName) Then vntFirstKName = Empty
    If Not IsMissing(vntGender) Then vntGender = Empty
    If Not IsMissing(vntBirth) Then vntBirth = Empty
    If Not IsMissing(vntCslDate) Then vntCslDate = Empty
    If Not IsMissing(vntAge) Then vntAge = Empty
    If Not IsMissing(vntOrgSName) Then vntOrgSName = Empty
    If Not IsMissing(vntSpare1) Then vntSpare1 = Empty
    If Not IsMissing(vntCsSName) Then vntCsSName = Empty
    If Not IsMissing(vntFilmNo) Then vntFilmNo = Empty
    If Not IsMissing(vntFilmDate) Then vntFilmDate = Empty
    If Not IsMissing(vntEntriedJudgement) Then vntEntriedJudgement = Empty
    If Not IsMissing(vntEntriedJudgementM) Then vntEntriedJudgementM = Empty
    If Not IsMissing(vntVolunteer) Then vntVolunteer = Empty
    If Not IsMissing(vntVolunteerName) Then vntVolunteerName = Empty
'## 2004.01.06 Add By T.Takagi@FSIT 予約群追加
    If Not IsMissing(vntRsvGrpName) Then vntRsvGrpName = Empty
'## 2004.01.06 Add End
'## 2016.08.12 張 自動判定処理実施有無追加 STR ##
    If Not IsMissing(vntMensetsuState) Then vntMensetsuState = Empty
'## 2016.08.12 張 自動判定処理実施有無追加 END ##
    lngCount = 0

    '異常判定の重み値を取得
    strBadWeight = objCommon.SelectJudBadWeight()
                
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "CNTLNO", lngCntlNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CSCD", strCsCd, ORAPARM_INPUT, ORATYPE_VARCHAR2

    '開始当日ＩＤが指定されている場合
    If Not IsMissing(vntStrDayId) Then
        objOraParam.Add "STRDAYID", CLng(vntStrDayId), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    
    '終了当日ＩＤが指定されている場合
    If Not IsMissing(vntEndDayId) Then
        objOraParam.Add "ENDDAYID", CLng(vntEndDayId), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    
    'グループコードが指定されている場合
    If Not IsMissing(vntGrpCd) Then
        objOraParam.Add "GRPCD", Trim(vntGrpCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    
    objOraParam.Add "FREECD", IIf(strSortKey = SORT_DAYID Or strSortKey = SORT_PERID, "", strSortKey), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
'## 2004.01.06 Add By T.Takagi@FSIT 予約群追加
    '予約群指定時
    If strRsvGrpCd <> "" Then
        objOraParam.Add "RSVGRPCD", CLng(strRsvGrpCd), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
'## 2004.01.06 Add End
    
    '指定条件を満たす受診情報を取得する
    strStmt = "SELECT BASEDCONSULT.RSVNO, BASEDCONSULT.DAYID,        " & vbLf & _
              "       BASEDCONSULT.PERID, BASEDCONSULT.CSLDATE,      " & vbLf & _
              "       TRIM(TO_CHAR(BASEDCONSULT.AGE, '999.99')) AGE, " & vbLf & _
              "       COURSE_P.WEBCOLOR,  COURSE_P.CSNAME,           " & vbLf & _
              "       PERSON.LASTNAME,    PERSON.FIRSTNAME,          " & vbLf & _
              "       PERSON.LASTKNAME,   PERSON.FIRSTKNAME,         " & vbLf & _
              "       PERSON.GENDER,      PERSON.BIRTH,              " & vbLf & _
              "       ORG.ORGSNAME,       FILMMNG.FILMNO             "

    strStmt = RTrim(strStmt) & ", " & vbLf & _
              "       FILMMNG.FILMDATE "

    strStmt = RTrim(strStmt) & ", " & vbLf & _
              "       PERSON.SPARE1, COURSE_P.CSSNAME "

    If Not IsMissing(vntEntriedJudgement) Then
        strStmt = RTrim(strStmt) & ", " & vbLf & _
              "       CheckResultPackage.CheckExistsNoJudgementAuto(BASEDCONSULT.RSVNO) ENTRIEDJUDGEMENTA "
    Else
        strStmt = RTrim(strStmt) & ", " & vbLf & _
              "       '' ENTRIEDJUDGEMENTA "
    End If

    If Not IsMissing(vntEntriedJudgementM) Then
        strStmt = RTrim(strStmt) & ", " & vbLf & _
              "       CheckResultPackage.CheckExistsNoJudgementManual(BASEDCONSULT.RSVNO) ENTRIEDJUDGEMENTM "
    Else
        strStmt = RTrim(strStmt) & ", " & vbLf & _
              "       '' ENTRIEDJUDGEMENTM "
    End If

    strStmt = RTrim(strStmt) & ", " & vbLf & _
              "       BASEDCONSULT.VOLUNTEER, BASEDCONSULT.VOLUNTEERNAME "

'## 2004.01.06 Add By T.Takagi@FSIT 予約群追加
    strStmt = RTrim(strStmt) & ", " & vbLf & _
              "       RSVGRP.RSVGRPNAME "
'## 2004.01.06 Add End

'## 2016.08.12 張 自動判定処理実施有無追加 STR ##
    strStmt = RTrim(strStmt) & ", " & vbLf & _
              "       usp_mensetsu_state(BASEDCONSULT.RSVNO) MENSETSUSTATE"
'## 2016.08.12 張 自動判定処理実施有無追加 END ##

    'コース・個人・団体は最後に結合するため、ここで指定
'## 2004.01.06 Mod By T.Takagi@FSIT 予約群追加
'    strStmt = strStmt & vbLf & _
'              "  FROM FILMMNG, ORG, PERSON, COURSE_P, "
    strStmt = strStmt & vbLf & _
              "  FROM RSVGRP, FILMMNG, ORG, PERSON, COURSE_P, "
'## 2004.01.06 Mod End
    
    'ここからは指定された受診日で受付されている受診情報取得処理
    strStmt = strStmt & vbLf & _
              "       ( SELECT RECEIPT.RSVNO,   RECEIPT.DAYID,  " & vbLf & _
              "                CONSULT.PERID,   CONSULT.CSCD,   " & vbLf & _
              "                CONSULT.CSLDATE, CONSULT.ORGCD1, " & vbLf & _
              "                CONSULT.ORGCD2,  CONSULT.AGE,    " & vbLf & _
              "                CONSULT.VOLUNTEER, CONSULT.VOLUNTEERNAME, "

    'フィルム番号管理テーブルを結合するための撮影機器区分を取得
    strStmt = strStmt & vbLf & _
              "                ( SELECT NVL(FREEFIELD6, ' ') " & vbLf & _
              "                    FROM FREE                 " & vbLf & _
              "                   WHERE FREECD = :FREECD     " & vbLf & _
              "                ) FILMMNGDIV                  "

'## 2004.01.06 Add By T.Takagi@FSIT 予約群追加
    strStmt = RTrim(strStmt) & ", " & vbLf & _
              "                CONSULT.RSVGRPCD "
'## 2004.01.06 Add End

    'FROM句(フィルム番号は検査結果情報より取得する)
    strStmt = strStmt & vbLf & _
              "           FROM CONSULT, RECEIPT "
    
    'まず指定条件を満たす受付情報を取得
    strStmt = strStmt & vbLf & _
              "          WHERE RECEIPT.CSLDATE = :CSLDATE " & vbLf & _
              "            AND RECEIPT.CNTLNO  = :CNTLNO  "

    '開始当日ＩＤが指定されている場合は条件節に追加
    If Not IsMissing(vntStrDayId) Then
        strStmt = strStmt & vbLf & _
              "            AND RECEIPT.DAYID  >= :STRDAYID "
    End If
    
    '終了当日ＩＤが指定されている場合は条件節に追加
    If Not IsMissing(vntEndDayId) Then
        strStmt = strStmt & vbLf & _
              "            AND RECEIPT.DAYID  <= :ENDDAYID "
    End If
    
'## 2004.01.09 Add By T.Takagi@FSIT 来院関連追加
    '来院者のみ取得する場合は条件節に追加
    If blnComeOnly Then
        strStmt = strStmt & vbLf & _
              "            AND RECEIPT.COMEDATE IS NOT NULL "
    End If
'## 2004.01.09 Add End
    
    '指定条件を満たす受付情報に受診情報を結合
    strStmt = strStmt & vbLf & _
              "            AND RECEIPT.RSVNO   = CONSULT.RSVNO "
    
    'コースコード指定時は条件節に追加
    If Trim(strCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "            AND CONSULT.CSCD = :CSCD "
    End If
    
    'グループコードが指定されている場合
    If Not IsMissing(vntGrpCd) Then

        'グループ内検査項目を受診項目として所有する受診情報のみを対象
        strStmt = strStmt & vbLf & _
              "            AND ( EXISTS ( SELECT RSL.RSVNO                         " & vbLf & _
              "                             FROM ITEM_P, GRP_I, RSL                " & vbLf & _
              "                            WHERE RSL.RSVNO     = RECEIPT.RSVNO     " & vbLf & _
              "                              AND GRP_I.GRPCD   = :GRPCD            " & vbLf & _
              "                              AND RSL.ITEMCD    = GRP_I.ITEMCD      " & vbLf & _
              "                              AND RSL.SUFFIX    = GRP_I.SUFFIX      " & vbLf & _
              "                              AND GRP_I.ITEMCD  = ITEM_P.ITEMCD     " & vbLf & _
              "                              AND ITEM_P.RSLQUE = " & RSLQUE_R & ") "

        'グループ内検査項目に問診項目が存在すれば無条件対象
        strStmt = strStmt & vbLf & _
              "                  OR                                                  " & vbLf & _
              "                  EXISTS ( SELECT GRP_I.GRPCD                         " & vbLf & _
              "                             FROM ITEM_P, GRP_I                       " & vbLf & _
              "                            WHERE GRP_I.GRPCD   = :GRPCD              " & vbLf & _
              "                              AND GRP_I.ITEMCD  = ITEM_P.ITEMCD       " & vbLf & _
              "                              AND ITEM_P.RSLQUE = " & RSLQUE_Q & ") ) "
    
    End If
    
    '異常判定を持つ受診者のみを取得する場合
    If blnBadJudgemnetOnly Then
        
        '現在登録されている判定情報の判定結果が異常とみなされるならば対象とする
        strStmt = strStmt & vbLf & _
              "            AND EXISTS ( SELECT JUDRSL.RSVNO                           " & vbLf & _
              "                           FROM JUD, JUDRSL                            " & vbLf & _
              "                          WHERE JUDRSL.RSVNO  = RECEIPT.RSVNO          " & vbLf & _
              "                            AND JUDRSL.JUDCD  = JUD.JUDCD              " & vbLf & _
              "                            AND JUD.WEIGHT   >= " & strBadWeight & " ) "
    
    End If
    
    '判定未完了者のみを取得する場合
    If blnNotCompletedJudgemnetOnly Then
        strStmt = strStmt & vbLf & _
              "            AND CheckResultPackage.CheckExistsNoJudgement(RECEIPT.RSVNO) > 0 "
    End If

'## 2004.01.06 Add By T.Takagi@FSIT 予約群追加
    '予約群指定時
    If strRsvGrpCd <> "" Then
        strStmt = strStmt & vbLf & _
              "            AND CONSULT.RSVGRPCD = :RSVGRPCD "
    End If
'## 2004.01.06 Add End

    '検査完了・未完了のチェック
    Do
    
        '引数未指定時は何もしない
        If IsMissing(vntEntryStatus) Then
            Exit Do
        End If
        
        '検査完了・未完了をチェックしない場合は何もしない
        If vntEntryStatus <> ENTRYSTATUS_NOT_COMPLETED And vntEntryStatus <> ENTRYSTATUS_COMPLETED Then
            Exit Do
        End If

        strStmt = strStmt & vbLf & _
              "            AND CheckResultPackage.CheckExistsNoResult(RECEIPT.RSVNO) = " & IIf(vntEntryStatus = ENTRYSTATUS_NOT_COMPLETED, "1", "0")

        Exit Do
    Loop

    '以下は未受付の受診情報を抽出する処理
    Do
    
'## 2004.01.09 Add By T.Takagi@FSIT 来院関連追加
        '来院者のみ取得する場合は何もしない
        If blnComeOnly Then
            Exit Do
        End If
'## 2004.01.09 Add End
    
        '未受付の受診情報を含めない場合は何もしない
        If Not blnNeedUnReceiptConsult Then
            Exit Do
        End If
    
        '当日ＩＤが指定されている場合は何もしない
        If Not IsMissing(vntStrDayId) Or Not IsMissing(vntEndDayId) Then
            Exit Do
        End If
        
        '未受付であれば当然異常判定(というか判定自体)を所有しないため、抽出非対象とする
        If blnBadJudgemnetOnly Then
            Exit Do
        End If
        
        '未受付であれば判定自体を所有しないため、判定未完云々で抽出制御する必要はない
        If blnNotCompletedJudgemnetOnly Then
            Exit Do
        End If
        
        '検査完了・未完了は受付後の受診情報に対して行うチェックのため、本条件指定時は未受付の受診情報はチェックしない
        If Not IsMissing(vntEntryStatus) Then
            If vntEntryStatus = ENTRYSTATUS_NOT_COMPLETED Or vntEntryStatus = ENTRYSTATUS_COMPLETED Then
                Exit Do
            End If
        End If
        
        'これより抽出する受診情報は先に抽出した受付情報とは排反(双方に含まれるデータが互いに存在しない)ため、UNION ALL結合する
        strStmt = strStmt & vbLf & _
              "          UNION ALL "

        '指定された受診日の受診情報を取得(当日ＩＤ、フィルム番号については当然存在しないのでNULLを返させる)
        strStmt = strStmt & vbLf & _
                  "     SELECT CONSULT.RSVNO,   RECEIPT.DAYID,  " & vbLf & _
                  "            CONSULT.PERID,   CONSULT.CSCD,   " & vbLf & _
                  "            CONSULT.CSLDATE, CONSULT.ORGCD1, " & vbLf & _
                  "            CONSULT.ORGCD2,  CONSULT.AGE,    " & vbLf & _
                  "                CONSULT.VOLUNTEER, CONSULT.VOLUNTEERNAME, " & vbLf & _
                  "            ' ' FILMMNGDIV                   "

'## 2004.01.06 Add By T.Takagi@FSIT 予約群追加
        strStmt = RTrim(strStmt) & ", " & vbLf & _
                  "                CONSULT.RSVGRPCD "
'## 2004.01.06 Add End

'## 2016.08.12 張 自動判定処理実施有無追加 STR ##
    strStmt = RTrim(strStmt) & ", " & vbLf & _
              "       usp_mensetsu_state(CONSULT.RSVNO) MENSETSUSTATE"
'## 2016.08.12 張 自動判定処理実施有無追加 END ##
        
        'FROM句(フィルム番号は検査結果情報より取得する)
        strStmt = strStmt & vbLf & _
                  "       FROM RECEIPT, " & vbLf & _
                  "            CONSULT  "

        'まず指定された受診日の非キャンセル受診情報を対象とする
        strStmt = strStmt & vbLf & _
                 "       WHERE CONSULT.CSLDATE   = :CSLDATE         " & vbLf & _
                 "         AND CONSULT.CANCELFLG = " & CONSULT_USED
                 
        '未受付受診情報を抽出するため、受付情報の存在しないレコードを対象とさせる
        strStmt = strStmt & vbLf & _
                 "         AND CONSULT.CSLDATE = RECEIPT.CSLDATE(+) " & vbLf & _
                 "         AND CONSULT.RSVNO   = RECEIPT.RSVNO(+)   " & vbLf & _
                 "         AND RECEIPT.DAYID  IS NULL               "
                 
        'コースコード指定時は条件節に追加
        If Trim(strCsCd) <> "" Then
            strStmt = strStmt & vbLf & _
                 "         AND CONSULT.CSCD = :CSCD "
        End If
                 
'## 2004.01.06 Add By T.Takagi@FSIT 予約群追加
    '予約群指定時
    If strRsvGrpCd <> "" Then
        strStmt = strStmt & vbLf & _
              "            AND CONSULT.RSVGRPCD = :RSVGRPCD "
    End If
'## 2004.01.06 Add End
                 
        Exit Do
    Loop
    
    '冒頭のFROM句の括弧閉じ
    strStmt = strStmt & vbLf & _
              "       ) BASEDCONSULT "
    
    'コース・個人・団体の各情報を結合
    strStmt = strStmt & vbLf & _
              " WHERE BASEDCONSULT.CSCD   = COURSE_P.CSCD " & vbLf & _
              "   AND BASEDCONSULT.PERID  = PERSON.PERID  " & vbLf & _
              "   AND BASEDCONSULT.ORGCD1 = ORG.ORGCD1    " & vbLf & _
              "   AND BASEDCONSULT.ORGCD2 = ORG.ORGCD2    "
    
    strStmt = strStmt & vbLf & _
              "   AND BASEDCONSULT.RSVNO      = FILMMNG.RSVNO(+)      " & vbLf & _
              "   AND BASEDCONSULT.FILMMNGDIV = FILMMNG.FILMMNGDIV(+) "
    
'## 2004.01.06 Add By T.Takagi@FSIT 予約群追加
    strStmt = strStmt & vbLf & _
              "   AND BASEDCONSULT.RSVGRPCD = RSVGRP.RSVGRPCD "
'## 2004.01.06 Add End
    
    'ソート順の指定
    Select Case strSortKey
        
        '個人ＩＤ順
        Case SORT_PERID
            strStmt = strStmt & vbLf & _
              " ORDER BY BASEDCONSULT.PERID, BASEDCONSULT.CSCD "
    
        '当日ＩＤ順の場合
        Case SORT_DAYID
            strStmt = strStmt & vbLf & _
              " ORDER BY BASEDCONSULT.DAYID NULLS LAST, BASEDCONSULT.CSCD, BASEDCONSULT.ORGCD1, BASEDCONSULT.ORGCD2, BASEDCONSULT.PERID "
        
        Case Else
            strStmt = strStmt & vbLf & _
              " ORDER BY FILMMNG.FILMNO NULLS LAST,BASEDCONSULT.DAYID NULLS LAST, BASEDCONSULT.CSCD, BASEDCONSULT.ORGCD1, BASEDCONSULT.ORGCD2, BASEDCONSULT.PERID "
        
    End Select
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objDayId = objFields("DAYID")
        Set objPerId = objFields("PERID")
        Set objCslDate = objFields("CSLDATE")
        Set objAge = objFields("AGE")
        Set objWebColor = objFields("WEBCOLOR")
        Set objCsName = objFields("CSNAME")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastKName = objFields("LASTKNAME")
        Set objFirstKName = objFields("FIRSTKNAME")
        Set objGender = objFields("GENDER")
        Set objBirth = objFields("BIRTH")
        Set objOrgSName = objFields("ORGSNAME")
        Set objSpare1 = objFields("SPARE1")
        Set objCsSName = objFields("CSSNAME")
        Set objFilmNo = objFields("FILMNO")
        Set objFilmDate = objFields("FILMDATE")
        Set objEntriedJudgement = objFields("ENTRIEDJUDGEMENTA")
        Set objEntriedJudgementM = objFields("ENTRIEDJUDGEMENTM")
        Set objVolunteer = objFields("VOLUNTEER")
        Set objVolunteerName = objFields("VOLUNTEERNAME")
'## 2004.01.06 Add By T.Takagi@FSIT 予約群追加
        Set objRsvGrpName = objFields("RSVGRPNAME")
'## 2004.01.06 Add End
'## 2016.08.12 張 自動判定処理実施有無追加 STR ##
        Set objMensetsuState = objFields("MENSETSUSTATE")
'## 2016.08.12 張 自動判定処理実施有無追加 END ##

        '配列形式で格納する
        Do Until objOraDyna.EOF
            
            'レコード数をカウント
            lngCount = lngCount + 1
            
            Do
                '現在のレコード位置が開始位置より前であれば取得しない
                If lngStartPos > 0 And lngCount < lngStartPos Then
                    Exit Do
                End If
                
                '現在のレコード位置が開始位置から取得件数分の間に存在しなければ何もしない
                If lngGetCount > 0 And lngCount > lngStartPos + lngGetCount - 1 Then
                    Exit Do
                End If
                
                '配列に追加
                ReDim Preserve vntArrRsvNo(i)
                ReDim Preserve vntArrDayId(i)
                ReDim Preserve vntArrPerId(i)
                ReDim Preserve vntArrCslDate(i)
                ReDim Preserve vntArrAge(i)
                ReDim Preserve vntArrWebColor(i)
                ReDim Preserve vntArrCsName(i)
                ReDim Preserve vntArrLastName(i)
                ReDim Preserve vntArrFirstName(i)
                ReDim Preserve vntArrLastKName(i)
                ReDim Preserve vntArrFirstKName(i)
                ReDim Preserve vntArrGender(i)
                ReDim Preserve vntArrBirth(i)
                ReDim Preserve vntArrOrgSName(i)
                ReDim Preserve vntArrSpare1(i)
                ReDim Preserve vntArrCsSName(i)
                ReDim Preserve vntArrFilmNo(i)
                ReDim Preserve vntArrFilmDate(i)
                ReDim Preserve vntArrEntriedJudgement(i)
                ReDim Preserve vntArrEntriedJudgementM(i)
                ReDim Preserve vntArrVolunteer(i)
                ReDim Preserve vntArrVolunteerName(i)
'## 2004.01.06 Add By T.Takagi@FSIT 予約群追加
                ReDim Preserve vntArrRsvGrpName(i)
'## 2004.01.06 Add End
'## 2016.08.12 張 自動判定処理実施有無追加 STR ##
                ReDim Preserve vntArrMensetsuState(i)
'## 2016.08.12 張 自動判定処理実施有無追加 END ##
                vntArrRsvNo(i) = objRsvNo.Value & ""
                vntArrDayId(i) = objDayId.Value & ""
                vntArrPerId(i) = objPerId.Value & ""
                vntArrCslDate(i) = objCslDate.Value & ""
                vntArrAge(i) = objAge.Value & ""
                vntArrWebColor(i) = objWebColor.Value & ""
                vntArrCsName(i) = objCsName.Value & ""
                vntArrLastName(i) = objLastName.Value & ""
                vntArrFirstName(i) = objFirstName.Value & ""
                vntArrLastKName(i) = objLastKName.Value & ""
                vntArrFirstKName(i) = objFirstKName.Value & ""
                vntArrGender(i) = objGender.Value & ""
                vntArrBirth(i) = objBirth.Value & ""
                vntArrOrgSName(i) = objOrgSName.Value & ""
                vntArrSpare1(i) = objSpare1.Value & ""
                vntArrCsSName(i) = objCsSName.Value & ""
                vntArrFilmNo(i) = objFilmNo.Value & ""
                vntArrFilmDate(i) = objFilmDate.Value & ""
                vntArrEntriedJudgement(i) = objEntriedJudgement.Value & ""
                vntArrEntriedJudgementM(i) = objEntriedJudgementM.Value & ""
                vntArrVolunteer(i) = objVolunteer.Value & ""
                vntArrVolunteerName(i) = objVolunteerName.Value & ""
'## 2004.01.06 Add By T.Takagi@FSIT 予約群追加
                vntArrRsvGrpName(i) = objRsvGrpName.Value & ""
'## 2004.01.06 Add End
'## 2016.08.12 張 自動判定処理実施有無追加 STR ##
                vntArrMensetsuState(i) = objMensetsuState.Value & ""
'## 2016.08.12 張 自動判定処理実施有無追加 END ##
                
                i = i + 1
                Exit Do
            Loop
            
            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        If Not IsMissing(vntRsvNo) Then vntRsvNo = vntArrRsvNo
        If Not IsMissing(vntDayId) Then vntDayId = vntArrDayId
        If Not IsMissing(vntWebColor) Then vntWebColor = vntArrWebColor
        If Not IsMissing(vntCsName) Then vntCsName = vntArrCsName
        If Not IsMissing(vntPerId) Then vntPerId = vntArrPerId
        If Not IsMissing(vntLastName) Then vntLastName = vntArrLastName
        If Not IsMissing(vntFirstName) Then vntFirstName = vntArrFirstName
        If Not IsMissing(vntLastKName) Then vntLastKName = vntArrLastKName
        If Not IsMissing(vntFirstKName) Then vntFirstKName = vntArrFirstKName
        If Not IsMissing(vntGender) Then vntGender = vntArrGender
        If Not IsMissing(vntBirth) Then vntBirth = vntArrBirth
        If Not IsMissing(vntCslDate) Then vntCslDate = vntArrCslDate
        If Not IsMissing(vntAge) Then vntAge = vntArrAge
        If Not IsMissing(vntOrgSName) Then vntOrgSName = vntArrOrgSName
        If Not IsMissing(vntSpare1) Then vntSpare1 = vntArrSpare1
        If Not IsMissing(vntCsSName) Then vntCsSName = vntArrCsSName
        If Not IsMissing(vntFilmNo) Then vntFilmNo = vntArrFilmNo
        If Not IsMissing(vntFilmDate) Then vntFilmDate = vntArrFilmDate
        If Not IsMissing(vntEntriedJudgement) Then vntEntriedJudgement = vntArrEntriedJudgement
        If Not IsMissing(vntEntriedJudgementM) Then vntEntriedJudgementM = vntArrEntriedJudgementM
        If Not IsMissing(vntVolunteer) Then vntVolunteer = vntArrVolunteer
        If Not IsMissing(vntVolunteerName) Then vntVolunteerName = vntArrVolunteerName
'## 2004.01.06 Add By T.Takagi@FSIT 予約群追加
        If Not IsMissing(vntRsvGrpName) Then vntRsvGrpName = vntArrRsvGrpName
'## 2004.01.06 Add End
'## 2016.08.12 張 自動判定処理実施有無追加 STR ##
        If Not IsMissing(vntMensetsuState) Then vntMensetsuState = vntArrMensetsuState
'## 2016.08.12 張 自動判定処理実施有無追加 END ##
        
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    SelectConsultListProgress = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectConsultListProgress = -1

    'イベントログ書き込み
    WriteErrorLog "Consult.SelectConsultListProgress"
    
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




'## 2003.11.18 Del Function by T.Takagi@FSIT
'
' 機能　　 : 指定条件の報告済み受診者一覧を取得
'
' 引数　　 : (In)     dtmStrCslDate       開始受診日
' 　　　　   (In)     dtmEndCslDate       終了受診日
' 　　　　   (In)     strCsCd             コースコード
' 　　　　   (Out)    vntRsvNo            予約番号
' 　　　　   (Out)    vntCslDate          受診日
' 　　　　   (Out)    vntReportPrintDate  成績書出力日
' 　　　　   (Out)    vntReportVersion    成績書版数
' 　　　　   (Out)    vntReportDocNo      文書番号
' 　　　　   (Out)    vntReportOrderNo    オーダ番号
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
'Public Function SelectConsultReported( _
'    ByVal dtmStrCslDate As Date, _
'    Optional ByVal dtmEndCslDate As Date = 0, _
'    Optional ByVal strCsCd As String = "", _
'    Optional ByRef vntRsvNo As Variant, _
'    Optional ByRef vntCslDate As Variant, _
'    Optional ByRef vntReportPrintDate As Variant, _
'    Optional ByRef vntReportVersion As Variant, _
'    Optional ByRef vntReportDocNo As Variant, _
'    Optional ByRef vntReportOrderNo As Variant _
') As Long
'
'    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
'    Dim objOraDyna              As OraDynaset       'ダイナセット
'    Dim strStmt                 As String           'SQLステートメント
'
'    Dim objFields               As OraFields        'フィールドオブジェクト
'    Dim objRsvNo                As OraField         '予約番号
'    Dim objCslDate              As OraField         '受診日
'    Dim objReportPrintDate      As OraField         '成績書出力日
'    Dim objReportVersion        As OraField         '成績書版数
'    Dim objReportDocNo          As OraField         '文書番号
'    Dim objReportOrderNo        As OraField         'オーダ番号
'
'    Dim vntArrRsvNo()           As Variant          '予約番号の配列
'    Dim vntArrCslDate()         As Variant          '受診日の配列
'    Dim vntArrReportPrintDate() As Variant          '成績書出力日の配列
'    Dim vntArrReportVersion()   As Variant          '成績書版数の配列
'    Dim vntArrReportDocNo()     As Variant          '文書番号の配列
'    Dim vntArrReportOrderNo()   As Variant          'オーダ番号の配列
'    Dim lngCount                As Long             'レコード数
'
'    'エラーハンドラの設定
'    On Error GoTo ErrorHandle
'
'    '初期処理
'    If Not IsMissing(vntRsvNo) Then
'        vntRsvNo = Empty
'    End If
'
'    If Not IsMissing(vntCslDate) Then
'        vntCslDate = Empty
'    End If
'
'    If Not IsMissing(vntReportPrintDate) Then
'        vntReportPrintDate = Empty
'    End If
'
'    If Not IsMissing(vntReportVersion) Then
'        vntReportVersion = Empty
'    End If
'
'    If Not IsMissing(vntReportDocNo) Then
'        vntReportDocNo = Empty
'    End If
'
'    If Not IsMissing(vntReportOrderNo) Then
'        vntReportOrderNo = Empty
'    End If
'
'    lngCount = 0
'
'    'キー値の設定
'    Set objOraParam = mobjOraDb.Parameters
'    objOraParam.Add "STRCSLDATE", dtmStrCslDate, ORAPARM_INPUT, ORATYPE_DATE
'    objOraParam.Add "ENDCSLDATE", IIf(dtmEndCslDate > 0, dtmEndCslDate, dtmStrCslDate), ORAPARM_INPUT, ORATYPE_DATE
'    objOraParam.Add "CSCD", strCsCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
'
'    '指定条件の報告済み受診者一覧を取得
'    strStmt = "SELECT RSVNO, CSLDATE, REPORTPRINTDATE,            " & vbLf & _
'              "       REPORTDOCNO, REPORTORDERNO                  " & vbLf & _
'              "  FROM CONSULT                                     " & vbLf & _
'              " WHERE CSLDATE BETWEEN :STRCSLDATE AND :ENDCSLDATE " & vbLf & _
'              "   AND REPORTPRINTDATE IS NOT NULL                 "
'
'    'コースコード指定時は条件節に追加
'    If strCsCd <> "" Then
'        strStmt = strStmt & vbLf & _
'              "   AND CSCD = :CSCD "
'    End If
'
'    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
'
'    '検索レコードが存在する場合
'    If Not objOraDyna.EOF Then
'
'        'オブジェクトの参照設定
'        Set objFields = objOraDyna.Fields
'        Set objRsvNo = objFields("RSVNO")
'        Set objCslDate = objFields("CSLDATE")
'        Set objReportPrintDate = objFields("RSVNO")
'        Set objReportVersion = objFields("REPORTPRINTDATE")
'        Set objReportDocNo = objFields("REPORTDOCNO")
'        Set objReportOrderNo = objFields("REPORTORDERNO")
'
'        'レコードの検索
'        Do Until objOraDyna.EOF
'
'            '配列形式で格納する
'            ReDim Preserve vntArrRsvNo(lngCount)
'            ReDim Preserve vntArrCslDate(lngCount)
'            ReDim Preserve vntArrReportPrintDate(lngCount)
'            ReDim Preserve vntArrReportVersion(lngCount)
'            ReDim Preserve vntArrReportDocNo(lngCount)
'            ReDim Preserve vntArrReportOrderNo(lngCount)
'            vntArrRsvNo(lngCount) = objRsvNo.Value
'            vntArrCslDate(lngCount) = objCslDate.Value
'            vntArrReportPrintDate(lngCount) = objReportPrintDate.Value
'            vntArrReportVersion(lngCount) = objReportVersion.Value & ""
'            vntArrReportDocNo(lngCount) = objReportDocNo.Value & ""
'            vntArrReportOrderNo(lngCount) = objReportOrderNo.Value & ""
'            lngCount = lngCount + 1
'
'            objOraDyna.MoveNext
'        Loop
'
'        '戻り値の設定
'        If Not IsMissing(vntRsvNo) Then
'            vntRsvNo = vntArrRsvNo
'        End If
'
'        If Not IsMissing(vntCslDate) Then
'            vntCslDate = vntArrCslDate
'        End If
'
'        If Not IsMissing(vntReportPrintDate) Then
'            vntReportPrintDate = vntArrReportPrintDate
'        End If
'
'        If Not IsMissing(vntReportVersion) Then
'            vntReportVersion = vntArrReportVersion
'        End If
'
'        If Not IsMissing(vntReportDocNo) Then
'            vntReportDocNo = vntArrReportDocNo
'        End If
'
'        If Not IsMissing(vntReportOrderNo) Then
'            vntReportOrderNo = vntArrReportOrderNo
'        End If
'
'    End If
'
'    'バインド変数の削除
'    Do Until objOraParam.Count <= 0
'        objOraParam.Remove (objOraParam.Count - 1)
'    Loop
'
'    '戻り値の設定
'    SelectConsultReported = lngCount
'
'    'トランザクションをコミット
'    mobjContext.SetComplete
'
'    Exit Function
'
'ErrorHandle:
'
'    SelectConsultReported = -1
'
'    'イベントログ書き込み
'    WriteErrorLog "Consult.SelectConsultReported"
'
'    'エラー発生時はトランザクションをアボートに設定
'    mobjContext.SetAbort
'
'    'エラーをもう一回引き起こす
'    Err.Raise Err.Number, Err.Source, Err.Description
'
'End Function

'
' 機能　　 : 検索予約番号の前後の予約番号および当日ＩＤを取得する
'
' 引数　　 : (In)     vntCslDate                    受診日
' 　　　　   (In)     vntCsCd  　                   コースコード
' 　　　　   (In)     vntSortKey  　                並び順
' 　　　　   (In)     vntCntlNo  　                 管理番号
' 　　　　   (In)     blnNeedUnReceiptConsult       未受付者取得フラグ
' 　　　　   (In)     blnBadJudgemnetOnly           異常判定所持者取得フラグ
' 　　　　   (In)     blnNotCompletedJudgemnetOnly  判定未完了者取得フラグ
' 　　　　   (In)     vntRsvNo  　                  予約番号
' 　　　　   (Out)    vntPrevRsvNo  　              前受診者予約番号
' 　　　　   (Out)    vntPrevDayId  　              前受診者当日ＩＤ
' 　　　　   (Out)    vntNextRsvNo  　              次受診者予約番号
' 　　　　   (Out)    vntNextDayId  　              次受診者当日ＩＤ
'## 2004.01.09 Add By T.Takagi@FSIT 来院関連追加
' 　　　　   (Out)    blnComeOnly                   True時は来院者のみ取得(このときblnNeedUnReceiptConsult値は無効)
'## 2004.01.09 Add End
'
' 戻り値　 :
'
' 備考　　 :
'
'## 2004.01.09 Mod By T.Takagi@FSIT 来院関連追加
'Public Sub SelectCurRsvNoPrevNext(
'    ByVal vntCslDate As Variant,
'    ByVal vntCsCd As Variant,
'    ByVal vntSortKey As Variant,
'    ByVal vntCntlNo As Variant,
'    ByVal blnNeedUnReceiptConsult As Boolean,
'    ByVal blnBadJudgemnetOnly As Boolean,
'    ByVal blnNotCompletedJudgemnetOnly As Boolean,
'    ByVal vntRsvNo As Variant,
'    ByRef vntPrevRsvNo As Variant,
'    ByRef vntPrevDayId As Variant,
'    ByRef vntNextRsvNo As Variant,
'    ByRef vntNextDayId As Variant
')
Public Sub SelectCurRsvNoPrevNext( _
    ByVal vntCslDate As Variant, _
    ByVal vntCsCd As Variant, _
    ByVal vntSortKey As Variant, _
    ByVal vntCntlNo As Variant, _
    ByVal blnNeedUnReceiptConsult As Boolean, _
    ByVal blnBadJudgemnetOnly As Boolean, _
    ByVal blnNotCompletedJudgemnetOnly As Boolean, _
    ByVal vntRsvNo As Variant, _
    ByRef vntPrevRsvNo As Variant, _
    ByRef vntPrevDayId As Variant, _
    ByRef vntNextRsvNo As Variant, _
    ByRef vntNextDayId As Variant, _
    Optional ByVal blnComeOnly As Boolean _
)
'## 2004.01.09 Mod End

    Dim vntArrRsvNo     As Variant  '予約番号の配列
    Dim vntArrDayId     As Variant  '当日ＩＤの配列
    Dim lngCount        As Long     'レコード数
    
    Dim i               As Long     'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    
    '管理番号のデフォルト値設定
    vntCntlNo = CLng("0" & vntCntlNo)
    
    vntPrevRsvNo = Empty
    vntPrevDayId = Empty
    vntNextRsvNo = Empty
    vntNextDayId = Empty
    
    '受診情報一覧の取得
'## 2004.01.09 Mod By T.Takagi@FSIT 来院関連追加
'    lngCount = SelectConsultList(vntCslDate, _
'                                 vntCntlNo, _
'                                 vntCsCd, , , , , , _
'                                 vntSortKey, _
'                                 blnNeedUnReceiptConsult, _
'                                 blnBadJudgemnetOnly, _
'                                 blnNotCompletedJudgemnetOnly, , _
'                                 vntArrRsvNo, _
'                                 vntArrDayId)
    lngCount = SelectConsultList(vntCslDate, _
                                 vntCntlNo, _
                                 vntCsCd, , , , , , _
                                 vntSortKey, _
                                 blnNeedUnReceiptConsult, _
                                 blnBadJudgemnetOnly, _
                                 blnNotCompletedJudgemnetOnly, , _
                                 vntArrRsvNo, _
                                 vntArrDayId, , , , , , , , , , , , , , , , , , , , , , blnComeOnly)
'## 2004.01.09 Mod End
    
    '受診情報を検索
    For i = 0 To lngCount - 1
    
        '引数指定された予約番号と一致する場合
        If CLng("0" & Trim(vntArrRsvNo(i))) = CLng("0" & Trim(vntRsvNo)) Then
        
            '前受診者の予約番号・当日ＩＤを取得する
            If i > 0 Then
                vntPrevRsvNo = vntArrRsvNo(i - 1)
                vntPrevDayId = vntArrDayId(i - 1)
            End If
            
            '次受診者の予約番号・当日ＩＤを取得する
            If i < lngCount - 1 Then
                vntNextRsvNo = vntArrRsvNo(i + 1)
                vntNextDayId = vntArrDayId(i + 1)
            End If
            
            Exit For
        End If
    Next i
            
    Exit Sub
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Consult.SelectCurRsvNoPrevNext"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Sub

'
' 機能　　 : 指定の予約番号に対する受診情報、個人情報を抽出
'
' 引数　　 : (In)     vntRsvNo            　 予約番号
' 　　　　 : (In)     strChkDate             受診年月日フラグ
' 　　　　 : (In)     strChkCsCd             コースコードフラグ
' 　　　　 : (In)     strChkOrgCd            受診時団体コードフラグ
' 　　　　 : (In)     strChkOrgBsdCd         受診時事業所コードフラグ
' 　　　　 : (In)     strChkOrgRoomCd        受診時室部コードフラグ
' 　　　　 : (In)     strChkOrgPostCd        受診時所属コードフラグ
' 　　　　 : (In)     strChkAge              受診時年齢フラグ
' 　　　　 : (In)     strChkEmpNo            従業員番号フラグ
' 　　　　 : (In)     strChkPerID            個人ＩＤフラグ
' 　　　　 : (In)     strChkName             氏名フラグ
' 　　　　 : (In)     strChkBirth            生年月日フラグ
' 　　　　 : (In)     strChkGender           性別フラグ
' 　　　　 : (In)     strChkPOrgCd           団体コードフラグ
' 　　　　 : (In)     strChkPOrgBsdCd        事業所コードフラグ
' 　　　　 : (In)     strChkPOrgRoomCd       室部コードフラグ
' 　　　　 : (In)     strChkPOrgPostCd       所属コードフラグ
' 　　　　 : (In)     strChkOverTime         超過勤務時間フラグ
'
' 戻り値　 : 抽出した項目の配列
'
' 備考　　 : 性別は名称に変換する
'
Private Function SelectDatCslPer(ByVal dtmStrDate As Date, ByVal dtmEndDate As Date, ByVal vntRsvNo As Variant, _
                                 ByVal strChkDate As String, ByVal strChkCSCD As String, _
                                 ByVal strChkOrgCd As String, ByVal strChkOrgBsdCd As String, _
                                 ByVal strChkOrgRoomCd As String, ByVal strChkOrgPostCd As String, _
                                 ByVal strChkAge As String, ByVal strChkEmpNo As String, _
                                 ByVal strChkPerID As String, ByVal strChkName As String, _
                                 ByVal strChkBirth As String, ByVal strChkGender As String, _
                                 ByVal strChkPOrgCd As String, ByVal strChkPOrgBsdCd As String, _
                                 ByVal strChkPOrgRoomCd As String, ByVal strChkPOrgPostCd As String, _
                                 ByVal strChkOverTime As String _
                                ) As Variant

    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objCslDate          As OraField         '受診年月日
    Dim objCsCd             As OraField         'コースコード
    Dim objOrgCd1           As OraField         '団体コード1
    Dim objOrgCd2           As OraField         '団体コード2
    Dim objAge              As OraField         '受診時年齢
    Dim objPerId            As OraField         '個人ＩＤ
    Dim objLastName         As OraField         '姓
    Dim objFirstName        As OraField         '名
    Dim objBirth            As OraField         '生年月日
    Dim objGender           As OraField         '性別(名称編集済み)
    Dim objOrgBsdCd         As OraField         '受診時事業所コード
    Dim objOrgRoomCd        As OraField         '受診時室部コード
    Dim objOrgPostCd        As OraField         '受診時所属コード
    Dim objOrgName          As OraField         '受診時団体名
    Dim objOrgBsdName       As OraField         '受診時事業所名
    Dim objOrgRoomName      As OraField         '受診時室部名
    Dim objOrgPostName      As OraField         '受診時所属名
    Dim objEmpNo            As OraField         '従業員番号
    Dim objPOrgCd1          As OraField         '団体コード1
    Dim objPOrgCd2          As OraField         '団体コード2
    Dim objPOrgBsdCd        As OraField         '事業所コード
    Dim objPOrgRoomCd       As OraField         '室部コード
    Dim objPOrgPostCd       As OraField         '所属コード
    Dim objPOrgName          As OraField        '団体名
    Dim objPOrgBsdName       As OraField        '事業所名
    Dim objPOrgRoomName      As OraField        '室部名
    Dim objPOrgPostName      As OraField        '所属名
    Dim objOverTime         As OraField         '超過勤務時間
    Dim objDataDate         As OraField         '超過勤務時間対象月

    Dim vntArrData()        As Variant          '受診情報、および個人情報用配列

    Dim lngCount            As Long             '抽出した項目数
    Dim i                   As Long             'インデックス
    Dim dtmBuf              As Date             '日付型バッファ
    Dim strBuf              As String           '文字型バッファ

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'OraParametersオブジェクトの参照
    Set objOraParam = mobjOraDb.Parameters
    
    'キー値の設定
    objOraParam.Add "RSVNO", vntRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "STRDATDATE", dtmStrDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDDATDATE", dtmEndDate, ORAPARM_INPUT, ORATYPE_DATE

    'SQL文の編集
'2004/3/31 FAS M,E
'    strStmt = ""
'    strStmt = strStmt & "SELECT CONSULT.CSLDATE, CONSULT.CSCD,                               " & vbLf
'    strStmt = strStmt & "       CONSULT.ORGCD1, CONSULT.ORGCD2,                              " & vbLf
'    strStmt = strStmt & "       CONSULT.ORGBSDCD, CONSULT.ORGROOMCD,                         " & vbLf
'    strStmt = strStmt & "       CONSULT.ORGPOSTCD, CONSULT.AGE,                              " & vbLf
'    strStmt = strStmt & "       PERSON.EMPNO, PERSON.PERID,                                  " & vbLf
'    strStmt = strStmt & "       PERSON.LASTNAME, PERSON.FIRSTNAME, PERSON.BIRTH,             " & vbLf
'    strStmt = strStmt & "       DECODE(PERSON.GENDER,'1','男性','2','女性',NULL) GENDERNAME, " & vbLf
'    strStmt = strStmt & "       PERSON.ORGCD1 PORGCD1 , PERSON.ORGCD2 PORGCD2,               " & vbLf
'    strStmt = strStmt & "       PERSON.ORGBSDCD PORGBSDCD, PERSON.ORGROOMCD PORGROOMCD,      " & vbLf
'    strStmt = strStmt & "       PERSON.ORGPOSTCD PORGPOSTCD,                                 " & vbLf
'    strStmt = strStmt & "       NVL(ORG.ORGNAME,'') ORGNAME, NVL(ORGBSD.ORGBSDNAME,'') ORGBSDNAME," & vbLf
'    strStmt = strStmt & "       NVL(ORGROOM.ORGROOMNAME,'') ORGROOMNAME,                     " & vbLf
'    strStmt = strStmt & "       NVL(ORGPOST.ORGPOSTNAME,'') ORGPOSTNAME,                     " & vbLf
'    strStmt = strStmt & "       NVL(P_ORG.ORGNAME,'') PORGNAME, NVL(P_ORGBSD.ORGBSDNAME,'') PORGBSDNAME," & vbLf
'    strStmt = strStmt & "       NVL(P_ORGROOM.ORGROOMNAME,'') PORGROOMNAME,                  " & vbLf
'    strStmt = strStmt & "       NVL(P_ORGPOST.ORGPOSTNAME,'') PORGPOSTNAME,                  " & vbLf
'    strStmt = strStmt & "       PERWORKINFO.DATADATE, NVL(PERWORKINFO.OVERTIME,0) OVERTIME   " & vbLf
'    strStmt = strStmt & "  FROM CONSULT, PERSON, ORG, ORGBSD, ORGROOM, ORGPOST,              " & vbLf
'    strStmt = strStmt & "       ORG P_ORG, ORGBSD P_ORGBSD, ORGROOM P_ORGROOM,               " & vbLf
'    strStmt = strStmt & "       ORGPOST P_ORGPOST, PERWORKINFO                               " & vbLf
'    strStmt = strStmt & " WHERE CONSULT.RSVNO = :RSVNO                                       " & vbLf
'    strStmt = strStmt & "   AND CONSULT.PERID = PERSON.PERID                                 " & vbLf
'    strStmt = strStmt & "   AND CONSULT.PERID = PERWORKINFO.PERID(+)                         " & vbLf
'    strStmt = strStmt & "   AND CONSULT.ORGCD1 = ORG.ORGCD1(+)                               " & vbLf
'    strStmt = strStmt & "   AND CONSULT.ORGCD2 = ORG.ORGCD2(+)                               " & vbLf
'    strStmt = strStmt & "   AND CONSULT.ORGCD1 = ORGBSD.ORGCD1(+)                            " & vbLf
'    strStmt = strStmt & "   AND CONSULT.ORGCD2 = ORGBSD.ORGCD2(+)                            " & vbLf
'    strStmt = strStmt & "   AND CONSULT.ORGBSDCD = ORGBSD.ORGBSDCD(+)                        " & vbLf
'    strStmt = strStmt & "   AND CONSULT.ORGCD1 = ORGROOM.ORGCD1(+)                           " & vbLf
'    strStmt = strStmt & "   AND CONSULT.ORGCD2 = ORGROOM.ORGCD2(+)                           " & vbLf
'    strStmt = strStmt & "   AND CONSULT.ORGBSDCD = ORGROOM.ORGBSDCD(+)                       " & vbLf
'    strStmt = strStmt & "   AND CONSULT.ORGROOMCD = ORGROOM.ORGROOMCD(+)                     " & vbLf
'    strStmt = strStmt & "   AND CONSULT.ORGCD1 = ORGPOST.ORGCD1(+)                           " & vbLf
'    strStmt = strStmt & "   AND CONSULT.ORGCD2 = ORGPOST.ORGCD2(+)                           " & vbLf
'    strStmt = strStmt & "   AND CONSULT.ORGBSDCD = ORGPOST.ORGBSDCD(+)                       " & vbLf
'    strStmt = strStmt & "   AND CONSULT.ORGROOMCD = ORGPOST.ORGROOMCD(+)                     " & vbLf
'    strStmt = strStmt & "   AND CONSULT.ORGPOSTCD = ORGPOST.ORGPOSTCD(+)                     " & vbLf
'    strStmt = strStmt & "   AND PERSON.ORGCD1 = P_ORG.ORGCD1(+)                              " & vbLf
'    strStmt = strStmt & "   AND PERSON.ORGCD2 = P_ORG.ORGCD2(+)                              " & vbLf
'    strStmt = strStmt & "   AND PERSON.ORGCD1 = P_ORGBSD.ORGCD1(+)                           " & vbLf
'    strStmt = strStmt & "   AND PERSON.ORGCD2 = P_ORGBSD.ORGCD2(+)                           " & vbLf
'    strStmt = strStmt & "   AND PERSON.ORGBSDCD = P_ORGBSD.ORGBSDCD(+)                       " & vbLf
'    strStmt = strStmt & "   AND PERSON.ORGCD1 = P_ORGROOM.ORGCD1(+)                          " & vbLf
'    strStmt = strStmt & "   AND PERSON.ORGCD2 = P_ORGROOM.ORGCD2(+)                          " & vbLf
'    strStmt = strStmt & "   AND PERSON.ORGBSDCD = P_ORGROOM.ORGBSDCD(+)                      " & vbLf
'    strStmt = strStmt & "   AND PERSON.ORGROOMCD = P_ORGROOM.ORGROOMCD(+)                    " & vbLf
'    strStmt = strStmt & "   AND PERSON.ORGCD1 = P_ORGPOST.ORGCD1(+)                          " & vbLf
'    strStmt = strStmt & "   AND PERSON.ORGCD2 = P_ORGPOST.ORGCD2(+)                          " & vbLf
'    strStmt = strStmt & "   AND PERSON.ORGBSDCD = P_ORGPOST.ORGBSDCD(+)                      " & vbLf
'    strStmt = strStmt & "   AND PERSON.ORGROOMCD = P_ORGPOST.ORGROOMCD(+)                    " & vbLf
'    strStmt = strStmt & "   AND PERSON.ORGPOSTCD = P_ORGPOST.ORGPOSTCD(+)                    " & vbLf
'    strStmt = strStmt & "   AND PERWORKINFO.DATADATE(+) BETWEEN :ENDDATDATE AND :STRDATDATE  " & vbLf
'    strStmt = strStmt & "ORDER BY DATADATE DESC                                              "

    strStmt = ""
    strStmt = strStmt & "SELECT CONSULT.CSLDATE, CONSULT.CSCD,                               " & vbLf
    strStmt = strStmt & "       CONSULT.ORGCD1, CONSULT.ORGCD2,CONSULT.AGE,                  " & vbLf
    strStmt = strStmt & "       CONSULT.EMPNO, PERSON.PERID,                                  " & vbLf
    strStmt = strStmt & "       PERSON.LASTNAME, PERSON.FIRSTNAME, PERSON.BIRTH,             " & vbLf
    strStmt = strStmt & "       DECODE(PERSON.GENDER,'1','男性','2','女性',NULL) GENDERNAME, " & vbLf
    strStmt = strStmt & "       CONSULT.ORGCD1 , CONSULT.ORGCD2 ,                            " & vbLf
    strStmt = strStmt & "       NVL(ORG.ORGNAME,'') ORGNAME                                  " & vbLf
    strStmt = strStmt & "  FROM CONSULT, PERSON, ORG                                         " & vbLf
    strStmt = strStmt & " WHERE CONSULT.RSVNO = :RSVNO                                       " & vbLf
    strStmt = strStmt & "   AND CONSULT.PERID = PERSON.PERID                                 " & vbLf
    strStmt = strStmt & "   AND CONSULT.ORGCD1 = ORG.ORGCD1(+)                               " & vbLf
    strStmt = strStmt & "   AND CONSULT.ORGCD2 = ORG.ORGCD2(+)                               " & vbLf
    strStmt = strStmt & "ORDER BY CONSULT.CSLDATE "
'2004/3/31 fas M,E

    '検索条件を満たすレコードを取得
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

'2004/3/31 FAS M,E
        'オブジェクトの参照設定
'        Set objFields = objOraDyna.Fields
'        Set objCslDate = objFields("CSLDATE")
'        Set objCsCd = objFields("CSCD")
'        Set objOrgCd1 = objFields("ORGCD1")
'        Set objOrgCd2 = objFields("ORGCD2")
'        Set objAge = objFields("AGE")
'        Set objPerId = objFields("PERID")
'        Set objLastName = objFields("LASTNAME")
'        Set objFirstName = objFields("FIRSTNAME")
'        Set objBirth = objFields("BIRTH")
'        Set objGender = objFields("GENDERNAME")
'        Set objOrgBsdCd = objFields("ORGBSDCD")
'        Set objOrgRoomCd = objFields("ORGROOMCD")
'        Set objOrgPostCd = objFields("ORGPOSTCD")
'        Set objOrgName = objFields("ORGNAME")
'        Set objOrgBsdName = objFields("ORGBSDNAME")
'        Set objOrgRoomName = objFields("ORGROOMNAME")
'        Set objOrgPostName = objFields("ORGPOSTNAME")
'        Set objEmpNo = objFields("EMPNO")
'        Set objPOrgCd1 = objFields("PORGCD1")
'        Set objPOrgCd2 = objFields("PORGCD2")
'        Set objPOrgBsdCd = objFields("PORGBSDCD")
'        Set objPOrgRoomCd = objFields("PORGROOMCD")
'        Set objPOrgPostCd = objFields("PORGPOSTCD")
'        Set objPOrgName = objFields("PORGNAME")
'        Set objPOrgBsdName = objFields("PORGBSDNAME")
'        Set objPOrgRoomName = objFields("PORGROOMNAME")
'        Set objPOrgPostName = objFields("PORGPOSTNAME")
'        Set objOverTime = objFields("OVERTIME")
'        Set objDataDate = objFields("DATADATE")

'        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCslDate = objFields("CSLDATE")
        Set objCsCd = objFields("CSCD")
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objAge = objFields("AGE")
        Set objPerId = objFields("PERID")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objBirth = objFields("BIRTH")
        Set objGender = objFields("GENDERNAME")
        Set objOrgName = objFields("ORGNAME")
        Set objEmpNo = objFields("EMPNO")
'        Set objOrgBsdCd = ""
'        Set objOrgRoomCd = ""
'        Set objOrgPostCd = ""
'        Set objOrgName = ""
'        Set objOrgBsdName = ""
'        Set objOrgRoomName = ""
'        Set objOrgPostName = ""
'        Set objPOrgCd1 = ""
'        Set objPOrgCd2 = ""
'        Set objPOrgBsdCd = ""
'        Set objPOrgRoomCd = ""
'        Set objPOrgPostCd = ""
'        Set objPOrgName = ""
'        Set objPOrgBsdName = ""
'        Set objPOrgRoomName = ""
'        Set objPOrgPostName = ""
'        Set objOverTime = ""
'        Set objDataDate = ""
'2004/3/31 FAS M,E

        '配列形式で格納する
        lngCount = 0
        '各フラグがチェックされていれば配列に格納
        If strChkDate <> "" Then
            ReDim Preserve vntArrData(lngCount)
            vntArrData(lngCount) = CStr(objCslDate.Value & "")
            lngCount = lngCount + 1
        End If
        If strChkCSCD <> "" Then
            ReDim Preserve vntArrData(lngCount)
            vntArrData(lngCount) = objCsCd.Value & ""
            lngCount = lngCount + 1
        End If
        If strChkOrgCd <> "" Then
            ReDim Preserve vntArrData(lngCount + 1)
            vntArrData(lngCount) = objOrgCd1.Value & "-" & objOrgCd2.Value & ""
            lngCount = lngCount + 1
        End If
'        If strChkOrgBsdCd <> "" Then
'            ReDim Preserve vntArrData(lngCount)
'            vntArrData(lngCount) = objOrgBsdCd.Value & ""
'            lngCount = lngCount + 1
'        End If
'        If strChkOrgRoomCd <> "" Then
'            ReDim Preserve vntArrData(lngCount)
'            vntArrData(lngCount) = objOrgRoomCd.Value & ""
'            lngCount = lngCount + 1
'        End If
'        If strChkOrgPostCd <> "" Then
'            ReDim Preserve vntArrData(lngCount)
'            vntArrData(lngCount) = objOrgPostCd.Value & ""
'            lngCount = lngCount + 1
'        End If
        If strChkOrgCd <> "" Then
            ReDim Preserve vntArrData(lngCount + 1)
            vntArrData(lngCount) = objOrgName.Value & ""
            lngCount = lngCount + 1
        End If
'        If strChkOrgBsdCd <> "" Then
'            ReDim Preserve vntArrData(lngCount)
'            vntArrData(lngCount) = objOrgBsdName.Value & ""
'            lngCount = lngCount + 1
'        End If
'        If strChkOrgRoomCd <> "" Then
'            ReDim Preserve vntArrData(lngCount)
'            vntArrData(lngCount) = objOrgRoomName.Value & ""
'            lngCount = lngCount + 1
'        End If
'        If strChkOrgPostCd <> "" Then
'            ReDim Preserve vntArrData(lngCount)
'            vntArrData(lngCount) = objOrgPostName.Value & ""
'            lngCount = lngCount + 1
'        End If
        If strChkAge <> "" Then
            ReDim Preserve vntArrData(lngCount)
            vntArrData(lngCount) = CStr(objAge.Value & "")
            lngCount = lngCount + 1
        End If
'        If strChkPOrgCd <> "" Then
'            ReDim Preserve vntArrData(lngCount + 1)
'            vntArrData(lngCount) = objPOrgCd1.Value & "-" & objPOrgCd2.Value & ""
'            lngCount = lngCount + 1
'        End If
'        If strChkPOrgBsdCd <> "" Then
'            ReDim Preserve vntArrData(lngCount)
'            vntArrData(lngCount) = objPOrgBsdCd.Value & ""
'            lngCount = lngCount + 1
'        End If
'        If strChkPOrgRoomCd <> "" Then
'            ReDim Preserve vntArrData(lngCount)
'            vntArrData(lngCount) = objPOrgRoomCd.Value & ""
'            lngCount = lngCount + 1
'        End If
'        If strChkPOrgPostCd <> "" Then
'            ReDim Preserve vntArrData(lngCount)
'            vntArrData(lngCount) = objPOrgPostCd.Value & ""
'            lngCount = lngCount + 1
'        End If
'        If strChkPOrgCd <> "" Then
'            ReDim Preserve vntArrData(lngCount + 1)
'            vntArrData(lngCount) = objPOrgName.Value & ""
'            lngCount = lngCount + 1
'        End If
'        If strChkPOrgBsdCd <> "" Then
'            ReDim Preserve vntArrData(lngCount)
'            vntArrData(lngCount) = objPOrgBsdName.Value & ""
'            lngCount = lngCount + 1
'        End If
'        If strChkPOrgRoomCd <> "" Then
'            ReDim Preserve vntArrData(lngCount)
'            vntArrData(lngCount) = objPOrgRoomName.Value & ""
'            lngCount = lngCount + 1
'        End If
'        If strChkPOrgPostCd <> "" Then
'            ReDim Preserve vntArrData(lngCount)
'            vntArrData(lngCount) = objPOrgPostName.Value & ""
'            lngCount = lngCount + 1
'        End If
        If strChkEmpNo <> "" Then
            ReDim Preserve vntArrData(lngCount)
            vntArrData(lngCount) = objEmpNo.Value & ""
            lngCount = lngCount + 1
        End If
        If strChkPerID <> "" Then
            ReDim Preserve vntArrData(lngCount)
            vntArrData(lngCount) = objPerId.Value & ""
            lngCount = lngCount + 1
        End If
        If strChkName <> "" Then
            ReDim Preserve vntArrData(lngCount + 1)
            vntArrData(lngCount) = objLastName.Value & ""
            lngCount = lngCount + 1
            vntArrData(lngCount) = objFirstName.Value & ""
            lngCount = lngCount + 1
        End If
        If strChkBirth <> "" Then
            ReDim Preserve vntArrData(lngCount)
            vntArrData(lngCount) = CStr(objBirth.Value & "")
            lngCount = lngCount + 1
        End If
        If strChkGender <> "" Then
            ReDim Preserve vntArrData(lngCount)
            vntArrData(lngCount) = objGender.Value & ""
            lngCount = lngCount + 1
        End If
'        If strChkOverTime <> "" Then
'            dtmBuf = dtmStrDate
'            Do Until dtmBuf < dtmEndDate
'                strBuf = "0"
'                If objOraDyna.EOF = False Then
'                    If objDataDate.Value = dtmBuf Then
'                        strBuf = CStr(objOverTime.Value)
'                        objOraDyna.MoveNext
'                    End If
'                End If
'                ReDim Preserve vntArrData(lngCount)
'                vntArrData(lngCount) = strBuf
'                lngCount = lngCount + 1
'                dtmBuf = DateAdd("m", -1, dtmBuf)
'            Loop
'        End If
    End If

    '戻り値の設定
    If lngCount > 0 Then
        SelectDatCslPer = vntArrData
    End If

    'バインド変数の削除
    objOraParam.Remove "RSVNO"
    objOraParam.Remove "STRDATDATE"
    objOraParam.Remove "ENDDATDATE"

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Consult.SelectDatCslPer"
    
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
' 機能　　 : 指定の予約番号に対する判定結果情報を抽出
'
' 引数　　 : (In)     vntRsvNo            予約番号
' 　　　　   (In)     lngJudAll           判定抽出方法(0:すべて、1:指定判定分類のみ)
' 　　　　   (In)     vntArrJudCondition  総合判定条件配列(条件未指定時:""、指定時は"CHECK")
' 　　　　   (In)     vntArrJudClassCd    判定分類コードの配列
' 　　　　   (In)     vntArrWeightFrom    判定用重み配列(FROM側)
' 　　　　   (In)     vntArrMarkFrom      判定コード(FROM側)範囲指定の配列
' 　　　　   (In)     vntArrWeightTo      判定用重み配列(TO側)
' 　　　　   (In)     vntArrMarkTo        判定コード(TO側)範囲指定の配列
'
' 戻り値　 : 抽出した項目の配列
'
' 備考　　 :
'
Private Function SelectDatJudRsl( _
    ByVal vntRsvNo As Variant, _
    ByVal lngJudAll As Long, _
    ByVal vntArrJudCondition As Variant, _
    ByVal vntArrJudClassCd As Variant, _
    ByVal vntArrWeightFrom As Variant, _
    ByVal vntArrMarkFrom As Variant, _
    ByVal vntArrWeightTo As Variant, _
    ByVal vntArrMarkTo As Variant _
) As Variant

    Const JUDCLASSROW           As Long = 3         '総合判定の1件あたりの出力項目数

    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント

    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objJudClassName         As OraField         '判定分類名称
    Dim objJudCd                As OraField         '判定コード
    Dim objJudSName             As OraField         '判定略称
    Dim objJudClassCd           As OraField         '判定分類コード
    Dim objWeight               As OraField         '判定重み

    Dim vntArrJudClassName()    As Variant          '判定分類名称の配列
    Dim vntArrJudCd()           As Variant          '判定コードの配列
    Dim vntArrJudSName()        As Variant          '判定略称の配列

    Dim vntArrData()            As Variant          '受診情報、および個人情報用配列

    Dim lngCount                As Long             'レコード数
    Dim i, j                    As Long             'インデックス

    Dim blnFind                 As Boolean          '抽出要否
    Dim lngPos                  As Long             '検索インデックス

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'OraParametersオブジェクトの参照
    Set objOraParam = mobjOraDb.Parameters
    'キー値の設定
    objOraParam.Add "RSVNO", vntRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER

    'SQL文の編集
    strStmt = "SELECT JUDRSL.JUDCLASSCD, JUDCLASS.JUDCLASSNAME, " & vbLf & _
              "       JUD.JUDCD, JUD.JUDSNAME, JUD.WEIGHT       " & vbLf & _
              "  FROM JUD, JUDCLASS, JUDRSL                     " & vbLf & _
              " WHERE JUDRSL.RSVNO      = :RSVNO                " & vbLf & _
              "   AND JUDRSL.JUDCLASSCD = JUDCLASS.JUDCLASSCD   " & vbLf & _
              "   AND JUDRSL.JUDCD      = JUD.JUDCD(+)          " & vbLf & _
              " ORDER BY JUDRSL.RSVNO, JUDRSL.JUDCLASSCD        "

    '検索条件を満たすレコードを取得
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objJudClassName = objFields("JUDCLASSNAME")
        Set objJudCd = objFields("JUDCD")
        Set objJudSName = objFields("JUDSNAME")
        Set objJudClassCd = objFields("JUDCLASSCD")
        Set objWeight = objFields("WEIGHT")

        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            
            '抽出要否の判定
            blnFind = False
            Do
                
                'すべて抽出する場合、以下の判定処理は行わない
                If lngJudAll = 0 Then
                    blnFind = True
                    Exit Do
                End If
                
                '絞込条件から同一判定分類を検索
                lngPos = -1
                For i = 0 To UBound(vntArrJudCondition)
                    If vntArrJudCondition(i) <> "" And vntArrJudClassCd(i) = objJudClassCd.Value & "" Then
                        lngPos = i
                        Exit For
                    End If
                Next i
                            
                '検索不能時は処理を抜ける
                If lngPos < 0 Then
                    Exit Do
                End If
                
                '判定結果の範囲指定
                Select Case True
            
                    'FROM側、TO側ともに指定されているとき
                    Case vntArrWeightFrom(lngPos) <> "" And vntArrWeightTo(lngPos) <> ""

                        '判定が存在しない場合は処理を抜ける
                        If objJudCd.Value & "" = "" Or objWeight.Value & "" = "" Then
                            Exit Do
                        End If

                        '判定が重み範囲を外れる場合は処理を抜ける
                        Select Case CLng("0" & objWeight.Value)
                            Case CLng("0" & vntArrWeightFrom(lngPos)) To CLng("0" & vntArrWeightTo(lngPos))
                            Case Else
                                Exit Do
                        End Select
                        
                    'FROM側にのみ指定されているとき
                    Case vntArrWeightFrom(lngPos) <> ""

                        '判定が存在しない場合は処理を抜ける
                        If objJudCd.Value & "" = "" Or objWeight.Value & "" = "" Then
                            Exit Do
                        End If

                        '判定が重み範囲を外れる場合は処理を抜ける
                        Select Case vntArrMarkFrom(lngPos)
                            Case OPTION_EQ
                                If CLng("0" & objWeight.Value) <> CLng("0" & vntArrWeightFrom(lngPos)) Then
                                    Exit Do
                                End If
                            Case OPTION_GE
                                If CLng("0" & objWeight.Value) < CLng("0" & vntArrWeightFrom(lngPos)) Then
                                    Exit Do
                                End If
                            Case OPTION_LE
                                If CLng("0" & objWeight.Value) > CLng("0" & vntArrWeightFrom(lngPos)) Then
                                    Exit Do
                                End If
                        End Select

                    'TO側にのみ指定されているとき
                    Case vntArrWeightTo(lngPos) <> ""

                        '判定が存在しない場合は処理を抜ける
                        If objJudCd.Value & "" = "" Or objWeight.Value & "" = "" Then
                            Exit Do
                        End If

                        '判定が重み範囲を外れる場合は処理を抜ける
                        Select Case vntArrMarkTo(lngPos)
                            Case OPTION_EQ
                                If CLng("0" & objWeight.Value) <> CLng("0" & vntArrWeightTo(lngPos)) Then
                                    Exit Do
                                End If
                            Case OPTION_GE
                                If CLng("0" & objWeight.Value) < CLng("0" & vntArrWeightTo(lngPos)) Then
                                    Exit Do
                                End If
                            Case OPTION_LE
                                If CLng("0" & objWeight.Value) > CLng("0" & vntArrWeightTo(lngPos)) Then
                                    Exit Do
                                End If
                        End Select

                    'いずれも指定されていない場合(無条件に対象とする)
                    Case Else

                End Select

                blnFind = True
                Exit Do
            Loop

            '抽出対象であれば
            If blnFind Then
            
                '配列宣言
                ReDim Preserve vntArrJudClassName(lngCount)
                ReDim Preserve vntArrJudCd(lngCount)
                ReDim Preserve vntArrJudSName(lngCount)
            
                'データ格納
                vntArrJudClassName(lngCount) = objJudClassName.Value & ""
                vntArrJudCd(lngCount) = objJudCd.Value & ""
                vntArrJudSName(lngCount) = objJudSName.Value & ""
                lngCount = lngCount + 1
                
            End If
            
            objOraDyna.MoveNext
        Loop

        If lngCount > 0 Then
            ReDim vntArrData(lngCount * JUDCLASSROW - 1)
            j = 0
            For i = 0 To lngCount - 1
                '戻り値用の配列に格納する
                vntArrData(j) = vntArrJudClassName(i)
                vntArrData(j + 1) = vntArrJudCd(i)
                vntArrData(j + 2) = vntArrJudSName(i)
                j = j + 3
            Next i
        End If

    End If

    '戻り値の設定
    If j > 0 Then
        SelectDatJudRsl = vntArrData
    End If

    'バインド変数の削除
    objOraParam.Remove "RSVNO"

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Consult.SelectDatJudRsl"
    
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
' 機能　　 : 指定の予約番号に対する検査結果情報を抽出
'
' 引数　　 : (In)     vntRsvNo            　予約番号
' 　　　　 : (In)     strOptResult          検査項目抽出モード
' 　　　　 : (In)     strChkOption          追加表示オプションフラグ
' 　　　　 : (In)     vntArrItemCdKey       検査項目コードの配列
' 　　　　 : (In)     vntArrSuffixKey       検査項目サフィックスの配列
' 　　　　 : (In)     vntArrRslValueFrom    検査結果(FROM側)の配列
' 　　　　 : (In)     vntArrRslMarkFrom     検査結果(FROM側)範囲指定の配列
' 　　　　 : (In)     vntArrRslValueTo      検査結果(TO側)の配列
' 　　　　 : (In)     vntArrRslMarkTo       検査結果(TO側)範囲指定の配列
' 　　　　 : (In)     vntArrRslCondition    検査結果条件配列(条件未指定時:""、指定時は結果タイプ)
' 　　　　 : (In)     vntArrSelItemCd       抽出指定の検査項目コード
' 　　　　 : (In)     vntArrSelSuffix       抽出指定の検査結果サフィックス
' 　　　　 : (Out)    vntRsvNoSkipFlg       検査結果による該当予約番号の処理スキップフラグ
' 　　　　 : (Out)    vntRecCount           抽出レコード件数
'
' 戻り値　 : 抽出した項目の配列
'
' 備考　　 :
'
Private Function SelectDatRsl(ByVal vntRsvNo As Variant, _
                              ByVal strOptResult As String, ByVal strChkOption As String, _
                              ByVal vntArrItemCdKey As Variant, ByVal vntArrSuffixKey As Variant, _
                              ByVal vntArrRslValueFrom As Variant, ByVal vntArrRslMarkFrom As Variant, _
                              ByVal vntArrRslValueTo As Variant, ByVal vntArrRslMarkTo As Variant, _
                              ByVal vntArrRslCondition As Variant, _
                              ByVal vntArrSelItemCd As Variant, ByVal vntArrSelSuffix As Variant, _
                              ByRef vntRsvNoSkipFlg As Variant, ByRef vntRecCount As Variant _
                             ) As Variant

    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント

    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objItemCd               As OraField         '検査項目コード
    Dim objSuffix               As OraField         'サフィックス
    Dim objItemName             As OraField         '検査項目名
    Dim objResult               As OraField         '検査結果
    Dim objResultType           As OraField         '結果タイプ(文章タイプチェックに使用)
    Dim objShortStc             As OraField         '文章
    Dim objRslCmtCd1            As OraField         '結果コメントコード1
    Dim objRslCmtName1          As OraField         '結果コメント名1
    Dim objRslCmtCd2            As OraField         '結果コメントコード2
    Dim objRslCmtName2          As OraField         '結果コメント名2
    Dim objStdFlg               As OraField         '正常値(基準値)フラグ

    Dim vntArrItemCd()          As Variant          '検査項目コード
    Dim vntArrSuffix()          As Variant          'サフィックス
    Dim vntArrItemName()        As Variant          '検査項目名
    Dim vntArrResult()          As Variant          '検査結果
    Dim vntArrShortStc()        As Variant          '文章
    Dim vntArrRslCmtCd1()       As Variant          '結果コメントコード1
    Dim vntArrRslCmtName1()     As Variant          '結果コメント名1
    Dim vntArrRslCmtCd2()       As Variant          '結果コメントコード2
    Dim vntArrRslCmtName2()     As Variant          '結果コメント名2
    Dim vntArrStdFlg()          As Variant          '正常値(基準値)フラグ

    Dim vntArrData()            As Variant          '受診情報、および個人情報用配列

    Dim blnCheckFlg             As Boolean          '条件チェック有無フラグ
    Dim blnCheckOKFlg           As Boolean          '条件チェックOKフラグ
    Dim blnNumericFlg           As Boolean          '数値･計算タイプフラグ
    Dim blnConditionFlg         As Boolean          '検査項目条件フラグ
    Dim vntRslValue             As Variant          '検査結果値
    Dim vntRslValueFrom         As Variant          '検査結果条件値(FROM側)
    Dim vntRslValueTo           As Variant          '検査結果条件値(TO側)
    Dim vntRsl                  As Variant          '検査結果条件値
    Dim vntRslMark              As Variant          '検査結果条件記号
    Dim strWorkItemCd           As String           '検査項目コード
    Dim strWorkSuffix           As String           'サフィックス
    Dim lngResultType           As Long             '結果タイプ
    Dim lngCount                As Long             'レコード数（予約番号絞込み時）
    Dim lngCount2               As Long             'レコード数（該当データ抽出時）
    Dim i, j                    As Long             'インデックス
    Dim lngColCnt               As Long             '列数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'OraParametersオブジェクトの参照
    Set objOraParam = mobjOraDb.Parameters
    'キー値の設定
    objOraParam.Add "RSVNO", vntRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER

    'スキップフラグのリセット
    vntRsvNoSkipFlg = True
    'レコード件数のリセット
    vntRecCount = 0

    Do
        '検査結果条件による予約番号の絞込み
        blnCheckOKFlg = True

        'SQL文の編集
        strStmt = "SELECT ITEMCD, SUFFIX, RESULT " & vbLf & _
                  "  FROM RSL                    " & vbLf & _
                  " WHERE RSVNO = :RSVNO         "

        '検索条件を満たすレコードを取得
        Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

        '検索レコードが存在する場合
        If Not objOraDyna.EOF Then

            'オブジェクトの参照設定
            Set objFields = objOraDyna.Fields
            Set objItemCd = objFields("ITEMCD")
            Set objSuffix = objFields("SUFFIX")
            Set objResult = objFields("RESULT")

            '配列形式で格納する
            lngCount = 0
            Do Until objOraDyna.EOF
                '配列宣言
                ReDim Preserve vntArrItemCd(lngCount)
                ReDim Preserve vntArrSuffix(lngCount)
                ReDim Preserve vntArrResult(lngCount)
                'データ格納
                vntArrItemCd(lngCount) = objItemCd.Value & ""
                vntArrSuffix(lngCount) = objSuffix.Value & ""
                vntArrResult(lngCount) = objResult.Value & ""
                lngCount = lngCount + 1
                objOraDyna.MoveNext
            Loop

            '検査条件のチェック
            For i = 0 To UBound(vntArrRslCondition)
                '条件設定されているとき、そうでなければ次の条件候補へ処理スキップ
                If vntArrRslCondition(i) <> "" Then
                    '検査項目の存在チェック
                    j = 0
                    blnCheckFlg = False
                    Do Until j > lngCount - 1
                        '検査項目が存在するときフラグを立て比較処理へ
                        If vntArrItemCdKey(i) = vntArrItemCd(j) And _
                           vntArrSuffixKey(i) = vntArrSuffix(j) Then
                            blnCheckFlg = True
                            Exit Do
                        End If
                        j = j + 1
                    Loop
                    '検査項目が存在し、かつ、検査項目値が存在するとき比較処理を、それ以外は抽出対象外
                    If blnCheckFlg And _
                       Not IsNull(vntArrResult(j)) And _
                       vntArrResult(j) <> "" Then
                        '条件タイプおよび検査結果値のセット
                        If vntArrRslCondition(i) = 0 Or vntArrRslCondition(i) = 5 Then
                            blnNumericFlg = True                    '数値・計算タイプ
                            vntRslValue = CDbl(vntArrResult(j))
                        Else
                            blnNumericFlg = False                   '上記以外のタイプ
                            vntRslValue = Trim(vntArrResult(j))
                        End If
                        '検査結果の範囲指定
                        If vntArrRslValueFrom(i) <> "" And vntArrRslValueTo(i) <> "" Then
                            'FROM側、TO側ともに指定されているとき
                            If blnNumericFlg Then
                                vntRslValueFrom = CDbl(vntArrRslValueFrom(i))
                            Else
                                vntRslValueFrom = Trim(vntArrRslValueFrom(i))
                            End If
                            If blnNumericFlg Then
                                vntRslValueTo = CDbl(vntArrRslValueTo(i))
                            Else
                                vntRslValueTo = Trim(vntArrRslValueTo(i))
                            End If
                            If vntRslValue < vntRslValueFrom Or vntRslValue > vntRslValueTo Then
                                blnCheckOKFlg = False               '条件チェックNG
                            End If
                        Else
                            'FROM側、TO側いずれかに指定されているとき
                            If vntArrRslValueFrom(i) <> "" Then
                                If blnNumericFlg Then
                                    vntRsl = CDbl(vntArrRslValueFrom(i))
                                Else
                                    vntRsl = Trim(vntArrRslValueFrom(i))
                                End If
                                vntRslMark = vntArrRslMarkFrom(i)
                            Else
                                If blnNumericFlg Then
                                    vntRsl = CDbl(vntArrRslValueTo(i))
                                Else
                                    vntRsl = Trim(vntArrRslValueTo(i))
                                End If
                                vntRslMark = vntArrRslMarkTo(i)
                            End If
                            Select Case vntRslMark
                                Case OPTION_EQ
                                    If vntRslValue <> vntRsl Then
                                        blnCheckOKFlg = False       '条件チェックNG
                                    End If
                                Case OPTION_GE
                                    If vntRslValue < vntRsl Then
                                        blnCheckOKFlg = False       '条件チェックNG
                                    End If
                                Case OPTION_LE
                                    If vntRslValue > vntRsl Then
                                        blnCheckOKFlg = False       '条件チェックNG
                                    End If
                            End Select
                        End If
                    Else
                        blnCheckOKFlg = False                       '条件チェックNG
                    End If
                End If
                '条件指定された検査項目が存在しないか、検査結果が指定条件に一致しないときチェック終了
                If Not blnCheckOKFlg Then
                    Exit For
                End If
            Next

        End If

        '検査結果条件を満たしていなければ以降の処理をスキップ
        If Not blnCheckOKFlg Then
            Exit Do
        End If

        '検査結果項目が抽出指定されているときデータ抽出
        If strOptResult <> CASE_NOTSELECT Then

            'SQL文の編集
            strStmt = "SELECT ITEMCD, SUFFIX, ITEMNAME, RESULT, RESULTTYPE, SHORTSTC,                   " & vbLf & _
                      "       RSLCMTCD1, RSLCMTNAME1, RSLCMTCD2, RSLCMTNAME2, STDFLG                    " & vbLf & _
                      "  FROM ( SELECT Q.ITEMCD, Q.SUFFIX, Q.ITEMNAME,                                  " & vbLf & _
                      "                Q.RESULT, Q.RESULTTYPE, S.SHORTSTC,                              " & vbLf & _
                      "                Q.RSLCMTCD1, Q.RSLCMTNAME1, Q.RSLCMTCD2, Q.RSLCMTNAME2,          " & vbLf & _
                      "                Q.STDFLG                                                         " & vbLf & _
                      "           FROM ( SELECT R.ITEMCD, R.SUFFIX, IC.ITEMNAME, R.RESULT,              " & vbLf & _
                      "                         IC.RESULTTYPE, IC.ITEMTYPE, IC.STCITEMCD,               " & vbLf & _
                      "                         R.RSLCMTCD1, RC1.RSLCMTNAME RSLCMTNAME1,                " & vbLf & _
                      "                         R.RSLCMTCD2, RC2.RSLCMTNAME RSLCMTNAME2,                " & vbLf & _
                      "                         SC.STDFLG                                               " & vbLf & _
                      "                    FROM RSL R, ITEM_C IC, RSLCMT RC1, RSLCMT RC2, STDVALUE_C SC " & vbLf & _
                      "                   WHERE R.RSVNO = :RSVNO                                        "

            '抽出すべき検査結果項目が指定されているとき
            If strOptResult = CASE_SELECT Then
                strStmt = strStmt & vbLf & _
                      "                     AND (                                                       "
                '配列個数分ループ
                blnConditionFlg = True
                For i = 0 To UBound(vntArrSelItemCd)
                    '検索キーを設定
                    strWorkItemCd = Replace(Trim(vntArrSelItemCd(i)), "'", "''")
                    strWorkSuffix = Replace(Trim(vntArrSelSuffix(i)), "'", "''")
                    '検査項目コードが存在するとき条件文を追加
                    If vntArrSelItemCd(i) <> "" And vntArrSelSuffix(i) <> "" Then
                        If blnConditionFlg Then
                            strStmt = strStmt & vbLf & _
                      "                          (R.ITEMCD = '" & strWorkItemCd & "' AND R.SUFFIX = '" & strWorkSuffix & "')"
                            blnConditionFlg = False
                        Else
                            strStmt = strStmt & vbLf & _
                      "                      OR  (R.ITEMCD = '" & strWorkItemCd & "' AND R.SUFFIX = '" & strWorkSuffix & "')"
                        End If
                    End If
                Next
                strStmt = strStmt & vbLf & _
                      "                         )                                                       "
            End If

            strStmt = strStmt & vbLf & _
                      "                     AND R.ITEMCD = IC.ITEMCD                                    " & vbLf & _
                      "                     AND R.SUFFIX = IC.SUFFIX                                    " & vbLf & _
                      "                     AND R.RSLCMTCD1 = RC1.RSLCMTCD(+)                           " & vbLf & _
                      "                     AND R.RSLCMTCD2 = RC2.RSLCMTCD(+)                           " & vbLf & _
                      "                     AND R.STDVALUECD = SC.STDVALUECD(+)                         " & vbLf & _
                      "                ) Q, SENTENCE S                                                  " & vbLf & _
                      "          WHERE Q.STCITEMCD = S.ITEMCD(+)                                        " & vbLf & _
                      "            AND Q.ITEMTYPE  = S.ITEMTYPE(+)                                      " & vbLf & _
                      "            AND Q.RESULT    = S.STCCD(+)                                         " & vbLf & _
                      "       )                                                                         " & vbLf & _
                      " ORDER BY ITEMCD, SUFFIX                                                         "

            '検索条件を満たすレコードを取得
            Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

            '検索レコードが存在する場合
            If Not objOraDyna.EOF Then

                'オブジェクトの参照設定
                Set objFields = objOraDyna.Fields
                Set objItemCd = objFields("ITEMCD")
                Set objSuffix = objFields("SUFFIX")
                Set objItemName = objFields("ITEMNAME")
                Set objResult = objFields("RESULT")
                Set objResultType = objFields("RESULTTYPE")
                Set objShortStc = objFields("SHORTSTC")
                Set objRslCmtCd1 = objFields("RSLCMTCD1")
                Set objRslCmtName1 = objFields("RSLCMTNAME1")
                Set objRslCmtCd2 = objFields("RSLCMTCD2")
                Set objRslCmtName2 = objFields("RSLCMTNAME2")
                Set objStdFlg = objFields("STDFLG")

                '配列形式で格納する
                lngCount2 = 0
                Do Until objOraDyna.EOF
                    '配列宣言
                    ReDim Preserve vntArrItemCd(lngCount2)
                    ReDim Preserve vntArrSuffix(lngCount2)
                    ReDim Preserve vntArrItemName(lngCount2)
                    ReDim Preserve vntArrResult(lngCount2)
                    ReDim Preserve vntArrShortStc(lngCount2)
                    ReDim Preserve vntArrRslCmtCd1(lngCount2)
                    ReDim Preserve vntArrRslCmtName1(lngCount2)
                    ReDim Preserve vntArrRslCmtCd2(lngCount2)
                    ReDim Preserve vntArrRslCmtName2(lngCount2)
                    ReDim Preserve vntArrStdFlg(lngCount2)
                    'データ格納
                    vntArrItemCd(lngCount2) = objItemCd.Value & ""
                    vntArrSuffix(lngCount2) = objSuffix.Value & ""
                    vntArrItemName(lngCount2) = objItemName.Value & ""
                    vntArrResult(lngCount2) = objResult.Value & ""
                    lngResultType = CLng(objResultType.Value & "")
                    If lngResultType = 4 Then
                        vntArrShortStc(lngCount2) = objShortStc.Value & ""   '結果タイプが文章なら文章をセット
                        vntArrResult(lngCount2) = objShortStc.Value & ""
                    Else
                        vntArrShortStc(lngCount2) = ""                       '文章以外なら空白をセット
                    End If
                    vntArrRslCmtCd1(lngCount2) = objRslCmtCd1.Value & ""
                    vntArrRslCmtName1(lngCount2) = objRslCmtName1.Value & ""
                    vntArrRslCmtCd2(lngCount2) = objRslCmtCd2.Value & ""
                    vntArrRslCmtName2(lngCount2) = objRslCmtName2.Value & ""
                    vntArrStdFlg(lngCount2) = objStdFlg.Value & ""
                    lngCount2 = lngCount2 + 1
                    objOraDyna.MoveNext
                Loop
                j = 0
                '１検査項目あたりの列数設定
                lngColCnt = 1
                '結果コメント抽出オプション選択？
                If strChkOption <> "" Then
                    lngColCnt = lngColCnt + 5
                End If
                If lngCount2 > 0 Then
                    '戻り値用の配列数確定
                    j = UBound(vntArrSelItemCd) + 1
                    j = (j * lngColCnt) - 1
                    ReDim vntArrData(j)
                End If
                For i = 0 To lngCount2 - 1
                    '検査項目の列位置を求める（列位置固定対応）
                    For j = LBound(vntArrSelItemCd) To UBound(vntArrSelItemCd)
                        If vntArrSelItemCd(j) = vntArrItemCd(i) And _
                           vntArrSelSuffix(j) = vntArrSuffix(i) Then
                            Exit For
                        End If
                    Next
                    If j <= UBound(vntArrSelItemCd) Then
                        j = j * lngColCnt
                        ReDim Preserve vntArrData(j)
                        vntArrData(j) = vntArrResult(i)
                        j = j + 1
                        If strChkOption <> "" Then
                            '結果コメント抽出オプションチェック時
                            ReDim Preserve vntArrData(j + 4)
                            vntArrData(j) = vntArrRslCmtCd1(i)
                            vntArrData(j + 1) = vntArrRslCmtName1(i)
                            vntArrData(j + 2) = vntArrRslCmtCd2(i)
                            vntArrData(j + 3) = vntArrRslCmtName2(i)
                            vntArrData(j + 4) = vntArrStdFlg(i)
                            j = j + 5
                        End If
                    End If
                Next
            End If
        End If

        '戻り値の設定
        vntRsvNoSkipFlg = False
        vntRecCount = lngCount2
        If j > 0 Then
            SelectDatRsl = vntArrData
        End If

        Exit Do
    Loop

    'バインド変数の削除
    objOraParam.Remove "RSVNO"

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Consult.SelectDatRsl"
    
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
' 機能　　 : 指定の汎用データ抽出条件に合致する予約番号、受診時年齢、性別のリストを抽出する
'
' 引数　　 : (In)     strStrDate            受診年月日(自)
' 　　　　 : (In)     strEndDate            受診年月日(至)
' 　　　　 : (In)     strCsCd               コースコード
' 　　　　 : (In)     strOrgCd1             団体コード1
' 　　　　 : (In)     strOrgCd2             団体コード2
' 　　　　 : (In)     strStrAge             受診時年齢(自)
' 　　　　 : (In)     strEndAge             受診時年齢(至)
' 　　　　 : (In)     lngGender             性別
' 　　　　 : (In)     vntArrItemCd          検査項目コードの配列
' 　　　　 : (In)     vntArrSuffix          検査項目サフィックスの配列
' 　　　　 : (In)     vntArrRslCondition    検査結果条件配列(条件未指定時:""、指定時は結果タイプ)
' 　　　　 : (In)     vntArrJudClassCd      判定分類コードの配列
' 　　　　 : (In)     vntArrWeightFrom      判定用重み(FROM側)の配列
' 　　　　 : (In)     vntArrMarkFrom        判定(FROM側)範囲指定の配列
' 　　　　 : (In)     vntArrWeightTo        判定用重み(TO側)の配列
' 　　　　 : (In)     vntArrMarkTo          判定(TO側)範囲指定の配列
' 　　　　 : (In)     vntArrJudCondition    総合判定条件配列(条件未指定時:""、指定時:"CHECK")
' 　　　　 : (In)     lngJudOperation       総合判定条件指定演算子(0:AND、1:OR)
'
' 戻り値　 : 抽出した予約番号リスト
'
' 備考　　 :
'
Private Function SelectDatRsvNoList(ByVal strStrDate As String, ByVal strEndDate As String, ByVal strCsCd As String, _
                                    ByVal strSubCsCd As String, ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, _
                                    ByVal strOrgBsdCd As String, ByVal strOrgRoomCd As String, _
                                    ByVal strOrgPostCd1 As String, ByVal strOrgPostCd2 As String, _
                                    ByVal strStrAge As String, ByVal strEndAge As String, ByVal lngGender As Long, _
                                    ByVal vntArrItemCd As Variant, ByVal vntArrSuffix As Variant, _
                                    ByVal vntArrRslCondition As Variant, _
                                    ByVal vntArrJudClassCd As Variant, _
                                    ByVal vntArrWeightFrom As Variant, ByVal vntArrMarkFrom As Variant, _
                                    ByVal vntArrWeightTo As Variant, ByVal vntArrMarkTo As Variant, _
                                    ByVal vntArrJudCondition As Variant, _
                                    ByVal lngJudOperation As Long _
                                   ) As Variant

    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objRsvNo            As OraField         '予約番号

    Dim objCommon           As Common           '共通クラス

    Dim vntArrRsvNo()       As Variant          '予約番号の配列

    Dim lngCount            As Long             'レコード数
    Dim i                   As Long             'インデックス

    Dim strOperation        As String           '演算子
    Dim blnOperation        As Boolean          '演算子指定有無
    Dim blnAdd              As Boolean          '追加フラグ

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'OraParametersオブジェクトの参照
    Set objOraParam = mobjOraDb.Parameters
    
    'キー値の設定
    objOraParam.Add "STRDATE", Trim(strStrDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDDATE", Trim(strEndDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "STRAGE", Trim(strStrAge), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ENDAGE", Trim(strEndAge), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CANCELFLG", CONSULT_USED, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "GENDER", lngGender, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DELFLG", DELFLG_USED, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SUBCSCD", Trim(strSubCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGBSDCD", Trim(strOrgBsdCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGROOMCD", Trim(strOrgRoomCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGPOSTCD1", Trim(strOrgPostCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGPOSTCD2", Trim(strOrgPostCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2

    'SQL文の編集
    strStmt = strStmt & "SELECT CONSULT.RSVNO                 " & vbLf
    strStmt = strStmt & "  FROM PERSON, CONSULT               " & vbLf
    
    'サブコースコード指定時
    If Trim(strSubCsCd) <> "" Then
        strStmt = strStmt & "      ,(                                                      " & vbLf
        strStmt = strStmt & "        SELECT CONSULT.RSVNO                                  " & vbLf
        strStmt = strStmt & "          FROM CONSULT, CONSULT_O, CTRPT_OPT                  " & vbLf
        strStmt = strStmt & "         WHERE  CONSULT.CSLDATE BETWEEN :STRDATE AND :ENDDATE " & vbLf
        strStmt = strStmt & "           AND  CONSULT.RSVNO         = CONSULT_O.RSVNO       " & vbLf
        strStmt = strStmt & "           AND  CONSULT_O.CTRPTCD     = CTRPT_OPT.CTRPTCD     " & vbLf
        strStmt = strStmt & "           AND  CONSULT_O.OPTCD       = CTRPT_OPT.OPTCD       " & vbLf
        strStmt = strStmt & "           AND  CONSULT_O.OPTBRANCHNO = CTRPT_OPT.OPTBRANCHNO " & vbLf
        strStmt = strStmt & "           AND  CTRPT_OPT.CSCD        = :SUBCSCD              " & vbLf
        strStmt = strStmt & "        GROUP BY CONSULT.RSVNO                                " & vbLf
        strStmt = strStmt & "       ) CONSULT_SUBCS                                        " & vbLf
    End If
    strStmt = strStmt & " WHERE CONSULT.CSLDATE   >= :STRDATE " & vbLf
    strStmt = strStmt & "   AND CONSULT.CSLDATE   <= :ENDDATE "

    'コースコード指定時
    If Trim(strCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "   AND CONSULT.CSCD       = :CSCD "
    End If

    'サブコースコード指定時
    If Trim(strSubCsCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "   AND CONSULT.RSVNO      = CONSULT_SUBCS.RSVNO "
    End If

    '団体コード指定時
    If Trim(strOrgCd1) <> "" Or Trim(strOrgCd2) <> "" Then
        strStmt = strStmt & vbLf & _
              "   AND CONSULT.ORGCD1     = :ORGCD1 " & vbLf & _
              "   AND CONSULT.ORGCD2     = :ORGCD2 "
    End If

    '事業所コード指定時
    If Trim(strOrgBsdCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "   AND CONSULT.ORGBSDCD   = :ORGBSDCD "
    End If
    '室部コード指定時
    If Trim(strOrgRoomCd) <> "" Then
        strStmt = strStmt & vbLf & _
              "   AND CONSULT.ORGROOMCD  = :ORGROOMCD "
    End If
    '所属コード指定時
    If Trim(strOrgPostCd1) <> "" Then
        strStmt = strStmt & vbLf & _
              "   AND CONSULT.ORGPOSTCD BETWEEN :ORGPOSTCD1 AND :ORGPOSTCD2 "
    End If
    
    '受診時年齢（範囲）
    strStmt = strStmt & vbLf & _
              "   AND CONSULT.AGE       >= :STRAGE " & vbLf & _
              "   AND CONSULT.AGE       <= :ENDAGE "

    'キャンセルフラグ(「使用中」)
    strStmt = strStmt & vbLf & _
              "   AND CONSULT.CANCELFLG  = :CANCELFLG "

    '受診情報と個人情報との結合
    strStmt = strStmt & vbLf & _
              "   AND CONSULT.PERID      = PERSON.PERID "

    '性別指定時
    If lngGender <> GENDER_BOTH Then
        strStmt = strStmt & vbLf & _
              "   AND PERSON.GENDER      = :GENDER "
    End If
    
    '削除フラグ(「使用中」)
    strStmt = strStmt & vbLf & _
              "   AND PERSON.DELFLG      = :DELFLG "

    '総合判定条件での絞込み
    blnOperation = False
    blnAdd = False
    For i = 0 To UBound(vntArrJudCondition)

        '絞込条件が設定されているとき
        If vntArrJudCondition(i) <> "" Then

            '初めて条件を追加する場合
            If Not blnOperation Then
                strStmt = strStmt & vbLf & "   AND ( "
                blnOperation = True
            End If

            '２つ目以降の条件に対しては演算子を指定
            strOperation = ""
            If blnAdd Then
                strOperation = IIf(lngJudOperation = 0, "AND", "OR")
            End If

            '条件文の追加
            strStmt = strStmt & vbLf & strOperation & " EXISTS ( SELECT JUDRSL.RSVNO                              " & vbLf & _
                                                      "            FROM JUD, JUDRSL                               " & vbLf & _
                                                      "           WHERE JUDRSL.RSVNO      = CONSULT.RSVNO         " & vbLf & _
                                                      "             AND JUDRSL.JUDCLASSCD = " & vntArrJudClassCd(i) & vbLf & _
                                                      "             AND JUDRSL.JUDCD      = JUD.JUDCD             "
            '判定結果の範囲指定
            
            'FROM側、TO側ともに指定されているとき
            If vntArrWeightFrom(i) <> "" And vntArrWeightTo(i) <> "" Then

                strStmt = strStmt & vbLf & " AND JUD.WEIGHT BETWEEN " & vntArrWeightFrom(i) & " AND " & vntArrWeightTo(i)

            'FROM側にのみ指定されているとき
            ElseIf vntArrWeightFrom(i) <> "" Then

                 Select Case vntArrMarkFrom(i)
                    Case OPTION_EQ
                        strStmt = strStmt & vbLf & " AND JUD.WEIGHT  = " & vntArrWeightFrom(i)
                    Case OPTION_GE
                        strStmt = strStmt & vbLf & " AND JUD.WEIGHT >= " & vntArrWeightFrom(i)
                    Case OPTION_LE
                        strStmt = strStmt & vbLf & " AND JUD.WEIGHT <= " & vntArrWeightFrom(i)
                End Select

            'TO側にのみ指定されているとき
            Else

                Select Case vntArrMarkTo(i)
                    Case OPTION_EQ
                        strStmt = strStmt & vbLf & " AND JUD.WEIGHT  = " & vntArrWeightTo(i)
                    Case OPTION_GE
                        strStmt = strStmt & vbLf & " AND JUD.WEIGHT >= " & vntArrWeightTo(i)
                    Case OPTION_LE
                        strStmt = strStmt & vbLf & " AND JUD.WEIGHT <= " & vntArrWeightTo(i)
                End Select

            End If

            strStmt = strStmt & vbLf & " ) "

            blnAdd = True
            
        End If

    Next i

    If blnOperation Then
        strStmt = strStmt & vbLf & " ) "
    End If

    '検査結果条件での絞込み
    For i = 0 To UBound(vntArrRslCondition)
        
        '絞込条件が設定されているとき
        If vntArrRslCondition(i) <> "" Then
            
            '条件文の追加
            strStmt = strStmt & vbLf & " AND EXISTS ( SELECT RSL.RSVNO                                                          " & vbLf & _
                                       "                FROM RSL                                                                " & vbLf & _
                                       "               WHERE RSL.RSVNO  = CONSULT.RSVNO                                         " & vbLf & _
                                       "                 AND RSL.ITEMCD = '" & Replace(Trim(vntArrItemCd(i)), "'", "''") & "'   " & vbLf & _
                                       "                 AND RSL.SUFFIX = '" & Replace(Trim(vntArrSuffix(i)), "'", "''") & "' ) "
        
        End If
    
    Next i

    'ORDER BY句の指定
    strStmt = strStmt & vbLf & _
              " ORDER BY CONSULT.CSLDATE, CONSULT.CSCD, CONSULT.ORGCD1, CONSULT.ORGCD2, CONSULT.PERID "

    '検索条件を満たすレコードを取得
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")

        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            '配列宣言
            ReDim Preserve vntArrRsvNo(lngCount)
            'データ格納
            vntArrRsvNo(lngCount) = CLng(objRsvNo.Value & "")
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

    End If

    '戻り値の設定
    If lngCount > 0 Then
        SelectDatRsvNoList = vntArrRsvNo
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
    WriteErrorLog "Consult.SelectDatRsvNoList"
    
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
' 機能　　 : 予約番号に合致する個人ＩＤ、受診日を取得する
'
' 引数　　 : (In)     strRsvNo        予約番号
' 　　　　 : (Out)    vntPerId        個人ＩＤ
' 　　　　 : (Out)    vntCslDate      受診日
' 　　　　 : (Out)    vntBefYear      受診日前日（年）
' 　　　　 : (Out)    vntBefMonth     受診日前日（月）
' 　　　　 : (Out)    vntBefDay       受診日前日（日）
'
' 戻り値　 : True   -   データあり
' 　　　　 : False  -   データなし
'
' 備考　　 :
'
Public Function SelectHistoryRsvNo(ByVal strRsvNo As String, _
                                   ByRef vntPerId As Variant, _
                                   ByRef vntCslDate As Variant, _
                                   ByRef vntBefYear As Variant, _
                                   ByRef vntBefMonth As Variant, _
                                   ByRef vntBefDay As Variant _
                                  ) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objPerId            As OraField         '個人ＩＤ
    Dim objBefDate          As OraField         '受診日前日
    Dim objCslDate          As OraField         '受診日

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    SelectHistoryRsvNo = False

    '個人ＩＤが設定されていない場合はエラー
    If IsEmpty(strRsvNo) Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", Trim(strRsvNo), ORAPARM_INPUT, ORATYPE_NUMBER

    '検索条件を満たす受診日情報を取得
    strStmt = "SELECT C.PERID, (C.CSLDATE - 1) BEFDATE, C.CSLDATE   " & vbLf & _
              "  FROM CONSULT C                                     " & vbLf & _
              " WHERE C.RSVNO = :RSVNO                              "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objPerId = objFields("PERID")
        Set objBefDate = objFields("BEFDATE")
        Set objCslDate = objFields("CSLDATE")

        vntPerId = objPerId.Value
        vntCslDate = objCslDate.Value
        vntBefYear = Year(objBefDate.Value)
        vntBefMonth = Month(objBefDate.Value)
        vntBefDay = Day(objBefDate.Value)

        SelectHistoryRsvNo = True

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
    WriteErrorLog "Consult.SelectHistoryRsvNo"
    
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

'## 2003.12.18 Add by T.Takagi@FSIT 他システム連携対応
'
' 機能      : 指定予約番号の受付情報を読む
'
' 引数　　 : (In)     lngRsvNo        予約番号
' 　　　　   (In)     blnLock         レコードロックを行うか
' 　　　　   (Out)    vntDayId        当日ＩＤ
' 　　　　   (Out)    vntUpdDate      更新日時
' 　　　　   (Out)    vntComeDate     来院日時
' 　　　　   (Out)    vntComeUser     来院処理者
' 　　　　   (Out)    vntOcrNo        ＯＣＲ番号
' 　　　　   (Out)    vntLockerKey    ロッカーキー
' 　　　　   (Out)    vntEditOcrDate  OCR内容確認修正日時
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectReceipt( _
    ByVal lngRsvNo As Long, _
    Optional ByVal blnLock As Boolean, _
    Optional ByRef vntDayId As Variant, _
    Optional ByRef vntUpdDate As Variant, _
    Optional ByRef vntComeDate As Variant, _
    Optional ByRef vntComeUser As Variant, _
    Optional ByRef vntOcrNo As Variant, _
    Optional ByRef vntLockerKey As Variant, _
    Optional ByRef vntEditOcrDate As Variant _
) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント

    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objDayId        As OraField         '当日ＩＤ
    Dim objUpdDate      As OraField         '更新日時
    Dim objComeDate     As OraField         '来院日時
    Dim objComeUser     As OraField         '来院処理者
    Dim objOcrNo        As OraField         'ＯＣＲ番号
    Dim objLockerKey    As OraField         'ロッカーキー
    Dim objEditOcrDate  As OraField         'OCR内容確認修正日時

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntDayId) Then vntDayId = Empty
    If Not IsMissing(vntUpdDate) Then vntUpdDate = Empty
    If Not IsMissing(vntComeDate) Then vntComeDate = Empty
    If Not IsMissing(vntComeUser) Then vntComeUser = Empty
    If Not IsMissing(vntOcrNo) Then vntOcrNo = Empty
    If Not IsMissing(vntLockerKey) Then vntLockerKey = Empty
    If Not IsMissing(vntEditOcrDate) Then vntEditOcrDate = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RPTRSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER 'UpdateWelcomeInfoのパラメータと重複しないための処理

    '受付情報の読み込み
    strStmt = "SELECT RECEIPT.DAYID,    RECEIPT.UPDDATE, RECEIPT.COMEDATE,  " & vbLf & _
              "       RECEIPT.COMEUSER, RECEIPT.OCRNO,   RECEIPT.LOCKERKEY, " & vbLf & _
              "       RECEIPT.EDITOCRDATE                                   " & vbLf & _
              "  FROM RECEIPT, CONSULT                                      " & vbLf & _
              " WHERE CONSULT.RSVNO   = :RPTRSVNO                           " & vbLf & _
              "   AND CONSULT.RSVNO   = RECEIPT.RSVNO                       " & vbLf & _
              "   AND CONSULT.CSLDATE = RECEIPT.CSLDATE                     "
              
    If blnLock Then
        strStmt = strStmt & vbLf & _
              "   FOR UPDATE "
    End If
    
    'SQL文の実行
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objDayId = objFields("DAYID")
        Set objUpdDate = objFields("UPDDATE")
        Set objComeDate = objFields("COMEDATE")
        Set objComeUser = objFields("COMEUSER")
        Set objOcrNo = objFields("OCRNO")
        Set objLockerKey = objFields("LOCKERKEY")
        Set objEditOcrDate = objFields("EDITOCRDATE")
    
        '戻り値の設定
        If Not IsMissing(vntDayId) Then vntDayId = objDayId.Value & ""
        If Not IsMissing(vntUpdDate) Then vntUpdDate = objUpdDate.Value & ""
        If Not IsMissing(vntComeDate) Then vntComeDate = objComeDate.Value & ""
        If Not IsMissing(vntComeUser) Then vntComeUser = objComeUser.Value & ""
        If Not IsMissing(vntOcrNo) Then vntOcrNo = objOcrNo.Value & ""
        If Not IsMissing(vntLockerKey) Then vntLockerKey = objLockerKey.Value & ""
        If Not IsMissing(vntEditOcrDate) Then vntEditOcrDate = objEditOcrDate.Value & ""

        Set objDayId = Nothing
        Set objUpdDate = Nothing
        Set objComeDate = Nothing
        Set objComeUser = Nothing
        Set objOcrNo = Nothing
        Set objLockerKey = Nothing
        Set objEditOcrDate = Nothing
        Set objFields = Nothing

        SelectReceipt = True
        
    End If

    Set objOraDyna = Nothing

    'バインド変数の削除
    objOraParam.Remove "RPTRSVNO"   'UpdateWelcomeInfoのパラメータと重複しないための処理

    Set objOraParam = Nothing

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    SelectReceipt = False

    'イベントログ書き込み
    WriteErrorLog "Consult.SelectReceipt"

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
' 機能　　 : 検索条件を満たす受診者の個人情報を取得する
'
' 引数　　 : (In)     vntRsvNo        予約番号
' 　　　　   (Out)    vntPerID        個人ＩＤ
' 　　　　   (Out)    vntCslDate      受診日
' 　　　　   (Out)    vntCsCd         コースコード
' 　　　　   (Out)    vntCsName       コース名
' 　　　　   (Out)    vntLastName     姓
' 　　　　   (Out)    vntFirstName  　名
' 　　　　   (Out)    vntLastKName    カナ姓
' 　　　　   (Out)    vntFirstKName 　カナ名
' 　　　　   (Out)    vntBirth        生年月日
' 　　　　   (Out)    vntAge          年齢
' 　　　　   (Out)    vntGender       性別
' 　　　　   (Out)    vntGenderName   性別名称
' 　　　　   (Out)    vntDayId        当日ＩＤ
' 　　　　   (Out)    vntDoctorCd     医師コード（省略可能）
' 　　　　   (Out)    vntDoctorName   医師名称（省略可能）
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectRslConsult(ByVal vntRsvNo As Variant, _
                                 ByRef vntPerId As Variant, _
                                 ByRef vntCslDate As Variant, _
                                 ByRef vntCsCd As Variant, _
                                 ByRef vntCsName As Variant, _
                                 ByRef vntLastName As Variant, _
                                 ByRef vntFirstName As Variant, _
                                 ByRef vntLastKName As Variant, _
                                 ByRef vntFirstKName As Variant, _
                                 ByRef vntBirth As Variant, _
                                 ByRef vntAge As Variant, _
                                 ByRef vntGender As Variant, _
                                 ByRef vntGenderName As Variant, _
                                 ByRef vntDayId As Variant, _
                                 Optional ByRef vntDoctorCd As Variant, _
                                 Optional ByRef vntDoctorName As Variant _
                                ) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna      As OraDynaset       'ダイナセット
    Dim strStmt         As String           'SQLステートメント

    Dim objFields       As OraFields        'フィールドオブジェクト
    Dim objRsvNo        As OraField         '予約番号
    Dim objPerId        As OraField         '個人ＩＤ
    Dim objCslDate      As OraField         '受診日
    Dim objCsCd         As OraField         'コースコード
    Dim objCsName       As OraField         'コース名
    Dim objLastName     As OraField         '姓
    Dim objFirstName    As OraField         '名
    Dim objLastKName    As OraField         'カナ姓
    Dim objFirstKName   As OraField         'カナ名
    Dim objBirth        As OraField         '生年月日
    Dim objAge          As OraField         '年齢
    Dim objGender       As OraField         '性別
    Dim objGenderName   As OraField         '性別名称
    Dim objDayId        As OraField         '当日ＩＤ
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'    Dim objDoctorCd     As OraField         '医師コード
'    Dim objDoctorName   As OraField         '医師名称
'## 2003.11.18 Del End

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '予約番号が設定されていない場合はエラー
    If IsEmpty(vntRsvNo) Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", Trim(vntRsvNo), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CANCELFLG", CStr(CONSULT_USED), ORAPARM_INPUT, ORATYPE_NUMBER

    '検索条件を満たす受診者情報のレコードを取得
'## 2003.11.18 Mod by T.Takagi@FSIT 不要項目削除
'    strStmt = "SELECT CN.RSVNO,     CN.PERID,       CN.CSLDATE,     CN.CSCD,        " & vbLf & _
'              "       CP.CSNAME,    P.LASTNAME,     P.FIRSTNAME,    P.LASTKNAME,    " & vbLf & _
'              "       P.FIRSTKNAME, P.BIRTH,        CN.AGE,         P.GENDER,       " & vbLf & _
'              "       DECODE(P.GENDER, '1', '男性', '2', '女性') D_GENDER,          " & vbLf & _
'              "       RC.DAYID,     CN.DOCTORCD,    HN.USERNAME                     " & vbLf & _
'              "  FROM CONSULT CN,  PERSON P, COURSE_P CP, RECEIPT RC, HAINSUSER HN  " & vbLf & _
'              " WHERE CN.RSVNO     = :RSVNO                                         " & vbLf & _
'              "   AND CN.CANCELFLG = :CANCELFLG                                     " & vbLf & _
'              "   AND CN.PERID     = P.PERID                                        " & vbLf & _
'              "   AND CN.CSCD      = CP.CSCD                                        " & vbLf & _
'              "   AND CN.RSVNO     = RC.RSVNO(+)                                    " & vbLf & _
'              "   AND CN.CSLDATE   = RC.CSLDATE(+)                                  " & vbLf & _
'              "   AND CN.DOCTORCD  = HN.USERID(+)                                   "
    strStmt = "SELECT CN.RSVNO,     CN.PERID,       CN.CSLDATE,     CN.CSCD,        " & vbLf & _
              "       CP.CSNAME,    P.LASTNAME,     P.FIRSTNAME,    P.LASTKNAME,    " & vbLf & _
              "       P.FIRSTKNAME, P.BIRTH,        CN.AGE,         P.GENDER,       " & vbLf & _
              "       DECODE(P.GENDER, '1', '男性', '2', '女性') D_GENDER,          " & vbLf & _
              "       RC.DAYID                                                      " & vbLf & _
              "  FROM CONSULT CN,  PERSON P, COURSE_P CP, RECEIPT RC                " & vbLf & _
              " WHERE CN.RSVNO     = :RSVNO                                         " & vbLf & _
              "   AND CN.CANCELFLG = :CANCELFLG                                     " & vbLf & _
              "   AND CN.PERID     = P.PERID                                        " & vbLf & _
              "   AND CN.CSCD      = CP.CSCD                                        " & vbLf & _
              "   AND CN.RSVNO     = RC.RSVNO(+)                                    " & vbLf & _
              "   AND CN.CSLDATE   = RC.CSLDATE(+)                                  "
'## 2003.11.18 Mod End

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields

        Set objRsvNo = objFields("RSVNO")
        Set objPerId = objFields("PERID")
        Set objCslDate = objFields("CSLDATE")
        Set objCsCd = objFields("CSCD")
        Set objCsName = objFields("CSNAME")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastKName = objFields("LASTKNAME")
        Set objFirstKName = objFields("FIRSTKNAME")
        Set objBirth = objFields("BIRTH")
        Set objAge = objFields("AGE")
        Set objGender = objFields("GENDER")
        Set objGenderName = objFields("D_GENDER")
        Set objDayId = objFields("DAYID")
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'        Set objDoctorCd = objFields("DOCTORCD")
'        Set objDoctorName = objFields("USERNAME")
'## 2003.11.18 Del End

        '戻り値の設定
        vntRsvNo = objRsvNo.Value & ""
        vntPerId = objPerId.Value & ""
        vntCslDate = objCslDate.Value & ""
        vntCsCd = objCsCd.Value & ""
        vntCsName = objCsName.Value & ""
        vntLastName = objLastName.Value & ""
        vntFirstName = objFirstName.Value & ""
        vntLastKName = objLastKName.Value & ""
        vntFirstKName = objFirstKName.Value & ""
        vntBirth = objBirth.Value & ""
        vntAge = Format(objAge.Value, "#0.00") & ""
        vntGender = objGender.Value & ""
        vntGenderName = objGenderName.Value & ""
        vntDayId = objDayId.Value & ""
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'        If Not IsMissing(vntDoctorCd) Then
'            vntDoctorCd = objDoctorCd.Value & ""
'        End If
'        If Not IsMissing(vntDoctorName) Then
'            vntDoctorName = objDoctorName.Value & ""
'        End If
'## 2003.11.18 Del End
        SelectRslConsult = True

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
    WriteErrorLog "Consult.SelectRslConsult"
    
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

'## 2003.11.18 Del by T.Takagi@FSIT 聖路加未対応メソッドのため削除
'
' 機能　　 : 指定予約番号の検体番号管理情報を取得する
'
' 引数　　 : (In)     lngRsvNo        予約番号
' 　　　　   (Out)    vntTestTubeNo   検体番号
' 　　　　   (Out)    vntSepOrderDiv  オーダ分割区分
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
'Public Function SelectTestTubeMng(ByVal lngRsvNo As Long, ByRef vntTestTubeNo As Variant, Optional ByRef vntSepOrderDiv As Variant) As Long
'
'    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
'    Dim objOraDyna          As OraDynaset       'ダイナセット
'    Dim strStmt             As String           'SQLステートメント
'
'    Dim objFields           As OraFields        'フィールドオブジェクト
'    Dim objTestTubeNo       As OraField         '検体番号
'    Dim objSepOrderDiv      As OraField         'オーダ分割区分
'
'    Dim vntArrTestTubeNo()  As Variant          '検体番号の配列
'    Dim vntArrSepOrderDiv() As Variant          'オーダ分割区分
'    Dim lngCount            As Long             'レコード数
'
'    'エラーハンドラの設定
'    On Error GoTo ErrorHandle
'
'    '初期処理
'    vntTestTubeNo = Empty
'    If Not IsMissing(vntSepOrderDiv) Then vntSepOrderDiv = Empty
'    lngCount = 0
'
'    'キー値の設定
'    Set objOraParam = mobjOraDb.Parameters
'    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
'
'    '指定予約番号の検体番号管理情報を取得する
'    strStmt = "SELECT TESTTUBENO, SEPORDERDIV FROM TESTTUBEMNG WHERE RSVNO = :RSVNO ORDER BY RSVNO, TESTTUBENO"
'
'    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
'
'    '検索レコードが存在する場合
'    If Not objOraDyna.EOF Then
'
'        'オブジェクトの参照設定
'        Set objFields = objOraDyna.Fields
'        Set objTestTubeNo = objFields("TESTTUBENO")
'        Set objSepOrderDiv = objFields("SEPORDERDIV")
'
'        '配列形式で格納する
'        Do Until objOraDyna.EOF
'            ReDim Preserve vntArrTestTubeNo(lngCount)
'            ReDim Preserve vntArrSepOrderDiv(lngCount)
'            vntArrTestTubeNo(lngCount) = objTestTubeNo.Value & ""
'            vntArrSepOrderDiv(lngCount) = objSepOrderDiv.Value & ""
'            lngCount = lngCount + 1
'            objOraDyna.MoveNext
'        Loop
'
'        '戻り値の設定
'        vntTestTubeNo = vntArrTestTubeNo
'        If Not IsMissing(vntSepOrderDiv) Then vntSepOrderDiv = vntArrSepOrderDiv
'
'    End If
'
'    'バインド変数の削除
'    Do Until objOraParam.Count <= 0
'        objOraParam.Remove (objOraParam.Count - 1)
'    Loop
'
'    '戻り値の設定
'    SelectTestTubeMng = lngCount
'
'    'トランザクションをコミット
'    mobjContext.SetComplete
'
'    Exit Function
'
'ErrorHandle:
'
'    SelectTestTubeMng = -1
'
'    'イベントログ書き込み
'    WriteErrorLog "Consult.SelectTestTubeMng"
'
'    'エラー発生時はトランザクションをアボートに設定
'    mobjContext.SetAbort
'
'    'エラーをもう一回引き起こす
'    Err.Raise Err.Number, Err.Source, Err.Description
'
'End Function

'
' 機能　　 : 検査項目名を抽出
'
' 引数　　 : (In)     vntArrSelItemCd       抽出指定の検査項目コード
' 　　　　 : (In)     vntArrSelSuffix       抽出指定の検査結果サフィックス
' 　　　　 : (Out)    vntRecCount           抽出レコード件数
'
' 戻り値　 : 抽出した項目の配列
'
' 備考　　 :
'
Private Function SelectHeadRsl(ByVal vntArrSelItemCd As Variant, ByVal vntArrSelSuffix As Variant, _
                               ByRef vntRecCount As Variant _
                              ) As Variant
 
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント

    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objItemCd               As OraField         '検査項目コード
    Dim objSuffix               As OraField         'サフィックス
    Dim objItemName             As OraField         '検査項目名
   
    Dim vntArrItemCd()          As Variant          '検査項目コード
    Dim vntArrSuffix()          As Variant          'サフィックス
    Dim vntArrItemName()        As Variant          '検査項目名

    Dim vntArrData()            As Variant          '受診情報、および個人情報用配列

    Dim lngCount                As Long             'レコード数（予約番号絞込み時）
    Dim lngCount2               As Long             'レコード数（該当データ抽出時）
    Dim i, j                    As Long             'インデックス
    Dim blnConditionFlg         As Boolean
    Dim strWorkItemCd           As String
    Dim strWorkSuffix           As String

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'レコード件数のリセット
    vntRecCount = 0

    'SQL文の編集
    strStmt = "SELECT ITEMCD, SUFFIX, ITEMNAME     " & vbLf & _
              "  FROM ITEM_C                       " & vbLf & _
              " WHERE (                            "
    '配列個数分ループ
    blnConditionFlg = True
    For i = 0 To UBound(vntArrSelItemCd)
        '検索キーを設定
        strWorkItemCd = Replace(Trim(vntArrSelItemCd(i)), "'", "''")
        strWorkSuffix = Replace(Trim(vntArrSelSuffix(i)), "'", "''")
        '検査項目コードが存在するとき条件文を追加
        If vntArrSelItemCd(i) <> "" And vntArrSelSuffix(i) <> "" Then
            If blnConditionFlg Then
                strStmt = strStmt & vbLf & _
          "                          (ITEMCD = '" & strWorkItemCd & "' AND SUFFIX = '" & strWorkSuffix & "')"
                blnConditionFlg = False
            Else
                strStmt = strStmt & vbLf & _
          "                      OR  (ITEMCD = '" & strWorkItemCd & "' AND SUFFIX = '" & strWorkSuffix & "')"
            End If
        End If
    Next
    strStmt = strStmt & vbLf & _
            "       )                      " & vbLf & _
            " ORDER BY ITEMCD, SUFFIX      "

    '検索条件を満たすレコードを取得
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objItemName = objFields("ITEMNAME")

        '配列形式で格納する
        lngCount2 = 0
        Do Until objOraDyna.EOF
            '配列宣言
            ReDim Preserve vntArrItemName(lngCount2)
            'データ格納
            vntArrItemName(lngCount2) = objItemName.Value & ""
            lngCount2 = lngCount2 + 1
            objOraDyna.MoveNext
        Loop
    End If

    '戻り値の設定
    vntRecCount = lngCount2
    If lngCount2 > 0 Then
        SelectHeadRsl = vntArrItemName
    End If

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Consult.SelectHeadRsl"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function
'
' 機能　　 : グループ９９９の検査項目を抽出
'
' 引数　　 : (Out)     vntArrSelItemCd       検査項目コード
' 　　　　 : (Out)     vntArrSelSuffix       サフィックス
'
' 戻り値　 : なし
'
' 備考　　 :
'
Private Sub SelectAllRslItem(ByRef vntArrItemCd As Variant, ByRef vntArrSuffix As Variant)
 
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント

    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objItemCd               As OraField         '検査項目コード
    Dim objSuffix               As OraField         'サフィックス
   
    Dim vntItemCd()             As Variant          '検査項目コード
    Dim vntSuffix()             As Variant          'サフィックス

    Dim lngCount                As Long             'レコード数（予約番号絞込み時）
    Dim i, j                    As Long             'インデックス

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    vntArrItemCd = Empty
    vntArrSuffix = Empty
    
    'SQL文の編集
    strStmt = ""
    strStmt = strStmt & "SELECT ITEMCD, SUFFIX    " & vbLf
    strStmt = strStmt & " From GRP_I              " & vbLf
    strStmt = strStmt & " WHERE GRPCD = '999'     " & vbLf
    strStmt = strStmt & " ORDER BY ITEMCD, SUFFIX "
    
    '検索条件を満たすレコードを取得
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objItemCd = objFields("ITEMCD")
        Set objSuffix = objFields("SUFFIX")

        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            '配列宣言
            ReDim Preserve vntItemCd(lngCount)
            ReDim Preserve vntSuffix(lngCount)
            'データ格納
            vntItemCd(lngCount) = objItemCd.Value & ""
            vntSuffix(lngCount) = objSuffix.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        vntArrItemCd = vntItemCd
        vntArrSuffix = vntSuffix
    
    End If

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Sub

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Consult.SelectAllRslItem"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Sub

'
' 機能　　 : 受診時追加検査項目テーブルの更新
'
' 引数　　 : (In)     lngRsvNo      予約番号
' 　　　　   (In)     strIpAddress  ＩＰアドレス
' 　　　　   (In)     strUpdUser    更新者
' 　　　　   (In)     vntItemCd     検査項目コード
' 　　　　   (In)     vntConsults   受診状態("1":受診、"0":未受診)
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function SetConsult_I(ByVal lngRsvNo As Long, ByVal strIpAddress As String, ByVal strUpdUser As String, ByRef vntItemCd As Variant, ByRef vntConsults As Variant) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント

    Dim objItemCd       As OraParamArray    '検査項目コード
    Dim objConsults     As OraParamArray    '受診状態
    
    Dim lngItemCount    As Long             '検査項目数
    Dim i               As Long             'インデックス
    
'## 2003.12.18 Add By T.Takagi@FSIT 他システム連携対応
    Dim Ret             As Long             '関数戻り値
    Dim vntMessage      As Variant          'メッセージ
'## 2003.12.18 Add End
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    If Not IsArray(vntItemCd) Then
        Exit Function
    End If
    
    '検査項目数の取得
    lngItemCount = UBound(vntItemCd) + 1
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "IPADDRESS", strIpAddress, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.AddTable "ITEMCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngItemCount, 6
    objOraParam.AddTable "CONSULTS", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngItemCount, 1
    
'## 2003.12.18 Add By T.Takagi@FSIT 他システム連携対応
    '戻り値のバインド変数定義
    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    objOraParam.Add "MESSAGE", "", ORAPARM_OUTPUT, ORATYPE_VARCHAR2
'## 2003.12.18 Add End
    
    'パラメータの参照設定
    Set objItemCd = objOraParam("ITEMCD")
    Set objConsults = objOraParam("CONSULTS")
    
    '配列数分の編集
    For i = 0 To UBound(vntItemCd)
        objItemCd(i) = CStr(vntItemCd(i))
        objConsults(i) = CStr(vntConsults(i))
    Next i
    
    '受診時追加検査項目テーブル更新用ストアドパッケージの関数呼び出し
'## 2003.12.18 Mod By T.Takagi@FSIT 他システム連携対応
'    strStmt = "BEGIN ConsultPackageLukes.SetDeleteConsultItem(:RSVNO, :IPADDRESS, :UPDUSER, :ITEMCD, :CONSULTS); END;"
    strStmt = "BEGIN :RET := ConsultPackageLukes.SetDeleteConsultItem(:RSVNO, :IPADDRESS, :UPDUSER, :ITEMCD, :CONSULTS, :MESSAGE); END;"
'## 2003.12.18 Mod End

    'PL/SQL文の実行
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
              
'## 2003.12.18 Add By T.Takagi@FSIT 他システム連携対応
    '戻り値の取得
    vntMessage = objOraParam("MESSAGE").Value & ""
    If vntMessage <> "" Then
        Err.Raise 1000, , vntMessage
    End If
'## 2003.12.18 Add End
              
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    SetConsult_I = True
    
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
    
    'イベントログ書き込み
    WriteErrorLog "Consult.SetConsult_I"
    
    SetConsult_I = False

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 指定予約番号範囲の受診情報に対する切り捨て処理
'
' 引数　　 : (In)     lngStrRsvNo  開始予約番号
' 　　　　   (In)     lngEndRsvNo  終了予約番号
' 　　　　   (In)     strUpdUser   更新者
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
'## 2004.01.03 Mod By T.Takagi@FSIT ログ対応
'Public Function TruncateConsult(ByVal lngStrRsvNo As Long, ByVal lngEndRsvNo As Long) As Boolean
Public Function TruncateConsult(ByVal lngStrRsvNo As Long, ByVal lngEndRsvNo As Long, ByVal strUpdUser As String) As Boolean
'## 2004.01.03 Mod End

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "STRRSVNO", lngStrRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ENDRSVNO", lngEndRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
'## 2004.01.03 Add By T.Takagi@FSIT ログ対応
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2004.01.03 Add End
    
    '指定予約番号範囲の受診情報に対する切り捨て処理
'## 2004.01.03 Mod By T.Takagi@FSIT ログ対応
'    mobjOraDb.ExecuteSQL "BEGIN ConsultAllPackage.TruncateConsult(:STRRSVNO, :ENDRSVNO); END;"
    mobjOraDb.ExecuteSQL "BEGIN ConsultAllPackage.TruncateConsult(:STRRSVNO, :ENDRSVNO, :UPDUSER); END;"
'## 2004.01.03 Mod End
    
    '戻り値の設定
    TruncateConsult = True
    
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

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'イベントログ書き込み
    WriteErrorLog "Consult.TruncateConsult"
    
    TruncateConsult = False

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 空白による文字列の分割
'
' 引数　　 : (In)     strExpression  文字列式
'
' 戻り値　 : 分割された文字列の配列
'
' 備考　　 : 通常のSplit関数では空白文字が複数並んだ場合に対応できないため作成
'
Private Function SplitByBlank(ByVal strExpression As String) As Variant

    Dim strBuffer   '変換処理後の文字列バッファ

    If Trim(strExpression) = "" Then
        SplitByBlank = Empty
        Exit Function
    End If

    '全角空白を半角空白に置換する
    strBuffer = Replace(Trim(strExpression), "　", " ")

    '2バイト以上の半角空白文字が存在しなくなるまで置換を繰り返す
    Do Until InStr(1, strBuffer, "  ") = 0
        strBuffer = Replace(strBuffer, "  ", " ")
    Loop

    '1バイト半角空白をデリミタとして配列を作成
    SplitByBlank = Split(strBuffer, " ")

End Function

'
' 機能　　 : 受診情報テーブルレコードを更新する
'
' 引数　　 : (In)     lngRsvNo           予約番号
' 　　　　   (In)     dtmCslDate         受診日
' 　　　　   (In)     strPerId           個人ＩＤ
' 　　　　   (In)     strCsCd            コースコード
' 　　　　   (In)     strOrgCd1          団体コード１
' 　　　　   (In)     strOrgCd2          団体コード２
' 　　　　   (In)     lngRsvGrpCd        予約群コード
' 　　　　   (In)     strAge             受診時年齢
' 　　　　   (In)     strUpdUser         更新者
' 　　　　   (In)     lngCtrPtCd         契約パターンコード
' 　　　　   (In)     strFirstRsvNo      １次健診予約番号
' 　　　　   (In)     strFreeDiv         フリー区分
' 　　　　   (In)     strFreeComment     フリーコメント
' 　　　　   (In)     strCslDivCd        受診区分コード
' 　　　　   (In)     lngRsvStatus       予約状況
' 　　　　   (In)     lngPrtOnSave       保存時印刷
' 　　　　   (In)     strCardAddrDiv     確認はがき宛先
' 　　　　   (In)     lngCardOutEng      確認はがき英文出力
' 　　　　   (In)     strFormAddrDiv     一式書式宛先
' 　　　　   (In)     lngFormOutEng      一式書式英文出力
' 　　　　   (In)     strReportAddrDiv   成績書宛先
' 　　　　   (In)     lngReportOurEng    成績書英文出力
' 　　　　   (In)     strVolunteer       ボランティア
' 　　　　   (In)     strVolunteerName   ボランティア名
' 　　　　   (In)     strCollectTicket   利用券回収
' 　　　　   (In)     lngIssueCslTicket  診察券発行
' 　　　　   (In)     strBillPrint       請求書出力
' 　　　　   (In)     strIsrSign         保険証記号
' 　　　　   (In)     strIsrNo           保険証番号
' 　　　　   (In)     strIsrManNo        保険者番号
' 　　　　   (In)     strEmpNo           社員番号
' 　　　　   (In)     strIntroductor     紹介者
' 　　　　   (In)     lngCurDayId        現在の当日ＩＤ
' 　　　　   (In)     vntOptCd           オプションコード
' 　　　　   (In)     vntOptBranchNo     オプション枝番
' 　　　　   (In)     lngMode            受付処理モード(0:受付しない、1:最終番号の次IDで受付、2:欠番を検索して発番、3:ID直接指定)
' 　　　　   (In)     lngDayId           当日ＩＤ(受付処理モード=3の場合のみ有効)
' 　　　　   (Out)    vntMessage         メッセージ
'            (In)     lngIgnoreFlg       予約枠無視フラグ
' 　　　　   (In)     strIpAddress       ＩＰアドレス
'## 2004.10.13 Mod By T.Takagi@FSIT 仮個人ＩＤ→実個人ＩＤ更新
' 　　　　   (In)     strCurrentPerId    読み込み直後の個人ＩＤ
'## 2004.10.13 Mod End
' 　　　　   (In)     strSendMailDiv     予約確認メール送信先
'
' 戻り値　 : 予約番号
'
' 備考　　 :
'
'#### 2013.3.1 SL-SN-Y0101-612 UPD START ####
''## 2004.10.13 Mod By T.Takagi@FSIT 仮個人ＩＤ→実個人ＩＤ更新
''Public Function UpdateConsult(
''    ByVal lngRsvNo As Long,
''    ByVal dtmCslDate As Date, ByVal strPerId As String,
''    ByVal strCsCd As String, ByVal strOrgCd1 As String,
''    ByVal strOrgCd2 As String, ByVal lngRsvGrpCd As Long,
''    ByVal strAge As String, ByVal strUpdUser As String,
''    ByVal lngCtrPtCd As Long, ByVal strFirstRsvNo As String,
''    ByVal strFreeDiv As String, ByVal strFreeComment As String,
''    ByVal strCslDivCd As String, ByVal lngRsvStatus As Long,
''    ByVal lngPrtOnSave As Long, ByVal strCardAddrDiv As String,
''    ByVal lngCardOutEng As Long, ByVal strFormAddrDiv As String,
''    ByVal lngFormOutEng As Long, ByVal strReportAddrDiv As String,
''    ByVal lngReportOurEng As Long, ByVal strVolunteer As String,
''    ByVal strVolunteerName As String, ByVal strCollectTicket As String,
''    ByVal lngIssueCslTicket As Long, ByVal strBillPrint As String,
''    ByVal strIsrSign As String, ByVal strIsrNo As String,
''    ByVal strIsrManNo As String, ByVal strEmpNo As String,
''    ByVal strIntroductor As String, ByVal lngCurDayId As Long,
''    ByRef vntOptCd As Variant, ByRef vntOptBranchNo As Variant,
''    ByVal lngMode As Long, ByVal lngDayId As Long,
''    ByRef vntMessage As Variant,
''    ByVal lngIgnoreFlg As Long,
''    ByVal strIpAddress As String
'') As Long
'Public Function UpdateConsult(
'    ByVal lngRsvNo As Long,
'    ByVal dtmCslDate As Date, ByVal strPerId As String,
'    ByVal strCsCd As String, ByVal strOrgCd1 As String,
'    ByVal strOrgCd2 As String, ByVal lngRsvGrpCd As Long,
'    ByVal strAge As String, ByVal strUpdUser As String,
'    ByVal lngCtrPtCd As Long, ByVal strFirstRsvNo As String,
'    ByVal strFreeDiv As String, ByVal strFreeComment As String,
'    ByVal strCslDivCd As String, ByVal lngRsvStatus As Long,
'    ByVal lngPrtOnSave As Long, ByVal strCardAddrDiv As String,
'    ByVal lngCardOutEng As Long, ByVal strFormAddrDiv As String,
'    ByVal lngFormOutEng As Long, ByVal strReportAddrDiv As String,
'    ByVal lngReportOurEng As Long, ByVal strVolunteer As String,
'    ByVal strVolunteerName As String, ByVal strCollectTicket As String,
'    ByVal lngIssueCslTicket As Long, ByVal strBillPrint As String,
'    ByVal strIsrSign As String, ByVal strIsrNo As String,
'    ByVal strIsrManNo As String, ByVal strEmpNo As String,
'    ByVal strIntroductor As String, ByVal lngCurDayId As Long,
'    ByRef vntOptCd As Variant, ByRef vntOptBranchNo As Variant,
'    ByVal lngMode As Long, ByVal lngDayId As Long,
'    ByRef vntMessage As Variant,
'    ByVal lngIgnoreFlg As Long,
'    ByVal strIpAddress As String,
'    Optional ByVal strCurrentPerId As String
') As Long
''## 2004.10.13 Mod End
Public Function UpdateConsult( _
    ByVal lngRsvNo As Long, _
    ByVal dtmCslDate As Date, ByVal strPerId As String, _
    ByVal strCsCd As String, ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, ByVal lngRsvGrpCd As Long, _
    ByVal strAge As String, ByVal strUpdUser As String, _
    ByVal lngCtrPtCd As Long, ByVal strFirstRsvNo As String, _
    ByVal strFreeDiv As String, ByVal strFreeComment As String, _
    ByVal strCslDivCd As String, ByVal lngRsvStatus As Long, _
    ByVal lngPrtOnSave As Long, ByVal strCardAddrDiv As String, _
    ByVal lngCardOutEng As Long, ByVal strFormAddrDiv As String, _
    ByVal lngFormOutEng As Long, ByVal strReportAddrDiv As String, _
    ByVal lngReportOurEng As Long, ByVal strVolunteer As String, _
    ByVal strVolunteerName As String, ByVal strCollectTicket As String, _
    ByVal lngIssueCslTicket As Long, ByVal strBillPrint As String, _
    ByVal strIsrSign As String, ByVal strIsrNo As String, _
    ByVal strIsrManNo As String, ByVal strEmpNo As String, _
    ByVal strIntroductor As String, ByVal lngCurDayId As Long, _
    ByRef vntOptCd As Variant, ByRef vntOptBranchNo As Variant, _
    ByVal lngMode As Long, ByVal lngDayId As Long, _
    ByRef vntMessage As Variant, _
    ByVal lngIgnoreFlg As Long, _
    ByVal strIpAddress As String, _
    Optional ByVal strCurrentPerId As String, Optional ByVal strSendMailDiv As String _
) As Long
'#### 2013.3.1 SL-SN-Y0101-612 UPD END   ####

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント

    Dim objOptCd        As OraParamArray    'オプションコード
    Dim objOptBranchNo  As OraParamArray    'オプション枝番

    Dim lngOptCount     As Long             'オプション検査数

    Dim lngArraySize    As Long             'オプション検査数
    Dim Ret             As Long             '関数戻り値
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'オプション数の取得
    lngOptCount = GetElementCount(vntOptCd)

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSCD", strCsCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RSVGRPCD", lngRsvGrpCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "AGE", strAge, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "FIRSTRSVNO", IIf(strFirstRsvNo <> "", CLng("0" & strFirstRsvNo), Null), ORAPARM_INPUT, ORATYPE_NUMBER
'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'    objOraParam.Add "FREEDIV", strFreeDiv, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "FREECOMMENT", StrConv(strFreeComment, vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2003.11.18 Del End
    objOraParam.Add "CSLDIVCD", strCslDivCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RSVSTATUS", lngRsvStatus, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "PRTONSAVE", lngPrtOnSave, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CARDADDRDIV", IIf(strCardAddrDiv <> "", CLng("0" & strCardAddrDiv), Null), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CARDOUTENG", lngCardOutEng, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "FORMADDRDIV", IIf(strFormAddrDiv <> "", CLng("0" & strFormAddrDiv), Null), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "FORMOUTENG", lngFormOutEng, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "REPORTADDRDIV", IIf(strReportAddrDiv <> "", CLng("0" & strReportAddrDiv), Null), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "REPORTOURENG", lngReportOurEng, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "VOLUNTEER", IIf(strVolunteer <> "", CLng("0" & strVolunteer), Null), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "VOLUNTEERNAME", StrConv(strVolunteerName, vbWide), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "COLLECTTICKET", IIf(strCollectTicket <> "", CLng("0" & strCollectTicket), Null), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ISSUECSLTICKET", lngIssueCslTicket, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BILLPRINT", IIf(strBillPrint <> "", CLng("0" & strBillPrint), Null), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ISRSIGN", strIsrSign, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ISRNO", strIsrNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ISRMANNO", strIsrManNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "EMPNO", strEmpNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "INTRODUCTOR", strIntroductor, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CURDAYID", lngCurDayId, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "MODE", lngMode, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DAYID", lngDayId, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "IGNOREFLG", lngIgnoreFlg, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "IPADDRESS", strIpAddress, ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2004.10.13 Add By T.Takagi@FSIT 仮個人ＩＤ→実個人ＩＤ更新
    objOraParam.Add "CURRENTPERID", strCurrentPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2004.10.13 Add End
'#### 2013.3.1 SL-SN-Y0101-612 ADD START ####
    objOraParam.Add "SENDMAILDIV", CLng("0" & Trim(strSendMailDiv)), ORAPARM_INPUT, ORATYPE_NUMBER
'#### 2013.3.1 SL-SN-Y0101-612 ADD END   ####
    
    'オプション検査のバインド変数定義
    lngArraySize = IIf(lngOptCount < 1, 1, lngOptCount)
    objOraParam.AddTable "OPTCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, 4
    objOraParam.AddTable "OPTBRANCHNO", ORAPARM_INPUT, ORATYPE_NUMBER, lngArraySize, 2
    objOraParam.Add "OPTCOUNT", lngOptCount, ORAPARM_INPUT, ORATYPE_NUMBER

    '戻り値のバインド変数定義
    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    objOraParam.Add "MESSAGE", "", ORAPARM_OUTPUT, ORATYPE_VARCHAR2

    'オブジェクトの参照設定
    Set objOptCd = objOraParam("OPTCD")
    Set objOptBranchNo = objOraParam("OPTBRANCHNO")

    'オプションコードの編集
    Do
        
        'オプションコードが存在しない場合は何もしない
        If lngOptCount <= 0 Or IsEmpty(vntOptCd) Then
            Exit Do
        End If
        
        '編集値が配列でない場合は添字の０番目に編集
        If Not IsArray(vntOptCd) Then
            objOptCd(0) = CStr(vntOptCd)
            objOptBranchNo(0) = CLng(vntOptBranchNo)
            Exit Do
        End If

        '配列数分の編集
        For i = 0 To UBound(vntOptCd)
            objOptCd(i) = CStr(vntOptCd(i))
            objOptBranchNo(i) = CLng(vntOptBranchNo(i))
        Next i
        
        Exit Do
    Loop

    '受診情報登録用ストアドパッケージの関数呼び出し
'#### 2013.3.1 SL-SN-Y0101-612 UPD START ####
''## 2003.11.18 Mod by T.Takagi@FSIT 不要項目削除
''    strStmt = "BEGIN                                                            " & vbLf & _
''              "    :RET := ConsultPackageLukes.UpdateConsult(                   " & vbLf & _
''              "                :RSVNO,                                          " & vbLf & _
''              "                :CSLDATE,        :PERID,         :CSCD,          " & vbLf & _
''              "                :ORGCD1,         :ORGCD2,        :RSVGRPCD,      " & vbLf & _
''              "                :AGE,            :UPDUSER,       :CTRPTCD,       " & vbLf & _
''              "                :FIRSTRSVNO,     :FREEDIV,       :FREECOMMENT,   " & vbLf & _
''              "                :CSLDIVCD,       :RSVSTATUS,     :PRTONSAVE,     " & vbLf & _
''              "                :CARDADDRDIV,    :CARDOUTENG,    :FORMADDRDIV,   " & vbLf & _
''              "                :FORMOUTENG,     :REPORTADDRDIV, :REPORTOURENG,  " & vbLf & _
''              "                :VOLUNTEER,      :VOLUNTEERNAME, :COLLECTTICKET, " & vbLf & _
''              "                :ISSUECSLTICKET, :BILLPRINT,     :ISRSIGN,       " & vbLf & _
''              "                :ISRNO,          :ISRMANNO,      :EMPNO,         " & vbLf & _
''              "                :INTRODUCTOR,    :CURDAYID,      :OPTCD,         " & vbLf & _
''              "                :OPTBRANCHNO,    :OPTCOUNT,      :MODE,          " & vbLf & _
''              "                :DAYID,          :MESSAGE,       :IGNOREFLG,     " & vbLf & _
''              "                :IPADDRESS                                       " & vbLf & _
''              "            );                                                   " & vbLf & _
''              "END;                                                             "
''## 2004.10.13 Mod By T.Takagi@FSIT 仮個人ＩＤ→実個人ＩＤ更新
''    strStmt = "BEGIN                                                            " & vbLf & _
''              "    :RET := ConsultPackageLukes.UpdateConsult(                   " & vbLf & _
''              "                :RSVNO,                                          " & vbLf & _
''              "                :CSLDATE,        :PERID,         :CSCD,          " & vbLf & _
''              "                :ORGCD1,         :ORGCD2,        :RSVGRPCD,      " & vbLf & _
''              "                :AGE,            :UPDUSER,       :CTRPTCD,       " & vbLf & _
''              "                :FIRSTRSVNO,                                     " & vbLf & _
''              "                :CSLDIVCD,       :RSVSTATUS,     :PRTONSAVE,     " & vbLf & _
''              "                :CARDADDRDIV,    :CARDOUTENG,    :FORMADDRDIV,   " & vbLf & _
''              "                :FORMOUTENG,     :REPORTADDRDIV, :REPORTOURENG,  " & vbLf & _
''              "                :VOLUNTEER,      :VOLUNTEERNAME, :COLLECTTICKET, " & vbLf & _
''              "                :ISSUECSLTICKET, :BILLPRINT,     :ISRSIGN,       " & vbLf & _
''              "                :ISRNO,          :ISRMANNO,      :EMPNO,         " & vbLf & _
''              "                :INTRODUCTOR,    :CURDAYID,      :OPTCD,         " & vbLf & _
''              "                :OPTBRANCHNO,    :OPTCOUNT,      :MODE,          " & vbLf & _
''              "                :DAYID,          :MESSAGE,       :IGNOREFLG,     " & vbLf & _
''              "                :IPADDRESS                                       " & vbLf & _
''              "            );                                                   " & vbLf & _
''              "END;                                                             "
'    strStmt = "BEGIN                                                            " & vbLf & _
'              "    :RET := ConsultPackageLukes.UpdateConsult(                   " & vbLf & _
'              "                :RSVNO,                                          " & vbLf & _
'              "                :CSLDATE,        :PERID,         :CSCD,          " & vbLf & _
'              "                :ORGCD1,         :ORGCD2,        :RSVGRPCD,      " & vbLf & _
'              "                :AGE,            :UPDUSER,       :CTRPTCD,       " & vbLf & _
'              "                :FIRSTRSVNO,                                     " & vbLf & _
'              "                :CSLDIVCD,       :RSVSTATUS,     :PRTONSAVE,     " & vbLf & _
'              "                :CARDADDRDIV,    :CARDOUTENG,    :FORMADDRDIV,   " & vbLf & _
'              "                :FORMOUTENG,     :REPORTADDRDIV, :REPORTOURENG,  " & vbLf & _
'              "                :VOLUNTEER,      :VOLUNTEERNAME, :COLLECTTICKET, " & vbLf & _
'              "                :ISSUECSLTICKET, :BILLPRINT,     :ISRSIGN,       " & vbLf & _
'              "                :ISRNO,          :ISRMANNO,      :EMPNO,         " & vbLf & _
'              "                :INTRODUCTOR,    :CURDAYID,      :OPTCD,         " & vbLf & _
'              "                :OPTBRANCHNO,    :OPTCOUNT,      :MODE,          " & vbLf & _
'              "                :DAYID,          :MESSAGE,       :IGNOREFLG,     " & vbLf & _
'              "                :IPADDRESS,      :CURRENTPERID                   " & vbLf & _
'              "            );                                                   " & vbLf & _
'              "END;                                                             "
''## 2004.10.13 Mod End
''## 2003.11.18 Mod End
    strStmt = "BEGIN                                                            " & vbLf & _
              "    :RET := ConsultPackageLukes.UpdateConsult(                   " & vbLf & _
              "                :RSVNO,                                          " & vbLf & _
              "                :CSLDATE,        :PERID,         :CSCD,          " & vbLf & _
              "                :ORGCD1,         :ORGCD2,        :RSVGRPCD,      " & vbLf & _
              "                :AGE,            :UPDUSER,       :CTRPTCD,       " & vbLf & _
              "                :FIRSTRSVNO,                                     " & vbLf & _
              "                :CSLDIVCD,       :RSVSTATUS,     :PRTONSAVE,     " & vbLf & _
              "                :CARDADDRDIV,    :CARDOUTENG,    :FORMADDRDIV,   " & vbLf & _
              "                :FORMOUTENG,     :REPORTADDRDIV, :REPORTOURENG,  " & vbLf & _
              "                :VOLUNTEER,      :VOLUNTEERNAME, :COLLECTTICKET, " & vbLf & _
              "                :ISSUECSLTICKET, :BILLPRINT,     :ISRSIGN,       " & vbLf & _
              "                :ISRNO,          :ISRMANNO,      :EMPNO,         " & vbLf & _
              "                :INTRODUCTOR,    :CURDAYID,      :OPTCD,         " & vbLf & _
              "                :OPTBRANCHNO,    :OPTCOUNT,      :MODE,          " & vbLf & _
              "                :DAYID,          :MESSAGE,       :IGNOREFLG,     " & vbLf & _
              "                :IPADDRESS,      :CURRENTPERID,  :SENDMAILDIV    " & vbLf & _
              "            );                                                   " & vbLf & _
              "END;                                                             "
'#### 2013.3.1 SL-SN-Y0101-612 UPD END   ####
    
    'PL/SQL文の実行
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    '戻り値の取得
    vntMessage = objOraParam("MESSAGE").Value & ""
    Ret = objOraParam("RET").Value

    'トランザクション制御
    If Ret > 0 Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If

    '戻り値の設定
    UpdateConsult = Ret

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Consult.UpdateConsult"
    
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

'## 2003.11.18 Del Function by T.Takagi@FSIT
'
' 機能　　 : 成績書文書番号・オーダ番号を更新する
'
' 引数　　 : (In)     lngRsvNo          予約番号
' 　　　　 : (In)     strReportDocNo    成績書文書番号
' 　　　　 : (In)     lngReportOrderNo  成績書オーダ番号
' 　　　　 : (In)     strUserId         ユーザーID
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
'Public Function UpdateConsultDocNo( _
'    ByVal lngRsvNo As Long, _
'    ByVal strReportDocNo As String, _
'    ByVal lngReportOrderNo As Long, _
'    ByVal strUserId As String _
') As Boolean
'
'    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
'    Dim strStmt         As String           'SQLステートメント
'
'    'エラーハンドラの設定
'    On Error GoTo ErrorHandle
'
'    'キー値及び更新値の設定
'    Set objOraParam = mobjOraDb.Parameters
'    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "REPORTDOCNO", Trim(strReportDocNo), ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "REPORTORDERNO", IIf(lngReportOrderNo > 0, lngReportOrderNo, Null), ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "USERID", Trim(strUserId), ORAPARM_INPUT, ORATYPE_VARCHAR2
'
'    '成績書文書番号・オーダ番号を更新する
'    strStmt = "UPDATE CONSULT                         " & vbLf & _
'              "   SET REPORTDOCNO   = :REPORTDOCNO,   " & vbLf & _
'              "       REPORTORDERNO = :REPORTORDERNO, " & vbLf & _
'              "       UPDDATE       = SYSDATE,        " & vbLf & _
'              "       UPDUSER       = :USERID         " & vbLf & _
'              " WHERE RSVNO         = :RSVNO          "
'
'    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
'
'    'バインド変数の削除
'    Do Until objOraParam.Count <= 0
'        objOraParam.Remove (objOraParam.Count - 1)
'    Loop
'
'    'トランザクションをコミット
'    mobjContext.SetComplete
'
'    '戻り値の設定
'    UpdateConsultDocNo = True
'
'    Exit Function
'
'ErrorHandle:
'
'    UpdateConsultDocNo = False
'
'    'イベントログ書き込み
'    WriteErrorLog "Consult.UpdateConsultDocNo"
'
'    'エラー発生時はトランザクションをアボートに設定
'    mobjContext.SetAbort
'
'    'エラーをもう一回引き起こす
'    Err.Raise Err.Number, Err.Source, Err.Description
'
'End Function

'## 2003.12.13 Add Function by T.Takagi@FSIT
'
' 機能　　 : 受診オプションテーブルレコードを更新する
'
' 引数　　 : (In)     lngRsvNo        予約番号
' 　　　　   (In)     lngCtrPtCd      契約パターンコード
' 　　　　   (In)     vntOptCd        オプションコード
' 　　　　   (In)     vntOptBranchNo  オプション枝番
' 　　　　   (In)     vntConsults     受診要否
' 　　　　   (In)     strIpAddress    ＩＰアドレス
' 　　　　   (In)     strUpdUser      更新者
'            (In)     lngIgnoreFlg    予約枠無視フラグ
' 　　　　   (Out)    vntMessage      メッセージ
'
' 戻り値　 : >0  正常終了
'
' 備考　　 :
'
Public Function UpdateConsult_O( _
    ByVal lngRsvNo As Long, _
    ByVal lngCtrPtCd As Long, _
    ByRef vntOptCd As Variant, _
    ByRef vntOptBranchNo As Variant, _
    ByRef vntConsults As Variant, _
    ByVal strIpAddress As String, _
    ByVal strUpdUser As String, _
    ByVal lngIgnoreFlg As Long, _
    ByRef vntMessage As Variant _
) As Long

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント

    Dim objOptCd        As OraParamArray    'オプションコード
    Dim objOptBranchNo  As OraParamArray    'オプション枝番
    Dim objConsults     As OraParamArray    '受診要否

    Dim lngOptCount     As Long             'オプション検査数

    Dim lngArraySize    As Long             'オプション検査数
    Dim Ret             As Long             '関数戻り値
    Dim i               As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CTRPTCD", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "IPADDRESS", strIpAddress, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "IGNOREFLG", lngIgnoreFlg, ORAPARM_INPUT, ORATYPE_NUMBER
    
    'オプション検査のバインド変数定義
    lngArraySize = UBound(vntOptCd) + 1
    objOraParam.AddTable "OPTCD", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, 4
    objOraParam.AddTable "OPTBRANCHNO", ORAPARM_INPUT, ORATYPE_NUMBER, lngArraySize, 2
    objOraParam.AddTable "CONSULTS", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, 1

    '戻り値のバインド変数定義
    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    objOraParam.Add "MESSAGE", "", ORAPARM_OUTPUT, ORATYPE_VARCHAR2

    'オブジェクトの参照設定
    Set objOptCd = objOraParam("OPTCD")
    Set objOptBranchNo = objOraParam("OPTBRANCHNO")
    Set objConsults = objOraParam("CONSULTS")

    '配列数分の編集
    For i = 0 To UBound(vntOptCd)
        objOptCd(i) = CStr(vntOptCd(i))
        objOptBranchNo(i) = CLng(vntOptBranchNo(i))
        objConsults(i) = CStr(vntConsults(i))
    Next i

    '受診情報登録用ストアドパッケージの関数呼び出し
    strStmt = "BEGIN                                            " & vbLf & _
              "    :RET := ConsultPackageLukes.UpdateConsult_O( " & vbLf & _
              "                :RSVNO,                          " & vbLf & _
              "                :CTRPTCD,                        " & vbLf & _
              "                :OPTCD,                          " & vbLf & _
              "                :OPTBRANCHNO,                    " & vbLf & _
              "                :CONSULTS,                       " & vbLf & _
              "                :IPADDRESS,                      " & vbLf & _
              "                :UPDUSER,                        " & vbLf & _
              "                :IGNOREFLG,                      " & vbLf & _
              "                :MESSAGE                         " & vbLf & _
              "            );                                   " & vbLf & _
              "END;                                             "
    
    'PL/SQL文の実行
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    '戻り値の取得
    vntMessage = objOraParam("MESSAGE").Value & ""
    Ret = objOraParam("RET").Value

    'トランザクション制御
    If Ret > 0 Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If

    '戻り値の設定
    UpdateConsult_O = Ret

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Consult.UpdateConsult_O"
    
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
' 機能　　 : 受診情報テーブルの事業部～所属までを、現在の個人テーブル情報で更新する。
'
' 引数　　 : (In)     strUserId         ユーザID
' 　　　　 : (In)     dtmStrDate        開始受診日
' 　　　　 : (In)     dtmEndDate        終了受診日
' 　　　　 : (In)     strOrgCd1         団体コード１
' 　　　　 : (In)     strOrgCd2         団体コード２
' 　　　　 : (In)     strCsCd           コースコード
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function UpdateConsultBsd(ByVal strUserId As String, _
                                 ByVal dtmStrDate As Date, _
                                 ByVal dtmEndDate As Date, _
                                 ByVal strOrgCd1 As String, _
                                 ByVal strOrgCd2 As String, _
                                 Optional ByVal vntCsCd As Variant _
                                ) As Boolean

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー値及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "USERID", Trim(strUserId), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "STRDATE", CDate(dtmStrDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDDATE", CDate(dtmEndDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    If IsMissing(vntCsCd) = False Then
        If Trim(vntCsCd) <> "" Then
            objOraParam.Add "CSCD", Trim(vntCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
        End If
    End If
    
    '個人情報テーブルの事業部、室部、所属で更新する。
    strStmt = "UPDATE CONSULT                                                                 " & vbLf & _
              "   SET ( ORGBSDCD, ORGROOMCD, ORGPOSTCD, UPDUSER, UPDDATE ) =                  " & vbLf & _
              "       ( SELECT ORGBSDCD, ORGROOMCD, ORGPOSTCD, :USERID, SYSDATE               " & vbLf & _
              "           FROM PERSON                                                         " & vbLf & _
              "          WHERE PERSON.PERID  = CONSULT.PERID                                  " & vbLf & _
              "            AND PERSON.ORGCD1 = :ORGCD1                                        " & vbLf & _
              "            AND PERSON.ORGCD2 = :ORGCD2                                        " & vbLf & _
              "       )                                                                       " & vbLf & _
              " WHERE CONSULT.CSLDATE BETWEEN :STRDATE AND :ENDDATE                           " & vbLf & _
              "   AND CONSULT.ORGCD1 = :ORGCD1                                                " & vbLf & _
              "   AND CONSULT.ORGCD2 = :ORGCD2                                                " & vbLf
    
    'コースの指定があるなら、検索条件追加
    If IsMissing(vntCsCd) = False Then
        If Trim(vntCsCd) <> "" Then
        strStmt = strStmt & _
                  "   AND CONSULT.CSCD   = :CSCD                                              " & vbLf
        End If
    End If
    
    '個人テーブルの団体コードなどくどい程設定しているが、契約の不整合を最も恐れるため、団体は絶対に合致させる。
    strStmt = strStmt & _
              "   AND CONSULT.PERID IN ( SELECT DISTINCT CONSULT.PERID                        " & vbLf & _
              "                            FROM PERSON, CONSULT                               " & vbLf & _
              "                           WHERE CONSULT.CSLDATE BETWEEN :STRDATE AND :ENDDATE " & vbLf & _
              "                             AND CONSULT.ORGCD1 = :ORGCD1                      " & vbLf & _
              "                             AND CONSULT.ORGCD2 = :ORGCD2                      " & vbLf & _
              "                             AND PERSON.PERID   = CONSULT.PERID                " & vbLf & _
              "                             AND PERSON.ORGCD1  = :ORGCD1                      " & vbLf & _
              "                             AND PERSON.ORGCD2  = :ORGCD2 )                    "
    

    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete

    '戻り値の設定
    UpdateConsultBsd = True
    
    Exit Function

ErrorHandle:

    UpdateConsultBsd = False
    
    'イベントログ書き込み
    WriteErrorLog "Consult.UpdateConsultBsd"
    
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
' 機能　　 : 判定医コードを更新する
'
' 引数　　 : (In)     strRsvNo        予約番号
' 　　　　 : (In)     strDoctorCd     判定医コード
' 　　　　 : (In)     strUserId       ログインユーザーＩＤ
'
' 戻り値　 : True  - 正常終了
' 　　　　 : False - 異常終了
'
' 備考　　 :
'
Public Function UpdateConsultDoctor(ByVal strRsvNo As String, ByVal strDoctorCd As String, ByVal strUserId As String) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim strStmt             As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '予約番号が設定されていない場合はエラー
    If IsEmpty(strRsvNo) Then
        Err.Raise 5 '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", Trim(strRsvNo), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DOCTORCD", Trim(strDoctorCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "USERID", Trim(strUserId), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '検索条件を満たす受診歴情報のレコードを取得
    strStmt = "UPDATE CONSULT               " & vbLf & _
              "   SET DOCTORCD = :DOCTORCD, " & vbLf & _
              "       UPDDATE  = SYSDATE,   " & vbLf & _
              "       UPDUSER  = :USERID    " & vbLf & _
              " WHERE RSVNO = :RSVNO        "

    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete

    '戻り値の設定
    UpdateConsultDoctor = True
    
    Exit Function

ErrorHandle:

    UpdateConsultDoctor = False
    
    'イベントログ書き込み
    WriteErrorLog "Consult.UpdateConsultDoctor"
    
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
' 機能　　 : 成績書出力情報を更新する
'
' 引数　　 : (In)     lngRsvNo  予約番号
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function UpdateConsultReport(ByVal lngRsvNo As Long) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER

    '成績書出力日を更新
    strStmt = "UPDATE CONSULT                   " & vbLf & _
              "   SET REPORTPRINTDATE = SYSDATE " & vbLf & _
              " WHERE RSVNO           = :RSVNO  " & vbLf & _
              "   AND REPORTPRINTDATE IS NULL   "

    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete

    '戻り値の設定
    UpdateConsultReport = True
    
    Exit Function

ErrorHandle:

    UpdateConsultReport = False

    'イベントログ書き込み
    WriteErrorLog "Consult.UpdateConsultReport"
    
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

'## 2003.11.18 Del by T.Takagi@FSIT 聖路加未対応メソッドのため削除
'
' 機能　　 : 指定オプション検査を追加し、受診情報、金額情報の再作成を行う
'
' 引数　　 : (In)     lngRsvNo    予約番号
' 　　　　   (In)     lngCtrPtCd  契約パターンコード
' 　　　　   (In)     strOptCd    オプションコード(カンマ区切り指定)
'
' 戻り値　 : 予約番号
'
' 備考　　 :
'
'Public Function UpdateConsultWithAddOption(ByVal lngRsvNo As Long, ByVal lngCtrPtcd As Long, ByVal strOptCd As String) As Long
'
'    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
'    Dim strStmt         As String           'SQLステートメント
'
'    Dim objOptCd        As OraParamArray    'オプションコード
'
'    Dim vntOptCd        As Variant          'オプションコード
'    Dim lngOptCount     As Long             'オプション検査数
'
'    Dim Ret             As Long             '関数戻り値
'    Dim i               As Long             'インデックス
'
'    'エラーハンドラの設定
'    On Error GoTo ErrorHandle
'
'    '各種項目数の取得
'    vntOptCd = Split(strOptCd, ",")
'    lngOptCount = GetElementCount(vntOptCd)
'
'    'オプションが１つもなければ終了
'    If lngOptCount = 0 Then
'        UpdateConsultWithAddOption = lngRsvNo
'        Exit Function
'    End If
'
'    'キー及び更新値の設定
'    Set objOraParam = mobjOraDb.Parameters
'    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "CTRPTCD", lngCtrPtcd, ORAPARM_INPUT, ORATYPE_NUMBER
'
'    'オプション検査のバインド変数定義
'    objOraParam.AddTable "OPTCD", ORAPARM_INPUT, ORATYPE_NUMBER, lngOptCount, 3
'    objOraParam.Add "OPTCOUNT", lngOptCount, ORAPARM_INPUT, ORATYPE_NUMBER
'
'    '戻り値のバインド変数定義
'    objOraParam.Add "MESSAGE", "", ORAPARM_OUTPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
'
'    'オブジェクトの参照設定
'    Set objOptCd = objOraParam("OPTCD")
'
'    'オプションコードの編集
'    For i = 0 To UBound(vntOptCd)
'        objOptCd(i) = vntOptCd(i)
'    Next i
'
'    '受診情報登録用ストアドパッケージの関数呼び出し
'    strStmt = "BEGIN :RET := ConsultPackage.UpdateConsultWithAddOption(:RSVNO, :CTRPTCD, :OPTCD, :OPTCOUNT, :MESSAGE); END;"
'
'    'PL/SQL文の実行
'    'mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
'
'    '戻り値の取得
'    'Ret = objOraParam("RET").Value
'
'    'トランザクション制御
'    If Ret > 0 Then
'        mobjContext.SetComplete
'    Else
'        mobjContext.SetAbort
'    End If
'
'    'バインド変数の削除
'    Do Until objOraParam.Count <= 0
'        objOraParam.Remove (objOraParam.Count - 1)
'    Loop
'
'    '戻り値の設定
'    UpdateConsultWithAddOption = Ret
'
'    Exit Function
'
'ErrorHandle:
'
'    'イベントログ書き込み
'    WriteErrorLog "Consult.UpdateConsultWithAddOption"
'
'    'エラー発生時はトランザクションをアボートに設定
'    mobjContext.SetAbort
'
'    'エラーをもう一回引き起こす
'    Err.Raise Err.Number, Err.Source, Err.Description
'
'End Function

'## 2003.11.18 Del by T.Takagi@FSIT 聖路加未対応メソッドのため削除
'
' 機能　　 : 指定請求明細分類のオプション検査を削除し、受診情報、金額情報の再作成を行う
'
' 引数　　 : (In)     lngRsvNo           予約番号
' 　　　　   (In)     strDmdLineClassCd  請求明細分類コード
' 　　　　   (In)     vntCtrPtCd         削除された時点での契約パターンコード
' 　　　　   (In)     vntDelOptCd        削除されたオプションコード
'
' 戻り値　 : 予約番号
'
' 備考　　 :
'
'Public Function UpdateConsultWithDelOption(ByVal lngRsvNo As Long, ByVal strDmdLineClassCd As String, ByRef vntCtrPtCd As Variant, ByRef vntDelOptCd As Variant) As Long
'
'    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
'    Dim strStmt         As String           'SQLステートメント
'
'    Dim lngCtrPtcd      As Long             '契約パターンコード
'    Dim strDelOptCd     As String           '削除されたオプションコード
'    Dim Ret             As Long             '関数戻り値
'
'    'エラーハンドラの設定
'    On Error GoTo ErrorHandle
'
'    '初期処理
'    vntCtrPtCd = Empty
'    vntDelOptCd = Empty
'
'    'キー及び更新値の設定
'    Set objOraParam = mobjOraDb.Parameters
'    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "DMDLINECLASSCD", strDmdLineClassCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
'
'    '戻り値のバインド変数定義
'    objOraParam.Add "CTRPTCD", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
'    objOraParam.Add "DELOPTCD", "", ORAPARM_OUTPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "MESSAGE", "", ORAPARM_OUTPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
'
'    '受診情報登録用ストアドパッケージの関数呼び出し
'    'strStmt = "BEGIN :RET := ConsultPackage.UpdateConsultWithDelOption(:RSVNO, :DMDLINECLASSCD, :CTRPTCD, :DELOPTCD, :MESSAGE); END;"
'
'    'PL/SQL文の実行
'    'mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
'
'    '戻り値の取得
'    'lngCtrPtCd = CLng("0" & objOraParam("CTRPTCD").Value)
'    'strDelOptCd = objOraParam("DELOPTCD").Value & ""
'    'Ret = objOraParam("RET").Value
'
'    'トランザクション制御
'    If Ret > 0 Then
'        mobjContext.SetComplete
'    Else
'        mobjContext.SetAbort
'    End If
'
'    'バインド変数の削除
'    Do Until objOraParam.Count <= 0
'        objOraParam.Remove (objOraParam.Count - 1)
'    Loop
'
'    '戻り値の設定
'    vntCtrPtCd = lngCtrPtcd
'    vntDelOptCd = strDelOptCd
'    UpdateConsultWithDelOption = Ret
'
'    Exit Function
'
'ErrorHandle:
'
'    'イベントログ書き込み
'    WriteErrorLog "Consult.UpdateConsultWithDelOption"
'
'    'エラー発生時はトランザクションをアボートに設定
'    mobjContext.SetAbort
'
'    'エラーをもう一回引き起こす
'    Err.Raise Err.Number, Err.Source, Err.Description
'
'End Function

'
' 機能　　 : お連れ様情報の妥当性チェック
'
' 引数　　 : (In)     dtmCslDate          受診日
' 　　　　   (In)     lngSeq              お連れ様Seq
' 　　　　   (In)     vntRsvNo            予約番号
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
Public Function CheckFriends( _
    ByVal dtmCslDate As Date, _
    ByVal lngSeq As Long, _
    ByVal vntRsvNo As Variant _
) As Variant
    Const MSG_TARGET        As String = "予約番号："
    Const MSG_ERRREPEAT     As String = "は別のお連れ様情報に登録済みです。"
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objSeq              As OraField         'お連れ様Seq
    Dim objRsvNo            As OraField         '予約番号
    
    Dim vntArrSeq()         As Variant          'お連れ様Seqの配列
    Dim vntArrRsvNo()       As Variant          '予約番号の配列

    Dim lngCount            As Long             'レコード件数

    Dim objCommon           As Common           '共通クラス
    
    Dim vntArrMessage       As Variant          'エラーメッセージの集合
    Dim strMessage          As String           'エラーメッセージ
    Dim i, j                As Long             'インデックス


    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")

    'SQL文の編集
    strStmt = "SELECT SEQ, RSVNO        " & vbLf & _
              "  FROM FRIENDS           " & vbLf & _
              " WHERE CSLDATE = '" & dtmCslDate & "' " & vbLf & _
              "   AND SEQ <> '" & lngSeq & "' " & vbLf & _
              "   AND RSVNO IN ( "
    For i = 0 To UBound(vntRsvNo)
        strStmt = strStmt & vbLf & _
                    IIf(i = 0, "", ",") & " '" & vntRsvNo(i) & "' "
    Next
    strStmt = strStmt & vbLf & _
              " )                       " & vbLf & _
              " ORDER BY RSVNO "
    
    '重複しているお連れ様情報の取得
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objSeq = objFields("SEQ")
        Set objRsvNo = objFields("RSVNO")

        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            '配列宣言
            ReDim Preserve vntArrSeq(lngCount)
            ReDim Preserve vntArrRsvNo(lngCount)
            'データ格納
            vntArrSeq(lngCount) = objSeq.Value & ""
            vntArrRsvNo(lngCount) = objRsvNo.Value & ""
            
            'エラーメッセージの作成（お連れ様情報の重複）
            strMessage = MSG_TARGET & vntArrRsvNo(lngCount) & MSG_ERRREPEAT
            objCommon.AppendArray vntArrMessage, strMessage
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

    End If

    '戻り値の編集
    If IsArray(vntArrMessage) Then
        CheckFriends = vntArrMessage
    End If

    Set objCommon = Nothing

    'トランザクション制御
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Consult.CheckFriends"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : お連れ様情報の削除を行う
'
' 引数　　 : (In)     dtmCslDate          受診日
' 　　　　   (In)     lngSeq              お連れ様Seq
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function DeleteFriends( _
    ByVal dtmCslDate As Date, _
    ByVal lngSeq As Long _
) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント


    'エラーハンドラの設定
    On Error GoTo ErrorHandle
       
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "SEQ", lngSeq, ORAPARM_INPUT, ORATYPE_NUMBER
        
    'お連れ様情報削除
    strStmt = "DELETE FRIENDS                           " & vbLf & _
              " WHERE CSLDATE = :CSLDATE                " & vbLf & _
              "   AND SEQ     = :SEQ                    "

    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    DeleteFriends = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    DeleteFriends = False

    'イベントログ書き込み
    WriteErrorLog "Consult.DeleteFriends"
    
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
' 機能　　 : お連れ様Ｓｅｑを取得する
'
' 引数　　 : (In)     dtmCslDate          受診日
'
' 戻り値　 : 正値   ＳｅｑＮｏ
' 　　　　   負値   異常終了
'
' 備考　　 :
'

Private Function GetFriendsSeq(ByRef dtmCslDate As Date) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim lngSeq                  As Long             'お連れ様Ｓｅｑ
    Dim lngCurrentMaxSeq        As Long             '現お連れ様Ｓｅｑの最大値
    
    Dim blnSuccess              As Boolean          '処理成功フラグ
    Dim i                       As Long             'インデックス


    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    
    lngSeq = -1
    
    Do
        
        strStmt = "SELECT /*+ INDEX_DESC(FRIENDS FRIENDS_PKEY) */ SEQ,      " & vbLf & _
                  "       GETTODAY.TODAY_DATE                               " & vbLf & _
                  "  FROM FRIENDS,                                          " & vbLf & _
                  "       (SELECT SYSDATE TODAY_DATE FROM DUAL) GETTODAY    " & vbLf & _
                  " WHERE ROWNUM = 1                                        " & vbLf & _
                  "   AND CSLDATE = :CSLDATE                                " & vbLf & _
                  "   FOR UPDATE NOWAIT                                     "
        
        
        '現SEQの最大値を取得する(他で処理中の場合は最大10回までリトライ)
        For i = 1 To 10
        
            blnSuccess = True
            
            '現入金Ｓｅｑの最大値を取得する
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
            Err.Raise 1000, , "現在他業務にてお連れ様情報を使用中のため、お連れ様Ｓｅｑ発番処理は行えませんでした。"
        End If
        
        
        'レコードが存在しない場合は初期値を発番
        If objOraDyna.EOF Then
            lngSeq = 1
            Exit Do
        End If
        
        '先頭レコードのＳｅｑ（すなわち現在の最大値）を取得
        lngCurrentMaxSeq = objOraDyna.Fields("SEQ").Value
        
        'インクリメントし新Ｓｅｑを求める
        lngSeq = lngCurrentMaxSeq + 1
        
        Exit Do
    Loop
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
   
    '戻り値の設定
    GetFriendsSeq = lngSeq
    
    Exit Function
    
ErrorHandle:

    'リソースビジーの場合は成功フラグをリセットして復帰
    If mobjOraDb.LastServerErr = 54 Then
        blnSuccess = False
        Resume Next
    End If

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'イベントログ書き込み
    WriteErrorLog "Consult.GetFriendsSeq"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 来院情報を取得する
'
' 引数　　 : (In)     lngRsvNo              予約番号
' 　　　　   (Out)    vntCancelFlg          キャンセルフラグ
' 　　　　   (Out)    vntCslDate            受診日
' 　　　　   (Out)    vntPerId              個人ID
' 　　　　   (Out)    vntCsCd               コースコード
' 　　　　   (Out)    vntOrgCd1             受診時団体コード1
' 　　　　   (Out)    vntOrgCd2             受診時団体コード2
' 　　　　   (Out)    vntRsvGrpCd           予約群コード
' 　　　　   (Out)    vntRsvDate            予約日
' 　　　　   (Out)    vntAge                受診時年齢
' 　　　　   (Out)    vntCtrPtCd            契約パターンコード
' 　　　　   (Out)    vntIsrSign            保険証記号
' 　　　　   (Out)    vntIsrNo              保険証番号
' 　　　　   (Out)    vntReportAddrDiv      成績書宛先
' 　　　　   (Out)    vntReportOurEng       成績書英文出力
' 　　　　   (Out)    vntCollectTicket      利用券回収
' 　　　　   (Out)    vntIssueCslTicket     診察券発行
' 　　　　   (Out)    vntBillPrint          請求書出力
' 　　　　   (Out)    vntVolunteer          ボランティア
' 　　　　   (Out)    vntVolunteerName      ボランティア名
' 　　　　   (Out)    vntDayID              当日ID
' 　　　　   (Out)    vntComeDate           来院日時
' 　　　　   (Out)    vntComeUser           来院処理者
' 　　　　   (Out)    vntOcrNo              OCR番号
' 　　　　   (Out)    vntLockerKey          ロッカーキー
' 　　　　   (Out)    vntBirth              生年月日
' 　　　　   (Out)    vntGender             性別
' 　　　　   (Out)    vntLastName           姓
' 　　　　   (Out)    vntFirstName          名
' 　　　　   (Out)    vntLastKName          カナ姓
' 　　　　   (Out)    vntFirstKName         カナ名
' 　　　　   (Out)    vntRomeName           ローマ字名
' 　　　　   (Out)    vntNationCd           国籍コード
' 　　　　   (Out)    vntNationName         国籍名
' 　　　　   (Out)    vntCompPerId          同伴者個人ID
' 　　　　   (Out)    vntCompPerName        同伴者個人名
' 　　　　   (Out)    vntCsName             コース名
' 　　　　   (Out)    vntCsSName            コース略称
' 　　　　   (Out)    vntOrgKName           団体カナ名称
' 　　　　   (Out)    vntOrgName            団体漢字名称
' 　　　　   (Out)    vntOrgSName           団体略称
' 　　　　   (Out)    vntTicket             利用券
' 　　　　   (Out)    vntInsBring           保険証当日持参
' 　　　　   (Out)    vntRsvGrpName         予約群名称
' 　　　　   (Out)    vntRsvGrpStrTime      予約群開始時間
' 　　　　   (Out)    vntRsvGrpEndTime      予約群終了時間
'
' 戻り値　 : True   レコードあり
' 　　　　   False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectWelComeInfo( _
    ByVal lngRsvNo As Long, _
    Optional ByRef vntCancelFlg As Variant, Optional ByRef vntCslDate As Variant, Optional ByRef vntPerId As Variant, Optional ByRef vntCsCd As Variant, _
    Optional ByRef vntOrgCd1 As Variant, Optional ByRef vntOrgCd2 As Variant, Optional ByRef vntRsvGrpCd As Variant, Optional ByRef vntRsvDate As Variant, _
    Optional ByRef vntAge As Variant, Optional ByRef vntCtrPtCd As Variant, Optional ByRef vntIsrSign As Variant, Optional ByRef vntIsrNo As Variant, _
    Optional ByRef vntReportAddrDiv As Variant, Optional ByRef vntReportOurEng As Variant, Optional ByRef vntCollectTicket As Variant, Optional ByRef vntIssueCslTicket As Variant, _
    Optional ByRef vntBillPrint As Variant, Optional ByRef vntVolunteer As Variant, Optional ByRef vntVolunteerName As Variant, _
    Optional ByRef vntDayId As Variant, Optional ByRef vntComeDate As Variant, Optional ByRef vntComeUser As Variant, Optional ByRef vntOcrNo As Variant, _
    Optional ByRef vntLockerKey As Variant, _
    Optional ByRef vntBirth As Variant, Optional ByRef vntGender As Variant, Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant, _
    Optional ByRef vntLastKName As Variant, Optional ByRef vntFirstKName As Variant, Optional ByRef vntRomeName As Variant, _
    Optional ByRef vntNationCd As Variant, Optional ByRef vntNationName As Variant, Optional ByRef vntCompPerId As Variant, Optional ByRef vntCompPerName As Variant, _
    Optional ByRef vntCsName As Variant, Optional ByRef vntCsSName As Variant, _
    Optional ByRef vntOrgKName As Variant, Optional ByRef vntOrgName As Variant, Optional ByRef vntOrgSName As Variant, _
    Optional ByRef vntTicket As Variant, Optional ByRef vntInsBring As Variant, _
    Optional ByRef vntRsvGrpName As Variant, Optional ByRef vntRsvGrpStrTime As Variant, Optional ByRef vntRsvGrpEndTime As Variant _
) As Boolean
    Dim objOraParam  As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna   As OraDynaset       'ダイナセット
    Dim strStmt      As String           'SQLステートメント

    Dim objFields    As OraFields        'フィールドオブジェクト
    Dim objCancelFlg        As OraField
    Dim objCslDate          As OraField
    Dim objPerId            As OraField
    Dim objCsCd             As OraField
    Dim objOrgCd1           As OraField
    Dim objOrgCd2           As OraField
    Dim objRsvGrpCd         As OraField
    Dim objRsvDate          As OraField
    Dim objAge              As OraField
    Dim objCtrPtCd          As OraField
    Dim objIsrSign          As OraField
    Dim objIsrNo            As OraField
    Dim objReportAddrDiv    As OraField
    Dim objReportOurEng     As OraField
    Dim objCollectTicket    As OraField
    Dim objIssueCslTicket   As OraField
    Dim objBillPrint        As OraField
    Dim objVolunteer        As OraField
    Dim objVolunteerName    As OraField
    Dim objDayId            As OraField
    Dim objComeDate         As OraField
    Dim objComeUser         As OraField
    Dim objOcrNo            As OraField
    Dim objLockerKey        As OraField
    Dim objBirth            As OraField
    Dim objGender           As OraField
    Dim objLastName         As OraField
    Dim objFirstName        As OraField
    Dim objLastKName        As OraField
    Dim objFirstKName       As OraField
    Dim objRomeName         As OraField
    Dim objNationCd         As OraField
    Dim objNationName       As OraField
    Dim objCompPerId        As OraField
    Dim objCompPerName      As OraField
    Dim objCsName           As OraField
    Dim objCsSName          As OraField
    Dim objOrgKName         As OraField
    Dim objOrgName          As OraField
    Dim objOrgSName         As OraField
    Dim objTicket           As OraField
    Dim objInsBring         As OraField
    Dim objRsvGrpName       As OraField
    Dim objRsvGrpStrTime    As OraField
    Dim objRsvGrpEndTime    As OraField
    
    '初期値
        If Not IsMissing(vntCancelFlg) Then vntCancelFlg = Empty
        If Not IsMissing(vntCslDate) Then vntCslDate = Empty
        If Not IsMissing(vntPerId) Then vntPerId = Empty
        If Not IsMissing(vntCsCd) Then vntCsCd = Empty
        If Not IsMissing(vntOrgCd1) Then vntOrgCd1 = Empty
        If Not IsMissing(vntOrgCd2) Then vntOrgCd2 = Empty
        If Not IsMissing(vntRsvGrpCd) Then vntRsvGrpCd = Empty
        If Not IsMissing(vntRsvDate) Then vntRsvDate = Empty
        If Not IsMissing(vntAge) Then vntAge = Empty
        If Not IsMissing(vntCtrPtCd) Then vntCtrPtCd = Empty
        If Not IsMissing(vntIsrSign) Then vntIsrSign = Empty
        If Not IsMissing(vntIsrNo) Then vntIsrNo = Empty
        If Not IsMissing(vntReportAddrDiv) Then vntReportAddrDiv = Empty
        If Not IsMissing(vntReportOurEng) Then vntReportOurEng = Empty
        If Not IsMissing(vntCollectTicket) Then vntCollectTicket = Empty
        If Not IsMissing(vntIssueCslTicket) Then vntIssueCslTicket = Empty
        If Not IsMissing(vntBillPrint) Then vntBillPrint = Empty
        If Not IsMissing(vntVolunteer) Then vntVolunteer = Empty
        If Not IsMissing(vntVolunteerName) Then vntVolunteerName = Empty
        If Not IsMissing(vntDayId) Then vntDayId = Empty
        If Not IsMissing(vntComeDate) Then vntComeDate = Empty
        If Not IsMissing(vntComeUser) Then vntComeUser = Empty
        If Not IsMissing(vntOcrNo) Then vntOcrNo = Empty
        If Not IsMissing(vntLockerKey) Then vntLockerKey = Empty
        If Not IsMissing(vntBirth) Then vntBirth = Empty
        If Not IsMissing(vntGender) Then vntGender = Empty
        If Not IsMissing(vntLastName) Then vntLastName = Empty
        If Not IsMissing(vntFirstName) Then vntFirstName = Empty
        If Not IsMissing(vntLastKName) Then vntLastKName = Empty
        If Not IsMissing(vntFirstKName) Then vntFirstKName = Empty
        If Not IsMissing(vntRomeName) Then vntRomeName = Empty
        If Not IsMissing(vntNationCd) Then vntNationCd = Empty
        If Not IsMissing(vntNationName) Then vntNationName = Empty
        If Not IsMissing(vntCompPerId) Then vntCompPerId = Empty
        If Not IsMissing(vntCompPerName) Then vntCompPerName = Empty
        If Not IsMissing(vntCsName) Then vntCsName = Empty
        If Not IsMissing(vntCsSName) Then vntCsSName = Empty
        If Not IsMissing(vntOrgKName) Then vntOrgKName = Empty
        If Not IsMissing(vntOrgName) Then vntOrgName = Empty
        If Not IsMissing(vntOrgSName) Then vntOrgSName = Empty
        If Not IsMissing(vntTicket) Then vntTicket = Empty
        If Not IsMissing(vntInsBring) Then vntInsBring = Empty
        If Not IsMissing(vntRsvGrpName) Then vntRsvGrpName = Empty
        If Not IsMissing(vntRsvGrpStrTime) Then vntRsvGrpStrTime = Empty
        If Not IsMissing(vntRsvGrpEndTime) Then vntRsvGrpEndTime = Empty

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER

    strStmt = ""
    strStmt = strStmt & vbLf & _
              "SELECT CONSULT.RSVNO,                        " & vbLf & _
              "       CONSULT.CANCELFLG,                    " & vbLf & _
              "       CONSULT.CSLDATE,                      " & vbLf & _
              "       CONSULT.PERID,                        " & vbLf & _
              "       CONSULT.CSCD,                         " & vbLf & _
              "       CONSULT.ORGCD1,                       " & vbLf & _
              "       CONSULT.ORGCD2,                       " & vbLf & _
              "       CONSULT.RSVGRPCD,                     " & vbLf & _
              "       CONSULT.RSVDATE,                      " & vbLf & _
              "       CONSULT.AGE,                          " & vbLf & _
              "       CONSULT.CTRPTCD,                      " & vbLf & _
              "       CONSULT.ISRSIGN,                      " & vbLf & _
              "       CONSULT.ISRNO,                        " & vbLf & _
              "       CONSULT.REPORTADDRDIV,                " & vbLf & _
              "       CONSULT.REPORTOURENG,                 " & vbLf & _
              "       CONSULT.COLLECTTICKET,                " & vbLf & _
              "       CONSULT.ISSUECSLTICKET,               " & vbLf & _
              "       CONSULT.BILLPRINT,                    " & vbLf & _
              "       CONSULT.VOLUNTEER,                    " & vbLf & _
              "       CONSULT.VOLUNTEERNAME,                " & vbLf
    strStmt = strStmt & vbLf & _
              "       RECEIPT.DAYID,                        " & vbLf & _
              "       RECEIPT.COMEDATE,                     " & vbLf & _
              "       RECEIPT.COMEUSER,                     " & vbLf & _
              "       RECEIPT.OCRNO,                        " & vbLf & _
              "       RECEIPT.LOCKERKEY,                    " & vbLf & _
              "       PERSON.BIRTH,                         " & vbLf & _
              "       PERSON.GENDER,                        " & vbLf & _
              "       PERSON.LASTNAME,                      " & vbLf & _
              "       PERSON.FIRSTNAME,                     " & vbLf & _
              "       PERSON.LASTKNAME,                     " & vbLf & _
              "       PERSON.FIRSTKNAME,                    " & vbLf & _
              "       PERSON.ROMENAME,                      " & vbLf & _
              "       PERSON.NATIONCD,                      " & vbLf & _
              "       (SELECT FREE.FREEFIELD1               " & vbLf & _
              "          FROM FREE                          " & vbLf & _
              "         WHERE PERSON.NATIONCD = FREE.FREECD) NATIONNAME,        " & vbLf & _
              "       PERSON.COMPPERID,                     " & vbLf & _
              "       (SELECT COMPPER.LASTNAME || '　' || COMPPER.FIRSTNAME     " & vbLf & _
              "          FROM PERSON COMPPER                " & vbLf & _
              "         WHERE COMPPER.PERID = PERSON.COMPPERID) COMPPERNAME,    " & vbLf
    strStmt = strStmt & vbLf & _
              "       COURSE_P.CSNAME,                      " & vbLf & _
              "       COURSE_P.CSSNAME,                     " & vbLf & _
              "       ORG.ORGKNAME,                         " & vbLf & _
              "       ORG.ORGNAME,                          " & vbLf & _
              "       ORG.ORGSNAME,                         " & vbLf & _
              "       ORG.TICKET,                           " & vbLf & _
              "       ORG.INSBRING,                         " & vbLf & _
              "       RSVGRP.RSVGRPNAME,                    " & vbLf & _
              "       RSVGRP.STRTIME RSVGRPSTRTIME,         " & vbLf & _
              "       RSVGRP.ENDTIME RSVGRPENDTIME          " & vbLf
    strStmt = strStmt & vbLf & _
              "  FROM CONSULT,                              " & vbLf & _
              "       RECEIPT,                              " & vbLf & _
              "       PERSON,                               " & vbLf & _
              "       COURSE_P,                             " & vbLf & _
              "       ORG,                                  " & vbLf & _
              "       RSVGRP                                " & vbLf
    strStmt = strStmt & vbLf & _
              " WHERE CONSULT.RSVNO    = :RSVNO             " & vbLf & _
              "   AND CONSULT.RSVNO    = RECEIPT.RSVNO(+)   " & vbLf & _
              "   AND CONSULT.PERID    = PERSON.PERID       " & vbLf & _
              "   AND CONSULT.CSCD     = COURSE_P.CSCD      " & vbLf & _
              "   AND CONSULT.ORGCD1   = ORG.ORGCD1         " & vbLf & _
              "   AND CONSULT.ORGCD2   = ORG.ORGCD2         " & vbLf & _
              "   AND CONSULT.RSVGRPCD = RSVGRP.RSVGRPCD    "
    
    'SQL文の実行
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCancelFlg = objFields("CANCELFLG")
        Set objCslDate = objFields("CSLDATE")
        Set objPerId = objFields("PERID")
        Set objCsCd = objFields("CSCD")
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objRsvGrpCd = objFields("RSVGRPCD")
        Set objRsvDate = objFields("RSVDATE")
        Set objAge = objFields("AGE")
        Set objCtrPtCd = objFields("CTRPTCD")
        Set objIsrSign = objFields("ISRSIGN")
        Set objIsrNo = objFields("ISRNO")
        Set objReportAddrDiv = objFields("REPORTADDRDIV")
        Set objReportOurEng = objFields("REPORTOURENG")
        Set objCollectTicket = objFields("COLLECTTICKET")
        Set objIssueCslTicket = objFields("ISSUECSLTICKET")
        Set objBillPrint = objFields("BILLPRINT")
        Set objVolunteer = objFields("VOLUNTEER")
        Set objVolunteerName = objFields("VOLUNTEERNAME")
        Set objDayId = objFields("DAYID")
        Set objComeDate = objFields("COMEDATE")
        Set objComeUser = objFields("COMEUSER")
        Set objOcrNo = objFields("OCRNO")
        Set objLockerKey = objFields("LOCKERKEY")
        Set objBirth = objFields("BIRTH")
        Set objGender = objFields("GENDER")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastKName = objFields("LASTKNAME")
        Set objFirstKName = objFields("FIRSTKNAME")
        Set objRomeName = objFields("ROMENAME")
        Set objNationCd = objFields("NATIONCD")
        Set objNationName = objFields("NATIONNAME")
        Set objCompPerId = objFields("COMPPERID")
        Set objCompPerName = objFields("COMPPERNAME")
        Set objCsName = objFields("CSNAME")
        Set objCsSName = objFields("CSSNAME")
        Set objOrgKName = objFields("ORGKNAME")
        Set objOrgName = objFields("ORGNAME")
        Set objOrgSName = objFields("ORGSNAME")
        Set objTicket = objFields("TICKET")
        Set objInsBring = objFields("INSBRING")
        Set objRsvGrpName = objFields("RSVGRPNAME")
        Set objRsvGrpStrTime = objFields("RSVGRPSTRTIME")
        Set objRsvGrpEndTime = objFields("RSVGRPENDTIME")

        '戻り値の設定
        If Not IsMissing(vntCancelFlg) Then vntCancelFlg = objCancelFlg.Value & ""
        If Not IsMissing(vntCslDate) Then vntCslDate = objCslDate.Value & ""
        If Not IsMissing(vntPerId) Then vntPerId = objPerId.Value & ""
        If Not IsMissing(vntCsCd) Then vntCsCd = objCsCd.Value & ""
        If Not IsMissing(vntOrgCd1) Then vntOrgCd1 = objOrgCd1.Value & ""
        If Not IsMissing(vntOrgCd2) Then vntOrgCd2 = objOrgCd2.Value & ""
        If Not IsMissing(vntRsvGrpCd) Then vntRsvGrpCd = objRsvGrpCd.Value & ""
        If Not IsMissing(vntRsvDate) Then vntRsvDate = objRsvDate.Value & ""
        If Not IsMissing(vntAge) Then vntAge = objAge.Value & ""
        If Not IsMissing(vntCtrPtCd) Then vntCtrPtCd = objCtrPtCd.Value & ""
        If Not IsMissing(vntIsrSign) Then vntIsrSign = objIsrSign.Value & ""
        If Not IsMissing(vntIsrNo) Then vntIsrNo = objIsrNo.Value & ""
        If Not IsMissing(vntReportAddrDiv) Then vntReportAddrDiv = objReportAddrDiv.Value & ""
        If Not IsMissing(vntReportOurEng) Then vntReportOurEng = objReportOurEng.Value & ""
        If Not IsMissing(vntCollectTicket) Then vntCollectTicket = objCollectTicket.Value & ""
        If Not IsMissing(vntIssueCslTicket) Then vntIssueCslTicket = objIssueCslTicket.Value & ""
        If Not IsMissing(vntBillPrint) Then vntBillPrint = objBillPrint.Value & ""
        If Not IsMissing(vntVolunteer) Then vntVolunteer = objVolunteer.Value & ""
        If Not IsMissing(vntVolunteerName) Then vntVolunteerName = objVolunteerName.Value & ""
        If Not IsMissing(vntDayId) Then vntDayId = objDayId.Value & ""
        If Not IsMissing(vntComeDate) Then vntComeDate = objComeDate.Value & ""
        If Not IsMissing(vntComeUser) Then vntComeUser = objComeUser.Value & ""
        If Not IsMissing(vntOcrNo) Then vntOcrNo = objOcrNo.Value & ""
        If Not IsMissing(vntLockerKey) Then vntLockerKey = objLockerKey.Value & ""
        If Not IsMissing(vntBirth) Then vntBirth = objBirth.Value & ""
        If Not IsMissing(vntGender) Then vntGender = objGender.Value & ""
        If Not IsMissing(vntLastName) Then vntLastName = objLastName.Value & ""
        If Not IsMissing(vntFirstName) Then vntFirstName = objFirstName.Value & ""
        If Not IsMissing(vntLastKName) Then vntLastKName = objLastKName.Value & ""
        If Not IsMissing(vntFirstKName) Then vntFirstKName = objFirstKName.Value & ""
        If Not IsMissing(vntRomeName) Then vntRomeName = objRomeName.Value & ""
        If Not IsMissing(vntNationCd) Then vntNationCd = objNationCd.Value & ""
        If Not IsMissing(vntNationName) Then vntNationName = objNationName.Value & ""
        If Not IsMissing(vntCompPerId) Then vntCompPerId = objCompPerId.Value & ""
        If Not IsMissing(vntCompPerName) Then vntCompPerName = objCompPerName.Value & ""
        If Not IsMissing(vntCsName) Then vntCsName = objCsName.Value & ""
        If Not IsMissing(vntCsSName) Then vntCsSName = objCsSName.Value & ""
        If Not IsMissing(vntOrgKName) Then vntOrgKName = objOrgKName.Value & ""
        If Not IsMissing(vntOrgName) Then vntOrgName = objOrgName.Value & ""
        If Not IsMissing(vntOrgSName) Then vntOrgSName = objOrgSName.Value & ""
        If Not IsMissing(vntTicket) Then vntTicket = objTicket.Value & ""
        If Not IsMissing(vntInsBring) Then vntInsBring = objInsBring.Value & ""
        If Not IsMissing(vntRsvGrpName) Then vntRsvGrpName = objRsvGrpName.Value & ""
        If Not IsMissing(vntRsvGrpStrTime) Then vntRsvGrpStrTime = objRsvGrpStrTime.Value & ""
        If Not IsMissing(vntRsvGrpEndTime) Then vntRsvGrpEndTime = objRsvGrpEndTime.Value & ""
        
         '戻り値の設定
        SelectWelComeInfo = True
    End If

   
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectWelComeInfo = False

    'イベントログ書き込み
    WriteErrorLog "Consult.SelectWelComeInfo"

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    ''エラーをもう一回引き起こす
     Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 検索条件を満たす受診者の一覧を取得する
'
' 引数　　 : (In)     strKey            検索キー
' 　　　　   (In)     dtmStrCslDate     開始受診日
' 　　　　   (In)     dtmEndCslDate     終了受診日
' 　　　　   (In)     strCsCd           コースコード
' 　　　　   (In)     strOrgCd1         団体コード１
' 　　　　   (In)     strOrgCd2         団体コード２
' 　　　　   (In)     strGrpCd          グループコード
' 　　　　   (In)     strItemCd         依頼項目コード
' 　　　　   (In)     strEntry          結果入力状態("":指定なし、"1":未入力のみ表示、"2":入力済みのみ表示)
' 　　　　   (In)     vntPrintField     表示項目
' 　　　　   (In)     vntSortKey        ソートキー
' 　　　　   (In)     vntSortType       ソート順(0:昇順、1:降順)
' 　　　　   (In)     lngStartPos       取得開始位置
' 　　　　   (In)     lngGetCount       取得件数
' 　　　　   (Out)    vntRsvNo          予約番号
' 　　　　   (Out)    vntCancelFlg      キャンセルフラグ
' 　　　　   (Out)    vntCslDate        受診日
' 　　　　   (Out)    vntPerId          個人ＩＤ
' 　　　　   (Out)    vntOrgSName       団体略称
' 　　　　   (Out)    vntRsvDate        予約日
' 　　　　   (Out)    vntAge            年齢
' 　　　　   (Out)    vntDayId          当日ＩＤ
' 　　　　   (Out)    vntWebColor       webカラー
' 　　　　   (Out)    vntCsName         コース名
' 　　　　   (Out)    vntName           氏名
' 　　　　   (Out)    vntKanaName       カナ氏名
' 　　　　   (Out)    vntBirth          生年月日
' 　　　　   (Out)    vntGender         性別
' 　　　　   (Out)    vntAddDiv         追加検査区分
' 　　　　   (Out)    vntAddName        追加検査名
' 　　　　   (Out)    vntRequestName    検査項目名
' 　　　　   (Out)    vntIsrSign        健保記号
' 　　　　   (Out)    vntIsrNo          健保番号
' 　　　　   (Out)    vntSubCsWebColor  サブコースのwebカラー
' 　　　　   (Out)    vntSubCsName      サブコース名
' 　　　　   (Out)    vntEntry          結果入力状態(0:未入力なし、1:未入力あり)
' 　　　　   (Out)    vntRsvStatus      予約状況
' 　　　　   (Out)    vntCardPrintDate  確認はがき出力日
' 　　　　   (Out)    vntFormPrintDate  一式書式出力日
' 　　　　   (Out)    vntCompPerId      同伴者個人ＩＤ      '2004/01/20 Add By K.Kagawa@FFCS
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
'## 2003.01.03 Mod By T.Takagi@FSIT 絞込み条件追加
'Public Function SelectDailyList(
'    ByVal strKey As String, ByVal dtmStrCslDate As Date, ByVal dtmEndCslDate As Date,
'    ByVal strCsCd As String,
'    ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, ByVal strGrpCd As String, ByVal strItemCd As String,
'    ByVal strEntry As String, ByVal vntPrintField As Variant,
'    ByVal lngSortKey As Long, ByVal lngSortType As Long, ByVal lngStartPos As Long, ByVal lngGetCount As Long,
'    Optional ByRef vntRsvNo As Variant, Optional ByRef vntCancelFlg As Variant,
'    Optional ByRef vntCslDate As Variant, Optional ByRef vntPerId As Variant,
'    Optional ByRef vntOrgSName As Variant,
'    Optional ByRef vntRsvDate As Variant, Optional ByRef vntAge As Variant,
'    Optional ByRef vntDayId As Variant,
'    Optional ByRef vntWebColor As Variant, Optional ByRef vntCsName As Variant,
'    Optional ByRef vntName As Variant, Optional ByRef vntKanaName As Variant,
'    Optional ByRef vntBirth As Variant, Optional ByRef vntGender As Variant,
'    Optional ByRef vntAddDiv As Variant, Optional ByRef vntAddName As Variant, Optional ByRef vntRequestName As Variant,
'    Optional ByRef vntIsrSign As Variant, Optional ByRef vntIsrNo As Variant,
'    Optional ByRef vntSubCsWebColor As Variant, Optional ByRef vntSubCsName As Variant,
'    Optional ByRef vntEntry As Variant,
'    Optional ByRef vntRsvStatus As Variant, Optional ByRef vntCardPrintDate As Variant, Optional ByRef vntFormPrintDate As Variant,
'    Optional ByRef vntRsvGrpName As Variant, Optional ByRef vntHasFriends As Variant
') As Long
'## 2003.01.03 Mod End
'## 2004/01/20 Add By K.Kagawa@FFCS 同伴者追加
'Public Function SelectDailyList(
'    ByVal strKey As String, ByVal dtmStrCslDate As Date, ByVal dtmEndCslDate As Date,
'    ByVal strCsCd As String,
'    ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, ByVal strGrpCd As String, ByVal strItemCd As String,
'    ByVal strEntry As String, ByVal vntPrintField As Variant,
'    ByVal lngSortKey As Long, ByVal lngSortType As Long, ByVal lngStartPos As Long, ByVal lngGetCount As Long,
'    Optional ByRef vntRsvNo As Variant, Optional ByRef vntCancelFlg As Variant,
'    Optional ByRef vntCslDate As Variant, Optional ByRef vntPerId As Variant,
'    Optional ByRef vntOrgSName As Variant,
'    Optional ByRef vntRsvDate As Variant, Optional ByRef vntAge As Variant,
'    Optional ByRef vntDayId As Variant,
'    Optional ByRef vntWebColor As Variant, Optional ByRef vntCsName As Variant,
'    Optional ByRef vntName As Variant, Optional ByRef vntKanaName As Variant,
'    Optional ByRef vntBirth As Variant, Optional ByRef vntGender As Variant,
'    Optional ByRef vntAddDiv As Variant, Optional ByRef vntAddName As Variant, Optional ByRef vntRequestName As Variant,
'    Optional ByRef vntIsrSign As Variant, Optional ByRef vntIsrNo As Variant,
'    Optional ByRef vntSubCsWebColor As Variant, Optional ByRef vntSubCsName As Variant,
'    Optional ByRef vntEntry As Variant,
'    Optional ByRef vntRsvStatus As Variant, Optional ByRef vntCardPrintDate As Variant, Optional ByRef vntFormPrintDate As Variant,
'    Optional ByRef vntRsvGrpName As Variant, Optional ByRef vntHasFriends As Variant,
'    Optional ByVal strRsvStat As String, Optional ByVal strRptStat As String
') As Long

'## 2013/04/15 Add By 張 検索条件に「受診区分」追加 START ################################################################
'Public Function SelectDailyList( _
'    ByVal strKey As String, ByVal dtmStrCslDate As Date, ByVal dtmEndCslDate As Date, _
'    ByVal strCsCd As String, _
'    ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, ByVal strGrpCd As String, ByVal strItemCd As String, _
'    ByVal strEntry As String, ByVal vntPrintField As Variant, _
'    ByVal lngSortKey As Long, ByVal lngSortType As Long, ByVal lngStartPos As Long, ByVal lngGetCount As Long, _
'    Optional ByRef vntRsvNo As Variant, Optional ByRef vntCancelFlg As Variant, _
'    Optional ByRef vntCslDate As Variant, Optional ByRef vntPerId As Variant, _
'    Optional ByRef vntOrgSName As Variant, _
'    Optional ByRef vntRsvDate As Variant, Optional ByRef vntAge As Variant, _
'    Optional ByRef vntDayId As Variant, _
'    Optional ByRef vntWebColor As Variant, Optional ByRef vntCsName As Variant, _
'    Optional ByRef vntName As Variant, Optional ByRef vntKanaName As Variant, _
'    Optional ByRef vntBirth As Variant, Optional ByRef vntGender As Variant, _
'    Optional ByRef vntAddDiv As Variant, Optional ByRef vntAddName As Variant, Optional ByRef vntRequestName As Variant, _
'    Optional ByRef vntIsrSign As Variant, Optional ByRef vntIsrNo As Variant, _
'    Optional ByRef vntSubCsWebColor As Variant, Optional ByRef vntSubCsName As Variant, _
'    Optional ByRef vntEntry As Variant, _
'    Optional ByRef vntRsvStatus As Variant, Optional ByRef vntCardPrintDate As Variant, Optional ByRef vntFormPrintDate As Variant, _
'    Optional ByRef vntRsvGrpName As Variant, Optional ByRef vntHasFriends As Variant, _
'    Optional ByVal strRsvStat As String, Optional ByVal strRptStat As String, Optional ByRef vntCompPerId As Variant _
') As Long

Public Function SelectDailyList( _
    ByVal strKey As String, ByVal dtmStrCslDate As Date, ByVal dtmEndCslDate As Date, _
    ByVal strCsCd As String, _
    ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, ByVal strGrpCd As String, ByVal strItemCd As String, _
    ByVal strEntry As String, ByVal vntPrintField As Variant, _
    ByVal lngSortKey As Long, ByVal lngSortType As Long, ByVal lngStartPos As Long, ByVal lngGetCount As Long, _
    Optional ByRef vntRsvNo As Variant, Optional ByRef vntCancelFlg As Variant, _
    Optional ByRef vntCslDate As Variant, Optional ByRef vntPerId As Variant, _
    Optional ByRef vntOrgSName As Variant, _
    Optional ByRef vntRsvDate As Variant, Optional ByRef vntAge As Variant, _
    Optional ByRef vntDayId As Variant, _
    Optional ByRef vntWebColor As Variant, Optional ByRef vntCsName As Variant, _
    Optional ByRef vntName As Variant, Optional ByRef vntKanaName As Variant, _
    Optional ByRef vntBirth As Variant, Optional ByRef vntGender As Variant, _
    Optional ByRef vntAddDiv As Variant, Optional ByRef vntAddName As Variant, Optional ByRef vntRequestName As Variant, _
    Optional ByRef vntIsrSign As Variant, Optional ByRef vntIsrNo As Variant, _
    Optional ByRef vntSubCsWebColor As Variant, Optional ByRef vntSubCsName As Variant, _
    Optional ByRef vntEntry As Variant, _
    Optional ByRef vntRsvStatus As Variant, Optional ByRef vntCardPrintDate As Variant, Optional ByRef vntFormPrintDate As Variant, _
    Optional ByRef vntRsvGrpName As Variant, Optional ByRef vntHasFriends As Variant, _
    Optional ByVal strRsvStat As String, Optional ByVal strRptStat As String, Optional ByRef vntCompPerId As Variant, Optional ByVal strCslDivCd As String _
) As Long
'## 2013/04/15 Add By 張 検索条件に「受診区分」追加 END   ################################################################

'## 2004/01/20 Add End
    Dim objCommon               As Common           '共通クラス
    Dim objCourse               As Object           'コース情報アクセス用
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objParaRsvNo            As OraParameter     '予約番号
    
    Dim objOraDyna              As OraDynaset       'ダイナセット１(受診者一覧)
    Dim objOraDyna2             As OraDynaset       'ダイナセット２(追加検査)
    Dim objOraDyna3             As OraDynaset       'ダイナセット３(受診項目)
    Dim objOraDyna4             As OraDynaset       'ダイナセット４(サブコース)
    
    Dim strStmt                 As String           'SQLステートメント１(受診者一覧)
    Dim strstmt2                As String           'SQLステートメント２(追加検査)
    Dim strStmt3                As String           'SQLステートメント３(受診項目)
    Dim strStmt4                As String           'SQLステートメント４(サブコース)

    Dim objFields               As OraFields        'フィールドオブジェクト１(受診者一覧)
    Dim objFields2              As OraFields        'フィールドオブジェクト２(追加検査)
    Dim objFields3              As OraFields        'フィールドオブジェクト３(受診項目)
    Dim objFields4              As OraFields        'フィールドオブジェクト４(サブコース)
    Dim objRsvNo                As OraField         '予約番号
    Dim objCancelFlg            As OraField         'キャンセルフラグ
    Dim objCslDate              As OraField         '受診日
    Dim objPerId                As OraField         '個人ＩＤ
    Dim objRsvDate              As OraField         '予約日
    Dim objAge                  As OraField         '年齢
    Dim objDayId                As OraField         '当日ＩＤ
    Dim objWebColor             As OraField         'webカラー
    Dim objCsName               As OraField         'コース名
    Dim objLastName             As OraField         '姓
    Dim objFirstName            As OraField         '名
    Dim objLastKName            As OraField         'カナ姓
    Dim objFirstKName           As OraField         'カナ名
    Dim objBirth                As OraField         '生年月日
    Dim objGender               As OraField         '性別
    Dim objOrgSName             As OraField         '団体略称
    Dim objAddDiv               As OraField         '追加検査区分
    Dim objAddName              As OraField         '追加検査名
    Dim objRequestName          As OraField         '検査項目名
    Dim objIsrSign              As OraField         '健保記号
    Dim objIsrNo                As OraField         '健保番号
    Dim objSubCsWebColor        As OraField         'サブコースのwebカラー
    Dim objSubCsName            As OraField         'サブコース名
    Dim objEntry                As OraField         '結果入力状態
    Dim objRsvStatus            As OraField         '予約状況
    Dim objCardPrintDate        As OraField         '確認はがき出力日
    Dim objFormPrintDate        As OraField         '一式書式出力日
    Dim objRsvGrpName           As OraField         '予約群名称
    Dim objHasFriends           As OraField         'お連れ様有無
'## 2004/01/20 Add By K.Kagawa@FFCS 同伴者追加
    Dim objCompPerId            As OraField         '同伴者個人ＩＤ
'## 2004/01/20 Add End

    Dim vntArrRsvNo()           As Variant          '予約番号の配列
    Dim vntArrCancelFlg()       As Variant          'キャンセルフラグの配列
    Dim vntArrCslDate()         As Variant          '受診日の配列
    Dim vntArrPerId()           As Variant          '個人ＩＤの配列
    Dim vntArrRsvDate()         As Variant          '予約日の配列
    Dim vntArrAge()             As Variant          '受診時年齢の配列
    Dim vntArrDayId()           As Variant          '当日ＩＤの配列
    Dim vntArrWebColor()        As Variant          'webカラーの配列
    Dim vntArrCsName()          As Variant          'コース名の配列
    Dim vntArrName()            As Variant          '氏名の配列
    Dim vntArrKanaName()        As Variant          'カナ氏名の配列
    Dim vntArrBirth()           As Variant          '生年月日の配列
    Dim vntArrGender()          As Variant          '性別の配列
    Dim vntArrOrgSName()        As Variant          '団体略称の配列
    Dim vntArrAddDiv()          As Variant          '追加検査区分の配列
    Dim vntArrAddName()         As Variant          '追加検査名の配列
    Dim vntArrRequestName()     As Variant          '検査項目名の配列
    Dim vntArrIsrSign()         As Variant          '健保記号の配列
    Dim vntArrIsrNo()           As Variant          '健保番号の配列
    Dim vntArrSubCsWebColor()   As Variant          'サブコースのwebカラーの配列
    Dim vntArrSubCsName()       As Variant          'サブコース名の配列
    Dim vntArrEntry()           As Variant          '結果入力状態の配列
    Dim vntArrRsvStatus()       As Variant          '予約状況の配列
    Dim vntArrCardPrintDate()   As Variant          '確認はがき出力日の配列
    Dim vntArrFormPrintDate()   As Variant          '一式書式出力日の配列
    Dim vntArrRsvGrpName()      As Variant          '予約群名称の配列
    Dim vntArrHasFriends()      As Variant          'お連れ様有無の配列
'## 2004/01/20 Add By K.Kagawa@FFCS 同伴者追加
    Dim vntArrCompPerId()       As Variant          '同伴者個人ＩＤの配列
'## 2004/01/20 Add End
    
    Dim vntArrAddDiv2()         As Variant          '追加検査区分の配列
    Dim vntArrAddName2()        As Variant          '追加検査名の配列
    Dim lngAddItemCount         As Long             '追加検査数
    
    Dim vntArrRequestName2()    As Variant          '検査項目名の配列
    Dim lngConsultItemCount     As Long             '検査項目数
    
    Dim vntArrSubCsWebColor2()  As Variant          'サブコースのwebカラーの配列
    Dim vntArrSubCsName2()      As Variant          'サブコース名の配列
    Dim lngSubCourseCount       As Long             'サブコース数
    
    Dim strPerOrgCd1            As String           '個人受診用の団体コード１
    Dim strPerOrgCd2            As String           '個人受診用の団体コード２
    
    Dim vntCsDiv                As Variant          'コース区分
    
    Dim blnCourse               As Boolean          'コースの追加要否
    Dim blnName                 As Boolean          '氏名の追加要否
    Dim blnKanaName             As Boolean          'カナ氏名の追加要否
    Dim blnGender               As Boolean          '性別の追加要否
    Dim blnBirth                As Boolean          '生年月日の追加要否
    Dim blnAge                  As Boolean          '受診時年齢の追加要否
    Dim blnOrgSName             As Boolean          '団体略称の追加要否
    Dim blnRsvDate              As Boolean          '予約日の追加要否
    Dim blnAddItem              As Boolean          '追加検査の追加要否
    Dim blnConsultItem          As Boolean          '受診項目の追加要否
    Dim blnIsrSign              As Boolean          '健保記号の追加要否
    Dim blnIsrNo                As Boolean          '健保番号の追加要否
    Dim blnSubCourse            As Boolean          'サブコースの追加要否
    Dim blnEntry                As Boolean          '結果入力状態の追加要否
    Dim blnRsvStatus            As Boolean          '予約状況の追加要否
    Dim blnCardPrintDate        As Boolean          '確認はがき出力日の追加要否
    Dim blnFormPrintDate        As Boolean          '一式書式出力日の追加要否
    Dim blnRsvGrp               As Boolean          '予約群の追加要否
    Dim blnHasFriends           As Boolean          'お連れ様有無の追加要否
    
    Dim lngCount                As Long             'レコード件数
    
    Dim dtmDate                 As Date             '作業用の日付
    Dim strBuffer               As String           '文字列バッファ
    Dim lngPhase                As Long             '取得フェイズ(0:件数のみ、1:実データ)
    Dim i                       As Long             'インデックス
    
    Dim strCondition            As String           '条件節
    Dim blnExistsRsvNo          As Boolean          '検索キー内に予約番号が存在するか
'## 2004.01.03 Add By T.Takagi@FSIT 当日ID検索機能追加
    Dim blnExistsDayId          As Boolean          '検索キー内に当日ＩＤが存在するか
'## 2004.01.03 Add End
    
'### 2006.08.03 Mod By 張 ＯＣＲ番号、ロッカー番号検索機能追加 Start ###
    Dim blnExistsOcrNo          As Boolean          '検索キー内にＯＣＲ番号が存在するか
    Dim blnExistsLockerKey      As Boolean          '検索キー内にロッカー番号が存在するか
'### 2006.08.03 Mod By 張 ＯＣＲ番号、ロッカー番号検索機能追加 End   ###
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If Not IsMissing(vntCancelFlg) Then vntCancelFlg = Empty
    If Not IsMissing(vntCslDate) Then vntCslDate = Empty
    If Not IsMissing(vntPerId) Then vntPerId = Empty
    If Not IsMissing(vntRsvDate) Then vntRsvDate = Empty
    If Not IsMissing(vntAge) Then vntAge = Empty
    If Not IsMissing(vntDayId) Then vntDayId = Empty
    If Not IsMissing(vntWebColor) Then vntWebColor = Empty
    If Not IsMissing(vntCsName) Then vntCsName = Empty
    If Not IsMissing(vntName) Then vntName = Empty
    If Not IsMissing(vntKanaName) Then vntKanaName = Empty
    If Not IsMissing(vntBirth) Then vntBirth = Empty
    If Not IsMissing(vntGender) Then vntGender = Empty
    If Not IsMissing(vntOrgSName) Then vntOrgSName = Empty
    If Not IsMissing(vntAddDiv) Then vntAddDiv = Empty
    If Not IsMissing(vntAddName) Then vntAddName = Empty
    If Not IsMissing(vntRequestName) Then vntRequestName = Empty
    If Not IsMissing(vntIsrSign) Then vntIsrSign = Empty
    If Not IsMissing(vntIsrNo) Then vntIsrNo = Empty
    If Not IsMissing(vntSubCsWebColor) Then vntSubCsWebColor = Empty
    If Not IsMissing(vntSubCsName) Then vntSubCsName = Empty
    If Not IsMissing(vntEntry) Then vntEntry = Empty
    If Not IsMissing(vntRsvStatus) Then vntRsvStatus = Empty
    If Not IsMissing(vntCardPrintDate) Then vntCardPrintDate = Empty
    If Not IsMissing(vntFormPrintDate) Then vntFormPrintDate = Empty
    If Not IsMissing(vntRsvGrpName) Then vntRsvGrpName = Empty
    If Not IsMissing(vntHasFriends) Then vntHasFriends = Empty
'## 2004/01/20 Add By K.Kagawa@FFCS 同伴者追加
    If Not IsMissing(vntCompPerId) Then vntCompPerId = Empty
'## 2004/01/20 Add End

    'オブジェクトのインスタンス作成
    
    '固定の団体コードを取得
    Set objCommon = CreateObject("HainsCommon.Common")
    objCommon.GetOrgCd ORGCD_KEY_PERSON, strPerOrgCd1, strPerOrgCd2
    Set objCommon = Nothing

    'コースコード指定時はコース区分を取得
    If strCsCd <> "" Then
        Set objCourse = CreateObject("HainsCourse.Course")
        objCourse.SelectCourse strCsCd, , , , , , , , , , , , , , , , , , , , , , , , , , vntCsDiv
        Set objCourse = Nothing
    End If
    
    '取得フィールド指定状態によるフラグ設定
    For i = 0 To UBound(vntPrintField)
        Select Case vntPrintField(i)
            Case COL_COURSE:        blnCourse = True
            Case COL_NAME:          blnName = True
            Case COL_KANANAME:      blnKanaName = True
            Case COL_GENDER:        blnGender = True
            Case COL_BIRTH:         blnBirth = True
            Case COL_AGE:           blnAge = True
            Case COL_ORGSNAME:      blnOrgSName = True
            Case COL_RSVDATE:       blnRsvDate = True
            Case COL_ADDITEM:       blnAddItem = True
            Case COL_BOTHNAME:      blnName = True: blnKanaName = True
            Case COL_CONSULTITEM:   blnConsultItem = True
            Case COL_ISRSIGN:       blnIsrSign = True
            Case COL_ISRNO:         blnIsrNo = True
            Case COL_SUBCOURSE:     blnSubCourse = True
            Case COL_ENTRY:         blnEntry = True
            Case COL_RSVSTATUS:     blnRsvStatus = True
            Case COL_CARDPRINTDATE: blnCardPrintDate = True
            Case COL_FORMPRINTDATE: blnFormPrintDate = True
            Case COL_RSVGRP:        blnRsvGrp = True
            Case COL_HASFRIENDS:    blnHasFriends = True
        End Select
    Next i
    
    '受診日の設定
    Select Case True
        
        '双方とも未指定の場合は何もしない
        Case dtmStrCslDate = 0 And dtmEndCslDate = 0
        
        '一方が未指定の場合、もう一方の値と同値として扱う
        Case dtmStrCslDate > 0 And dtmEndCslDate = 0
            dtmEndCslDate = dtmStrCslDate
        Case dtmStrCslDate = 0 And dtmEndCslDate > 0
            dtmStrCslDate = dtmEndCslDate
        
        '双方とも指定されている場合、大小逆転時に入れ替えを行う
        Case Else
            If dtmEndCslDate < dtmStrCslDate Then
                dtmDate = dtmStrCslDate
                dtmStrCslDate = dtmEndCslDate
                dtmEndCslDate = dtmDate
            End If

    End Select
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "STRCSLDATE", dtmStrCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDCSLDATE", dtmEndCslDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "CSCD", strCsCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "GRPCD", strGrpCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ITEMCD", strItemCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RSVNO", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "STARTPOS", lngStartPos, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ENDPOS", (lngStartPos + lngGetCount - 1), ORAPARM_INPUT, ORATYPE_NUMBER
    
'## 2013/04/15 Add By 張 検索条件に「受診区分」追加 START ################################################################
    objOraParam.Add "CSLDIVCD", strCslDivCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2013/04/15 Add By 張 検索条件に「受診区分」追加 END   ################################################################

    'オブジェクトの参照設定
    Set objParaRsvNo = objOraParam("RSVNO")

    '(SQLステートメント２)指定予約番号の追加検査情報を「オプション検査」「その他追加項目」「削除項目」の順に取得する
    '(列:ADDDIVの昇順でSORTされることを利用する)
    strstmt2 = "SELECT ADDDIV, ADDNAME "
    
    'オプション検査情報を「2:全員対象」「1:別途条件指定」「0:希望者のみ」の順に取得する
    strstmt2 = strstmt2 & vbLf & _
               "  FROM ( SELECT CONSULT_O.RSVNO,                              " & vbLf & _
               "                0                     ADDDIV,                 " & vbLf & _
               "                0                     ADDORDER,               " & vbLf & _
               "                CONSULT_O.OPTCD       ADDCODE,                " & vbLf & _
               "                CONSULT_O.OPTBRANCHNO ADDCODE2,               " & vbLf & _
               "                CTRPT_OPT.OPTNAME     ADDNAME                 " & vbLf & _
               "           FROM CTRPT_OPT, CONSULT_O                          " & vbLf & _
               "          WHERE CONSULT_O.CTRPTCD     = CTRPT_OPT.CTRPTCD     " & vbLf & _
               "            AND CONSULT_O.OPTCD       = CTRPT_OPT.OPTCD       " & vbLf & _
               "            AND CONSULT_O.OPTBRANCHNO = CTRPT_OPT.OPTBRANCHNO "

    '追加グループ情報を取得
    '最終的に「追加グループ」「追加検査項目」「削除グループ」「削除項目」の順に並ぶよう、ADDDIV, ADDORDERを設定
    strstmt2 = strstmt2 & vbLf & _
               "          UNION                                              " & vbLf & _
               "         SELECT CONSULT_G.RSVNO,                             " & vbLf & _
               "                DECODE(CONSULT_G.EDITFLG, 1, 1, 2) ADDDIV,   " & vbLf & _
               "                0                                  ADDORDER, " & vbLf & _
               "                CONSULT_G.GRPCD                    ADDCODE,  " & vbLf & _
               "                0                                  ADDCODE2, " & vbLf & _
               "                GRP_P.GRPNAME                      ADDNAME   " & vbLf & _
               "           FROM GRP_P, CONSULT_G                             " & vbLf & _
               "          WHERE CONSULT_G.GRPCD = GRP_P.GRPCD                "
           
    '追加検査項目情報を取得
    '最終的に「追加グループ」「追加検査項目」「削除グループ」「削除項目」の順に並ぶよう、ADDDIV, ADDORDERを設定
    strstmt2 = strstmt2 & vbLf & _
               "          UNION " & vbLf & _
               "         SELECT CONSULT_I.RSVNO,                             " & vbLf & _
               "                DECODE(CONSULT_I.EDITFLG, 1, 1, 2) ADDDIV,   " & vbLf & _
               "                1                                  ADDORDER, " & vbLf & _
               "                CONSULT_I.ITEMCD                   ADDCODE,  " & vbLf & _
               "                0                                  ADDCODE2, " & vbLf & _
               "                ITEM_P.REQUESTNAME                 ADDNAME   " & vbLf & _
               "           FROM ITEM_P, CONSULT_I                            " & vbLf & _
               "          WHERE CONSULT_I.ITEMCD = ITEM_P.ITEMCD             " & vbLf & _
               "       )                                                     " & vbLf & _
               " WHERE RSVNO = :RSVNO                                        "
    
    '(SQLステートメント３)指定予約番号の受診項目を取得する
    strStmt3 = "SELECT DISTINCT                               " & vbLf & _
               "       CONSULTITEMLIST.ITEMCD,                " & vbLf & _
               "       ITEM_P.REQUESTNAME                     " & vbLf & _
               "  FROM ITEM_P, CONSULTITEMLIST                " & vbLf & _
               " WHERE CONSULTITEMLIST.RSVNO  = :RSVNO        " & vbLf & _
               "   AND CONSULTITEMLIST.ITEMCD = ITEM_P.ITEMCD "
    
    '(SQLステートメント４)サブコース用取得用のSQLステートメント編集
    strStmt4 = EditSelectSubCourseStatement()
    
    '検索キーから条件節に変換
    If strKey <> "" Then
'## 2004.01.03 Mod By T.Takagi@FSIT 当日ID検索機能追加
'        strCondition = CreateConditionForDailyList(strKey, blnExistsRsvNo)
'        strCondition = CreateConditionForDailyList(strKey, blnExistsRsvNo, blnExistsDayId)
        
'### 2006.08.03 Mod By 張 ＯＣＲ番号、ロッカー番号検索機能追加 ###
        strCondition = CreateConditionForDailyList(strKey, blnExistsRsvNo, blnExistsDayId, blnExistsOcrNo, blnExistsLockerKey)

        '条件に当日ＩＤがあり、かつ受診日未指定ならば以後システム日付のみで扱う
'### 2006.08.03 Mod By 張 ＯＣＲ番号、ロッカー番号検索機能追加 ###
'        If blnExistsDayId And dtmStrCslDate = 0 And dtmEndCslDate = 0 Then
        If (blnExistsDayId Or blnExistsOcrNo Or blnExistsLockerKey) And dtmStrCslDate = 0 And dtmEndCslDate = 0 Then
            dtmStrCslDate = Date
            dtmEndCslDate = Date
            objOraParam("STRCSLDATE").Value = dtmStrCslDate
            objOraParam("ENDCSLDATE").Value = dtmEndCslDate
        End If
'## 2004.01.03 Mod End
    End If
    
    '(SQLステートメント１)件数取得と実データ取得という２回分のSQL発行
    For lngPhase = 0 To 1

        Select Case lngPhase
        
            Case 0  '件数取得の場合
            
                '検索ベース基本表の件数をとる
                strStmt = "SELECT COUNT(*) "
                
            Case 1  '実データ取得の場合
            
                '指定条件を満たす受診情報を取得する
                strStmt = "SELECT SEQPERCONSULT.* "
            
                'コース情報が必要な場合は列を追加する
                If blnCourse Then
                    strStmt = RTrim(strStmt) & "," & vbLf & _
                          "       COURSE_P.WEBCOLOR, COURSE_P.CSNAME "
                Else
                    strStmt = RTrim(strStmt) & "," & vbLf & _
                          "       '' WEBCOLOR, '' CSNAME "
                End If
                  
                'SEQ付き検索ベース基本表を作成
                strStmt = strStmt & vbLf & _
                          "  FROM ( SELECT ROWNUM SEQ, PERCONSULT.* "
                          
                'ソート後の検索ベース基本表を作成
                strStmt = strStmt & vbLf & _
                          "           FROM ( SELECT * "
        
        End Select
        
        '検索ベースとなる基本表を作成
'## 2004/01/20 Add By K.Kagawa@FFCS 同伴者追加
'        strStmt = strStmt & vbLf & "           FROM ( SELECT CONSULT.RSVNO,         CONSULT.CANCELFLG,     " & vbLf & _
'                                   "                         CONSULT.CSLDATE,       CONSULT.CSCD,          " & vbLf & _
'                                   "                         CONSULT.RSVDATE,       CONSULT.RSVGRPCD,      " & vbLf & _
'                                   "                         CONSULT.AGE,           CONSULT.ISRSIGN,       " & vbLf & _
'                                   "                         CONSULT.ISRNO,         CONSULT.RSVSTATUS,     " & vbLf & _
'                                   "                         CONSULT.CARDPRINTDATE, CONSULT.FORMPRINTDATE, " & vbLf & _
'                                   "                         PERSON.PERID,          PERSON.LASTNAME,       " & vbLf & _
'                                   "                         PERSON.FIRSTNAME,      PERSON.LASTKNAME,      " & vbLf & _
'                                   "                         PERSON.FIRSTKNAME,     PERSON.BIRTH,          " & vbLf & _
'                                   "                         PERSON.GENDER                                 "
        strStmt = strStmt & vbLf & "           FROM ( SELECT CONSULT.RSVNO,         CONSULT.CANCELFLG,     " & vbLf & _
                                   "                         CONSULT.CSLDATE,       CONSULT.CSCD,          " & vbLf & _
                                   "                         CONSULT.RSVDATE,       CONSULT.RSVGRPCD,      " & vbLf & _
                                   "                         CONSULT.AGE,           CONSULT.ISRSIGN,       " & vbLf & _
                                   "                         CONSULT.ISRNO,         CONSULT.RSVSTATUS,     " & vbLf & _
                                   "                         CONSULT.CARDPRINTDATE, CONSULT.FORMPRINTDATE, " & vbLf & _
                                   "                         PERSON.PERID,          PERSON.LASTNAME,       " & vbLf & _
                                   "                         PERSON.FIRSTNAME,      PERSON.LASTKNAME,      " & vbLf & _
                                   "                         PERSON.FIRSTKNAME,     PERSON.BIRTH,          " & vbLf & _
                                   "                         PERSON.GENDER,         PERSON.COMPPERID       "
'## 2004/01/20 Add End
    
        '受付情報、団体、事業部、室部、所属は件数取得時には必要ないため、実データ取得時のみ設定
        If lngPhase = 1 Then
        
            '受付情報の列を指定
            strStmt = RTrim(strStmt) & "," & vbLf & "        RECEIPT.DAYID"
        
            '団体略称が必要な場合は列を指定
            If blnOrgSName Then
'## 2003.11.29 Mod by T.Takagi@FSIT 団体「個人受診者」は必ず出す
'                strStmt = RTrim(strStmt) & "," & vbLf & "    CASE WHEN CONSULT.ORGCD1 = '" & strPerOrgCd1 & "' " & vbLf & _
'                                                        "          AND CONSULT.ORGCD2 = '" & strPerOrgCd2 & "' " & vbLf & _
'                                                        "         THEN NULL                                    " & vbLf & _
'                                                        "         ELSE ORG.ORGSNAME                            " & vbLf & _
'                                                        "    END ORGSNAME,                                     " & vbLf & _
'                                                        "    CASE WHEN CONSULT.ORGCD1 = '" & strPerOrgCd1 & "' " & vbLf & _
'                                                        "          AND CONSULT.ORGCD2 = '" & strPerOrgCd2 & "' " & vbLf & _
'                                                        "         THEN NULL                                    " & vbLf & _
'                                                        "         ELSE ORG.ORGKNAME                            " & vbLf & _
'                                                        "    END ORGKNAME                                      "
                strStmt = RTrim(strStmt) & "," & vbLf & "    ORG.ORGSNAME, ORG.ORGKNAME"
'## 2003.11.29 Mod End
            Else
                strStmt = RTrim(strStmt) & "," & vbLf & "    '' ORGSNAME, '' ORGKNAME"
            End If
            
            '結果入力状態が必要な場合は関数を追加
            If blnEntry Then
                strStmt = RTrim(strStmt) & "," & vbLf & "    CheckResultPackage.CheckExistsNoResult(CONSULT.RSVNO) ENTRY"
            Else
                strStmt = RTrim(strStmt) & "," & vbLf & "    '' ENTRY"
            End If
            
            '予約群が必要な場合は追加
            If blnRsvGrp Then
                strStmt = RTrim(strStmt) & "," & vbLf & "    RSVGRP.RSVGRPNAME "
            Else
                strStmt = RTrim(strStmt) & "," & vbLf & "    '' RSVGRPNAME "
            End If
            
            'お連れ様が必要な場合は追加
            If blnHasFriends Then
                strStmt = RTrim(strStmt) & "," & vbLf & "    ( SELECT COUNT(*)                           " & vbLf & _
                                                        "        FROM FRIENDS                            " & vbLf & _
                                                        "       WHERE RSVNO = CONSULT.RSVNO ) HASFRIENDS "
            Else
                strStmt = RTrim(strStmt) & "," & vbLf & "    '' HASFRIENDS "
            End If

        End If
        
'## 2003.01.03 Mod By T.Takagi@FSIT 絞込み条件追加
'        '個人、受診情報テーブルは必ず必要
'        strStmt = strStmt & vbLf & "                    FROM CONSULT, PERSON"
        strStmt = strStmt & vbLf & "                    FROM RECEIPT, PERSON, CONSULT"
'## 2003.01.03 Mod End
    
        '受付情報、団体、事業部、室部、所属は件数取得時には必要ないため、実データ取得時のみ設定
        If lngPhase = 1 Then
        
'## 2003.01.03 Del By T.Takagi@FSIT 絞込み条件追加
'            '受付情報テーブルを指定
'            strStmt = strStmt & ", RECEIPT"
'## 2003.01.03 Del End
                      
            '団体略称が必要な場合は団体テーブルを指定
            If blnOrgSName Then
                strStmt = strStmt & ", ORG"
            End If
        
            '予約群が必要な場合は予約群テーブルを指定
            If blnRsvGrp Then
                strStmt = strStmt & ", RSVGRP"
            End If
        
        End If
        
        '個人情報、受診情報を結合
        If dtmStrCslDate > 0 Or dtmEndCslDate > 0 Or blnExistsRsvNo = True Then
            strStmt = strStmt & vbLf & "               WHERE PERSON.PERID = CONSULT.PERID "
        Else
            strStmt = strStmt & vbLf & "               WHERE PERSON.PERID = CONSULT.PERID(+) "
        End If
        
'## 2003.01.03 Add By T.Takagi@FSIT 絞込み条件追加
        '受付情報を結合する
        strStmt = strStmt & vbLf & "                     AND CONSULT.RSVNO = RECEIPT.RSVNO(+) AND CONSULT.CSLDATE = RECEIPT.CSLDATE(+) "
'## 2003.01.03 Add End
        
        '受付情報、団体、事業部、室部、所属は件数取得時には必要ないため、実データ取得時のみ設定
        If lngPhase = 1 Then
            
'## 2003.01.03 Del By T.Takagi@FSIT 絞込み条件追加
'            '受付情報を結合する
'            strStmt = strStmt & vbLf & "                 AND CONSULT.RSVNO = RECEIPT.RSVNO(+) AND CONSULT.CSLDATE = RECEIPT.CSLDATE(+) "
'## 2003.01.03 Del End
            
            '団体略称が必要な場合は受診情報と結合
            If blnOrgSName Then
                strStmt = strStmt & vbLf & "             AND CONSULT.ORGCD1 = ORG.ORGCD1(+) " & vbLf & _
                                           "             AND CONSULT.ORGCD2 = ORG.ORGCD2(+) "
            End If
        
            '予約群が必要な場合は予約群テーブルと結合
            If blnRsvGrp Then
                strStmt = strStmt & vbLf & "             AND CONSULT.RSVGRPCD = RSVGRP.RSVGRPCD(+) "
            End If
        
        End If
        
        '開始受診日指定時は条件節に加える
        If dtmStrCslDate > 0 Then
            strStmt = strStmt & vbLf & "                 AND CONSULT.CSLDATE >= :STRCSLDATE "
        End If
        
        '終了受診日指定時は条件節に加える
        If dtmEndCslDate > 0 Then
            strStmt = strStmt & vbLf & "                 AND CONSULT.CSLDATE <= :ENDCSLDATE "
        End If
        
        '検索キー指定時は条件節に加える
        If strCondition <> "" Then
            strStmt = strStmt & vbLf & "                 AND " & strCondition
        End If
        
        'コースコード指定時の条件節追加
        If strCsCd <> "" Then
            
            'コース区分による処理振り分け
            Select Case CLng(vntCsDiv)
            
                '受診情報のコースとして存在可能なメインコースの場合
                Case 0, 1
                    
                    '受診情報による絞込みを行う
                    strStmt = strStmt & vbLf & _
                                       "                 AND CONSULT.CSCD = :CSCD "
        
                '受診情報のコースとして存在しないメインコースの場合
                Case 2
                
                    '受診オプションのメインコースとして存在するかを検索
                    strStmt = strStmt & vbLf & _
                                       "                 AND EXISTS ( SELECT CONSULT_O.RSVNO                               " & vbLf & _
                                       "                                FROM COURSE_P, CTRPT_OPT, CONSULT_O                " & vbLf & _
                                       "                               WHERE CONSULT_O.RSVNO       = CONSULT.RSVNO         " & vbLf & _
                                       "                                 AND CONSULT_O.CTRPTCD     = CTRPT_OPT.CTRPTCD     " & vbLf & _
                                       "                                 AND CONSULT_O.OPTCD       = CTRPT_OPT.OPTCD       " & vbLf & _
                                       "                                 AND CONSULT_O.OPTBRANCHNO = CTRPT_OPT.OPTBRANCHNO " & vbLf & _
                                       "                                 AND CTRPT_OPT.CSCD        = COURSE_P.CSCD         " & vbLf & _
                                       "                                 AND COURSE_P.MAINCSCD     = :CSCD )               "
    
                'サブコースの場合
                Case 3
        
                    '指定サブコースを受診するか検索
                    strStmt = strStmt & vbLf & _
                                       "                 AND ConsultPackageLukes.ExistsSubCourse(CONSULT.RSVNO, :CSCD) = 1 "
    
            End Select
            
        End If
        
        '団体コード指定時は条件節に加える
        If strOrgCd1 <> "" And strOrgCd2 <> "" Then
            strStmt = strStmt & vbLf & "                 AND CONSULT.ORGCD1 = :ORGCD1 AND CONSULT.ORGCD2 = :ORGCD2 "
        End If
        
        'グループコード指定時は条件節に加える
        If strGrpCd <> "" Then
            strStmt = strStmt & vbLf & "                 AND ConsultPackageLukes.ExistsItemInGroup(CONSULT.RSVNO, :GRPCD) = 1 "
        End If
        
        '検査項目コード指定時は条件節に加える
        If strItemCd <> "" Then
            strStmt = strStmt & vbLf & "                 AND ConsultPackageLukes.ExistsItem(CONSULT.RSVNO, :ITEMCD) = 1 "
        End If
        
'## 2003.01.03 Add By T.Takagi@FSIT 絞込み条件追加
        Select Case strRsvStat
            Case "1"    'キャンセルのみ
                strStmt = strStmt & vbLf & "             AND CONSULT.CANCELFLG != " & CONSULT_USED
            Case "2"    '予約のみ
                strStmt = strStmt & vbLf & "             AND CONSULT.CANCELFLG = " & CONSULT_USED & vbLf & _
                                           "             AND RECEIPT.RSVNO IS NULL "
            Case "3"    '受付のみ
'                strStmt = strStmt & vbLf & "             AND EXISTS ( SELECT RSVNO                       " & vbLf & _
'                                           "                                FROM RECEIPT                 " & vbLf & _
'                                           "                               WHERE RSVNO = CONSULT.RSVNO ) "
                strStmt = strStmt & vbLf & "             AND RECEIPT.RSVNO IS NOT NULL "
        End Select

        Select Case strRptStat
            Case "1"    '未来院
                strStmt = strStmt & vbLf & "             AND CONSULT.RSVNO    IS NOT NULL " & vbLf & _
                                           "             AND RECEIPT.COMEDATE IS NULL     "
            Case "2"    '来院済み
                strStmt = strStmt & vbLf & "             AND RECEIPT.COMEDATE IS NOT NULL "
        End Select
'## 2003.01.03 Add End
        
        
'## 2013/04/15 Add By 張 検索条件に「受診区分」追加 START ################################################################
        If strCslDivCd <> "" Then
            strStmt = strStmt & vbLf & "                 AND CONSULT.CSLDIVCD =  :CSLDIVCD"
        End If
'## 2013/04/15 Add By 張 検索条件に「受診区分」追加 END   ################################################################
        
        
        '結果入力状態指定時は条件節に加える
        If strEntry <> "" Then
            strStmt = strStmt & vbLf & "                 AND CheckResultPackage.CheckExistsNoResult(CONSULT.RSVNO) = " & IIf(strEntry = "1", "1", "0")
        End If
        
        '検索ベース基本表の副問い合わせ終了
        strStmt = strStmt & vbLf & _
                  "                                 ) "
        
        '件数取得時はここまでしか必要ないため、以降の処理は実データ取得時のみ行う
        If lngPhase = 1 Then
        
            'ソート順を追加
            strStmt = strStmt & vbLf & EditSortOrder(lngSortKey, lngSortType, vntPrintField)
            
            'ソート後の検索ベース基本表問い合わせ終了
            strStmt = strStmt & vbLf & _
                      "                    ) PERCONSULT"
                      
            'SEQ付き検索ベース基本表の副問い合わせ終了
            strStmt = strStmt & vbLf & _
                      "           ) SEQPERCONSULT"
            
            'コース情報が必要な場合はコーステーブルを指定
            If blnCourse Then
                strStmt = strStmt & ", COURSE_P"
            End If
                      
            strBuffer = "WHERE"
                      
            '取得開始位置が必要な場合は指定する
            If lngStartPos > 0 Then
                strStmt = strStmt & vbLf & strBuffer & " SEQPERCONSULT.SEQ >= :STARTPOS"
                strBuffer = "AND"
            End If
                      
            '取得件数が必要な場合は指定する
            If lngGetCount > 0 Then
                strStmt = strStmt & vbLf & strBuffer & " SEQPERCONSULT.SEQ <= :ENDPOS"
                strBuffer = "AND"
            End If
                      
            'コース情報が必要な場合は結合する
            If blnCourse Then
                strStmt = strStmt & vbLf & strBuffer & " SEQPERCONSULT.CSCD = COURSE_P.CSCD(+) "
            End If
                      
            strStmt = strStmt & vbLf & " ORDER BY SEQ"
    
        End If
        
        '受診情報の取得
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
            Set objRsvNo = objFields("RSVNO")
            Set objCancelFlg = objFields("CANCELFLG")
            Set objCslDate = objFields("CSLDATE")
            Set objPerId = objFields("PERID")
            Set objRsvDate = objFields("RSVDATE")
            Set objAge = objFields("AGE")
            Set objDayId = objFields("DAYID")
            Set objWebColor = objFields("WEBCOLOR")
            Set objCsName = objFields("CSNAME")
            Set objLastName = objFields("LASTNAME")
            Set objFirstName = objFields("FIRSTNAME")
            Set objLastKName = objFields("LASTKNAME")
            Set objFirstKName = objFields("FIRSTKNAME")
            Set objBirth = objFields("BIRTH")
            Set objGender = objFields("GENDER")
            Set objOrgSName = objFields("ORGSNAME")
            Set objIsrSign = objFields("ISRSIGN")
            Set objIsrNo = objFields("ISRNO")
            Set objEntry = objFields("ENTRY")
            Set objRsvStatus = objFields("RSVSTATUS")
            Set objCardPrintDate = objFields("CARDPRINTDATE")
            Set objFormPrintDate = objFields("FORMPRINTDATE")
            Set objRsvGrpName = objFields("RSVGRPNAME")
            Set objHasFriends = objFields("HASFRIENDS")
            Set objCompPerId = objFields("COMPPERID")
    
            '配列形式で格納する
            i = 0
            Do Until objOraDyna.EOF
                
                '配列に追加
                ReDim Preserve vntArrRsvNo(i)
                ReDim Preserve vntArrCancelFlg(i)
                ReDim Preserve vntArrCslDate(i)
                ReDim Preserve vntArrPerId(i)
                ReDim Preserve vntArrDayId(i)
                vntArrRsvNo(i) = objRsvNo.Value
                vntArrCancelFlg(i) = objCancelFlg.Value
                vntArrCslDate(i) = objCslDate.Value
                vntArrPerId(i) = objPerId.Value
                vntArrDayId(i) = Format(objDayId.Value, "0000")
'## 2004/01/20 Add By K.Kagawa@FFCS 同伴者追加
                ReDim Preserve vntArrCompPerId(i)
                vntArrCompPerId(i) = objCompPerId.Value
'## 2004/01/20 Add End
                    
                '以下はフィールド指定状態による配列追加処理
                
                '予約日
                If blnRsvDate Then
                    ReDim Preserve vntArrRsvDate(i)
                    If Not IsNull(objRsvDate.Value) Then
                        vntArrRsvDate(i) = DateValue(objRsvDate.Value)
                    End If
                End If
                    
                '受診時年齢
                If blnAge Then
                    ReDim Preserve vntArrAge(i)
                    If Not IsNull(objAge.Value) Then
                        vntArrAge(i) = Format(objAge.Value, "0.00")
                    End If
                End If
                    
                'コース
                If blnCourse Then
                    ReDim Preserve vntArrWebColor(i)
                    ReDim Preserve vntArrCsName(i)
                    vntArrWebColor(i) = objWebColor.Value & ""
                    vntArrCsName(i) = objCsName.Value & ""
                End If
                
                '氏名
                If blnName Then
                    ReDim Preserve vntArrName(i)
                    vntArrName(i) = Trim(objLastName.Value & "　" & objFirstName.Value)
                End If
                
                'カナ氏名
                If blnKanaName Then
                    ReDim Preserve vntArrKanaName(i)
                    vntArrKanaName(i) = Trim(objLastKName.Value & "　" & objFirstKName.Value)
                End If
                
                '生年月日
                If blnBirth Then
                    ReDim Preserve vntArrBirth(i)
                    vntArrBirth(i) = objBirth.Value
                End If
                
                '性別
                If blnGender Then
                    ReDim Preserve vntArrGender(i)
                    vntArrGender(i) = objGender.Value
                End If
                
                '団体略称
                If blnOrgSName Then
                    ReDim Preserve vntArrOrgSName(i)
                    vntArrOrgSName(i) = objOrgSName.Value & ""
                End If
                
                '健保記号
                If blnIsrSign Then
                    ReDim Preserve vntArrIsrSign(i)
                    vntArrIsrSign(i) = objIsrSign.Value & ""
                End If
    
                '健保番号
                If blnIsrNo Then
                    ReDim Preserve vntArrIsrNo(i)
                    vntArrIsrNo(i) = objIsrNo.Value & ""
                End If
    
                '結果入力状態
                If blnEntry Then
                    ReDim Preserve vntArrEntry(i)
                    vntArrEntry(i) = objEntry.Value & ""
                End If
                
                '予約状況
                If blnRsvStatus Then
                    ReDim Preserve vntArrRsvStatus(i)
                    vntArrRsvStatus(i) = objRsvStatus.Value & ""
                End If
                
                '確認はがき出力日
                If blnCardPrintDate Then
                    ReDim Preserve vntArrCardPrintDate(i)
                    vntArrCardPrintDate(i) = objCardPrintDate.Value & ""
                End If
                
                '一式書式出力日
                If blnFormPrintDate Then
                    ReDim Preserve vntArrFormPrintDate(i)
                    vntArrFormPrintDate(i) = objFormPrintDate.Value & ""
                End If
                
                '予約群
                If blnRsvGrp Then
                    ReDim Preserve vntArrRsvGrpName(i)
                    vntArrRsvGrpName(i) = objRsvGrpName.Value & ""
                End If
                
                'お連れ様有無
                If blnHasFriends Then
                    ReDim Preserve vntArrHasFriends(i)
                    vntArrHasFriends(i) = objHasFriends.Value & ""
                End If
                
                'キー値の設定
                objParaRsvNo.Value = CLng("0" & objRsvNo.Value)
        
                '追加検査情報の編集
                Do
                    
                    '追加検査情報を取得しない場合は処理を抜ける
                    If Not blnAddItem Then
                        Exit Do
                    End If
                    
                    '配列の拡張
                    ReDim Preserve vntArrAddDiv(i)
                    ReDim Preserve vntArrAddName(i)
        
                    '受診情報の存在しない行ならば処理を抜ける
                    If objParaRsvNo.Value = 0 Then
                        Exit Do
                    End If
                    
                    '初めて追加検査を取得する場合
                    If objOraDyna2 Is Nothing Then
                        
                        'ダイナセットを新規作成
                        Set objOraDyna2 = mobjOraDb.CreateDynaset(OmitCharSpc(strstmt2), ORADYN_READONLY + ORADYN_NOCACHE)
                    
                        'オブジェクトの参照設定
                        Set objFields2 = objOraDyna2.Fields
                        Set objAddDiv = objFields2("ADDDIV")
                        Set objAddName = objFields2("ADDNAME")
                        
                    '２回目以降はRefreshで対応
                    Else
                        objOraDyna2.Refresh
                    End If
                
                    '配列形式で格納する
                    lngAddItemCount = 0
                    Do Until objOraDyna2.EOF
                        ReDim Preserve vntArrAddDiv2(lngAddItemCount)
                        ReDim Preserve vntArrAddName2(lngAddItemCount)
                        vntArrAddDiv2(lngAddItemCount) = objAddDiv.Value
                        vntArrAddName2(lngAddItemCount) = objAddName.Value
                        lngAddItemCount = lngAddItemCount + 1
                        objOraDyna2.MoveNext
                    Loop
                    
                    '追加検査情報が存在する場合はカンマ区切りで結合して格納する
                    If lngAddItemCount > 0 Then
                        vntArrAddDiv(i) = Join(vntArrAddDiv2, ",")
                        vntArrAddName(i) = Join(vntArrAddName2, ",")
                    End If
                        
                    Exit Do
                Loop
    
                '受診項目情報の取得
                Do
                    
                    '受診項目情報を取得しない場合は処理を抜ける
                    If Not blnConsultItem Then
                        Exit Do
                    End If
                    
                    '配列の拡張
                    ReDim Preserve vntArrRequestName(i)
        
                    '受診情報の存在しない行ならば処理を抜ける
                    If objParaRsvNo.Value = 0 Then
                        Exit Do
                    End If
                    
                    '初めて受診項目を取得する場合
                    If objOraDyna3 Is Nothing Then
                        
                        'ダイナセットを新規作成
                        Set objOraDyna3 = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt3), ORADYN_READONLY + ORADYN_NOCACHE)
                    
                        'オブジェクトの参照設定
                        Set objFields3 = objOraDyna3.Fields
                        Set objRequestName = objFields3("REQUESTNAME")
                    
                    '２回目以降はRefreshで対応
                    Else
                        objOraDyna3.Refresh
                    End If
                
                    '配列形式で格納する
                    lngConsultItemCount = 0
                    Do Until objOraDyna3.EOF
                        ReDim Preserve vntArrRequestName2(lngConsultItemCount)
                        vntArrRequestName2(lngConsultItemCount) = objRequestName.Value & ""
                        lngConsultItemCount = lngConsultItemCount + 1
                        objOraDyna3.MoveNext
                    Loop
                    
                    '受診項目情報が存在する場合はカンマ区切りで結合して格納する
                    If lngConsultItemCount > 0 Then
                        vntArrRequestName(i) = Join(vntArrRequestName2, ",")
                    End If
                        
                    Exit Do
                Loop
                    
                'サブコースの取得
                Do
                
                    'サブコースを取得しない場合は処理を抜ける
                    If Not blnSubCourse Then
                        Exit Do
                    End If
                    
                    '配列の拡張
                    ReDim Preserve vntArrSubCsWebColor(i)
                    ReDim Preserve vntArrSubCsName(i)
        
                    '受診情報の存在しない行ならば処理を抜ける
                    If objParaRsvNo.Value = 0 Then
                        Exit Do
                    End If
                    
                    '初めてサブコースを取得する場合
                    If objOraDyna4 Is Nothing Then
                        
                        'ダイナセットを新規作成
                        Set objOraDyna4 = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt4), ORADYN_READONLY + ORADYN_NOCACHE)
                    
                        'オブジェクトの参照設定
                        Set objFields4 = objOraDyna4.Fields
                        Set objSubCsWebColor = objFields4("WEBCOLOR")
                        Set objSubCsName = objFields4("CSNAME")
                    
                    '２回目以降はRefreshで対応
                    Else
                        objOraDyna4.Refresh
                    End If
                
                    '配列形式で格納する
                    lngSubCourseCount = 0
                    Do Until objOraDyna4.EOF
                        ReDim Preserve vntArrSubCsWebColor2(lngSubCourseCount)
                        ReDim Preserve vntArrSubCsName2(lngSubCourseCount)
                        vntArrSubCsWebColor2(lngSubCourseCount) = objSubCsWebColor.Value & ""
                        vntArrSubCsName2(lngSubCourseCount) = objSubCsName.Value & ""
                        lngSubCourseCount = lngSubCourseCount + 1
                        objOraDyna4.MoveNext
                    Loop
                    
                    'サブコースが存在する場合はカンマ区切りで結合して格納する
                    If lngSubCourseCount > 0 Then
                        vntArrSubCsWebColor(i) = Join(vntArrSubCsWebColor2, ",")
                        vntArrSubCsName(i) = Join(vntArrSubCsName2, ",")
                    End If
                    
                    Exit Do
                Loop
                
                i = i + 1
                objOraDyna.MoveNext
            Loop
        
            '戻り値の設定
            If Not IsMissing(vntRsvNo) Then vntRsvNo = vntArrRsvNo
            If Not IsMissing(vntCancelFlg) Then vntCancelFlg = vntArrCancelFlg
            If Not IsMissing(vntCslDate) Then vntCslDate = vntArrCslDate
            If Not IsMissing(vntPerId) Then vntPerId = vntArrPerId
            If Not IsMissing(vntRsvDate) Then vntRsvDate = vntArrRsvDate
            If Not IsMissing(vntAge) Then vntAge = vntArrAge
            If Not IsMissing(vntDayId) Then vntDayId = vntArrDayId
            If Not IsMissing(vntWebColor) Then vntWebColor = vntArrWebColor
            If Not IsMissing(vntCsName) Then vntCsName = vntArrCsName
            If Not IsMissing(vntName) Then vntName = vntArrName
            If Not IsMissing(vntKanaName) Then vntKanaName = vntArrKanaName
            If Not IsMissing(vntBirth) Then vntBirth = vntArrBirth
            If Not IsMissing(vntGender) Then vntGender = vntArrGender
            If Not IsMissing(vntOrgSName) Then vntOrgSName = vntArrOrgSName
            If Not IsMissing(vntAddDiv) Then vntAddDiv = vntArrAddDiv
            If Not IsMissing(vntAddName) Then vntAddName = vntArrAddName
            If Not IsMissing(vntRequestName) Then vntRequestName = vntArrRequestName
            If Not IsMissing(vntIsrSign) Then vntIsrSign = vntArrIsrSign
            If Not IsMissing(vntIsrNo) Then vntIsrNo = vntArrIsrNo
            If Not IsMissing(vntSubCsWebColor) Then vntSubCsWebColor = vntArrSubCsWebColor
            If Not IsMissing(vntSubCsName) Then vntSubCsName = vntArrSubCsName
            If Not IsMissing(vntEntry) Then vntEntry = vntArrEntry
            If Not IsMissing(vntRsvStatus) Then vntRsvStatus = vntArrRsvStatus
            If Not IsMissing(vntCardPrintDate) Then vntCardPrintDate = vntArrCardPrintDate
            If Not IsMissing(vntFormPrintDate) Then vntFormPrintDate = vntArrFormPrintDate
            If Not IsMissing(vntRsvGrpName) Then vntRsvGrpName = vntArrRsvGrpName
            If Not IsMissing(vntHasFriends) Then vntHasFriends = vntArrHasFriends
'## 2004/01/20 Add By K.Kagawa@FFCS 同伴者追加
            If Not IsMissing(vntCompPerId) Then vntCompPerId = vntArrCompPerId
'## 2004/01/20 Add By End
        
            Exit Do
        Loop
        
        '件数取得にて０件の場合は処理を終了する
        If lngPhase = 0 And lngCount = 0 Then
            Exit For
        End If
        
    Next lngPhase

    Set objRsvNo = Nothing
    Set objCancelFlg = Nothing
    Set objCslDate = Nothing
    Set objPerId = Nothing
    Set objRsvDate = Nothing
    Set objAge = Nothing
    Set objDayId = Nothing
    Set objWebColor = Nothing
    Set objCsName = Nothing
    Set objLastName = Nothing
    Set objFirstName = Nothing
    Set objLastKName = Nothing
    Set objFirstKName = Nothing
    Set objBirth = Nothing
    Set objGender = Nothing
    Set objOrgSName = Nothing
    Set objAddDiv = Nothing
    Set objAddName = Nothing
    Set objRequestName = Nothing
    Set objIsrSign = Nothing
    Set objIsrNo = Nothing
    Set objSubCsWebColor = Nothing
    Set objSubCsName = Nothing
    Set objEntry = Nothing
    Set objRsvStatus = Nothing
    Set objCardPrintDate = Nothing
    Set objFormPrintDate = Nothing
    Set objFields4 = Nothing
    Set objFields3 = Nothing
    Set objFields2 = Nothing
    Set objFields = Nothing
    Set objOraDyna4 = Nothing
    Set objOraDyna3 = Nothing
    Set objOraDyna2 = Nothing
    Set objOraDyna = Nothing
    Set objParaRsvNo = Nothing

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    Set objOraParam = Nothing

    '戻り値の設定
    SelectDailyList = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectDailyList = -1

    'イベントログ書き込み
    WriteErrorLog "Consult.SelectDailyList"
    
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

'## 2003.11.18 Del by T.Takagi@FSIT 聖路加未対応メソッドのため削除
'
' 機能　　 : 指定オプション検査を追加し、受診情報、金額情報の再作成を行う
'
' 引数　　 : (In)     lngRsvNo    予約番号
' 　　　　   (In)     lngCtrPtCd  契約パターンコード
' 　　　　   (In)     strOptCd    オプションコード(カンマ区切り指定)
'
' 戻り値　 : 予約番号
'
' 備考　　 :
'
'Public Function UpdateConsultWithAddOption(ByVal lngRsvNo As Long, ByVal lngCtrPtcd As Long, ByVal strOptCd As String) As Long
'
'    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
'    Dim strStmt         As String           'SQLステートメント
'
'    Dim objOptCd        As OraParamArray    'オプションコード
'
'    Dim vntOptCd        As Variant          'オプションコード
'    Dim lngOptCount     As Long             'オプション検査数
'
'    Dim Ret             As Long             '関数戻り値
'    Dim i               As Long             'インデックス
'
'    'エラーハンドラの設定
'    On Error GoTo ErrorHandle
'
'    '各種項目数の取得
'    vntOptCd = Split(strOptCd, ",")
'    lngOptCount = GetElementCount(vntOptCd)
'
'    'オプションが１つもなければ終了
'    If lngOptCount = 0 Then
'        UpdateConsultWithAddOption = lngRsvNo
'        Exit Function
'    End If
'
'    'キー及び更新値の設定
'    Set objOraParam = mobjOraDb.Parameters
'    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "CTRPTCD", lngCtrPtcd, ORAPARM_INPUT, ORATYPE_NUMBER
'
'    'オプション検査のバインド変数定義
'    objOraParam.AddTable "OPTCD", ORAPARM_INPUT, ORATYPE_NUMBER, lngOptCount, 3
'    objOraParam.Add "OPTCOUNT", lngOptCount, ORAPARM_INPUT, ORATYPE_NUMBER
'
'    '戻り値のバインド変数定義
'    objOraParam.Add "MESSAGE", "", ORAPARM_OUTPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
'
'    'オブジェクトの参照設定
'    Set objOptCd = objOraParam("OPTCD")
'
'    'オプションコードの編集
'    For i = 0 To UBound(vntOptCd)
'        objOptCd(i) = vntOptCd(i)
'    Next i
'
'    '受診情報登録用ストアドパッケージの関数呼び出し
'    strStmt = "BEGIN :RET := ConsultPackage.UpdateConsultWithAddOption(:RSVNO, :CTRPTCD, :OPTCD, :OPTCOUNT, :MESSAGE); END;"
'
'    'PL/SQL文の実行
'    'mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
'
'    '戻り値の取得
'    'Ret = objOraParam("RET").Value
'
'    'トランザクション制御
'    If Ret > 0 Then
'        mobjContext.SetComplete
'    Else
'        mobjContext.SetAbort
'    End If
'
'    'バインド変数の削除
'    Do Until objOraParam.Count <= 0
'        objOraParam.Remove (objOraParam.Count - 1)
'    Loop
'
'    '戻り値の設定
'    UpdateConsultWithAddOption = Ret
'
'    Exit Function
'
'ErrorHandle:
'
'    'イベントログ書き込み
'    WriteErrorLog "Consult.UpdateConsultWithAddOption"
'
'    'エラー発生時はトランザクションをアボートに設定
'    mobjContext.SetAbort
'
'    'エラーをもう一回引き起こす
'    Err.Raise Err.Number, Err.Source, Err.Description
'
'End Function

'## 2003.11.18 Del by T.Takagi@FSIT 聖路加未対応メソッドのため削除
'
' 機能　　 : 指定請求明細分類のオプション検査を削除し、受診情報、金額情報の再作成を行う
'
' 引数　　 : (In)     lngRsvNo           予約番号
' 　　　　   (In)     strDmdLineClassCd  請求明細分類コード
' 　　　　   (In)     vntCtrPtCd         削除された時点での契約パターンコード
' 　　　　   (In)     vntDelOptCd        削除されたオプションコード
'
' 戻り値　 : 予約番号
'
' 備考　　 :
'
'Public Function UpdateConsultWithDelOption(ByVal lngRsvNo As Long, ByVal strDmdLineClassCd As String, ByRef vntCtrPtCd As Variant, ByRef vntDelOptCd As Variant) As Long
'
'    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
'    Dim strStmt         As String           'SQLステートメント
'
'    Dim lngCtrPtcd      As Long             '契約パターンコード
'    Dim strDelOptCd     As String           '削除されたオプションコード
'    Dim Ret             As Long             '関数戻り値
'
'    'エラーハンドラの設定
'    On Error GoTo ErrorHandle
'
'    '初期処理
'    vntCtrPtCd = Empty
'    vntDelOptCd = Empty
'
'    'キー及び更新値の設定
'    Set objOraParam = mobjOraDb.Parameters
'    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "DMDLINECLASSCD", strDmdLineClassCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
'
'    '戻り値のバインド変数定義
'    objOraParam.Add "CTRPTCD", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
'    objOraParam.Add "DELOPTCD", "", ORAPARM_OUTPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "MESSAGE", "", ORAPARM_OUTPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
'
'    '受診情報登録用ストアドパッケージの関数呼び出し
'    'strStmt = "BEGIN :RET := ConsultPackage.UpdateConsultWithDelOption(:RSVNO, :DMDLINECLASSCD, :CTRPTCD, :DELOPTCD, :MESSAGE); END;"
'
'    'PL/SQL文の実行
'    'mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
'
'    '戻り値の取得
'    'lngCtrPtCd = CLng("0" & objOraParam("CTRPTCD").Value)
'    'strDelOptCd = objOraParam("DELOPTCD").Value & ""
'    'Ret = objOraParam("RET").Value
'
'    'トランザクション制御
'    If Ret > 0 Then
'        mobjContext.SetComplete
'    Else
'        mobjContext.SetAbort
'    End If
'
'    'バインド変数の削除
'    Do Until objOraParam.Count <= 0
'        objOraParam.Remove (objOraParam.Count - 1)
'    Loop
'
'    '戻り値の設定
'    vntCtrPtCd = lngCtrPtcd
'    vntDelOptCd = strDelOptCd
'    UpdateConsultWithDelOption = Ret
'
'    Exit Function
'
'ErrorHandle:
'
'    'イベントログ書き込み
'    WriteErrorLog "Consult.UpdateConsultWithDelOption"
'
'    'エラー発生時はトランザクションをアボートに設定
'    mobjContext.SetAbort
'
'    'エラーをもう一回引き起こす
'    Err.Raise Err.Number, Err.Source, Err.Description
'
'End Function

'
' 機能　　 : お連れ様情報を取得する
'
' 引数　　 : (In)     dtmCslDate          受診日
' 　　　　   (In)     lngRsvNo            予約番号
' 　　　　   (Out)    vntCslDate          受診日
' 　　　　   (Out)    vntSeq              お連れ様Seq
' 　　　　   (Out)    vntRsvNo            予約番号
' 　　　　   (Out)    vntSameGrp1         面接同時受診１
' 　　　　   (Out)    vntSameGrp2         面接同時受診２
' 　　　　   (Out)    vntSameGrp3         面接同時受診３
' 　　　　   (Out)    vntPerId            個人ＩＤ
' 　　　　   (Out)    vntCsCd             コースコード
' 　　　　   (Out)    vntCsName           コース名
' 　　　　   (Out)    vntOrgCd1           団体コード1
' 　　　　   (Out)    vntOrgCd2           団体コード2
' 　　　　   (Out)    vntOrgName          団体名称
' 　　　　   (Out)    vntOrgSName         団体略称
' 　　　　   (Out)    vntLastName         姓
' 　　　　   (Out)    vntFirstName     　 名
' 　　　　   (Out)    vntLastKName        カナ姓
' 　　　　   (Out)    vntFirstKName    　 カナ名
' 　　　　   (Out)    vntDayId            当日ＩＤ
' 　　　　   (Out)    vntRsvGrpName       予約群名称
' 　　　　   (Out)    vntCompPerId        同伴者個人ＩＤ    '2004/01/20 Add By K.Kagawa@FFCS
' 　　　　   (Out)    vntCancelFlg        キャンセルフラグ  '2004/04/20 Add By T.Takagi@FSIT
' 　　　　   (Out)    vntRsvGrpCd         予約群コード      '2004/04/20 Add By T.Takagi@FSIT
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
'Public Function SelectFriends(
'    ByVal dtmCslDate As Date,
'    Optional ByVal lngRsvNo As Long,
'    Optional ByRef vntCslDate As Variant, Optional ByRef vntSeq As Variant, Optional ByRef vntRsvNo As Variant,
'    Optional ByRef vntSameGrp1 As Variant, Optional ByRef vntSameGrp2 As Variant, Optional ByRef vntSameGrp3 As Variant,
'    Optional ByRef vntPerId As Variant, Optional ByRef vntCsCd As Variant, Optional ByRef vntCsName As Variant,
'    Optional ByRef vntOrgCd1 As Variant, Optional ByRef vntOrgCd2 As Variant, Optional ByRef vntOrgName As Variant, Optional ByRef vntOrgSName As Variant,
'    Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant, Optional ByRef vntLastKName As Variant, Optional ByRef vntFirstKName As Variant,
'    Optional ByRef vntDayId As Variant, Optional ByRef vntRsvGrpName As Variant
') As Long
'## 2004/01/20 Add By K.Kagawa@FFCS 同伴者追加
'## 2004/04/20 Mod By T.Takagi@FSIT 受診日一括変更(キャンセルフラグ・予約群コード追加)
'Public Function SelectFriends(
'    ByVal dtmCslDate As Date,
'    Optional ByVal lngRsvNo As Long,
'    Optional ByRef vntCslDate As Variant, Optional ByRef vntSeq As Variant, Optional ByRef vntRsvNo As Variant,
'    Optional ByRef vntSameGrp1 As Variant, Optional ByRef vntSameGrp2 As Variant, Optional ByRef vntSameGrp3 As Variant,
'    Optional ByRef vntPerId As Variant, Optional ByRef vntCsCd As Variant, Optional ByRef vntCsName As Variant,
'    Optional ByRef vntOrgCd1 As Variant, Optional ByRef vntOrgCd2 As Variant, Optional ByRef vntOrgName As Variant, Optional ByRef vntOrgSName As Variant,
'    Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant, Optional ByRef vntLastKName As Variant, Optional ByRef vntFirstKName As Variant,
'    Optional ByRef vntDayId As Variant, Optional ByRef vntRsvGrpName As Variant, Optional ByRef vntCompPerId As Variant
') As Long
Public Function SelectFriends( _
    ByVal dtmCslDate As Date, _
    Optional ByVal lngRsvNo As Long, _
    Optional ByRef vntCslDate As Variant, Optional ByRef vntSeq As Variant, Optional ByRef vntRsvNo As Variant, _
    Optional ByRef vntSameGrp1 As Variant, Optional ByRef vntSameGrp2 As Variant, Optional ByRef vntSameGrp3 As Variant, _
    Optional ByRef vntPerId As Variant, Optional ByRef vntCsCd As Variant, Optional ByRef vntCsName As Variant, _
    Optional ByRef vntOrgCd1 As Variant, Optional ByRef vntOrgCd2 As Variant, Optional ByRef vntOrgName As Variant, Optional ByRef vntOrgSName As Variant, _
    Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant, Optional ByRef vntLastKName As Variant, Optional ByRef vntFirstKName As Variant, _
    Optional ByRef vntDayId As Variant, Optional ByRef vntRsvGrpName As Variant, Optional ByRef vntCompPerId As Variant, _
    Optional ByRef vntCancelFlg As Variant, Optional ByRef vntRsvGrpCd As Variant _
) As Long
'## 2004/04/20 Mod End
'## 2004/01/20 Add End

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objCslDate          As OraField         '受診日
    Dim objSeq              As OraField         'お連れ様Seq
    Dim objRsvNo            As OraField         '予約番号
    Dim objSameGrp1         As OraField         '面接同時受診１
    Dim objSameGrp2         As OraField         '面接同時受診２
    Dim objSameGrp3         As OraField         '面接同時受診３
    Dim objPerId            As OraField         '個人ＩＤ
    Dim objCsCd             As OraField         'コースコード
    Dim objCsName           As OraField         'コース名
    Dim objOrgCd1           As OraField         '団体コード1
    Dim objOrgCd2           As OraField         '団体コード2
    Dim objOrgName          As OraField         '団体名称
    Dim objOrgSName         As OraField         '団体略称
    Dim objLastName         As OraField         '姓
    Dim objFirstName        As OraField         '名
    Dim objLastKName        As OraField         'カナ姓
    Dim objFirstKName       As OraField         'カナ名
    Dim objDayId            As OraField         '当日ＩＤ
    Dim objRsvGrpName       As OraField         '予約群名称
'## 2004/01/20 Add By K.Kagawa@FFCS 同伴者追加
    Dim objCompPerId        As OraField         '同伴者個人ＩＤ
'## 2004/01/20 Add End
    
    Dim vntArrCslDate()     As Variant          '受診日の配列
    Dim vntArrSeq()         As Variant          'お連れ様Seqの配列
    Dim vntArrRsvNo()       As Variant          '予約番号の配列
    Dim vntArrSameGrp1()    As Variant          '面接同時受診１の配列
    Dim vntArrSameGrp2()    As Variant          '面接同時受診２の配列
    Dim vntArrSameGrp3()    As Variant          '面接同時受診３の配列
    Dim vntArrPerId()       As Variant          '個人ＩＤの配列
    Dim vntArrCsCd()        As Variant          'コースコードの配列
    Dim vntArrCsName()      As Variant          'コース名の配列
    Dim vntArrOrgCd1()      As Variant          '団体コード1の配列
    Dim vntArrOrgCd2()      As Variant          '団体コード2の配列
    Dim vntArrOrgName()     As Variant          '団体名称の配列
    Dim vntArrOrgSName()    As Variant          '団体略称の配列
    Dim vntArrLastName()    As Variant          '姓の配列
    Dim vntArrFirstName()   As Variant          '名の配列
    Dim vntArrLastKName()   As Variant          'カナ姓の配列
    Dim vntArrFirstKName()  As Variant          'カナ名の配列
    Dim vntArrDayId()       As Variant          '当日ＩＤの配列
    Dim vntArrRsvGrpName()  As Variant          '予約群名称の配列
'## 2004/01/20 Add By K.Kagawa@FFCS 同伴者追加
    Dim vntArrCompPerId()   As Variant          '同伴者個人ＩＤの配列
'## 2004/01/20 Add End

    Dim lngCount            As Long             'レコード件数

'## 2004/04/20 Add By T.Takagi@FSIT 受診日一括変更(キャンセルフラグ・予約群コード追加)
    Dim objCancelFlg        As OraField         'キャンセルフラグ
    Dim objRsvGrpCd         As OraField         '予約群コード
    Dim vntArrCancelFlg()   As Variant          'キャンセルフラグの配列
    Dim vntArrRsvGrpCd()    As Variant          '予約群コードの配列
'## 2004/04/20 Add End

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntCslDate) Then vntCslDate = Empty
    If Not IsMissing(vntSeq) Then vntSeq = Empty
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If Not IsMissing(vntSameGrp1) Then vntSameGrp1 = Empty
    If Not IsMissing(vntSameGrp2) Then vntSameGrp2 = Empty
    If Not IsMissing(vntSameGrp3) Then vntSameGrp3 = Empty
    If Not IsMissing(vntPerId) Then vntPerId = Empty
    If Not IsMissing(vntCsCd) Then vntCsCd = Empty
    If Not IsMissing(vntCsName) Then vntCsName = Empty
    If Not IsMissing(vntOrgCd1) Then vntOrgCd1 = Empty
    If Not IsMissing(vntOrgCd2) Then vntOrgCd2 = Empty
    If Not IsMissing(vntOrgName) Then vntOrgName = Empty
    If Not IsMissing(vntOrgSName) Then vntOrgSName = Empty
    If Not IsMissing(vntLastName) Then vntLastName = Empty
    If Not IsMissing(vntFirstName) Then vntFirstName = Empty
    If Not IsMissing(vntLastKName) Then vntLastKName = Empty
    If Not IsMissing(vntFirstKName) Then vntFirstKName = Empty
    If Not IsMissing(vntDayId) Then vntDayId = Empty
    If Not IsMissing(vntRsvGrpName) Then vntRsvGrpName = Empty
'## 2004/01/20 Add By K.Kagawa@FFCS 同伴者追加
    If Not IsMissing(vntCompPerId) Then vntCompPerId = Empty
'## 2004/01/20 Add End
'## 2004/04/20 Add By T.Takagi@FSIT 受診日一括変更(キャンセルフラグ・予約群コード追加)
    If Not IsMissing(vntCancelFlg) Then vntCancelFlg = Empty
    If Not IsMissing(vntRsvGrpCd) Then vntRsvGrpCd = Empty
'## 2004/04/20 Add End

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
    If Not IsMissing(lngRsvNo) Then
        objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    End If

    '検索条件を満たすお連れ様情報と一致する受診者情報を取得する
'## 2004/01/20 Add By K.Kagawa@FFCS 同伴者追加
'    strStmt = "SELECT FRIENDSLIST.CSLDATE,                " & vbLf & _
'              "       FRIENDSLIST.SEQ,                    " & vbLf & _
'              "       FRIENDSLIST.RSVNO,                  " & vbLf & _
'              "       FRIENDS.SAMEGRP1,                   " & vbLf & _
'              "       FRIENDS.SAMEGRP2,                   " & vbLf & _
'              "       FRIENDS.SAMEGRP3,                   " & vbLf & _
'              "       CONSULT.PERID,                      " & vbLf & _
'              "       CONSULT.CSCD,                       " & vbLf & _
'              "       COURSE_P.CSNAME,                    " & vbLf & _
'              "       CONSULT.ORGCD1,                     " & vbLf & _
'              "       CONSULT.ORGCD2,                     " & vbLf & _
'              "       ORG.ORGNAME,                        " & vbLf & _
'              "       ORG.ORGSNAME,                       " & vbLf & _
'              "       PERSON.LASTNAME,                    " & vbLf & _
'              "       PERSON.FIRSTNAME,                   " & vbLf & _
'              "       PERSON.LASTKNAME,                   " & vbLf & _
'              "       PERSON.FIRSTKNAME,                  " & vbLf & _
'              "       RECEIPT.DAYID,                      " & vbLf & _
'              "       RSVGRP.RSVGRPNAME                   "
    strStmt = "SELECT FRIENDSLIST.CSLDATE,                " & vbLf & _
              "       FRIENDSLIST.SEQ,                    " & vbLf & _
              "       FRIENDSLIST.RSVNO,                  " & vbLf & _
              "       FRIENDS.SAMEGRP1,                   " & vbLf & _
              "       FRIENDS.SAMEGRP2,                   " & vbLf & _
              "       FRIENDS.SAMEGRP3,                   " & vbLf & _
              "       CONSULT.PERID,                      " & vbLf & _
              "       CONSULT.CSCD,                       " & vbLf & _
              "       COURSE_P.CSNAME,                    " & vbLf & _
              "       CONSULT.ORGCD1,                     " & vbLf & _
              "       CONSULT.ORGCD2,                     " & vbLf & _
              "       ORG.ORGNAME,                        " & vbLf & _
              "       ORG.ORGSNAME,                       " & vbLf & _
              "       PERSON.LASTNAME,                    " & vbLf & _
              "       PERSON.FIRSTNAME,                   " & vbLf & _
              "       PERSON.LASTKNAME,                   " & vbLf & _
              "       PERSON.FIRSTKNAME,                  " & vbLf & _
              "       PERSON.COMPPERID,                   " & vbLf & _
              "       RECEIPT.DAYID,                      " & vbLf & _
              "       RSVGRP.RSVGRPNAME                   "
'## 2004/01/20 Add End

'## 2004/04/20 Add By T.Takagi@FSIT 受診日一括変更(キャンセルフラグ・予約群コード追加)
    strStmt = RTrim(strStmt) & ", " & vbLf & _
              "       CONSULT.CANCELFLG, " & vbLf & _
              "       CONSULT.RSVGRPCD   "
'## 2004/04/20 Add End

    'CONSULTがFULL SCANになるのでまず内部ビューで(アスタリスク指定で一寸手抜き)
'    strStmt = strStmt & vbLf & _
'              "  FROM FRIENDS, CONSULT,                         " & vbLf & _
'              "       COURSE_P, ORG, PERSON, RECEIPT, RSVGRP,   "
    strStmt = strStmt & vbLf & _
              "  FROM FRIENDS,                                                  " & vbLf & _
              "       (SELECT * FROM CONSULT WHERE CSLDATE = :CSLDATE) CONSULT, " & vbLf & _
              "       COURSE_P, ORG, PERSON, RECEIPT, RSVGRP,                   "
    
    
    '予約番号を指定？
    If Not IsMissing(lngRsvNo) Then
        'お連れ様情報を取得する
        '   指定した予約番号がお連れ様情報になくても受診者情報は取得する(このときSEQは0となる)
        '   指定した予約番号が先頭になるようにSORTNOをつける
        strStmt = strStmt & vbLf & _
                  "       ( SELECT CSLDATE,                                     " & vbLf & _
                  "                MAX(SEQ) SEQ,                                " & vbLf & _
                  "                RSVNO,                                       " & vbLf & _
                  "                DECODE(RSVNO,TO_NUMBER(:RSVNO),0,1) SORTNO   " & vbLf & _
                  "           FROM                                              " & vbLf & _
                  "                ( SELECT :CSLDATE CSLDATE,                   " & vbLf & _
                  "                         TO_NUMBER(0) SEQ,                   " & vbLf & _
                  "                         TO_NUMBER(:RSVNO) RSVNO             " & vbLf & _
                  "                    FROM DUAL                                " & vbLf & _
                  "                  UNION                                      " & vbLf & _
                  "                  SELECT CSLDATE,                            " & vbLf & _
                  "                         SEQ,                                " & vbLf & _
                  "                         RSVNO                               " & vbLf & _
                  "                    FROM FRIENDS                             " & vbLf & _
                  "                   WHERE CSLDATE = :CSLDATE                  " & vbLf & _
                  "                     AND SEQ = ( SELECT SEQ                  " & vbLf & _
                  "                                   FROM FRIENDS              " & vbLf & _
                  "                                  WHERE CSLDATE = :CSLDATE   " & vbLf & _
                  "                                    AND RSVNO = :RSVNO )     " & vbLf & _
                  "                )                                            " & vbLf & _
                  "         GROUP BY CSLDATE, RSVNO                             " & vbLf & _
                  "       ) FRIENDSLIST                                         "
    Else
        'お連れ様情報を取得する
        strStmt = strStmt & vbLf & _
                  "       ( SELECT CSLDATE,                   " & vbLf & _
                  "                SEQ,                       " & vbLf & _
                  "                RSVNO                      " & vbLf & _
                  "           FROM FRIENDS                    " & vbLf & _
                  "          WHERE CSLDATE = :CSLDATE         " & vbLf & _
                  "       ) FRIENDSLIST                       "
    End If
    
    strStmt = strStmt & vbLf & _
              " WHERE FRIENDSLIST.CSLDATE = FRIENDS.CSLDATE(+)  " & vbLf & _
              "   AND FRIENDSLIST.SEQ     = FRIENDS.SEQ(+)      " & vbLf & _
              "   AND FRIENDSLIST.RSVNO   = FRIENDS.RSVNO(+)    " & vbLf & _
              "   AND FRIENDSLIST.RSVNO   = CONSULT.RSVNO       " & vbLf & _
              "   AND CONSULT.CSCD        = COURSE_P.CSCD       " & vbLf & _
              "   AND CONSULT.ORGCD1      = ORG.ORGCD1          " & vbLf & _
              "   AND CONSULT.ORGCD2      = ORG.ORGCD2          " & vbLf & _
              "   AND CONSULT.PERID       = PERSON.PERID        " & vbLf & _
              "   AND CONSULT.RSVNO       = RECEIPT.RSVNO(+)    " & vbLf & _
              "   AND CONSULT.CSLDATE     = RECEIPT.CSLDATE(+)  " & vbLf & _
              "   AND CONSULT.RSVGRPCD    = RSVGRP.RSVGRPCD     "
    
    '予約番号を指定？
    If Not IsMissing(lngRsvNo) Then
        strStmt = strStmt & vbLf & _
                " ORDER BY FRIENDSLIST.CSLDATE,                   " & vbLf & _
                "          FRIENDSLIST.SEQ,                       " & vbLf & _
                "          FRIENDSLIST.SORTNO,                    " & vbLf & _
                "          FRIENDSLIST.RSVNO                      "
    Else
        strStmt = strStmt & vbLf & _
                " ORDER BY FRIENDSLIST.CSLDATE,                   " & vbLf & _
                "          FRIENDSLIST.SEQ,                       " & vbLf & _
                "          FRIENDSLIST.RSVNO                      "
    End If
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    'レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCslDate = objFields("CSLDATE")
        Set objSeq = objFields("SEQ")
        Set objRsvNo = objFields("RSVNO")
        Set objSameGrp1 = objFields("SAMEGRP1")
        Set objSameGrp2 = objFields("SAMEGRP2")
        Set objSameGrp3 = objFields("SAMEGRP3")
        Set objPerId = objFields("PERID")
        Set objCsCd = objFields("CSCD")
        Set objCsName = objFields("CSNAME")
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objOrgName = objFields("ORGNAME")
        Set objOrgSName = objFields("ORGSNAME")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastKName = objFields("LASTKNAME")
        Set objFirstKName = objFields("FIRSTKNAME")
        Set objDayId = objFields("DAYID")
        Set objRsvGrpName = objFields("RSVGRPNAME")
'## 2004/01/20 Add By K.Kagawa@FFCS 同伴者追加
        Set objCompPerId = objFields("COMPPERID")
'## 2004/01/20 Add End
'## 2004/04/20 Add By T.Takagi@FSIT 受診日一括変更(キャンセルフラグ・予約群コード追加)
        Set objCancelFlg = objFields("CANCELFLG")
        Set objRsvGrpCd = objFields("RSVGRPCD")
'## 2004/04/20 Add End

        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrCslDate(lngCount)
            ReDim Preserve vntArrSeq(lngCount)
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrSameGrp1(lngCount)
            ReDim Preserve vntArrSameGrp2(lngCount)
            ReDim Preserve vntArrSameGrp3(lngCount)
            ReDim Preserve vntArrPerId(lngCount)
            ReDim Preserve vntArrCsCd(lngCount)
            ReDim Preserve vntArrCsName(lngCount)
            ReDim Preserve vntArrOrgCd1(lngCount)
            ReDim Preserve vntArrOrgCd2(lngCount)
            ReDim Preserve vntArrOrgName(lngCount)
            ReDim Preserve vntArrOrgSName(lngCount)
            ReDim Preserve vntArrLastName(lngCount)
            ReDim Preserve vntArrFirstName(lngCount)
            ReDim Preserve vntArrLastKName(lngCount)
            ReDim Preserve vntArrFirstKName(lngCount)
            ReDim Preserve vntArrDayId(lngCount)
            ReDim Preserve vntArrRsvGrpName(lngCount)
'## 2004/01/20 Add By K.Kagawa@FFCS 同伴者追加
            ReDim Preserve vntArrCompPerId(lngCount)
'## 2004/01/20 Add End
'## 2004/04/20 Add By T.Takagi@FSIT 受診日一括変更(キャンセルフラグ・予約群コード追加)
            ReDim Preserve vntArrCancelFlg(lngCount)
            ReDim Preserve vntArrRsvGrpCd(lngCount)
'## 2004/04/20 Add End

            vntArrCslDate(lngCount) = objCslDate.Value & ""
            vntArrSeq(lngCount) = objSeq.Value & ""
            vntArrRsvNo(lngCount) = objRsvNo.Value & ""
            vntArrSameGrp1(lngCount) = objSameGrp1.Value & ""
            vntArrSameGrp2(lngCount) = objSameGrp2.Value & ""
            vntArrSameGrp3(lngCount) = objSameGrp3.Value & ""
            vntArrPerId(lngCount) = objPerId.Value & ""
            vntArrCsCd(lngCount) = objCsCd.Value & ""
            vntArrCsName(lngCount) = objCsName.Value & ""
            vntArrOrgCd1(lngCount) = objOrgCd1.Value & ""
            vntArrOrgCd2(lngCount) = objOrgCd2.Value & ""
            vntArrOrgName(lngCount) = objOrgName.Value & ""
            vntArrOrgSName(lngCount) = objOrgSName.Value & ""
            vntArrLastName(lngCount) = objLastName.Value & ""
            vntArrFirstName(lngCount) = objFirstName.Value & ""
            vntArrLastKName(lngCount) = objLastKName.Value & ""
            vntArrFirstKName(lngCount) = objFirstKName.Value & ""
            vntArrDayId(lngCount) = objDayId.Value & ""
            vntArrRsvGrpName(lngCount) = objRsvGrpName.Value & ""
'## 2004/01/20 Add By K.Kagawa@FFCS 同伴者追加
            vntArrCompPerId(lngCount) = objCompPerId.Value & ""
'## 2004/01/20 Add End
'## 2004/04/20 Add By T.Takagi@FSIT 受診日一括変更(キャンセルフラグ・予約群コード追加)
            vntArrCancelFlg(lngCount) = objCancelFlg.Value & ""
            vntArrRsvGrpCd(lngCount) = objRsvGrpCd.Value & ""
'## 2004/04/20 Add End
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        If Not IsMissing(vntCslDate) Then vntCslDate = vntArrCslDate
        If Not IsMissing(vntSeq) Then vntSeq = vntArrSeq
        If Not IsMissing(vntRsvNo) Then vntRsvNo = vntArrRsvNo
        If Not IsMissing(vntSameGrp1) Then vntSameGrp1 = vntArrSameGrp1
        If Not IsMissing(vntSameGrp2) Then vntSameGrp2 = vntArrSameGrp2
        If Not IsMissing(vntSameGrp3) Then vntSameGrp3 = vntArrSameGrp3
        If Not IsMissing(vntPerId) Then vntPerId = vntArrPerId
        If Not IsMissing(vntCsCd) Then vntCsCd = vntArrCsCd
        If Not IsMissing(vntCsName) Then vntCsName = vntArrCsName
        If Not IsMissing(vntOrgCd1) Then vntOrgCd1 = vntArrOrgCd1
        If Not IsMissing(vntOrgCd2) Then vntOrgCd2 = vntArrOrgCd2
        If Not IsMissing(vntOrgName) Then vntOrgName = vntArrOrgName
        If Not IsMissing(vntOrgSName) Then vntOrgSName = vntArrOrgSName
        If Not IsMissing(vntLastName) Then vntLastName = vntArrLastName
        If Not IsMissing(vntFirstName) Then vntFirstName = vntArrFirstName
        If Not IsMissing(vntLastKName) Then vntLastKName = vntArrLastKName
        If Not IsMissing(vntFirstKName) Then vntFirstKName = vntArrFirstKName
        If Not IsMissing(vntDayId) Then vntDayId = vntArrDayId
        If Not IsMissing(vntRsvGrpName) Then vntRsvGrpName = vntArrRsvGrpName
'## 2004/01/20 Add By K.Kagawa@FFCS 同伴者追加
        If Not IsMissing(vntCompPerId) Then vntCompPerId = vntArrCompPerId
'## 2004/01/20 Add End
'## 2004/04/20 Add By T.Takagi@FSIT 受診日一括変更(キャンセルフラグ・予約群コード追加)
        If Not IsMissing(vntCancelFlg) Then vntCancelFlg = vntArrCancelFlg
        If Not IsMissing(vntRsvGrpCd) Then vntRsvGrpCd = vntArrRsvGrpCd
'## 2004/04/20 Add End

    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    SelectFriends = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    '戻り値の設定
    SelectFriends = -1
    
    'イベントログ書き込み
    WriteErrorLog "Consult.SelectFriends"
    
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
' 機能　　 : お連れ様情報テーブルを更新する
'
' 引数　　 : (In)     dtmCslDate          受診日
' 　　　　   (In)     lngSeq              お連れ様Seq
' 　　　　   (In)     vntRsvNo            予約番号
' 　　　　   (In)     vntSameGrp1         面接同時受診１
' 　　　　   (In)     vntSameGrp2         面接同時受診２
' 　　　　   (In)     vntSameGrp3         面接同時受診３
' 　　　　   (Out)    vntMessage          メッセージ
' 　　　　   (In)     vntPerId            個人ID(同伴者設定用)          '2004/01/20 Add By K.Kagawa@FFCS
' 　　　　   (In)     vntCompPerId        同伴者個人ID(同伴者設定用)    '2004/01/20 Add By K.Kagawa@FFCS
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
'## 2004/01/20 Add By K.Kagawa@FFCS 同伴者追加
'Public Function UpdateFriends(
'    ByVal dtmCslDate As Date,
'    ByVal lngSeq As Long,
'    ByVal vntRsvNo As Variant,
'    ByVal vntSameGrp1 As Variant,
'    ByVal vntSameGrp2 As Variant,
'    ByVal vntSameGrp3 As Variant,
'    ByRef vntMessage As Variant,
'    Optional ByVal vntPerId As Variant,
'    Optional ByVal vntCompPerId As Variant
') As Boolean
Public Function UpdateFriends( _
    ByVal dtmCslDate As Date, _
    ByVal lngSeq As Long, _
    ByVal vntRsvNo As Variant, _
    ByVal vntSameGrp1 As Variant, _
    ByVal vntSameGrp2 As Variant, _
    ByVal vntSameGrp3 As Variant, _
    ByRef vntMessage As Variant, _
    Optional ByVal vntPerId As Variant, _
    Optional ByVal vntCompPerId As Variant _
) As Boolean
'## 2004/01/20 Add End

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント

    Dim lngArraySize            As Long             '更新レコード配列数
    
    Dim objCslDate              As OraParamArray    '受診日
    Dim objSeq                  As OraParamArray    'お客様Seq
    Dim objRsvNo                As OraParamArray    '予約番号
    Dim objSameGrp1             As OraParamArray    '面接同時受診１
    Dim objSameGrp2             As OraParamArray    '面接同時受診２
    Dim objSameGrp3             As OraParamArray    '面接同時受診３
'## 2004/01/20 Add By K.Kagawa@FFCS 同伴者追加
    Dim objPerId                As OraParamArray    '個人ID
    Dim objCompPerId            As OraParamArray    '同伴者個人ID
'## 2004/01/20 Add End

    Dim i                       As Long             'ループカウンタ


    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    Set objOraParam = mobjOraDb.Parameters

    Do
        'お連れ様情報の妥当性チェック
        vntMessage = CheckFriends(dtmCslDate, lngSeq, vntRsvNo)
        If Not IsEmpty(vntMessage) Then
            Exit Do
        End If
    
        If lngSeq = 0 Then
            '新規登録のときはお連れ様Seq発番処理
            lngSeq = GetFriendsSeq(dtmCslDate)
        Else
            'キー値の設定
            objOraParam.Add "CSLDATE", dtmCslDate, ORAPARM_INPUT, ORATYPE_DATE
            objOraParam.Add "SEQ", lngSeq, ORAPARM_INPUT, ORATYPE_NUMBER
                
            '指定されたお連れ様情報を一度削除する
            strStmt = "DELETE FRIENDS                           " & vbLf & _
                      " WHERE CSLDATE = :CSLDATE                " & vbLf & _
                      "   AND SEQ     = :SEQ                    "
        
            mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
            
            'バインド変数の削除
            Do Until objOraParam.Count <= 0
                objOraParam.Remove (objOraParam.Count - 1)
            Loop
        End If
        
        '配列数
        lngArraySize = UBound(vntRsvNo) + 1
        
        If lngArraySize > 0 Then
            objOraParam.AddTable "CSLDATE", ORAPARM_INPUT, ORATYPE_DATE, lngArraySize
            objOraParam.AddTable "SEQ", ORAPARM_INPUT, ORATYPE_NUMBER, lngArraySize, 5
            objOraParam.AddTable "RSVNO", ORAPARM_INPUT, ORATYPE_NUMBER, lngArraySize, 9
            objOraParam.AddTable "SAMEGRP1", ORAPARM_INPUT, ORATYPE_NUMBER, lngArraySize, 1
            objOraParam.AddTable "SAMEGRP2", ORAPARM_INPUT, ORATYPE_NUMBER, lngArraySize, 1
            objOraParam.AddTable "SAMEGRP3", ORAPARM_INPUT, ORATYPE_NUMBER, lngArraySize, 1
               
            'OraParameterオブジェクトの参照設定
            Set objCslDate = objOraParam("CSLDATE")
            Set objSeq = objOraParam("SEQ")
            Set objRsvNo = objOraParam("RSVNO")
            Set objSameGrp1 = objOraParam("SAMEGRP1")
            Set objSameGrp2 = objOraParam("SAMEGRP2")
            Set objSameGrp3 = objOraParam("SAMEGRP3")
            
            'OraParameterオブジェクトの値設定
            For i = 0 To lngArraySize - 1
                objCslDate(i) = dtmCslDate
                objSeq(i) = lngSeq
                objRsvNo(i) = vntRsvNo(i)
                objSameGrp1(i) = IIf(IsNumeric(vntSameGrp1(i)), vntSameGrp1(i), Null)
                objSameGrp2(i) = IIf(IsNumeric(vntSameGrp2(i)), vntSameGrp2(i), Null)
                objSameGrp3(i) = IIf(IsNumeric(vntSameGrp3(i)), vntSameGrp3(i), Null)
            Next i
            
            'お連れ様情報の更新
            strStmt = "INSERT INTO FRIENDS      " & vbLf & _
                      "VALUES (                 " & vbLf & _
                      "  :CSLDATE,              " & vbLf & _
                      "  :SEQ,                  " & vbLf & _
                      "  :RSVNO,                " & vbLf & _
                      "  :SAMEGRP1,             " & vbLf & _
                      "  :SAMEGRP2,             " & vbLf & _
                      "  :SAMEGRP3)             "
        
            mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
        
            'バインド変数の削除
            Do Until objOraParam.Count <= 0
                objOraParam.Remove (objOraParam.Count - 1)
            Loop
        End If
        
'## 2004/01/20 Add By K.Kagawa@FFCS 同伴者追加
        If Not IsMissing(vntPerId) Then
            '配列数
            lngArraySize = UBound(vntPerId) + 1
            
            If lngArraySize > 0 Then
                objOraParam.AddTable "PERID", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, 12
                objOraParam.AddTable "COMPPERID", ORAPARM_INPUT, ORATYPE_VARCHAR2, lngArraySize, 12
                   
                'OraParameterオブジェクトの参照設定
                Set objPerId = objOraParam("PERID")
                Set objCompPerId = objOraParam("COMPPERID")
                
                'OraParameterオブジェクトの値設定
                For i = 0 To lngArraySize - 1
                    objPerId(i) = vntPerId(i)
                    objCompPerId(i) = vntCompPerId(i)
                Next i
                
                '同伴者のクリア(同伴者の付け替えがあったときのため、一旦クリアしてから更新する)
                strStmt = "UPDATE PERSON                                    " & vbLf & _
                          "   SET COMPPERID = ''                            " & vbLf & _
                          " WHERE PERID IN                                  " & vbLf & _
                          "       (SELECT PERID                             " & vbLf & _
                          "          FROM (                                 " & vbLf & _
                          "                SELECT TO_CHAR(:PERID) PERID     " & vbLf & _
                          "                  FROM DUAL                      " & vbLf & _
                          "                UNION                            " & vbLf & _
                          "                SELECT COMPPERID                 " & vbLf & _
                          "                  FROM PERSON                    " & vbLf & _
                          "                 WHERE PERID = :PERID            " & vbLf & _
                          "                   AND COMPPERID IS NOT NULL     " & vbLf & _
                          "               )                                 " & vbLf & _
                          "       )                                         "

                mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
            
                '同伴者の更新
                strStmt = "UPDATE PERSON                    " & vbLf & _
                          "   SET COMPPERID = :COMPPERID    " & vbLf & _
                          " WHERE PERID = :PERID            "

                mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
            
                'バインド変数の削除
                Do Until objOraParam.Count <= 0
                    objOraParam.Remove (objOraParam.Count - 1)
                Loop
            End If
        End If
'## 2004/01/20 Add End
        
        Exit Do
    Loop
    
    '戻り値の設定
    UpdateFriends = True

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function

ErrorHandle:

    UpdateFriends = False

    'イベントログ書き込み
    WriteErrorLog "Consult.UpdateFriends"

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
' 機能　　 : 来院情報を更新する
'
' 引数　　 : (In)     lngRsvNo              予約番号
' 　　　　   (In)     lngMode               処理モード(0:全て, 1:当日ID, 2:来院, 3:OCR番号, 4:ロッカーキー)
' 　　　　   (In)     strUpdUser            更新者
' 　　　　   (Out)    vntDayID              当日ID
' 　　　　   (Out)    vntWelCome            来院(0:無処理, 1:来院状態にする, 2:来院状態を解除する)
' 　　　　   (Out)    vntOcrNo              OCR番号
' 　　　　   (Out)    vntLockerKey          ロッカーキー
'## 2004.10.15 Add By T.Takagi@FSIT 誘導キャンセル機能実装
' 　　　　   (In)     strForce              強制来院取消フラグ
' 　　　　   (Out)    vntVisitStatus        来院制御ストアドのエラーコード
' 　　　　   (Out)    vntErrorMessage       エラーメッセージ
'## 2004.10.15 Add End
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
'## 2004.10.15 Mod By T.Takagi@FSIT 誘導キャンセル機能実装
'Public Function UpdateWelComeInfo(ByVal lngRsvNo As Long,
'                                 ByVal lngMode As Long,
'                                 ByVal strUpdUser As String,
'                                 Optional ByVal vntDayId As Variant,
'                                 Optional ByVal vntWelCome As Variant,
'                                 Optional ByVal vntOcrNo As Variant,
'                                 Optional ByVal vntLockerKey As Variant
'                                ) As Boolean
Public Function UpdateWelComeInfo( _
    ByVal lngRsvNo As Long, _
    ByVal lngMode As Long, _
    ByVal strUpdUser As String, _
    Optional ByVal vntDayId As Variant, _
    Optional ByVal vntWelCome As Variant, _
    Optional ByVal vntOcrNo As Variant, _
    Optional ByVal vntLockerKey As Variant, _
    Optional ByVal strForce As String, _
    Optional ByRef vntVisitStatus As Variant, _
    Optional ByRef vntErrorMessage As Variant _
) As Boolean
'## 2004.10.15 Mod End

    Dim objOraParam     As OraParameters    'OraParametersオブジェクト
    Dim strStmt         As String           'SQLステートメント
    Dim strStmtSet      As String           'SQLステートメント(SET部分)

'## 2003.12.18 Add by T.Takagi@FSIT 他システム連携対応
    Dim objOrderJnl         As Object       'ジャーナル制御用
    Dim vntBeforeComeDate   As Variant      '処理前の来院日時
    Dim vntAfterComeDate    As Variant      '処理後の来院日時
    Dim lngVisitMode        As Long         '来院制御モード(0:何もしない、1:来院、2:来院解除)
    Dim dtmComeDate         As Date         '来院日時
    Dim vntMessage          As Variant      'メッセージ
'## 2003.12.18 Add End

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

'## 2004.10.15 Add By T.Takagi@FSIT 誘導キャンセル機能実装
    '初期処理
    If Not IsMissing(vntVisitStatus) Then vntVisitStatus = Empty
    If Not IsMissing(vntErrorMessage) Then vntErrorMessage = Empty
'## 2004.10.15 Add End

    'キー値及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", Trim(lngRsvNo), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "COMEUSER", Trim(strUpdUser), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
'## 2003.12.18 Add by T.Takagi@FSIT 他システム連携対応
    '現在の受付情報を読み、現在の来院日時を取得。かつレコードロック
    If SelectReceipt(lngRsvNo, True, , , vntBeforeComeDate) = False Then
        Err.Raise 1000, , "この受診者は受付されていません。"
        Exit Function
    End If
'## 2003.12.18 Add End
    
    '当日ID
    If lngMode = 0 Or lngMode = 1 Then
        If IsMissing(vntDayId) = False Then
            If Trim(vntDayId) <> "" Then
                objOraParam.Add "DAYID", Trim(vntDayId), ORAPARM_INPUT, ORATYPE_NUMBER
'*********************************************************************************
'当日IDの更新は保留
'*********************************************************************************
            End If
        End If
    End If
    '来院
    If lngMode = 0 Or lngMode = 2 Then
        If IsMissing(vntWelCome) = False Then
            Select Case Trim(vntWelCome)
            Case "1"    '来院状態にする
                strStmtSet = strStmtSet & IIf(strStmtSet <> "", ", ", "") & vbLf & _
                    " COMEDATE = SYSDATE,   " & vbLf & _
                    " COMEUSER = :COMEUSER  "
            Case "2"    '来院状態を解除する
                strStmtSet = strStmtSet & IIf(strStmtSet <> "", ", ", "") & vbLf & _
                    " COMEDATE = NULL, " & vbLf & _
                    " COMEUSER = NULL  "
            Case Else
                '無処理
            End Select
        End If
    End If
    'OCR番号
    If lngMode = 0 Or lngMode = 3 Then
        If IsMissing(vntOcrNo) = False Then
            If Trim(vntOcrNo) <> "" Then
                objOraParam.Add "OCRNO", Trim(vntOcrNo), ORAPARM_INPUT, ORATYPE_VARCHAR2
                
                strStmtSet = strStmtSet & IIf(strStmtSet <> "", ", ", "") & vbLf & _
                    " OCRNO = :OCRNO "
            Else
                strStmtSet = strStmtSet & IIf(strStmtSet <> "", ", ", "") & vbLf & _
                    " OCRNO = NULL "
            End If
        End If
    End If
    'ロッカーキー
    If lngMode = 0 Or lngMode = 4 Then
        If IsMissing(vntLockerKey) = False Then
            If Trim(vntLockerKey) <> "" Then
                objOraParam.Add "LOCKERKEY", Trim(vntLockerKey), ORAPARM_INPUT, ORATYPE_VARCHAR2
                
                strStmtSet = strStmtSet & IIf(strStmtSet <> "", ", ", "") & vbLf & _
                    " LOCKERKEY = :LOCKERKEY "
            Else
                strStmtSet = strStmtSet & IIf(strStmtSet <> "", ", ", "") & vbLf & _
                    " LOCKERKEY = NULL "
            End If
        End If
    End If
    '更新するものあり？
    If strStmtSet <> "" Then
        
        '来院情報を更新する
        strStmt = "UPDATE RECEIPT                   " & vbLf & _
                  "   SET " & strStmtSet & vbLf & _
                  " WHERE RSVNO           = :RSVNO  "
        
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    End If
    
'## 2003.12.18 Add by T.Takagi@FSIT 他システム連携対応
    '処理後の受付情報を読み、来院日時を取得(この時点でレコードが消失することはない)
    SelectReceipt lngRsvNo, , , , vntAfterComeDate

    '処理前後で来院状態に変更があった場合はジャーナル情報等の制御を行う
    
    '処理前後の来院日時を比較し、制御モードを決定する
    If vntBeforeComeDate = "" Then
        If vntAfterComeDate <> "" Then
            lngVisitMode = 1
            dtmComeDate = vntAfterComeDate
        End If
    Else
        If vntAfterComeDate = "" Then
            lngVisitMode = 2
            dtmComeDate = vntBeforeComeDate
        End If
    End If
            
    '処理前後で来院状態に変更があった場合はジャーナル情報等の制御を行う
    If lngVisitMode > 0 Then
        Set objOrderJnl = CreateObject("HainsOrderJnl.OrderJnl")
'## 2004.10.15 Mod By T.Takagi@FSIT 誘導キャンセル機能実装
'        If objOrderJnl.VisitControl(lngRsvNo, lngVisitMode, dtmComeDate, vntMessage) < 1 Then
'            Err.Raise 1000, , vntMessage
        
        'ジャーナル制御
        vntVisitStatus = objOrderJnl.VisitControl(lngRsvNo, lngVisitMode, dtmComeDate, vntMessage, strForce)
        
        If vntVisitStatus <= 0 Then

            'メッセージを設定
            vntErrorMessage = vntMessage
            
            'エラー時はトランザクションをアボートに設定
            mobjContext.SetAbort

            'バインド変数の削除
            Do Until objOraParam.Count <= 0
                objOraParam.Remove (objOraParam.Count - 1)
            Loop
    
            '戻り値の設定
            UpdateWelComeInfo = False
    
            Exit Function

'## 2004.10.15 Mod End
        End If
    End If
'## 2003.12.18 Add End
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete

    '戻り値の設定
    UpdateWelComeInfo = True
    
    Exit Function

ErrorHandle:

    UpdateWelComeInfo = False
    
    'イベントログ書き込み
    WriteErrorLog "Consult.UpdateWelComeInfo"
    
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
' 機能　　 : 成績書発送日更新
'
' 引数   　: (In)     lngRsvNo      予約番号
'     　　 : (In)     lngMode       0:発送日時更新、1:発送日時クリア
'
'
' 戻り値　 :  1:正常終了
' 　　　　 :  0:更新対象データなし
' 　　　　 : -1:更新対象データなし
'
' 備考　　 :
Public Function UpdateReportSendDate(ByVal lngRsvNo As Long, _
                                     ByVal lngMode As Long) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント
    Dim Ret         As Long             '関数戻り値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
 
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '成績書発送日の更新
    If lngMode = 1 Then
        '発送日クリアモード
        strStmt = "UPDATE CONSULT                  " & vbLf & _
                  "   SET REPORTSENDDATE = ''      " & vbLf & _
                  " WHERE RSVNO          = :RSVNO  "
    Else
        '発送日更新モード
        strStmt = "UPDATE CONSULT                  " & vbLf & _
                  "   SET REPORTSENDDATE = SYSDATE " & vbLf & _
                  " WHERE RSVNO          = :RSVNO  "
    End If
          
    Ret = mobjOraDb.ExecuteSQL(OmitCharSpc(strStmt))

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete

    '戻り値の設定
    UpdateReportSendDate = Ret

    Exit Function

ErrorHandle:

    UpdateReportSendDate = -1

    'イベントログ書き込み
    WriteErrorLog "Consult.UpdateReportSendDate"

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

'#### 2004.01.08 add
'
' 機能　　 : 検索条件を満たす成績書作成情報の一覧を取得する
'
' 引数　　 : (In)     strKey              検索キー
' 　　　　   (In)     vntStartCslDate     検索条件受診日（開始）
' 　　　　   (In)     vntEndCslDate       検索条件受診日（終了）
' 　　　　   (In)     vntSearchOrg1       検索条件団体コード１
' 　　　　   (In)     vntSearchOrg2       検索条件団体コード２
' 　　　　   (In)     lngStartPos         取得開始位置
' 　　　　   (In)     lngPageMaxLine      １ページ表示ＭＡＸ行（０：ＭＡＸ行指定無し）
' 　　　　   (Out)    vntRsvNo            予約番号
' 　　　　   (Out)    vntCslDate          受診日
' 　　　　   (Out)    vntPerId            個人ＩＤ
' 　　　　   (Out)    vntLastName         姓
' 　　　　   (Out)    vntFirstName        名
' 　　　　   (Out)    vntLastKName        カナ姓
' 　　　　   (Out)    vntFirstKName       カナ名
' 　　　　   (Out)    vntOrgSName         団体略称
' 　　　　   (Out)    vntDayId            当日ＩＤ
' 　　　　   (Out)    vntReportSendDate   発送確認日時
' 　　　　   (Out)    vntPubNote          成績書コメント
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectInqReportsInfoList( _
    ByVal strKey As String, ByVal vntStartCslDate As Variant, ByVal vntEndCslDate As Variant, _
    ByVal vntSearchOrg1 As Variant, ByVal vntSearchOrg2 As Variant, _
    Optional ByVal lngStartPos As Long = 1, _
    Optional ByVal lngPageMaxLine As Long = 0, _
    Optional ByRef vntRsvNo As Variant, Optional ByRef vntCslDate As Variant, _
    Optional ByRef vntPerId As Variant, _
    Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant, _
    Optional ByRef vntLastKName As Variant, Optional ByRef vntFirstKName As Variant, _
    Optional ByRef vntOrgSName As Variant, Optional ByRef vntDayId As Variant, _
    Optional ByRef vntReportSendDate As Variant, Optional ByRef vntPubNote As Variant _
) As Long

    
    Dim objOraParam                 As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna                  As OraDynaset       'ダイナセット
    Dim strStmt                     As String           'SQLステートメント
    Dim strstmt2                    As String           'SQLステートメント
    Dim strStmt_count               As String           'SQLステートメント
    Dim strStmt_data                As String           'SQLステートメント

    Dim objFields                   As OraFields        'フィールドオブジェクト
    Dim objRsvNo                    As OraField         '予約番号
    Dim objCslDate                  As OraField         '受診日
    Dim objPerId                    As OraField         '個人ＩＤ
    Dim objLastName                 As OraField         '姓
    Dim objFirstName                As OraField         '名
    Dim objLastKName                As OraField         'カナ姓
    Dim objFirstKName               As OraField         'カナ名
    Dim objOrgSName                 As OraField         '団体略称
    Dim objDayId                    As OraField         '当日ＩＤ
    Dim objReportSendDate           As OraField         '発送確認日時
    Dim objPubNote                  As OraField         '成績書コメント

    Dim vntArrRsvNo()               As Variant          '予約番号の配列
    Dim vntArrCslDate()             As Variant          '受診日の配列
    Dim vntArrPerId()               As Variant          '個人ＩＤの配列
    Dim vntArrLastName()            As Variant          '姓の配列
    Dim vntArrFirstName()           As Variant          '名の配列
    Dim vntArrLastKName()           As Variant          'カナ姓の配列
    Dim vntArrFirstKName()          As Variant          'カナ名の配列
    Dim vntArrOrgSName()            As Variant          '団体略称の配列
    Dim vntArrDayId()               As Variant          '当日ＩＤの配列
    Dim vntArrReportSendDate()      As Variant          '発送確認日時の配列
    Dim vntArrPubNote()             As Variant          '成績書コメントの配列
    
    Dim lngAllCount                 As Long             '全件数
    Dim lngCount                    As Long             'レコード数

    Dim blnExistsRsvNo              As Boolean
    Dim blnExistsDayId              As Boolean
'### 2006.08.03 Mod By 張 ＯＣＲ番号、ロッカー番号検索機能追加 Start ###
    Dim blnExistsOcrNo              As Boolean          '検索キー内にＯＣＲ番号が存在するか
    Dim blnExistsLockerKey          As Boolean          '検索キー内にロッカー番号が存在するか
'### 2006.08.03 Mod By 張 ＯＣＲ番号、ロッカー番号検索機能追加 End   ###
    
    Dim i                           As Long             'インデックス

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If Not IsMissing(vntCslDate) Then vntCslDate = Empty
    If Not IsMissing(vntPerId) Then vntPerId = Empty
    If Not IsMissing(vntLastName) Then vntLastName = Empty
    If Not IsMissing(vntFirstName) Then vntFirstName = Empty
    If Not IsMissing(vntLastKName) Then vntLastKName = Empty
    If Not IsMissing(vntFirstKName) Then vntFirstKName = Empty
    If Not IsMissing(vntOrgSName) Then vntOrgSName = Empty
    If Not IsMissing(vntDayId) Then vntDayId = Empty
    If Not IsMissing(vntReportSendDate) Then vntReportSendDate = Empty
    If Not IsMissing(vntPubNote) Then vntPubNote = Empty
    lngCount = 0

                
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "STARTPOS", lngStartPos, ORAPARM_INPUT, ORATYPE_NUMBER
    If lngPageMaxLine > 0 Then
        objOraParam.Add "ENDPOS", (CLng(lngStartPos) + CLng(lngPageMaxLine) - 1), ORAPARM_INPUT, ORATYPE_NUMBER
    End If

    '検索条件を満たす成績書作成情報件数を取得
    strStmt_count = _
              "SELECT COUNT(*)                                   "

    '検索条件を満たす成績書作成情報を取得
    strStmt_data = _
                "SELECT FINALLISTVIEW.RSVNO,                               " & vbLf & _
                "       FINALLISTVIEW.CSLDATE, FINALLISTVIEW.PERID,        " & vbLf & _
                "       FINALLISTVIEW.LASTNAME, FINALLISTVIEW.FIRSTNAME,   " & vbLf & _
                "       FINALLISTVIEW.LASTKNAME, FINALLISTVIEW.FIRSTKNAME, " & vbLf & _
                "       FINALLISTVIEW.ORGCD1, FINALLISTVIEW.ORGCD2,        " & vbLf & _
                "       FINALLISTVIEW.ORGSNAME,                            " & vbLf & _
                "       FINALLISTVIEW.DAYID, FINALLISTVIEW.REPORTSENDDATE, " & vbLf & _
                "       FINALLISTVIEW.PUBNOTE                              "

    strStmt_data = strStmt_data & _
                "FROM (                                                                 " & vbLf & _
                "     SELECT ROWNUM SEQ, BASEVIEW.*                                     " & vbLf & _
                "       FROM (                                                          " & vbLf & _
                "            SELECT CONSULT.RSVNO, CONSULT.CSLDATE, CONSULT.PERID,      " & vbLf & _
                "                   PERSON.LASTNAME, PERSON.FIRSTNAME,                  " & vbLf & _
                "                   PERSON.LASTKNAME, PERSON.FIRSTKNAME,                " & vbLf & _
                "                   ORG.ORGCD1, ORG.ORGCD2, ORG.ORGSNAME,               " & vbLf & _
                "                   RECEIPT.DAYID, CONSULT.REPORTSENDDATE,              " & vbLf & _
                "                   PubNotePackage.EditOrgPubNote(CONSULT.ORGCD1, CONSULT.ORGCD2) PUBNOTE   "
    
    strStmt = "  FROM CONSULT, RECEIPT, PERSON, ORG                         "
    '受診日範囲指定
    If vntStartCslDate <> "" And vntEndCslDate <> "" Then
        objOraParam.Add "SCSLDATE", Format(Trim(vntStartCslDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
        objOraParam.Add "ECSLDATE", Format(Trim(vntEndCslDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
        strStmt = strStmt & vbLf & _
                "  WHERE CONSULT.CSLDATE BETWEEN :SCSLDATE  AND :ECSLDATE"
    Else
        '受診日開始日のみ指定
        If vntStartCslDate <> "" And vntEndCslDate = "" Then
            objOraParam.Add "SCSLDATE", Format(Trim(vntStartCslDate), "yyyy/mm/dd"), ORAPARM_INPUT, ORATYPE_DATE
            strStmt = strStmt & vbLf & _
                "  WHERE CONSULT.CSLDATE = :SCSLDATE  "
        End If
    End If

    '検索キー 指定？
    If strKey <> "" Then
        blnExistsRsvNo = False
        blnExistsDayId = False
        
        '### 2006.08.03 Mod By 張 ＯＣＲ番号、ロッカー番号検索機能追加 Start ###
        'strstmt2 = CreateConditionForDailyList(strKey, blnExistsRsvNo, blnExistsDayId)
        blnExistsOcrNo = False
        blnExistsLockerKey = False
        strstmt2 = CreateConditionForDailyList(strKey, blnExistsRsvNo, blnExistsDayId, blnExistsOcrNo, blnExistsLockerKey)
        '### 2006.08.03 Mod By 張 ＯＣＲ番号、ロッカー番号検索機能追加 End   ###
        
        strStmt = strStmt & vbLf & _
                "    AND " & strstmt2
    End If
    
    '団体コード指定
    If vntSearchOrg1 <> "" And vntSearchOrg2 <> "" Then
        objOraParam.Add "ORGCD1", Trim(vntSearchOrg1), ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "ORGCD2", Trim(vntSearchOrg2), ORAPARM_INPUT, ORATYPE_VARCHAR2
        strStmt = strStmt & vbLf & _
                "    AND CONSULT.ORGCD1 = :ORGCD1  " & vbLf & _
                "    AND CONSULT.ORGCD2 = :ORGCD2  "
    End If
    
    strStmt = strStmt & vbLf & _
                "    AND CONSULT.RSVNO    = RECEIPT.RSVNO  " & vbLf & _
                "    AND CONSULT.PERID    = PERSON.PERID   " & vbLf & _
                "    AND CONSULT.ORGCD1   = ORG.ORGCD1     " & vbLf & _
                "    AND CONSULT.ORGCD2   = ORG.ORGCD2     "
    
    '全件数取得
    strStmt_count = strStmt_count & strStmt
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt_count), ORADYN_READONLY + ORADYN_NOCACHE)
        
    lngAllCount = objOraDyna.Fields(0).Value
    
    '並べ替え
    strStmt = strStmt & vbLf & _
                "     ORDER BY CONSULT.CSLDATE, RECEIPT.DAYID   " & vbLf & _
                "     ) BASEVIEW                                " & vbLf & _
                " ) FINALLISTVIEW                               "
    
    '取得件数で絞込み
    strStmt = strStmt & vbLf & _
              "  WHERE FINALLISTVIEW.SEQ >= :STARTPOS "
    If lngPageMaxLine > 0 Then
        strStmt = strStmt & vbLf & _
              "    AND FINALLISTVIEW.SEQ <= :ENDPOS "
    End If
    
    
    'データ取得
    strStmt_data = strStmt_data & vbLf & strStmt
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt_data), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRsvNo = objFields("RSVNO")
        Set objCslDate = objFields("CSLDATE")
        Set objPerId = objFields("PERID")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastKName = objFields("LASTKNAME")
        Set objFirstKName = objFields("FIRSTKNAME")
        Set objOrgSName = objFields("ORGSNAME")
        Set objDayId = objFields("DAYID")
        Set objReportSendDate = objFields("REPORTSENDDATE")
        Set objPubNote = objFields("PUBNOTE")
        '配列形式で格納する
        Do Until objOraDyna.EOF
            
            
            '配列に追加
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrCslDate(lngCount)
            ReDim Preserve vntArrPerId(lngCount)
            ReDim Preserve vntArrLastName(lngCount)
            ReDim Preserve vntArrFirstName(lngCount)
            ReDim Preserve vntArrLastKName(lngCount)
            ReDim Preserve vntArrFirstKName(lngCount)
            ReDim Preserve vntArrOrgSName(lngCount)
            ReDim Preserve vntArrDayId(lngCount)
            ReDim Preserve vntArrReportSendDate(lngCount)
            ReDim Preserve vntArrPubNote(lngCount)
                
            vntArrRsvNo(lngCount) = objRsvNo.Value & ""
            vntArrCslDate(lngCount) = objCslDate.Value & ""
            vntArrPerId(lngCount) = objPerId.Value & ""
            vntArrLastName(lngCount) = objLastName.Value & ""
            vntArrFirstName(lngCount) = objFirstName.Value & ""
            vntArrLastKName(lngCount) = objLastKName.Value & ""
            vntArrFirstKName(lngCount) = objFirstKName.Value & ""
            vntArrOrgSName(lngCount) = objOrgSName.Value & ""
            vntArrDayId(lngCount) = objDayId.Value & ""
            vntArrReportSendDate(lngCount) = objReportSendDate.Value & ""
            vntArrPubNote(lngCount) = objPubNote.Value & ""
                
            'レコード数をカウント
            lngCount = lngCount + 1
            
            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        If Not IsMissing(vntRsvNo) Then vntRsvNo = vntArrRsvNo
        If Not IsMissing(vntCslDate) Then vntCslDate = vntArrCslDate
        If Not IsMissing(vntPerId) Then vntPerId = vntArrPerId
        If Not IsMissing(vntLastName) Then vntLastName = vntArrLastName
        If Not IsMissing(vntFirstName) Then vntFirstName = vntArrFirstName
        If Not IsMissing(vntLastKName) Then vntLastKName = vntArrLastKName
        If Not IsMissing(vntFirstKName) Then vntFirstKName = vntArrFirstKName
        If Not IsMissing(vntOrgSName) Then vntOrgSName = vntArrOrgSName
        If Not IsMissing(vntDayId) Then vntDayId = vntArrDayId
        If Not IsMissing(vntReportSendDate) Then vntReportSendDate = vntArrReportSendDate
        If Not IsMissing(vntPubNote) Then vntPubNote = vntArrPubNote
        
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    SelectInqReportsInfoList = lngAllCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectInqReportsInfoList = -1

    'イベントログ書き込み
    WriteErrorLog "Consult.SelectInqReportsInfoList"
    
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


'**********************************************************************************
'* Date: 2005.09.08 ADD BY 李
'*       年度内2回以上の予約をチェックする団体（対象外）
'*
'**********************************************************************************

Private Function RsvChkOrg(pOrgCd1 As String, pOrgCd2 As String, _
                            ByRef sDate1 As String, ByRef sDate2 As String) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim strStmt             As String           'SQLステートメント
    Dim bolRet              As Boolean

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", pOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", pOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "FREECD", "RSV2ORG%", ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "FREECLASSCD", "RS2", ORAPARM_INPUT, ORATYPE_VARCHAR2

    strStmt = " SELECT FREEFIELD1 ,FREEFIELD2                   " & vbLf & _
              "         ,FREEFIELD3 ,FREEFIELD4                 " & vbLf & _
              " FROM FREE                                       " & vbLf & _
              " WHERE FREECD        LIKE :FREECD                " & vbLf & _
              "   AND FREECLASSCD   =    :FREECLASSCD           " & vbLf & _
              "   AND FREEFIELD1    =    :ORGCD1                " & vbLf & _
              "   AND FREEFIELD2    =    :ORGCD2                "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        Set objFields = objOraDyna.Fields
        If Not IsNull(objFields("FREEFIELD3")) Then sDate1 = CStr(objFields("FREEFIELD3"))
        If Not IsNull(objFields("FREEFIELD4")) Then sDate2 = CStr(objFields("FREEFIELD4"))
        bolRet = True
    Else
        bolRet = False
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

'    '戻り値の設定
    RsvChkOrg = bolRet

    Set objOraParam = Nothing
    Set objOraDyna = Nothing

    Exit Function

ErrorHandle:
    RsvChkOrg = False
    'イベントログ書き込み
    WriteErrorLog "FlexReportEx.RsvChkOrg"

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
'    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'**************************************************************************************
' 日付　　： 2005/09/08  Add by 李
' 機能　　: 年度内に２回目予約を行う場合、ワーニング対応
'
' 引数　　 : (In)     vntPerId    個人ＩＤ
' 　　　　   (In)     strCslDate  保存したい受診日
' 　　　　   (In)     vntCsCd     保存したいコースコード
' 　　　　   (In)     strRsvNo    保存対象となる受診情報の予約番号
' 　　　　   (In)     vntOrgCd1   団体コード１
' 　　　　   (In)     vntOrgCd2   団体コード２
'
' 戻り値　 : ワーニング対象となる受診情報存在時、メッセージを返す
'
' 備考　　 :
'
'**************************************************************************************

Public Function CheckConsult_Ctr(ByVal vntPerId As Variant, ByVal dtmCslDate As Date, ByVal vntCsCd As Variant, _
                                 ByVal vntOrgCd1 As Variant, ByVal vntOrgCd2 As Variant, _
                                 Optional ByVal vntRsvNo As Variant, _
                                 Optional ByVal intFRsv As Integer)
    
    Dim blnRet                  As Boolean
    Dim blnChkDate              As Boolean
    Dim strMessage              As String
    Dim FF()                    As String
    Dim strChkCSCD              As String
    Dim i                       As Integer
    Dim dtmRsvDate              As Date
    Dim dtmCtrStartDate         As Date
    Dim dtmCtrEndDate           As Date
    Dim dtmCtrTempDate          As Date
    Dim bolCS                   As Boolean
    Dim strCurCslDate           As Variant
    Dim Ret                     As Boolean
    Dim strRsvNo                As String
    Dim strDate1                As String
    Dim strDate2                As String
    Dim intNowYear              As Integer
    Dim intCslYear              As Integer
    Dim lngRsvNo                As Long
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
                
    If intFRsv = 1 Then Exit Function
'    # 対象外団体チェック
    If Not RsvChkOrg(CStr(vntOrgCd1), CStr(vntOrgCd2), strDate1, strDate2) Then Exit Function
    
    If IsNumeric(vntRsvNo) Then lngRsvNo = CLng(vntRsvNo)
    If lngRsvNo > 0 Then
        '受診情報を読み、現在の受診日を取得
        Ret = SelectConsult(lngRsvNo, , strCurCslDate)
        
        If Ret = False Then
            Exit Function
        End If
        
        '受診日に変更がない場合は対象外
        If CDate(strCurCslDate) = dtmCslDate Then
            Exit Function
        End If
    End If

    If GetFreeCd("RSV2CSCD01", FF()) Then
        For i = 0 To UBound(FF())
            If Trim(vntCsCd) = Trim(FF(i)) Then
                bolCS = True
                Exit For
            End If
        Next i
        If Not bolCS Then Exit Function
    Else
    '# 基本対象コース設定
        If Not (Trim(vntCsCd) = "100" Or Trim(vntCsCd) = "110") Then Exit Function
        ReDim FF(1) As String
        FF(0) = "100"
        FF(1) = "110"
    End If

    intNowYear = Year(Now)
    intCslYear = Year(dtmCslDate)
    
    If strDate1 = "" Then strDate1 = "04/01"
    If strDate2 = "" Then strDate2 = "03/31"
    
    If Month(dtmCslDate) > CInt(Mid(strDate2, 1, 2)) Then
        strDate1 = CStr(intCslYear) & "/" & strDate1
        strDate2 = CStr(intCslYear + 1) & "/" & strDate2
    Else
        strDate1 = CStr(intCslYear - 1) & "/" & strDate1
        strDate2 = CStr(intCslYear) & "/" & strDate2
    End If
        

'    If Not IsDate(strDate1) Then strDate1 = CStr(intNowYear) & "/04/01"
'    If Not IsDate(strDate2) Then strDate2 = CStr(intNowYear + 1) & "/03/31"

    dtmCtrStartDate = CDate(strDate1)
    dtmCtrEndDate = CDate(strDate2)

'    Do
'       If dtmCtrEndDate < dtmCslDate Then
'           dtmCtrEndDate = DateAdd("yyyy", 1, dtmCtrEndDate)
'       Else
'           dtmCtrStartDate = DateAdd("yyyy", -1, dtmCtrEndDate + 1)
'           blnChkDate = True
'       End If
'       If blnChkDate Then Exit Do
'    Loop

    For i = LBound(FF()) To UBound(FF())
        If Trim(FF(i)) <> "" Then
            If strChkCSCD <> "" Then
                strChkCSCD = strChkCSCD & ","
            End If
            strChkCSCD = strChkCSCD & FF(i)
        End If
    Next i


    If SelectConsultFromCslDate(dtmCtrStartDate, dtmCtrEndDate, vntPerId, dtmRsvDate, strChkCSCD, lngRsvNo) Then
        strMessage = Year(dtmRsvDate) & "年" & Month(dtmRsvDate) & "月" & Day(dtmRsvDate) & "日"
        strMessage = strMessage & "にこの受診者の受診情報がすでに存在します。"
    End If
    
'' =========================================================================================================''
''    '#　契約情報を取得する。
''    If SelectCtrInfo(vntOrgCd1, vntOrgCd2, vntCsCd, dtmCtrStartDate, dtmCtrEndDate) Then
''        If Not IsDate(dtmCtrStartDate) Then Exit Function
''
''        If dtmCslDate <= dtmCtrEndDate Then
''             dtmCtrTempDate = DateAdd("yyyy", 1, dtmCtrStartDate)
''            Do
''                If dtmCtrTempDate <= dtmCslDate Then
''                    dtmCtrTempDate = DateAdd("yyyy", 1, dtmCtrTempDate)
''                Else
''                    dtmCtrStartDate = DateAdd("yyyy", -1, dtmCtrTempDate)
''                    blnChkDate = True
''                End If
''
''                If blnChkDate Then Exit Do
''            Loop
''
''            If dtmCtrTempDate > dtmCtrEndDate Then
''                dtmCtrTempDate = dtmCtrEndDate
''            End If
''
''            For i = LBound(FF()) To UBound(FF())
''                If Trim(FF(i)) <> "" Then
''                    If strChkCSCD <> "" Then
''                        strChkCSCD = strChkCSCD & ","
''                    End If
''                    strChkCSCD = strChkCSCD & FF(i)
''                End If
''            Next i
''
''            If SelectConsultFromCslDate(dtmCtrStartDate, dtmCtrTempDate - 1, vntPerId, dtmRsvDate, strChkCSCD) Then
''                strMessage = Year(dtmRsvDate) & "年" & Month(dtmRsvDate) & "月" & Day(dtmRsvDate) & "日"
''                strMessage = strMessage & "にこの受診者の受診情報がすでに存在します。"
''            End If
''
''        Else
''            strMessage = "予約日付が契約期間の範囲を超過します。"
''        End If
''    End If
'' =========================================================================================================''
    
    CheckConsult_Ctr = strMessage
    Exit Function
    
ErrorHandle:
    WriteErrorLog "Consult.CheckConsult_Ctr"
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

Private Function SelectCtrInfo(ByVal sOrgCd1 As String, _
                          ByVal sOrgcd2 As String, _
                          ByVal sCSCD As String, _
                          ByRef dtmCtrStartDate As Date, _
                          ByRef dtmCtrEndDate As Date)
                          
    Dim objOraParam         As OraParameters        'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset           'ダイナセット
    Dim objFields           As OraFields            'フィールドコレクション
    Dim strStmt             As String               'SQLステートメント
    Dim bolRet              As Boolean

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", sOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", sOrgcd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSCD", sCSCD, ORAPARM_INPUT, ORATYPE_VARCHAR2

    strStmt = " SELECT CTRMNG.CTRPTCD,                                      " & vbLf & _
              "         CTRMNG.CSCD, CTRMNG.REFORGCD1, CTRMNG.REFORGCD2,    " & vbLf & _
              "         CTRPT.STRDATE, CTRPT.ENDDATE, COURSE_P.CSNAME       " & vbLf & _
              " FROM COURSE_P, CTRPT, CTRMNG                                " & vbLf & _
              " WHERE CTRMNG.ORGCD1       = :ORGCD1                         " & vbLf & _
              "     AND CTRMNG.ORGCD2     = :ORGCD2                         " & vbLf & _
              "     AND CTRMNG.CSCD       = :CSCD                           " & vbLf & _
              "     AND CTRMNG.CTRPTCD    = CTRPT.CTRPTCD                   " & vbLf & _
              "     AND CTRMNG.CSCD       = COURSE_P.CSCD                   " & vbLf & _
              "     AND CTRPT.StrDate     <= TRUNC(SYSDATE)                 " & vbLf & _
              "     AND CTRPT.EndDate     >= TRUNC(SYSDATE)                 " & vbLf & _
              " ORDER BY CSCD, STRDATE                                      "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        Set objFields = objOraDyna.Fields
        objOraDyna.MoveFirst
        
        dtmCtrStartDate = CDate(objFields("STRDATE").Value)
        dtmCtrEndDate = CDate(objFields("ENDDATE").Value)
        bolRet = True
    Else
        bolRet = False
    End If

    SelectCtrInfo = bolRet

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
                          
Exit Function

ErrorHandle:
    SelectCtrInfo = False
    'イベントログ書き込み
    WriteErrorLog "FlexReportEx.SelectCtrInfo"

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
                                                  
End Function


'************************************************************************************
'* 日付：2005/09/09  Add by 李
'* 機能：契約期間内に受診情報をチェックする。
'*
'************************************************************************************
Private Function SelectConsultFromCslDate(ByVal CslDate1 As Date, _
                          ByVal CslDate2 As Date, _
                          ByVal sPerId As String, _
                          ByRef RetCslDate As Date, _
                          Optional ByVal sChkCSCD As String, _
                          Optional ByVal lngRsvNo As Long)
                          
    Dim objOraParam         As OraParameters        'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset           'ダイナセット
    Dim objFields           As OraFields            'フィールドコレクション
    Dim strStmt             As String               'SQLステートメント
    Dim bolRet              As Boolean
    Dim i                   As Integer
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE1", CslDate1, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "CSLDATE2", CslDate2, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "PERID", sPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSCD", sChkCSCD, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER

    strStmt = " SELECT a.RSVNO, a.CslDate, a.CTRPTCD,  a.CSCD, a.PERID,             " & vbCrLf & _
              "         a.OrgCd1, a.OrgCd2                                          " & vbCrLf & _
              " FROM CONSULT a                                                      " & vbCrLf & _
              " WHERE a.CSLDATE         >= :CSLDATE1                                " & vbCrLf & _
              "     AND a.CSLDATE       <= :CSLDATE2                                " & vbCrLf & _
              "     AND a.PERID         = :PERID                                    " & vbCrLf & _
              "     AND a.CANCELFLG     = 0                                         " & vbCrLf & _
              "     AND a.CSCD          IN ( " & sChkCSCD & " )                     " & vbCrLf

    If lngRsvNo > 0 Then
        strStmt = strStmt & " AND a.RSVNO  <> :RSVNO  " & vbCrLf
    End If
              
    strStmt = strStmt & " ORDER BY a.CslDate      DESC   "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        Set objFields = objOraDyna.Fields
        objOraDyna.MoveFirst
        
        RetCslDate = CDate(objFields("CslDate").Value)
        bolRet = True
    Else
        bolRet = False
    End If

    SelectConsultFromCslDate = bolRet

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
                          
Exit Function

ErrorHandle:
    SelectConsultFromCslDate = False
    'イベントログ書き込み
    WriteErrorLog "FlexReportEx.SelectConsultFromCslDate"

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
                                                  
End Function


Private Function GetFreeCd(ByVal pFreeCd As String, ByRef FF() As String) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim strStmt             As String           'SQLステートメント
    Dim bolRet              As Boolean
    Dim i                   As Integer

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "FREECD", pFreeCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
'    objOraParam.Add "FREECLASSCD", pFClass, ORAPARM_INPUT, ORATYPE_VARCHAR2

    strStmt = " SELECT FREEFIELD1, FREEFIELD2, FREEFIELD3, FREEFIELD4,      " & vbCrLf & _
              "        FREEFIELD5, FREEFIELD6, FREEFIELD7                   " & vbCrLf & _
              " FROM FREE                                                   " & vbCrLf & _
              " WHERE FREECD        = :FREECD                               "

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        bolRet = True
        Set objFields = objOraDyna.Fields
        For i = 0 To 6
            ReDim Preserve FF(i) As String
            If Not IsNull(objFields(i)) Then FF(i) = CStr(objFields(i))
        Next i
    End If

    
    '戻り値の設定
    GetFreeCd = bolRet

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop


    Set objOraParam = Nothing
    Set objOraDyna = Nothing

    Exit Function

ErrorHandle:
    'イベントログ書き込み
    WriteErrorLog "FlexReportEx.RsvChkOrg"

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
'    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

