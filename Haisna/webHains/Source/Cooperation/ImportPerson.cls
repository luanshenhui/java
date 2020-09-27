VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "ImportPerson"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

Implements ObjectControl

Private mobjContext     As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession  As OraSession       'OraSessionオブジェクト
Private mobjOraDb       As OraDatabase      'OraDatabaseオブジェクト

Private Const UNDEFINED_CODE        As String = "0000000000"    '未設定用の事業部、室部、所属コード

Private Const TRANSACTIONDIV_PERCSV As String = "LOGPERCSV"     '人事情報取り込み用のログ処理ＩＤ
Private Const TRANSACTIONDIV_RSVCSV As String = "LOGRSVCSV"     'ＣＳＶ一括予約用のログ処理ＩＤ

Private Const INDEX_ORGCD1          As Long = 0                 '団体コード１
Private Const INDEX_ORGCD2          As Long = 1                 '団体コード２
Private Const INDEX_EMPNO           As Long = 2                 '従業員番号
Private Const INDEX_NAME            As Long = 3                 '姓名
'## 2003.01.29 Mod 52Lines By T.Takagi@FSIT 姓・名フィールド削除
'Private Const INDEX_LASTNAME        As Long = 4                 '姓
'Private Const INDEX_FIRSTNAME       As Long = 5                 '名
'Private Const INDEX_KNAME           As Long = 6                 'カナ姓名
'Private Const INDEX_LASTKNAME       As Long = 7                 'カナ姓
'Private Const INDEX_FIRSTKNAME      As Long = 8                 'カナ名
'Private Const INDEX_BIRTH           As Long = 9                 '生年月日
'Private Const INDEX_HIREDATE        As Long = 10                '入社年月日
'Private Const INDEX_GENDER          As Long = 11                '性別
'Private Const INDEX_ORGBSDCD        As Long = 12                '事業部コード
'Private Const INDEX_ORGBSDNAME      As Long = 13                '事業部名称
'Private Const INDEX_ORGROOMCD       As Long = 14                '室部コード
'Private Const INDEX_ORGROOMNAME     As Long = 15                '室部名称
'Private Const INDEX_ORGPOSTCD       As Long = 16                '所属コード
'Private Const INDEX_ORGPOSTNAME     As Long = 17                '所属名称
'Private Const INDEX_JOBCD           As Long = 18                '職名コード
'Private Const INDEX_JOBNAME         As Long = 19                '職名
'Private Const INDEX_DUTYCD          As Long = 20                '職責コード
'Private Const INDEX_DUTYNAME        As Long = 21                '職責名称
'Private Const INDEX_QUALIFYCD       As Long = 22                '資格コード
'Private Const INDEX_QUALIFYNAME     As Long = 23                '資格名称
'Private Const INDEX_EMPDIV          As Long = 24                '従業員区分
'Private Const INDEX_EMPNAME         As Long = 25                '従業員名称
'Private Const INDEX_HONGENDIV       As Long = 26                '本現区分
'Private Const INDEX_RETIREMENT      As Long = 27                '休・退職区分
'Private Const INDEX_TRANSFERDIV     As Long = 28                '出向区分
'Private Const INDEX_ISRSIGN         As Long = 29                '健保記号
'Private Const INDEX_ISRNO           As Long = 30                '健保番号
'Private Const INDEX_RETIREDATE      As Long = 31                '退職年月日
Private Const INDEX_KNAME           As Long = 4                 'カナ姓名
Private Const INDEX_BIRTH           As Long = 5                 '生年月日
Private Const INDEX_HIREDATE        As Long = 6                 '入社年月日
Private Const INDEX_GENDER          As Long = 7                 '性別
Private Const INDEX_ORGBSDCD        As Long = 8                 '事業部コード
Private Const INDEX_ORGBSDNAME      As Long = 9                 '事業部名称
Private Const INDEX_ORGROOMCD       As Long = 10                '室部コード
Private Const INDEX_ORGROOMNAME     As Long = 11                '室部名称
Private Const INDEX_ORGPOSTCD       As Long = 12                '所属コード
Private Const INDEX_ORGPOSTNAME     As Long = 13                '所属名称
Private Const INDEX_JOBCD           As Long = 14                '職名コード
Private Const INDEX_JOBNAME         As Long = 15                '職名
Private Const INDEX_DUTYCD          As Long = 16                '職責コード
Private Const INDEX_DUTYNAME        As Long = 17                '職責名称
Private Const INDEX_QUALIFYCD       As Long = 18                '資格コード
Private Const INDEX_QUALIFYNAME     As Long = 19                '資格名称
Private Const INDEX_EMPDIV          As Long = 20                '従業員区分
Private Const INDEX_EMPNAME         As Long = 21                '従業員区分名称
Private Const INDEX_HONGENDIV       As Long = 22                '本現区分
Private Const INDEX_RETIREMENT      As Long = 23                '休・退職区分
Private Const INDEX_TRANSFERDIV     As Long = 24                '出向区分
Private Const INDEX_ISRSIGN         As Long = 25                '健保記号
Private Const INDEX_ISRNO           As Long = 26                '健保番号
Private Const INDEX_RETIREDATE      As Long = 27                '退職年月日
'## 2003.01.29 Mod End

Private Const LENGTH_ORGCD1         As Long = 5                 '団体コード１
Private Const LENGTH_ORGCD2         As Long = 5                 '団体コード２
Private Const LENGTH_EMPNO          As Long = 7                 '従業員番号
Private Const LENGTH_NAME           As Long = 32                '姓名
'## 2003.01.29 Mod 52Lines By T.Takagi@FSIT 姓・名フィールド削除＆従業員区分名称対応
'Private Const LENGTH_LASTNAME       As Long = 32                '姓
'Private Const LENGTH_FIRSTNAME      As Long = 32                '名
'Private Const LENGTH_KNAME          As Long = 32                'カナ姓名
'Private Const LENGTH_LASTKNAME      As Long = 32                'カナ姓
'Private Const LENGTH_FIRSTKNAME     As Long = 32                'カナ名
'Private Const LENGTH_BIRTH          As Long = 0                 '生年月日
'Private Const LENGTH_HIREDATE       As Long = 0                 '入社年月日
'Private Const LENGTH_GENDER         As Long = 1                 '性別
'Private Const LENGTH_ORGBSDCD       As Long = 10                '事業部コード
'Private Const LENGTH_ORGBSDNAME     As Long = 80                '事業部名称
'Private Const LENGTH_ORGROOMCD      As Long = 10                '室部コード
'Private Const LENGTH_ORGROOMNAME    As Long = 80                '室部名称
'Private Const LENGTH_ORGPOSTCD      As Long = 10                '所属コード
'Private Const LENGTH_ORGPOSTNAME    As Long = 80                '所属名称
'Private Const LENGTH_JOBCD          As Long = 9                 '職名コード
'Private Const LENGTH_JOBNAME        As Long = 100               '職名
'Private Const LENGTH_DUTYCD         As Long = 8                 '職責コード
'Private Const LENGTH_DUTYNAME       As Long = 12                '職責名称
'Private Const LENGTH_QUALIFYCD      As Long = 5                 '資格コード
'Private Const LENGTH_QUALIFYNAME    As Long = 16                '資格名称
'Private Const LENGTH_EMPDIV         As Long = 2                 '従業員区分
'Private Const LENGTH_EMPNAME        As Long = 64                '従業員名称
'Private Const LENGTH_HONGENDIV      As Long = 1                 '本現区分
'Private Const LENGTH_RETIREMENT     As Long = 1                 '休・退職区分
'Private Const LENGTH_TRANSFERDIV    As Long = 1                 '出向区分
'Private Const LENGTH_ISRSIGN        As Long = 4                 '健保記号
'Private Const LENGTH_ISRNO          As Long = 8                 '健保番号
'Private Const LENGTH_RETIREDATE     As Long = 0                 '退職年月日
Private Const LENGTH_KNAME          As Long = 32                'カナ姓名
Private Const LENGTH_BIRTH          As Long = 0                 '生年月日
Private Const LENGTH_HIREDATE       As Long = 0                 '入社年月日
Private Const LENGTH_GENDER         As Long = 1                 '性別
Private Const LENGTH_ORGBSDCD       As Long = 10                '事業部コード
Private Const LENGTH_ORGBSDNAME     As Long = 80                '事業部名称
Private Const LENGTH_ORGROOMCD      As Long = 10                '室部コード
Private Const LENGTH_ORGROOMNAME    As Long = 80                '室部名称
Private Const LENGTH_ORGPOSTCD      As Long = 10                '所属コード
Private Const LENGTH_ORGPOSTNAME    As Long = 80                '所属名称
Private Const LENGTH_JOBCD          As Long = 9                 '職名コード
Private Const LENGTH_JOBNAME        As Long = 100               '職名
Private Const LENGTH_DUTYCD         As Long = 8                 '職責コード
Private Const LENGTH_DUTYNAME       As Long = 12                '職責名称
Private Const LENGTH_QUALIFYCD      As Long = 5                 '資格コード
Private Const LENGTH_QUALIFYNAME    As Long = 16                '資格名称
Private Const LENGTH_EMPDIV         As Long = 6                 '従業員区分
Private Const LENGTH_EMPNAME        As Long = 64                '従業員区分名称
Private Const LENGTH_HONGENDIV      As Long = 1                 '本現区分
Private Const LENGTH_RETIREMENT     As Long = 1                 '休・退職区分
Private Const LENGTH_TRANSFERDIV    As Long = 1                 '出向区分
Private Const LENGTH_ISRSIGN        As Long = 4                 '健保記号
Private Const LENGTH_ISRNO          As Long = 8                 '健保番号
Private Const LENGTH_RETIREDATE     As Long = 0                 '退職年月日
'## 2003.01.29 Mod End

Private Const NAME_ORGCD1           As String = "団体コード１"  '団体コード１
Private Const NAME_ORGCD2           As String = "団体コード２"  '団体コード２
Private Const NAME_EMPNO            As String = "従業員番号"    '従業員番号
'## 2003.01.29 Mod 54Lines By T.Takagi@FSIT 姓・名フィールド削除＆名称修正
'Private Const NAME_NAME             As String = "姓名"          '姓名
'Private Const NAME_LASTNAME         As String = "姓"            '姓
'Private Const NAME_FIRSTNAME        As String = "名"            '名
'Private Const NAME_KNAME            As String = "カナ姓名"      'カナ姓名
'Private Const NAME_LASTKNAME        As String = "カナ姓"        'カナ姓
'Private Const NAME_FIRSTKNAME       As String = "カナ名"        'カナ名
'Private Const NAME_BIRTH            As String = "生年月日"      '生年月日
'Private Const NAME_HIREDATE         As String = "入社年月日"    '入社年月日
'Private Const NAME_GENDER           As String = "性別"          '性別
'Private Const NAME_ORGBSDCD         As String = "事業部コード"  '事業部コード
'Private Const NAME_ORGBSDNAME       As String = "事業部名称"    '事業部名称
'Private Const NAME_ORGROOMCD        As String = "室部コード"    '室部コード
'Private Const NAME_ORGROOMNAME      As String = "室部名称"      '室部名称
'Private Const NAME_ORGPOSTCD        As String = "所属コード"    '所属コード
'Private Const NAME_ORGPOSTNAME      As String = "所属名称"      '所属名称
'Private Const NAME_JOBCD            As String = "職名コード"    '職名コード
'Private Const NAME_JOBNAME          As String = "職名"          '職名
'Private Const NAME_DUTYCD           As String = "職責コード"    '職責コード
'Private Const NAME_DUTYNAME         As String = "職責名称"      '職責名称
'Private Const NAME_QUALIFYCD        As String = "資格コード"    '資格コード
'Private Const NAME_QUALIFYNAME      As String = "資格名称"      '資格名称
'Private Const NAME_EMPDIV           As String = "従業員区分"    '従業員区分
'Private Const NAME_EMPNAME          As String = "従業員名称"    '従業員名称
'Private Const NAME_HONGENDIV        As String = "本現区分"      '本現区分
'Private Const NAME_RETIREMENT       As String = "休・退職区分"  '休・退職区分
'Private Const NAME_TRANSFERDIV      As String = "出向区分"      '出向区分
'Private Const NAME_ISRSIGN          As String = "健保記号"      '健保記号
'Private Const NAME_ISRNO            As String = "健保番号"      '健保番号
'Private Const NAME_RETIREDATE       As String = "退職年月日"    '退職年月日
Private Const NAME_NAME             As String = "氏名"              '姓名
Private Const NAME_KNAME            As String = "カナ氏名"          'カナ姓名
Private Const NAME_BIRTH            As String = "生年月日"          '生年月日
Private Const NAME_HIREDATE         As String = "入社年月日"        '入社年月日
Private Const NAME_GENDER           As String = "性別コード"        '性別
Private Const NAME_ORGBSDCD         As String = "事業部コード"      '事業部コード
Private Const NAME_ORGBSDNAME       As String = "事業部名称"        '事業部名称
Private Const NAME_ORGROOMCD        As String = "室部コード"        '室部コード
Private Const NAME_ORGROOMNAME      As String = "室部名称"          '室部名称
Private Const NAME_ORGPOSTCD        As String = "所属コード"        '所属コード
Private Const NAME_ORGPOSTNAME      As String = "所属名称"          '所属名称
Private Const NAME_JOBCD            As String = "職名コード"        '職名コード
Private Const NAME_JOBNAME          As String = "職名"              '職名
Private Const NAME_DUTYCD           As String = "職責コード"        '職責コード
Private Const NAME_DUTYNAME         As String = "職責名称"          '職責名称
Private Const NAME_QUALIFYCD        As String = "資格レベル"        '資格コード
Private Const NAME_QUALIFYNAME      As String = "資格名称"          '資格名称
Private Const NAME_EMPDIV           As String = "従業員区分コード"  '従業員区分
Private Const NAME_EMPNAME          As String = "従業員区分名称"    '従業員区分名称
Private Const NAME_HONGENDIV        As String = "本現区分レベル"    '本現区分
Private Const NAME_RETIREMENT       As String = "従業員状態コード"  '休・退職区分
Private Const NAME_TRANSFERDIV      As String = "出向フラグ"        '出向区分
Private Const NAME_ISRSIGN          As String = "健保記号"          '健保記号
Private Const NAME_ISRNO            As String = "健康保険番号"      '健保番号
Private Const NAME_RETIREDATE       As String = "退職年月日"        '退職年月日

'## 2003.02.07 Add 3Lines By T.Takagi@FSIT 受診希望日対応
Private Const INDEX_CSLDATE         As Long = 28
Private Const LENGTH_CSLDATE        As Long = 0
Private Const NAME_CSLDATE          As String = "受診希望日"

'
' 機能　　 : 配列に格納されたＣＳＶデータのチェックを行う
'
' 引数　　 : (In)     vntNames     項目名
' 　　　　   (In)     vntColumns   カラム値
' 　　　　   (In)     vntLengths   項目長
' 　　　　   (Out)    vntMessage1  メッセージ１
' 　　　　   (Out)    vntMessage2  メッセージ２
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub CheckColumnValue(ByRef vntNames As Variant, ByRef vntColumns As Variant, ByRef vntLengths As Variant, ByRef vntMessage1 As Variant, ByRef vntMessage2 As Variant)

    Dim objCommon       As Object   '共通クラス
    
    Dim vntArrMessage1  As Variant  'メッセージ１
    Dim vntArrMessage2  As Variant  'メッセージ２
    
    Dim strStdMessage1  As String   '基本メッセージ１
    Dim strStdMessage2  As String   '基本メッセージ２
    
    Dim strLastName     As String   '姓
    Dim strFirstName    As String   '名
    
    Dim blnTooLong      As Boolean  '項目長が長すぎる場合にTrue
    Dim i               As Long     'インデックス
    Dim j               As Long     'インデックス
    
'## 2003.04.23 Add 1Line By T.Takagi@FSIT ログ修正
    Dim strMessage      As String   'メッセージ
'## 2003.04.23 Add End
    
    'オブジェクトのインスタンス作成
    Set objCommon = CreateObject("HainsCommon.Common")
    
'## 2003.04.23 Add 2Lines By T.Takagi@FSIT ログ修正
    strMessage = "従業員番号=" & IIf(vntColumns(INDEX_EMPNO) <> "", vntColumns(INDEX_EMPNO), "なし")
    strMessage = strMessage & "、氏名=" & IIf(vntColumns(INDEX_NAME) <> "", vntColumns(INDEX_NAME), "なし")
'## 2003.04.23 Add End
    
    '項目単位のチェック
    For i = LBound(vntNames) To UBound(vntNames)
    
        '必須項目のチェック
        Select Case i
        
            '団体コード１，２、従業員番号、姓名、カナ姓名、生年月日、性別は必須チェックを行う
            Case INDEX_ORGCD1, INDEX_ORGCD2, INDEX_EMPNO, INDEX_NAME, INDEX_KNAME, INDEX_BIRTH, INDEX_GENDER

                If vntColumns(i) = "" Then
'## 2003.04.23 Mod 2Lines By T.Takagi@FSIT ログ修正
'                    AppendMessage vntArrMessage1, vntArrMessage2, vntNames(i) & "が設定されていません。"
                    AppendMessage vntArrMessage1, vntArrMessage2, vntNames(i) & "が設定されていません。", strMessage
'## 2003.04.23 Mod End
                End If
            
'## 2003.01.29 Mod 4Lines By T.Takagi@FSIT 従業員区分名称対応
'            '事業部コード、室部コード、所属コード、職名コード、職責コード、資格コードは対応する名称が存在する場合のみ必須チェックを行う
'            Case INDEX_ORGBSDCD, INDEX_ORGROOMCD, INDEX_ORGPOSTCD, INDEX_JOBCD, INDEX_DUTYCD, INDEX_QUALIFYCD
            '事業部コード、室部コード、所属コード、職名コード、職責コード、資格コード、従業員区分は対応する名称が存在する場合のみ必須チェックを行う
            Case INDEX_ORGBSDCD, INDEX_ORGROOMCD, INDEX_ORGPOSTCD, INDEX_JOBCD, INDEX_DUTYCD, INDEX_QUALIFYCD, INDEX_EMPDIV
'## 2003.01.29 Mod End
            
                If vntColumns(i + 1) <> "" And vntColumns(i) = "" Then
'## 2003.04.23 Mod 2Lines By T.Takagi@FSIT ログ修正
'                    AppendMessage vntArrMessage1, vntArrMessage2, vntNames(i + 1) & "が設定されている場合、" & vntNames(i) & "は必ず必要です。"
                    AppendMessage vntArrMessage1, vntArrMessage2, vntNames(i + 1) & "が設定されている場合、" & vntNames(i) & "は必ず必要です。", strMessage
'## 2003.04.23 Mod End
                End If
            
            Case Else
        
        End Select
            
        '項目値が存在する場合のチェック処理
        Do
        
            ''項目値が存在しなければ制御を抜ける
            If vntColumns(i) = "" Then
                Exit Do
            End If
        
            blnTooLong = False
            
            '基本メッセージの作成
            strStdMessage1 = vntNames(i) & "の値が長すぎます。"
'## 2003.04.23 Mod 2Lines By T.Takagi@FSIT ログ修正
'            strStdMessage2 = vntNames(i) & "=" & vntColumns(i)
            strStdMessage2 = strMessage & "、" & vntNames(i) & "=" & vntColumns(i)
'## 2003.04.23 Mod End
            
            '項目長のチェック
            Select Case i
            
'## 2003.01.29 Del 2Lines By T.Takagi@FSIT 姓・名フィールド削除＆従業員区分名称対応
'                '姓、名、カナ姓、カナ名、従業員名称は未使用のためチェック非対象
'                Case INDEX_FIRSTNAME, INDEX_LASTNAME, INDEX_FIRSTKNAME, INDEX_LASTKNAME, INDEX_EMPNAME
'## 2003.01.29 Del End
            
'## 2003.02.07 Mod 4Lines By T.Takagi@FSIT 受診希望日対応
'                '生年月日、入社年月日、退職年月日については日付形式のため以降のチェックを行う
'                Case INDEX_BIRTH, INDEX_HIREDATE, INDEX_RETIREDATE
                '生年月日、入社年月日、退職年月日、受診希望日については日付形式のため以降のチェックを行う
                Case INDEX_BIRTH, INDEX_HIREDATE, INDEX_RETIREDATE, INDEX_CSLDATE
'## 2003.02.07 Mod End
            
                '姓名、カナ姓名は全角変換かつ空白分離後の値でチェックを行う
                Case INDEX_NAME, INDEX_KNAME
            
                    '姓名に分割
                    SplitName vntColumns(i), strLastName, strFirstName
            
                    If LenB(StrConv(strLastName, vbFromUnicode)) > vntLengths(i) Or LenB(StrConv(strFirstName, vbFromUnicode)) > vntLengths(i) Then
'## 2003.04.23 Mod 6Lines By T.Takagi@FSIT ログ修正
'                        AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strStdMessage2
                        If i = INDEX_NAME Then
                            AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strMessage
                        Else
                            AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strStdMessage2
                        End If
'## 2003.04.23 Mod End
                        blnTooLong = True
                    End If
            
'## 2003.01.29 Mod 4Lines By T.Takagi@FSIT 従業員区分名称対応
'                '事業部名称、室部名称、所属名称、職名、職責名称、資格名称は全角変換後の値でチェックを行う
'                Case INDEX_ORGBSDNAME, INDEX_ORGROOMNAME, INDEX_ORGPOSTNAME, INDEX_JOBNAME, INDEX_DUTYNAME, INDEX_QUALIFYNAME
                '事業部名称、室部名称、所属名称、職名、職責名称、資格名称、従業員区分名称は全角変換後の値でチェックを行う
                Case INDEX_ORGBSDNAME, INDEX_ORGROOMNAME, INDEX_ORGPOSTNAME, INDEX_JOBNAME, INDEX_DUTYNAME, INDEX_QUALIFYNAME, INDEX_EMPNAME
'## 2003.01.29 Mod End
            
                    If LenB(StrConv(StrConv(vntColumns(i), vbWide), vbFromUnicode)) > vntLengths(i) Then
                        AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strStdMessage2
                        blnTooLong = True
                    End If
            
                'それ以外の通常の項目長チェック
                Case Else
            
                    If LenB(StrConv(vntColumns(i), vbFromUnicode)) > vntLengths(i) Then
'## 2003.04.23 Mod 6Lines By T.Takagi@FSIT ログ修正
'                        AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strStdMessage2
                        If i = INDEX_EMPNO Then
                            AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strMessage
                        Else
                            AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strStdMessage2
                        End If
'## 2003.04.23 Mod End
                        blnTooLong = True
                    End If
            
            End Select
            
            '項目長エラー時は処理を抜ける
            If blnTooLong Then
                Exit Do
            End If
            
            '基本メッセージの作成
            strStdMessage1 = vntNames(i) & "が無効です。"
            
            '項目タイプごとのチェック
            Select Case i
            
                'カナ姓名の場合はカナ文字チェックを行う
                Case INDEX_KNAME
            
                    If Not objCommon.CheckKana(vntColumns(i)) Then
                        AppendMessage vntArrMessage1, vntArrMessage2, vntNames(i) & "に不正な文字が含まれます。", strStdMessage2
                    End If
                    
'## 2003.02.07 Mod 4Lines By T.Takagi@FSIT 受診希望日対応
'                '生年月日、入社年月日、退職年月日については日付チェックを行う
'                Case INDEX_BIRTH, INDEX_HIREDATE, INDEX_RETIREDATE
                '生年月日、入社年月日、退職年月日、受診希望日については日付チェックを行う
                Case INDEX_BIRTH, INDEX_HIREDATE, INDEX_RETIREDATE, INDEX_CSLDATE
'## 2003.02.07 Mod End
                    
                    If Not CheckDate(vntColumns(i)) Then
                        AppendMessage vntArrMessage1, vntArrMessage2, vntNames(i) & "が日付として認識できません。", strStdMessage2
                    End If
                    
                '性別は"1"、"2"しか許さない
                Case INDEX_GENDER
                
                    If Not CheckIntoValue(vntColumns(i), Array("1", "2")) Then
                         AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strStdMessage2
                    End If
                    
                '本現区分は"", "1"、"5"しか許さない
                Case INDEX_HONGENDIV
                
                    If Not CheckIntoValue(vntColumns(i), Array("", "1", "5")) Then
                         AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strStdMessage2
                    End If
                
'## 2003.04.17 Mod 8Lines By T.Takagi@FSIT 出向区分は"", "0"、"1"しか許さない
'                '出向区分は"", "0"、"1", "2", "3"しか許さない
'                Case INDEX_TRANSFERDIV
'
'                    If Not CheckIntoValue(vntColumns(i), Array("", "0", "1", "2", "3")) Then
                '出向区分は"", "0"、"1"しか許さない
                Case INDEX_TRANSFERDIV
                
                    If Not CheckIntoValue(vntColumns(i), Array("", "0", "1")) Then
'## 2003.04.17 Mod End
                         AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strStdMessage2
                    End If
                    
                '休・退職区分は"", "0"、"1"しか許さない
                Case INDEX_RETIREMENT
                
                    If Not CheckIntoValue(vntColumns(i), Array("", "0", "1")) Then
                         AppendMessage vntArrMessage1, vntArrMessage2, strStdMessage1, strStdMessage2
                    End If
                    
            End Select
                    
            Exit Do
        Loop
        
    Next i

    '戻り値の設定
    vntMessage1 = vntArrMessage1
    vntMessage2 = vntArrMessage2

    Exit Sub
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Import.CheckColumnValue"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Sub

'
' 機能　　 : ＣＳＶデータ内各項目値のチェックを行う
'
' 引数　　 : (In)     strCsvStream  ＣＳＶデータ
' 　　　　   (In)     strOrgCd1     団体コード１
' 　　　　   (In)     strOrgCd2     団体コード２
' 　　　　   (In)     vntNames      項目名の配列
' 　　　　   (In)     vntLengths    項目長の配列
' 　　　　   (Out)    udtPerson     個人情報レコード
' 　　　　   (Out)    vntMessage1   メッセージ１
' 　　　　   (Out)    vntMessage2   メッセージ２
'
' 戻り値　 : True   エラーなし
' 　　　　   False  エラーあり
'
' 備考　　 :
'
Private Function CheckCsv( _
    ByRef strCsvStream As String, _
    ByRef strOrgCd1 As String, _
    ByRef strOrgCd2 As String, _
    ByRef vntNames As Variant, _
    ByRef vntLengths As Variant, _
    ByRef udtPerson As PERSON_INF, _
    ByRef vntMessage1 As Variant, _
    ByRef vntMessage2 As Variant _
) As Boolean

    Dim vntColumns      As Variant  '各カラムの集合
    
    Dim strCsvOrgCd1    As String   '団体コード１
    Dim strCsvOrgCd2    As String   '団体コード２
    Dim strLastName     As String   '姓
    Dim strFirstName    As String   '名
    Dim strLastKName    As String   'カナ姓
    Dim strFirstKName   As String   'カナ名

    Dim vntArrMessage1  As Variant  'メッセージ１
    Dim vntArrMessage2  As Variant  'メッセージ２
    Dim strMessage      As String   'メッセージ
    
    '初期処理
    Initialize udtPerson
    vntMessage1 = Empty
    vntMessage2 = Empty
    
    Do
    
        'レコードが存在しない場合はエラー
        If strCsvStream = "" Then
            AppendMessage vntArrMessage1, vntArrMessage2, "取り込みデータが存在しません。"
            Exit Do
        End If
    
        'レコード値の配列化
'## 2003.02.07 Mod 2Lines By T.Takagi@FSIT 受診希望日対応
'        SetColumnsArrayFromCsvString strCsvStream, INDEX_RETIREDATE, vntColumns
        SetColumnsArrayFromCsvString strCsvStream, INDEX_CSLDATE, vntColumns
'## 2003.02.07 Mod End
    
        'CSVデータの項目値チェック
        CheckColumnValue vntNames, vntColumns, vntLengths, vntArrMessage1, vntArrMessage2
        
        If Not IsEmpty(vntArrMessage1) Then
            Exit Do
        End If
        
        '団体コードの取得
        strCsvOrgCd1 = vntColumns(INDEX_ORGCD1)
        strCsvOrgCd2 = vntColumns(INDEX_ORGCD2)
        
        '団体コードの値が今回処理対象の団体と異なる場合はエラー
        If strCsvOrgCd1 <> strOrgCd1 Or strCsvOrgCd2 <> strOrgCd2 Then
'## 2003.04.23 Mod 4Lines By T.Takagi@FSIT ログ修正
'            AppendMessage vntArrMessage1, vntArrMessage2, "この団体は処理対象外です。", "団体コード=" & strCsvOrgCd1 & "-" & strCsvOrgCd2
            strMessage = "従業員番号=" & IIf(vntColumns(INDEX_EMPNO) <> "", vntColumns(INDEX_EMPNO), "なし")
            strMessage = strMessage & "、氏名=" & IIf(vntColumns(INDEX_NAME) <> "", vntColumns(INDEX_NAME), "なし")
            AppendMessage vntArrMessage1, vntArrMessage2, "この団体は処理対象外です。", strMessage & "、団体コード=" & strCsvOrgCd1 & "-" & strCsvOrgCd2
'## 2003.04.23 Mod End
            Exit Do
        End If
        
        '姓名の分割
        SplitName vntColumns(INDEX_NAME), strLastName, strFirstName
        SplitName vntColumns(INDEX_KNAME), strLastKName, strFirstKName
        
        '戻り値の設定
        With udtPerson
            .DelFlg = CLng("0" & vntColumns(INDEX_RETIREMENT))
            .TransferDiv = CLng("0" & vntColumns(INDEX_TRANSFERDIV))
            .LastName = strLastName
            .FirstName = strFirstName
            .LastKName = strLastKName
            .FirstKName = strFirstKName
            .Birth = IIf(Not IsDate(vntColumns(INDEX_BIRTH)), Format(vntColumns(INDEX_BIRTH), "0000/00/00"), vntColumns(INDEX_BIRTH))
            .Gender = vntColumns(INDEX_GENDER)
            .OrgBsdCd = vntColumns(INDEX_ORGBSDCD)
            .OrgBsdName = StrConv(vntColumns(INDEX_ORGBSDNAME), vbWide)
            .OrgRoomCd = vntColumns(INDEX_ORGROOMCD)
            .OrgRoomName = StrConv(vntColumns(INDEX_ORGROOMNAME), vbWide)
            .OrgPostCd = vntColumns(INDEX_ORGPOSTCD)
            .OrgPostName = StrConv(vntColumns(INDEX_ORGPOSTNAME), vbWide)
            .JobCd = vntColumns(INDEX_JOBCD)
            .JobName = StrConv(vntColumns(INDEX_JOBNAME), vbWide)
            .DutyCd = vntColumns(INDEX_DUTYCD)
            .DutyName = StrConv(vntColumns(INDEX_DUTYNAME), vbWide)
            .QualifyCd = vntColumns(INDEX_QUALIFYCD)
            .QualifyName = StrConv(vntColumns(INDEX_QUALIFYNAME), vbWide)
            .IsrSign = vntColumns(INDEX_ISRSIGN)
            .IsrNo = vntColumns(INDEX_ISRNO)
            .RelationCd = RELATIONCD_SELF
            .BranchNo = BRANCHNO_SELF
            .EmpNo = vntColumns(INDEX_EMPNO)
'## 2003.01.29 Mod 6Lines By T.Takagi@FSIT 日付型変数の編集不備
'            .HireDate = CDate("0" & vntColumns(INDEX_HIREDATE))
            If vntColumns(INDEX_HIREDATE) <> "" Then
                .HireDate = IIf(Not IsDate(vntColumns(INDEX_HIREDATE)), Format(vntColumns(INDEX_HIREDATE), "0000/00/00"), vntColumns(INDEX_HIREDATE))
            Else
                .HireDate = 0
            End If
'## 2003.01.29 Mod End
            .EmpDiv = vntColumns(INDEX_EMPDIV)
'## 2003.01.29 Add 1Line By T.Takagi@FSIT 従業員区分名称対応
            .EmpName = StrConv(vntColumns(INDEX_EMPNAME), vbWide)
'## 2003.01.29 Add End
            .HongenDiv = vntColumns(INDEX_HONGENDIV)
'## 2003.02.07 Add 5Lines By T.Takagi@FSIT 受診希望日対応
            If vntColumns(INDEX_CSLDATE) <> "" Then
                .CslDate = IIf(Not IsDate(vntColumns(INDEX_CSLDATE)), Format(vntColumns(INDEX_CSLDATE), "0000/00/00"), vntColumns(INDEX_CSLDATE))
            Else
                .CslDate = 0
            End If
'## 2003.02.07 Add End
        
'## 2003.04.22 Add 3Lines By T.Takagi@FSIT 健保番号の先頭ゼロカット
            Do Until Left(.IsrNo, 1) <> "0"
                .IsrNo = Right(.IsrNo, Len(.IsrNo) - 1)
            Loop
'## 2003.04.22 Add End
        End With
        
        CheckCsv = True
        
        Exit Do
    Loop
    
    'メッセージの編集
    vntMessage1 = vntArrMessage1
    vntMessage2 = vntArrMessage2
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Import.CheckCsv"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
End Function

'## 2003.04.04 Add Function By T.Takagi@FSIT 個人情報削除機能追加
'
' 機能　　 : 指定個人ＩＤと同一健保記号、番号、続柄、枝番を持つ、従業員情報が未設定である個人情報を削除する
'
' 引数　　 : (In)     strPerId     個人ＩＤ
' 　　　　   (In)     lngTransId   トランザクションＩＤ
' 　　　　   (In)     strTransDiv  トランザクション区分
' 　　　　   (In)     lngLineNo    行番号
'
' 戻り値　 :
'
' 備考　　 :
'
Private Sub DeletePerson(ByVal strPerId As String, ByVal lngTransId As Long, ByVal strTransDiv As String, ByVal lngLineNo As Long)

    Dim objPerson           As Object       '個人情報アクセス用
    Dim objRegistPerson     As RegistPerson '個人情報登録用
    
    Dim vntPerId            As Variant      '個人ＩＤ
    Dim vntLastName         As Variant      '姓
    Dim vntFirstName        As Variant      '名
    Dim vntTel1             As Variant      '電話番号１－市外局番
    Dim vntTel2             As Variant      '電話番号１－局番
    Dim vntTel3             As Variant      '電話番号１－番号
    Dim vntZipCd1           As Variant      '郵便番号１
    Dim vntZipCd2           As Variant      '郵便番号２
    Dim vntPrefCd           As Variant      '都道府県コード
    Dim vntCityName         As Variant      '市区町村名
    Dim vntAddress1         As Variant      '住所１
    Dim vntAddress2         As Variant      '住所２
    Dim lngCount            As Long         'レコード数

    Dim strMessage          As String       'メッセージ
    Dim Ret                 As Long         '関数戻り値
    Dim i                   As Long         'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objPerson = CreateObject("HainsPerson.Person")
    Set objRegistPerson = CreateObject("HainsCooperation.RegistPerson")
    
    '指定個人ＩＤと同一健保記号、番号、続柄、枝番を持つ、従業員情報が未設定である個人情報を取得
    lngCount = objRegistPerson.SelectPersonSameIsr(strPerId, vntPerId, vntLastName, vntFirstName, vntTel1, vntTel2, vntTel3, vntZipCd1, vntZipCd2, vntPrefCd, vntCityName, vntAddress1, vntAddress2)
    
    '削除前の通知
    If lngCount > 0 Then
        PutHainsLog mobjOraDb, lngTransId, strTransDiv, "I", lngLineNo, "この個人と同一な健保記号・番号・続柄・枝番をもつ従業員番号未設定の個人情報を削除します。", ""
    End If
    
    '個人情報の検索
    For i = 0 To lngCount - 1
    
        'これらの個人情報は基本的に引数指定個人ＩＤの個人情報と同一人物であるため、個人属性情報を移行する
        objRegistPerson.RegistPersonDetail strPerId, vntTel1(i), vntTel2(i), vntTel3(i), vntZipCd1(i), vntZipCd2(i), vntPrefCd(i), vntCityName(i), vntAddress1(i), vntAddress2(i)

        'メッセージ２をあらかじめ編集
        strMessage = "氏名=" & Trim(vntLastName(i) & "　" & vntFirstName(i)) & "（" & vntPerId(i) & "）"
        
        '個人情報の削除
        Ret = objPerson.DeletePerson(vntPerId(i))
        Select Case Ret
            Case 0
                PutHainsLog mobjOraDb, lngTransId, strTransDiv, "I", lngLineNo, "個人情報が削除されました。", strMessage
            Case -1
                PutHainsLog mobjOraDb, lngTransId, strTransDiv, "E", lngLineNo, "アフターケア情報が存在します。削除できません。", strMessage
            Case -2
                PutHainsLog mobjOraDb, lngTransId, strTransDiv, "E", lngLineNo, "受診情報が存在します。削除できません。", strMessage
        End Select
            
    Next i
    
    Exit Sub
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Import.DeletePerson"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Sub

'
' 機能　　 : 個人情報の取り込みならびに受診情報の作成を行う
'
' 引数　　 : (In)     strFileName           個人情報ファイル名
' 　　　　   (In)     strOrgCd1             団体コード１
' 　　　　   (In)     strOrgCd2             団体コード２
' 　　　　   (In)     strUserId             ユーザＩＤ
' 　　　　   (In)     lngCtrPtCd            契約パターンコード(省略時は個人情報の取り込みのみを行う)
' 　　　　   (Out)    vntReadCount          読み込みレコード数
' 　　　　   (Out)    vntWritePersonCount   作成／更新個人情報数
' 　　　　   (Out)    vntWriteConsultCount  作成受診情報数
' 　　　　   (In)     blnSkipFirstRow       True指定時、先頭行を見出し行とみなしてスキップする
'
' 戻り値　 :
'
' 備考　　 :
'
'## 2003.01.29 Mod 21Lines By T.Takagi@FSIT 先頭行スキップ機能追加
'Public Sub ImportPerson(
'    ByVal strFileName As String,
'    ByVal strOrgCd1 As String,
'    ByVal strOrgCd2 As String,
'    Optional ByVal strUserId As String = "",
'    Optional ByVal lngCtrPtCd As Long = 0,
'    Optional ByRef vntReadCount As Variant,
'    Optional ByRef vntWritePersonCount As Variant,
'    Optional ByRef vntWriteConsultCount As Variant
')
Public Sub ImportPerson( _
    ByVal strFileName As String, _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    Optional ByVal strUserId As String = "", _
    Optional ByVal lngCtrPtCd As Long = 0, _
    Optional ByRef vntReadCount As Variant, _
    Optional ByRef vntWritePersonCount As Variant, _
    Optional ByRef vntWriteConsultCount As Variant, _
    Optional ByVal blnSkipFirstRow As Boolean = True _
)
'## 2003.01.29 Mod End

    Dim objFso              As Object       'ファイルシステムオブジェクト
    Dim objConsult          As ConsultAll   '一括予約用
    Dim objContract         As Object       '契約情報アクセス用
    Dim objFree             As Object       '汎用情報アクセス用
    Dim objHainsLog         As Object       'ログ情報アクセス用
    Dim objOrganization     As Object       '団体情報アクセス用
    Dim objPerson           As Object       '個人情報アクセス用
    Dim objRegistPerson     As RegistPerson '個人情報登録用
    
    Dim lngTransactionId    As Long         'トランザクションＩＤ
    Dim strTransactionDiv   As String       'トランザクション区分
    
    Dim vntNames            As Variant      '項目名の配列
    Dim vntLengths          As Variant      '項目長の配列
    
    Dim vntOrgSName         As Variant      '団体略称
    Dim vntCsCd             As Variant      'コースコード
    Dim vntCsName           As Variant      'コース名
    Dim vntStrDate          As Variant      '契約開始日
    Dim vntEndDate          As Variant      '契約終了日
    
    Dim intFileNo           As Integer      'ファイル番号
    Dim strBuffer           As String       '文字列バッファ
    
    Dim vntFreeCdHeader     As Variant      '挿入対象となる汎用コード接頭辞の配列
    Dim vntFreeCdBody       As Variant      '挿入対象となる汎用コードの配列
    Dim vntFreeClassCd      As Variant      '挿入対象となる汎用分類コードの配列
    Dim vntFreeName         As Variant      '挿入対象となる汎用名の配列
    Dim vntFreeField        As Variant      '挿入対象となるフィールド値の配列
    
    Dim lngLineNo           As Long         '行番号
    
    Dim udtPerson           As PERSON_INF   '個人情報構造体

    Dim vntPerId            As Variant      '個人ＩＤ
    Dim vntLastName         As Variant      '姓
    Dim vntFirstName        As Variant      '名
    Dim vntLastKName        As Variant      'カナ姓
    Dim vntFirstKName       As Variant      'カナ名
    Dim vntBirth            As Variant      '生年月日
    Dim vntGender           As Variant      '性別
    Dim vntIsrSign          As Variant      '健保記号
    Dim vntIsrNo            As Variant      '健保番号

    Dim strUpdJobCd         As String       '(登録時の)職名コード
    Dim strUpdDutyCd        As String       '(登録時の)職責コード
    Dim strUpdQualifyCd     As String       '(登録時の)資格コード
'## 2003.01.29 Add 1Line By T.Takagi@FSIT 従業員区分名称対応
    Dim strUpdEmpDiv        As String       '(登録時の)従業員区分
'## 2003.01.29 Add End

    Dim lngReadCount        As Long         '読み込みレコード数
    Dim lngPerCount         As Long         '作成／更新個人情報数
    Dim lngCslCount         As Long         '作成受診情報数
    
    Dim vntTitle            As Variant      '表題
    Dim vntMessage1         As Variant      'メッセージ１
    Dim vntMessage2         As Variant      'メッセージ２
    Dim strMessage1         As String       'メッセージ１
    Dim strMessage2         As String       'メッセージ２
    Dim strMode             As String       '処理モード
    Dim strInformationDiv   As String       '情報区分
    Dim blnCompareError     As Boolean      'エラーフラグ
    Dim Ret                 As Boolean      '関数戻り値
    Dim blnExists           As Boolean      '個人テーブルの存在状態
    Dim Ret2                As Long         '関数戻り値
    Dim i                   As Long         'インデックス
'## 2003.04.04 Add 1Line By T.Takagi@FSIT 従業員キーのレコードがなければ健保キーでチェック
    Dim Ret3                As Long         '関数戻り値
'## 2003.04.04 Add End
    
'## 2003.01.29 Add 1Line By T.Takagi@FSIT 入社年月日の編集ロジック不備
    Dim vntHireDate         As Variant      '入社年月日
'## 2003.01.29 Add End
    
'## 2003.04.22 Mod 1Line By T.Takagi@FSIT 新取り込み処理
    Dim vntEmpNo            As Variant      '従業員番号
'## 2003.04.22 Add End
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'オブジェクトのインスタンス作成
    Set objFso = CreateObject("Scripting.FileSystemObject")
    Set objConsult = CreateObject("HainsCooperation.ConsultAll")
    Set objContract = CreateObject("HainsContract.Contract")
    Set objFree = CreateObject("HainsFree.Free")
    Set objHainsLog = CreateObject("HainsHainsLog.HainsLog")
    Set objOrganization = CreateObject("HainsOrganization.Organization")
    Set objPerson = CreateObject("HainsPerson.Person")
    Set objRegistPerson = CreateObject("HainsCooperation.RegistPerson")
    
    'トランザクションＩＤ・区分・表題の取得
    lngTransactionId = objHainsLog.IncreaseTransactionId()
    strTransactionDiv = IIf(lngCtrPtCd = 0, TRANSACTIONDIV_PERCSV, TRANSACTIONDIV_RSVCSV)
    
    '項目名の配列を作成
'## 2003.01.29 Mod 15Lines By T.Takagi@FSIT 姓・名フィールド削除
'    vntNames = Array(NAME_ORGCD1, NAME_ORGCD2, NAME_EMPNO, NAME_NAME, _
'                     NAME_LASTNAME, NAME_FIRSTNAME, NAME_KNAME, NAME_LASTKNAME, _
'                     NAME_FIRSTKNAME, NAME_BIRTH, NAME_HIREDATE, NAME_GENDER, _
'                     NAME_ORGBSDCD, NAME_ORGBSDNAME, NAME_ORGROOMCD, NAME_ORGROOMNAME, _
'                     NAME_ORGPOSTCD, NAME_ORGPOSTNAME, NAME_JOBCD, NAME_JOBNAME, _
'                     NAME_DUTYCD, NAME_DUTYNAME, NAME_QUALIFYCD, NAME_QUALIFYNAME, _
'                     NAME_EMPDIV, NAME_EMPNAME, NAME_HONGENDIV, NAME_RETIREMENT, _
'                     NAME_TRANSFERDIV, NAME_ISRSIGN, NAME_ISRNO, NAME_RETIREDATE)
'## 2003.02.07 Mod 14Lines By T.Takagi@FSIT 受診希望日対応
'    vntNames = Array(NAME_ORGCD1, NAME_ORGCD2, NAME_EMPNO, NAME_NAME, NAME_KNAME, _
'                     NAME_BIRTH, NAME_HIREDATE, NAME_GENDER, _
'                     NAME_ORGBSDCD, NAME_ORGBSDNAME, NAME_ORGROOMCD, NAME_ORGROOMNAME, _
'                     NAME_ORGPOSTCD, NAME_ORGPOSTNAME, NAME_JOBCD, NAME_JOBNAME, _
'                     NAME_DUTYCD, NAME_DUTYNAME, NAME_QUALIFYCD, NAME_QUALIFYNAME, _
'                     NAME_EMPDIV, NAME_EMPNAME, NAME_HONGENDIV, NAME_RETIREMENT, _
'                     NAME_TRANSFERDIV, NAME_ISRSIGN, NAME_ISRNO, NAME_RETIREDATE)
    vntNames = Array(NAME_ORGCD1, NAME_ORGCD2, NAME_EMPNO, NAME_NAME, NAME_KNAME, _
                     NAME_BIRTH, NAME_HIREDATE, NAME_GENDER, _
                     NAME_ORGBSDCD, NAME_ORGBSDNAME, NAME_ORGROOMCD, NAME_ORGROOMNAME, _
                     NAME_ORGPOSTCD, NAME_ORGPOSTNAME, NAME_JOBCD, NAME_JOBNAME, _
                     NAME_DUTYCD, NAME_DUTYNAME, NAME_QUALIFYCD, NAME_QUALIFYNAME, _
                     NAME_EMPDIV, NAME_EMPNAME, NAME_HONGENDIV, NAME_RETIREMENT, _
                     NAME_TRANSFERDIV, NAME_ISRSIGN, NAME_ISRNO, NAME_RETIREDATE, NAME_CSLDATE)
'## 2003.02.07 Mod End
'## 2003.01.29 Mod End
    
    '項目長の配列を作成
'## 2003.01.29 Mod 15Lines By T.Takagi@FSIT 姓・名フィールド削除
'    vntLengths = Array(LENGTH_ORGCD1, LENGTH_ORGCD2, LENGTH_EMPNO, LENGTH_NAME, _
'                       LENGTH_LASTNAME, LENGTH_FIRSTNAME, LENGTH_KNAME, LENGTH_LASTKNAME, _
'                       LENGTH_FIRSTKNAME, LENGTH_BIRTH, LENGTH_HIREDATE, LENGTH_GENDER, _
'                       LENGTH_ORGBSDCD, LENGTH_ORGBSDNAME, LENGTH_ORGROOMCD, LENGTH_ORGROOMNAME, _
'                       LENGTH_ORGPOSTCD, LENGTH_ORGPOSTNAME, LENGTH_JOBCD, LENGTH_JOBNAME, _
'                       LENGTH_DUTYCD, LENGTH_DUTYNAME, LENGTH_QUALIFYCD, LENGTH_QUALIFYNAME, _
'                       LENGTH_EMPDIV, LENGTH_EMPNAME, LENGTH_HONGENDIV, LENGTH_RETIREMENT, _
'                       LENGTH_TRANSFERDIV, LENGTH_ISRSIGN, LENGTH_ISRNO, LENGTH_RETIREDATE)
'## 2003.02.07 Mod 14Lines By T.Takagi@FSIT 受診希望日対応
'    vntLengths = Array(LENGTH_ORGCD1, LENGTH_ORGCD2, LENGTH_EMPNO, LENGTH_NAME, LENGTH_KNAME, _
'                       LENGTH_BIRTH, LENGTH_HIREDATE, LENGTH_GENDER, _
'                       LENGTH_ORGBSDCD, LENGTH_ORGBSDNAME, LENGTH_ORGROOMCD, LENGTH_ORGROOMNAME, _
'                       LENGTH_ORGPOSTCD, LENGTH_ORGPOSTNAME, LENGTH_JOBCD, LENGTH_JOBNAME, _
'                       LENGTH_DUTYCD, LENGTH_DUTYNAME, LENGTH_QUALIFYCD, LENGTH_QUALIFYNAME, _
'                       LENGTH_EMPDIV, LENGTH_EMPNAME, LENGTH_HONGENDIV, LENGTH_RETIREMENT, _
'                       LENGTH_TRANSFERDIV, LENGTH_ISRSIGN, LENGTH_ISRNO, LENGTH_RETIREDATE)
    vntLengths = Array(LENGTH_ORGCD1, LENGTH_ORGCD2, LENGTH_EMPNO, LENGTH_NAME, LENGTH_KNAME, _
                       LENGTH_BIRTH, LENGTH_HIREDATE, LENGTH_GENDER, _
                       LENGTH_ORGBSDCD, LENGTH_ORGBSDNAME, LENGTH_ORGROOMCD, LENGTH_ORGROOMNAME, _
                       LENGTH_ORGPOSTCD, LENGTH_ORGPOSTNAME, LENGTH_JOBCD, LENGTH_JOBNAME, _
                       LENGTH_DUTYCD, LENGTH_DUTYNAME, LENGTH_QUALIFYCD, LENGTH_QUALIFYNAME, _
                       LENGTH_EMPDIV, LENGTH_EMPNAME, LENGTH_HONGENDIV, LENGTH_RETIREMENT, _
                       LENGTH_TRANSFERDIV, LENGTH_ISRSIGN, LENGTH_ISRNO, LENGTH_RETIREDATE, LENGTH_CSLDATE)
'## 2003.02.07 Mod End
'## 2003.01.29 Mod End
    
    '汎用テーブルレコード挿入時の固定値情報を作成
'## 2003.01.29 Mod 6Lines By T.Takagi@FSIT 従業員区分名称対応
'    vntFreeCdHeader = Array("JOB", "DUTY", "QUALIFY")
'    vntFreeClassCd = Array("JOB", "DUT", "QFY")
'    vntFreeName = Array("職名", "職責", "資格")
    vntFreeCdHeader = Array("JOB", "DUTY", "QUALIFY", "EMPDIV")
    vntFreeClassCd = Array("JOB", "DUT", "QFY", "EMP")
    vntFreeName = Array("職名", "職責", "資格", "従業員区分")
'## 2003.01.29 Mod End
    
    '汎用テーブルから表題を取得
    objFree.SelectFree 0, strTransactionDiv, , vntTitle
    
    '開始ログの発行
    PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, "I", "", vntTitle & "処理を開始します。", ""
    
    '指定されたパラメータ情報を編集する
    Do
    
        '団体略称の取得
        If objOrganization.SelectOrg(strOrgCd1, strOrgCd2, , , , vntOrgSName) = False Then
            PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, "E", "", "団体情報が存在しません。", "団体コード=" & strOrgCd1 & "-" & strOrgCd2
            Exit Do
        End If
        
        'ログ発行
        PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, "I", "", "■次の団体が指定されました。", "団体=" & vntOrgSName & "（" & strOrgCd1 & "-" & strOrgCd2 & "）"
    
        '契約パターン指定時
        If lngCtrPtCd > 0 Then
        
            '契約管理情報の読み込み
            If objContract.SelectCtrMng(strOrgCd1, strOrgCd2, lngCtrPtCd, vntOrgSName, vntCsCd, vntCsName, vntStrDate, vntEndDate) = False Then
                PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, "E", "", "契約情報が存在しません。", "契約パターンコード=" & lngCtrPtCd
                Exit Do
            End If
        
            'ログ発行
            strMessage2 = "契約パターンコード=" & lngCtrPtCd
            strMessage2 = strMessage2 & "、コース=" & vntCsName & "（" & vntCsCd & "）"
            strMessage2 = strMessage2 & "、契約期間=" & vntStrDate & "-" & vntEndDate
            PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, "I", "", "■次の契約情報が指定されました。", strMessage2
    
        End If
    
        'ファイルが存在しない場合は処理を終了する
        If objFso.FileExists(strFileName) = False Then
            PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, "E", "", "ファイルが存在しません。", "ファイル名=" & strFileName
            Exit Do
        End If
    
        'ファイルオープン
        intFileNo = FreeFile()
        Open strFileName For Input Lock Read Write As #intFileNo
    
'## 2003.01.29 Add 3Lines By T.Takagi@FSIT 先頭行スキップ機能追加
        If Not EOF(intFileNo) And blnSkipFirstRow = True Then
            Line Input #intFileNo, strBuffer
        End If
'## 2003.01.29 Add End
        
        'ファイル読み込み
        Do Until EOF(intFileNo)
   
            Do
                
                '１行読み込み
                Line Input #intFileNo, strBuffer

                '行番号をインクリメント
                lngLineNo = lngLineNo + 1

                '行データが存在しない場合はスキップ
                If Trim(strBuffer) = "" Then
                    Exit Do
                End If
                
                '読み込みレコード数のインクリメント
                lngReadCount = lngReadCount + 1
                
                'CSVデータのチェック
                Ret = CheckCsv(strBuffer, strOrgCd1, strOrgCd2, vntNames, vntLengths, udtPerson, vntMessage1, vntMessage2)
    
                'エラー時はログを発行し、次レコードへ
                If Ret = False Then
                    PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, "E", lngLineNo, vntMessage1, vntMessage2
                    Exit Do
                End If
    
'## 2003.04.22 Mod 344Lines By T.Takagi@FSIT 新取り込み処理
''## 2003.02.20 Add 23Lines By T.Takagi@FSIT 新規挿入にて退職者及び出向者は取り込まない
'                '団体・従業員番号をキーに個人情報の有無を検索する
'                blnExists = objRegistPerson.SelectPersonFromOrg(strOrgCd1, strOrgCd2, udtPerson.EmpNo, vntPerId, vntLastName, vntFirstName, vntLastKName, vntFirstKName, vntBirth, vntGender, vntIsrSign, vntIsrNo)
'
''## 2003.04.04 Add 40Lines By T.Takagi@FSIT 従業員キーのレコードがなければ健保キーでチェック
'                '従業員キーによる個人情報が存在しない場合
'                If blnExists = False Then
'
'                    '読み込みレコードに健保記号、健保番号が存在するならば
'                    If udtPerson.IsrSign <> "" And udtPerson.IsrNo <> "" Then
'
'                        vntIsrSign = Empty
'                        vntIsrNo = Empty
'
'                        '健保記号・健保番号・続柄・枝番をキーに個人情報の有無を検索する
'                        Ret3 = objRegistPerson.SelectPersonFromIsr(udtPerson.IsrSign, udtPerson.IsrNo, udtPerson.RelationCd, udtPerson.BranchNo, vntPerId, vntLastName, vntFirstName, vntLastKName, vntFirstKName, vntBirth, vntGender)
'                        Select Case Ret3
'
'                            'レコードがただ１つ存在する場合
'                            Case Is > 0
'
'                                '個人情報の存在状態を更新
'                                blnExists = True
'
'                                '後の健保記号、健保番号相違チェックに掛からないよう、値を格納しておく
'                                vntIsrSign = udtPerson.IsrSign
'                                vntIsrNo = udtPerson.IsrNo
'
'                            'レコードが複数存在する場合
'                            Case 0
'
'                                'ログを発行して次レコードへ
'                                strMessage2 = "健保記号=" & udtPerson.IsrSign
'                                strMessage2 = strMessage2 & "、健保番号=" & udtPerson.IsrNo
''## 2003.04.17 Add 1Line By T.Takagi@FSIT メッセージ強化
'                                strMessage2 = strMessage2 & "、氏名=" & Trim(udtPerson.LastName & "　" & udtPerson.FirstName)
''## 2003.04.17 Add End
'                                PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, "E", lngLineNo, "この健保記号、番号を持つ本人個人情報が複数存在します。", strMessage2
'                                Exit Do
'
'                            'レコードが存在しない場合は完全なる新規レコードであり、ここでは何もする必要はない
'                            Case Else
'
'                        End Select
'
'                    End If
'
'                End If
''## 2003.04.04 Add End
'
'                'レコードが存在しない場合、すなわち新規挿入時
'                If blnExists = False Then
'
'                    '退職者であれば取り込み対象とせず、次レコードへ
'                    If udtPerson.DelFlg <> "0" Then
'                        strMessage1 = "退職者のため、新規取り込みは行われません。"
'                        strMessage2 = "従業員番号=" & udtPerson.EmpNo & "、氏名=" & Trim(udtPerson.LastName & "　" & udtPerson.FirstName)
''## 2003.04.17 Mod 2Lines By T.Takagi@FSIT 実際は大量に出て鬱陶しいということで情報区分を変更する
''                        PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, "E", lngLineNo, strMessage1, strMessage2
'                        PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, "I", lngLineNo, strMessage1, strMessage2
''## 2003.04.17 Mod End
'                        Exit Do
'                    End If
'
'                    '出向者であれば取り込み対象とせず、次レコードへ
'                    If udtPerson.TransferDiv <> "0" Then
'                        strMessage1 = "出向者のため、新規取り込みは行われません。"
'                        strMessage2 = "従業員番号=" & udtPerson.EmpNo & "、氏名=" & Trim(udtPerson.LastName & "　" & udtPerson.FirstName)
''## 2003.04.17 Mod 2Lines By T.Takagi@FSIT 実際は大量に出て鬱陶しいということで情報区分を変更する
''                        PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, "E", lngLineNo, strMessage1, strMessage2
'                        PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, "I", lngLineNo, strMessage1, strMessage2
''## 2003.04.17 Mod End
'                        Exit Do
'                    End If
'
'                End If
''## 2003.02.20 Add End
'
'                '健保記号、健保番号の特殊処理
'                With udtPerson
'
'                    '健保記号、健保番号のいずれかが存在しない場合
'                    If (.IsrSign = "" And .IsrNo <> "") Or (.IsrSign <> "" And .IsrNo = "") Then
'
'                        'ワーニングログを発行
'                        strMessage1 = "健保記号、健保番号のいずれかが未指定です。以後両値とも未指定で扱います。"
'                        strMessage2 = "健保記号=" & IIf(.IsrSign <> "", .IsrSign, "なし")
'                        strMessage2 = strMessage2 & "、健保番号=" & IIf(.IsrNo <> "", .IsrNo, "なし")
'                        PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, "W", lngLineNo, strMessage1, strMessage2
'
'                        '以後双方とも指定なしとして扱う
'                        .IsrSign = ""
'                        .IsrNo = ""
'
'                    End If
'
'                End With
'
''## 2003.02.20 Del 2Lines By T.Takagi@FSIT 新規挿入にて退職者は取り込まない
''                '団体・従業員番号をキーに個人情報の有無を検索する
''                blnExists = objRegistPerson.SelectPersonFromOrg(strOrgCd1, strOrgCd2, udtPerson.EmpNo, vntPerId, vntLastName, vntFirstName, vntLastKName, vntFirstKName, vntBirth, vntGender, vntIsrSign, vntIsrNo)
''## 2003.02.20 Del End
'
'                'レコード存在時
'                If blnExists = True Then
'
'                    blnCompareError = False
'
'                    'CSVデータの生年月日、性別と個人情報の各値とを比較
'                    ComparePerson udtPerson, vntBirth, vntGender, vntPerId, vntLastName, vntFirstName, vntMessage1, vntMessage2
'                    If Not IsEmpty(vntMessage1) Then
'                        PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, "E", lngLineNo, vntMessage1, vntMessage2
'                        blnCompareError = True
'                    End If
'
''## 2003.04.17 Add 6Lines By T.Takagi@FSIT 退職者であれば現在の個人テーブルレコード上の健保記号・健保番号を有効にする
'                    '退職者であれば現在の個人テーブルレコード上の健保記号・健保番号を有効にする
'                    '(現レコード値をクリアすべきでなく、またこの後のチェック処理にてエラーとならないための制御)
'                    If udtPerson.DelFlg <> "0" Then
'                        udtPerson.IsrSign = vntIsrSign
'                        udtPerson.IsrNo = vntIsrNo
'                    End If
''## 2003.04.17 Add End
'
'                    'CSVデータの健保記号、健保番号と個人情報の各値とを比較
'                    CompareIsr udtPerson, vntIsrSign, vntIsrNo, vntPerId, vntLastName, vntFirstName, vntMessage1, vntMessage2
'                    If Not IsEmpty(vntMessage1) Then
'                        PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, "E", lngLineNo, vntMessage1, vntMessage2
'                        blnCompareError = True
'                    End If
'
'                    '比較エラー時は次レコードへ
'                    If blnCompareError Then
'                        Exit Do
'                    End If
'
'                    'CSVデータの姓名と個人情報とのそれとを比較し、エラー時は警告ログを発行する
'                    CompareName udtPerson, vntLastName, vntFirstName, vntLastKName, vntFirstKName, vntMessage1, vntMessage2
'                    If Not IsEmpty(vntMessage1) Then
'                        PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, "W", lngLineNo, vntMessage1, vntMessage2
'                    End If
'
'                End If
    
                '団体・従業員番号をキーに個人情報の有無を検索する
                blnExists = objRegistPerson.SelectPersonFromOrg(strOrgCd1, strOrgCd2, udtPerson.EmpNo, vntPerId, vntLastName, vntFirstName, vntLastKName, vntFirstKName, vntBirth, vntGender, vntIsrSign, vntIsrNo)
    
                '個人情報が存在する場合
                If blnExists Then
                
                    blnCompareError = False

                    'CSVデータの生年月日、性別と個人情報の各値とを比較
                    ComparePerson udtPerson, vntBirth, vntGender, vntPerId, vntLastName, vntFirstName, vntMessage1, vntMessage2
                    If Not IsEmpty(vntMessage1) Then
                        For i = 0 To UBound(vntMessage1)
                            vntMessage2(i) = "従業員番号=" & udtPerson.EmpNo & "、" & vntMessage2(i)
                        Next i
                        PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, "E", lngLineNo, vntMessage1, vntMessage2
                        blnCompareError = True
                    End If
    
                    '現個人情報に健保記号、番号が存在する場合(データベース上で片方だけ存在するという場合は発生しえない)
                    If vntIsrSign <> "" Or vntIsrNo <> "" Then
                    
                        '健保番号が存在する場合
                        If udtPerson.IsrNo <> "" Then
                    
                            'CSVデータに健保番号しか存在しない場合、健保記号は現個人情報の値を使用する
                            If udtPerson.IsrSign = "" Then
                                udtPerson.IsrSign = vntIsrSign
                            End If
                    
                            'CSVデータの健保記号、健保番号と個人情報の各値とを比較
                            CompareIsr udtPerson, vntIsrSign, vntIsrNo, vntPerId, vntLastName, vntFirstName, vntMessage1, vntMessage2
                            If Not IsEmpty(vntMessage1) Then
                                PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, "E", lngLineNo, vntMessage1, vntMessage2
                                blnCompareError = True
                            End If
                            
                        '健保番号が存在しない場合
                        Else
                        
                            '(エラー時を除く)健保記号が存在する場合
                            If (Not blnCompareError) And udtPerson.IsrSign <> "" Then
                                
                                'ログを発行
                                strMessage1 = "健保記号、健保番号のいずれかが未指定です。以後両値とも未指定で扱います。"
                                strMessage2 = "従業員番号=" & udtPerson.EmpNo
                                strMessage2 = strMessage2 & "、氏名=" & Trim(udtPerson.LastName & "　" & udtPerson.FirstName)
                                strMessage2 = strMessage2 & "、健保記号=" & IIf(udtPerson.IsrSign <> "", udtPerson.IsrSign, "なし")
                                strMessage2 = strMessage2 & "、健保番号=" & IIf(udtPerson.IsrNo <> "", udtPerson.IsrNo, "なし")
                                PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, "I", lngLineNo, strMessage1, strMessage2
                                    
                                '健保番号も指定なしとして扱う
                                udtPerson.IsrSign = ""
                                
                            End If
                            
                        End If
                        
                    '現個人情報に健保記号、番号ともに存在しない場合
                    Else
                    
                        '健保記号、健保番号の特殊処理
                        With udtPerson
        
                            '健保記号、健保番号のいずれかが存在しない場合
                            If (.IsrSign = "" And .IsrNo <> "") Or (.IsrSign <> "" And .IsrNo = "") Then
        
                                'ログを発行
                                strMessage1 = "健保記号、健保番号のいずれかが未指定です。以後両値とも未指定で扱います。"
                                strMessage2 = "従業員番号=" & udtPerson.EmpNo
                                strMessage2 = strMessage2 & "、氏名=" & Trim(udtPerson.LastName & "　" & udtPerson.FirstName)
                                strMessage2 = strMessage2 & "、健保記号=" & IIf(.IsrSign <> "", .IsrSign, "なし")
                                strMessage2 = strMessage2 & "、健保番号=" & IIf(.IsrNo <> "", .IsrNo, "なし")
                                PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, "I", lngLineNo, strMessage1, strMessage2
        
                                '以後双方とも指定なしとして扱う(データベース上で片方だけ存在するという場合は発生しえない)
                                .IsrSign = ""
                                .IsrNo = ""
        
                            End If
        
                        End With
                    
                    End If
    
                    '比較エラー時は次レコードへ
                    If blnCompareError Then
                        Exit Do
                    End If
    
                    'CSVデータの姓名と個人情報とのそれとを比較し、エラー時は警告ログを発行する
                    CompareName udtPerson, vntLastName, vntFirstName, vntLastKName, vntFirstKName, vntMessage1, vntMessage2
                    If Not IsEmpty(vntMessage1) Then
                        For i = 0 To UBound(vntMessage1)
                            vntMessage2(i) = "従業員番号=" & udtPerson.EmpNo & "、" & vntMessage2(i)
                        Next i
                        PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, "W", lngLineNo, vntMessage1, vntMessage2
                    End If
    
                '団体・従業員番号をキーとした個人情報が存在しない場合
                Else
    
                    '人事データの健保記号、番号がともに空でない場合
                    If udtPerson.IsrSign <> "" And udtPerson.IsrNo <> "" Then
    
                        '健保記号・健保番号・続柄・枝番・団体コードをキーに個人情報の有無を検索する
                        Ret3 = objRegistPerson.SelectPersonFromIsr(udtPerson.IsrSign, udtPerson.IsrNo, udtPerson.RelationCd, udtPerson.BranchNo, vntPerId, vntLastName, vntFirstName, vntLastKName, vntFirstKName, vntBirth, vntGender, , , , , , , , , , strOrgCd1, strOrgCd2, vntEmpNo)
                        Select Case Ret3

                            'レコードがただ１つ存在する場合（本来、同一本人・団体のデータは複数作成されないため、本条件発生時はエラーとなる）
                            Case Is > 0

                                'CSVデータの生年月日、性別と個人情報の各値とを比較
                                ComparePerson udtPerson, vntBirth, vntGender, vntPerId, vntLastName, vntFirstName, vntMessage1, vntMessage2
                                If Not IsEmpty(vntMessage1) Then
                                    For i = 0 To UBound(vntMessage1)
                                        vntMessage1(i) = "同一健保記号、番号の個人情報が存在しますが" & vntMessage1(i)
                                        vntMessage2(i) = "健保記号=" & udtPerson.IsrSign & "、健保番号=" & udtPerson.IsrNo & "、" & vntMessage2(i)
                                    Next i
                                    PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, "E", lngLineNo, vntMessage1, vntMessage2
                                    Exit Do
                                End If

                                'CSVデータの従業員番号と個人情報のそれとを比較（絶対異なるはず。同値であれば先の団体・従業員番号キー検索ですでにヒットしている。）
                                If udtPerson.EmpNo <> vntEmpNo Then
                                    strMessage2 = "健保記号=" & udtPerson.IsrSign
                                    strMessage2 = strMessage2 & "、健保番号=" & udtPerson.IsrNo
                                    strMessage2 = strMessage2 & "、氏名=" & Trim(vntLastName & "　" & vntFirstName) & "（" & vntPerId & "）"
                                    strMessage2 = strMessage2 & "、従業員番号=" & udtPerson.EmpNo
                                    strMessage2 = strMessage2 & "、現在の従業員番号=" & IIf(vntEmpNo <> "", vntEmpNo, "なし")
                                    PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, "E", lngLineNo, "同一健保記号、番号の個人情報が存在しますが現在の個人情報と従業員記号が異なります。", strMessage2
                                    Exit Do
                                End If

                            'レコードが複数存在する場合
                            Case 0

                                'ログを発行して次レコードへ
                                strMessage2 = "健保記号=" & udtPerson.IsrSign
                                strMessage2 = strMessage2 & "、健保番号=" & udtPerson.IsrNo
                                strMessage2 = strMessage2 & "、従業員番号=" & udtPerson.EmpNo
                                strMessage2 = strMessage2 & "、氏名=" & Trim(udtPerson.LastName & "　" & udtPerson.FirstName)
                                PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, "E", lngLineNo, "指定された団体内において同じ健保記号、番号を持つ本人個人情報が複数存在します。", strMessage2
                                Exit Do

                            'レコードが存在しない場合は完全なる新規レコードであり、ここでは何もする必要はない
                            Case Else

                        End Select
    
                    '人事データの健保記号、番号のいずれかが空である場合
                    Else
    
                        '健保記号、健保番号の特殊処理
                        With udtPerson
        
                            '後にはじかれる退職者および出向者を除くデータに対し
                            If .DelFlg = "0" And .TransferDiv = "0" Then
                            
                                '健保記号、健保番号のいずれかが存在しない場合
                                If (.IsrSign = "" And .IsrNo <> "") Or (.IsrSign <> "" And .IsrNo = "") Then
            
                                    'ログを発行
                                    strMessage1 = "健保記号、健保番号のいずれかが未指定です。以後両値とも未指定で扱います。"
                                    strMessage2 = "従業員番号=" & udtPerson.EmpNo
                                    strMessage2 = strMessage2 & "、氏名=" & Trim(udtPerson.LastName & "　" & udtPerson.FirstName)
                                    strMessage2 = strMessage2 & "、健保記号=" & IIf(.IsrSign <> "", .IsrSign, "なし")
                                    strMessage2 = strMessage2 & "、健保番号=" & IIf(.IsrNo <> "", .IsrNo, "なし")
                                    PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, "I", lngLineNo, strMessage1, strMessage2
            
                                    '以後双方とも指定なしとして扱う(データベース上で片方だけ存在するという場合は発生しえない)
                                    .IsrSign = ""
                                    .IsrNo = ""
            
                                End If
        
                            End If
                            
                        End With
                    
                    End If
    
                    '退職者であれば取り込み対象とせず、次レコードへ
                    If udtPerson.DelFlg <> "0" Then
                        strMessage1 = "退職者のため、新規取り込みは行われません。"
                        strMessage2 = "従業員番号=" & udtPerson.EmpNo
                        strMessage2 = strMessage2 & "、氏名=" & Trim(udtPerson.LastName & "　" & udtPerson.FirstName)
                        PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, "I", lngLineNo, strMessage1, strMessage2
                        Exit Do
                    End If

                    '出向者であれば取り込み対象とせず、次レコードへ
                    If udtPerson.TransferDiv <> "0" Then
                        strMessage1 = "出向者のため、新規取り込みは行われません。"
                        strMessage2 = "従業員番号=" & udtPerson.EmpNo
                        strMessage2 = strMessage2 & "、氏名=" & Trim(udtPerson.LastName & "　" & udtPerson.FirstName)
                        PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, "I", lngLineNo, strMessage1, strMessage2
                        Exit Do
                    End If

                End If
'## 2003.04.22 Mod End
    
                '処理モードの設定
                strMode = IIf(blnExists, MODE_UPDATE, MODE_INSERT)
                
                '事業部の登録
                With udtPerson
                    Ret2 = InsertOrgBsd(strOrgCd1, strOrgCd2, .OrgBsdCd, .OrgBsdName, strMessage1, strMessage2)
                End With
                
                'ログ発行
                If strMessage1 <> "" Then
                    strInformationDiv = IIf(Ret2 = 1, "I", IIf(Ret2 = 0, "W", "E"))
                    PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, strInformationDiv, lngLineNo, strMessage1, strMessage2
                End If
                
                'エラー時は次レコードへ
                If Ret2 < 0 Then
                    Exit Do
                End If
                
                '室部の登録
                With udtPerson
                    Ret2 = InsertOrgRoom(strOrgCd1, strOrgCd2, .OrgBsdCd, .OrgBsdName, .OrgRoomCd, .OrgRoomName, strMessage1, strMessage2)
                End With
                
                'ログ発行
                If strMessage1 <> "" Then
                    strInformationDiv = IIf(Ret2 = 1, "I", IIf(Ret2 = 0, "W", "E"))
                    PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, strInformationDiv, lngLineNo, strMessage1, strMessage2
                End If
                
                'エラー時は次レコードへ
                If Ret2 < 0 Then
                    Exit Do
                End If
                
                '室部の登録
                With udtPerson
                    Ret2 = InsertOrgPost(strOrgCd1, strOrgCd2, .OrgBsdCd, .OrgBsdName, .OrgRoomCd, .OrgRoomName, .OrgPostCd, .OrgPostName, strMessage1, strMessage2)
                End With
                
                'ログ発行
                If strMessage1 <> "" Then
                    strInformationDiv = IIf(Ret2 = 1, "I", IIf(Ret2 = 0, "W", "E"))
                    PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, strInformationDiv, lngLineNo, strMessage1, strMessage2
                End If
                
                'エラー時は次レコードへ
                If Ret2 < 0 Then
                    Exit Do
                End If
                
                '汎用テーブルレコード挿入時の可変情報を設定
                With udtPerson
'## 2003.01.29 Mod 4Lines By T.Takagi@FSIT 従業員区分名称対応
'                    vntFreeCdBody = Array(.JobCd, .DutyCd, .QualifyCd)
'                    vntFreeField = Array(.JobName, .DutyName, .QualifyName)
                    vntFreeCdBody = Array(.JobCd, .DutyCd, .QualifyCd, .EmpDiv)
                    vntFreeField = Array(.JobName, .DutyName, .QualifyName, .EmpName)
'## 2003.01.29 Mod End
                End With
                
                '職名・職責・資格の登録
                For i = 0 To UBound(vntFreeCdHeader)
                    
                    '汎用テーブルレコードの挿入
                    Ret2 = InsertFree(vntFreeCdHeader(i), vntFreeCdBody(i), vntFreeClassCd(i), vntFreeName(i), vntFreeField(i), strMessage1, strMessage2)
                
                    'ログ発行
                    If strMessage1 <> "" Then
                        strInformationDiv = IIf(Ret2 = 1, "I", IIf(Ret2 = 0, "W", "E"))
                        PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, strInformationDiv, lngLineNo, strMessage1, strMessage2
                    End If
                    
                    'エラー時は次レコードへ
                    If Ret2 < 0 Then
                        Exit Do
                    End If
                
                Next i
    
                '個人情報の登録
                With udtPerson
                
                    '接頭辞を付加した職名、職責、資格のコードを編集
                    strUpdJobCd = IIf(.JobCd <> "", vntFreeCdHeader(0) & .JobCd, "")
                    strUpdDutyCd = IIf(.DutyCd <> "", vntFreeCdHeader(1) & .DutyCd, "")
                    strUpdQualifyCd = IIf(.QualifyCd <> "", vntFreeCdHeader(2) & .QualifyCd, "")
'## 2003.01.29 Add 1Line By T.Takagi@FSIT 従業員区分名称対応
                    strUpdEmpDiv = IIf(.EmpDiv <> "", vntFreeCdHeader(3) & .EmpDiv, "")
'## 2003.01.29 Add End
    
                    '処理振り分け
                    Select Case strMode
                    
                        '個人情報の挿入
                        Case MODE_INSERT
'## 2003.01.29 Mod 28Lines By T.Takagi@FSIT 従業員区分名称対応
'                            Ret2 = objPerson.InsertPerson( _
'                                       vntPerId, 0, _
'                                       .DelFlg, .TransferDiv, 1, _
'                                       .LastName, .FirstName, _
'                                       .LastKName, .FirstKName, _
'                                       .Birth, .Gender, _
'                                       strUserId, _
'                                       strOrgCd1, strOrgCd2, _
'                                       .OrgBsdCd, .OrgRoomCd, .OrgPostCd, _
'                                       strUpdJobCd, strUpdDutyCd, strUpdQualifyCd, _
'                                       .IsrSign, .IsrNo, .RelationCd, .BranchNo, _
'                                       .EmpNo, , , _
'                                       .HireDate, .EmpDiv, .HongenDiv _
'                                   )
                            Ret2 = objPerson.InsertPerson( _
                                       vntPerId, 0, _
                                       .DelFlg, .TransferDiv, 1, _
                                       .LastName, .FirstName, _
                                       .LastKName, .FirstKName, _
                                       .Birth, .Gender, _
                                       strUserId, _
                                       strOrgCd1, strOrgCd2, _
                                       .OrgBsdCd, .OrgRoomCd, .OrgPostCd, _
                                       strUpdJobCd, strUpdDutyCd, strUpdQualifyCd, _
                                       .IsrSign, .IsrNo, .RelationCd, .BranchNo, _
                                       .EmpNo, , , _
                                       .HireDate, strUpdEmpDiv, .HongenDiv _
                                   )
'## 2003.01.29 Mod End
                     
                        '個人情報の更新
                        Case MODE_UPDATE
'## 2003.01.29 Mod 34Lines By T.Takagi@FSIT 入社年月日の編集ロジック不備＆従業員区分名称対応
'                            Ret2 = objPerson.UpdatePerson( _
'                                       vntPerId, , _
'                                       .DelFlg, .TransferDiv, 1, _
'                                       strUserId, _
'                                       .LastName, .FirstName, _
'                                       .LastKName, .FirstKName, _
'                                       .Birth, .Gender, _
'                                       strOrgCd1, strOrgCd2, _
'                                       .OrgBsdCd, .OrgRoomCd, .OrgPostCd, _
'                                       strUpdJobCd, strUpdDutyCd, strUpdQualifyCd, _
'                                       .IsrSign, .IsrNo, .RelationCd, .BranchNo, _
'                                       .EmpNo, , , _
'                                       .HireDate, .EmpDiv, .HongenDiv _
'                                   )
                            If .HireDate > 0 Then
                                vntHireDate = .HireDate
                            Else
                                vntHireDate = ""
                            End If

                            Ret2 = objPerson.UpdatePerson( _
                                       vntPerId, , _
                                       .DelFlg, .TransferDiv, 1, _
                                       strUserId, _
                                       .LastName, .FirstName, _
                                       .LastKName, .FirstKName, _
                                       .Birth, .Gender, _
                                       strOrgCd1, strOrgCd2, _
                                       .OrgBsdCd, .OrgRoomCd, .OrgPostCd, _
                                       strUpdJobCd, strUpdDutyCd, strUpdQualifyCd, _
                                       .IsrSign, .IsrNo, .RelationCd, .BranchNo, _
                                       .EmpNo, , , _
                                       vntHireDate, strUpdEmpDiv, .HongenDiv _
                                   )
'## 2003.01.29 Mod End
                                                         
                    End Select
                        
                End With
                        
                '戻り値に応じたメッセージの編集
                EditMessage 0, strMode, Ret2, vntPerId, udtPerson, strUserId, strMessage1, strMessage2
                    
                'ログ発行
                strInformationDiv = IIf(Ret2 > 0, "I", "E")
                PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, strInformationDiv, lngLineNo, strMessage1, strMessage2
    
                'エラー時は次レコードへ
                If Ret2 < 0 Then
                    Exit Do
                End If
    
                '作成／更新個人情報数のインクリメント
                lngPerCount = lngPerCount + 1
    
'## 2003.04.04 Add 2Lines By T.Takagi@FSIT 個人情報削除機能追加
                '指定個人ＩＤと同一健保記号、番号、続柄、枝番を持つ、従業員情報が未設定である個人情報を削除する
                DeletePerson vntPerId, lngTransactionId, strTransactionDiv, lngLineNo
'## 2003.04.04 Add End
    
                '契約パターンコード未設定時はここで処理を抜け、次レコードへ
                If lngCtrPtCd = 0 Then
                    Exit Do
                End If
    
                '指定個人の受診情報を作成
'## 2003.02.07 Mod 2Lines By T.Takagi@FSIT 受診希望日対応
'                Ret2 = objConsult.InsertConsultFromPerId(strUserId, strOrgCd1, strOrgCd2, vntPerId, lngCtrPtCd, vntMessage1, vntMessage2)
'## 2003.05.17 Mod 2Lines By T.Takagi@FSIT ログ強化
'                Ret2 = objConsult.InsertConsultFromPerId(strUserId, strOrgCd1, strOrgCd2, vntPerId, lngCtrPtCd, udtPerson.CslDate, vntMessage1, vntMessage2)
                Ret2 = objConsult.InsertConsultFromPerId(strUserId, strOrgCd1, strOrgCd2, vntPerId, lngCtrPtCd, udtPerson.CslDate, vntMessage1, vntMessage2, lngTransactionId, strTransactionDiv)
'## 2003.05.17 Mod End
'## 2003.02.07 Mod End
    
                'ログ発行
'## 2003.04.23 Mod 2Lines By T.Takagi@FSIT 同一個人、契約パターンの受診情報存在チェック
'                strInformationDiv = IIf(Ret2 > 0, "I", "E")
                strInformationDiv = IIf(Ret2 > 0, "I", IIf(Ret2 = -12, "W", "E"))
'## 2003.04.23 Mod End
                PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, strInformationDiv, lngLineNo, vntMessage1, vntMessage2
                
                '作成受診情報数のインクリメント
                If Ret2 > 0 Then
                    lngCslCount = lngCslCount + 1
                End If
                
                Exit Do
            Loop
        
        Loop
        
        'ファイルクローズ
        Close #intFileNo
        
        Exit Do
    Loop

    '終了ログの発行
    PutHainsLog mobjOraDb, lngTransactionId, strTransactionDiv, "I", "", vntTitle & "処理を終了します。", ""

    '戻り値の設定
    If Not IsMissing(vntReadCount) Then
        vntReadCount = lngReadCount
    End If
    
    If Not IsMissing(vntWritePersonCount) Then
        vntWritePersonCount = lngPerCount
    End If
    
    If Not IsMissing(vntWriteConsultCount) Then
        vntWriteConsultCount = lngCslCount
    End If
    
    Exit Sub
    
ErrorHandle:

    'ファイルクローズ
    Close #intFileNo

    'イベントログ書き込み
    WriteErrorLog "Import.ImportPerson"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Sub

'
' 機能　　 : 汎用テーブルレコードの挿入
'
' 引数　　 : (In)     strFreeCdHeader  汎用コード(接頭辞)
' 　　　　   (In)     strFreeCdBody    汎用コード(コード部)
' 　　　　   (In)     strFreeClassCd   汎用分類コード
' 　　　　   (In)     strFreeName      汎用名
' 　　　　   (In)     strFreeField     フィールド値
' 　　　　   (Out)    strMessage1      メッセージ１
' 　　　　   (Out)    strMessage2      メッセージ２
'
' 戻り値　 : 1   正常終了
' 　　　　   0   レコードあり
' 　　　　   -1  エラー
'
' 備考　　 :
'
Private Function InsertFree( _
    ByVal strFreeCdHeader As String, _
    ByVal strFreeCdBody As String, _
    ByVal strFreeClassCd As String, _
    ByVal strFreeName As String, _
    ByVal strFreeField As String, _
    ByRef strMessage1 As String, _
    ByRef strMessage2 As String _
) As Long

    Dim objFree         As Object   '汎用情報アクセス用
    
    Dim strFreeCd       As String   '汎用コード
    Dim vntFreeField    As Variant  'フィールド値
    Dim strStdMessage   As String   '基本メッセージ
    
    Dim Ret             As Long     '関数戻り値
    Dim Ret2            As Boolean  '関数戻り値
    Dim Ret3            As Long     '関数戻り値
    
    '初期処理
    strMessage1 = ""
    strMessage2 = ""
    Ret = 0
    
    Do
        
        'コード未設定ならば何もしない
        If strFreeCdBody = "" Then
            Exit Do
        End If
        
        'オブジェクトのインスタンス作成
        Set objFree = CreateObject("HainsFree.Free")
        
        '汎用コードの編集
        strFreeCd = strFreeCdHeader & strFreeCdBody
        
        'メッセージ基本部分の編集
        strStdMessage = strFreeName & "=" & strFreeField & "（" & strFreeCdBody & "）"
        
        '汎用テーブル読み込み
        Ret2 = objFree.SelectFree(0, strFreeCd, , , , vntFreeField)
    
        'レコードが存在する場合
        If Ret2 = True Then
        
'## 2003.04.17 Mod 17Lines By T.Takagi@FSIT 引数のフィールド値と現レコードのそれが一致しない場合は更新する
'            '引数のフィールド値と現レコードのそれが一致しない場合はエラー
'            If strFreeField <> "" And strFreeField <> vntFreeField Then
'                strMessage1 = "現在の" & strFreeName & "情報と名称が異なります。" & strFreeName & "は更新されません。"
'                strMessage2 = strStdMessage
'                strMessage2 = strMessage2 & "、現在の" & strFreeName & "=" & vntFreeField
'            End If
            '引数のフィールド値と現レコードのそれが一致しない場合
            If strFreeField <> "" And strFreeField <> vntFreeField Then
            
                '汎用テーブルレコードを更新
                Ret3 = objFree.UpdateFree(strFreeCd, , , , strFreeField)
                
                strMessage1 = strFreeName & "情報が更新されました。"
                strMessage2 = strStdMessage
                Ret = 1
            
            End If
'## 2003.04.17 Mod End
        
            Exit Do
        End If
    
        'レコードが存在しない場合は汎用テーブルレコードを挿入、このとき名称が存在しない場合はコード値をそのままフィールド値とする
        Ret3 = objFree.InsertFree(strFreeCd, strFreeClassCd, strFreeName, , IIf(strFreeField = "", strFreeCdBody, strFreeField))
        Select Case Ret3
            Case INSERT_NORMAL
                strMessage1 = strFreeName & "情報が挿入されました。"
                strMessage2 = strStdMessage
                Ret = 1
            Case INSERT_DUPLICATE
            Case Else
                strMessage1 = strFreeName & "情報の挿入時にエラーが発生しました。"
                strMessage2 = strStdMessage
                Ret = -1
        End Select
        
        Exit Do
    Loop

    '戻り値の設定
    InsertFree = Ret
    
End Function

'
' 機能　　 : 事業部の挿入
'
' 引数　　 : (In)     strOrgCd1      団体コード１
' 　　　　   (In)     strOrgCd2      団体コード２
' 　　　　   (In)     strOrgBsdCd    事業部コード
' 　　　　   (In)     strOrgBsdName  事業部名称
' 　　　　   (Out)    strMessage1    メッセージ１
' 　　　　   (Out)    strMessage2    メッセージ２
'
' 戻り値　 : 1   正常終了
' 　　　　   0   レコードあり
' 　　　　   -1  エラー
'
' 備考　　 :
'
Private Function InsertOrgBsd( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal strOrgBsdCd As String, _
    ByVal strOrgBsdName As String, _
    ByRef strMessage1 As String, _
    ByRef strMessage2 As String _
) As Long

    Dim objOrgBsd       As Object   '事業部情報アクセス用
    
    Dim vntOrgBsdName   As Variant  '事業部名称
    Dim strStdMessage   As String   '基本メッセージ
    
    Dim Ret             As Long     '関数戻り値
    Dim Ret2            As Boolean  '関数戻り値
    Dim Ret3            As Long     '関数戻り値
    
    '初期処理
    strMessage1 = ""
    strMessage2 = ""
    Ret = 0
    
    Do
        
        '未設定コードならば何もしない
        If strOrgBsdCd = "" Or strOrgBsdCd = UNDEFINED_CODE Then
            Exit Do
        End If
        
'## 2003.01.29 Add 1Line By T.Takagi@FSIT 事業部・室部未設定時に異常
        strOrgBsdCd = IIf(strOrgBsdCd = "", UNDEFINED_CODE, strOrgBsdCd)
'## 2003.01.29 Add End
        
        'オブジェクトのインスタンス作成
        Set objOrgBsd = CreateObject("HainsOrgBsd.OrgBsd")
        
        'メッセージ基本部分の編集
        strStdMessage = "事業部=" & strOrgBsdName & "（" & strOrgBsdCd & "）"
        
        '事業部テーブル読み込み
        Ret2 = objOrgBsd.SelectOrgBsd(strOrgCd1, strOrgCd2, strOrgBsdCd, , vntOrgBsdName)

        'レコードが存在する場合
        If Ret2 = True Then

'## 2003.04.17 Mod 17Lines By T.Takagi@FSIT 引数の事業部名称と現レコードのそれが一致しない場合は更新する
'            '引数の事業部名称と現レコードのそれが一致しない場合はエラー
'            If strOrgBsdName <> "" And strOrgBsdName <> vntOrgBsdName Then
'                strMessage1 = "現在の事業部情報と名称が異なります。事業部は更新されません。"
'                strMessage2 = strStdMessage
'                strMessage2 = strMessage2 & "、現在の事業部名称=" & vntOrgBsdName
'            End If
            '引数の事業部名称と現レコードのそれが一致しない場合
            If strOrgBsdName <> "" And strOrgBsdName <> vntOrgBsdName Then
            
                '事業部テーブルレコードを更新、このときカナ名称も強制更新する
                Ret3 = objOrgBsd.UpdateOrgBsd(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgBsdName, strOrgBsdName)
                
                strMessage1 = "事業部情報が更新されました。"
                strMessage2 = strStdMessage
                Ret = 1
                
            End If
'## 2003.04.17 Mod End

            Exit Do
        End If

        'レコードが存在しない場合は事業部テーブルレコードを挿入、このとき事業部名称が存在しない場合はコード値をそのまま事業部名称とする
        Ret3 = objOrgBsd.InsertOrgBsd(strOrgCd1, strOrgCd2, strOrgBsdCd, "", IIf(strOrgBsdName = "", strOrgBsdCd, strOrgBsdName))
        Select Case Ret3
            Case INSERT_NORMAL
                strMessage1 = "事業部情報が挿入されました。"
                strMessage2 = strStdMessage
                Ret = 1
            Case INSERT_DUPLICATE
            Case Else
                strMessage1 = "事業部情報の挿入時にエラーが発生しました。"
                strMessage2 = strStdMessage
                Ret = -1
        End Select
                
        Exit Do
    Loop

    '戻り値の設定
    InsertOrgBsd = Ret
    
End Function

'
' 機能　　 : 所属の挿入
'
' 引数　　 : (In)     strOrgCd1       団体コード１
' 　　　　   (In)     strOrgCd2       団体コード２
' 　　　　   (In)     strOrgBsdCd     事業部コード
' 　　　　   (In)     strOrgBsdName   事業部名称
' 　　　　   (In)     strOrgRoomCd    室部コード
' 　　　　   (In)     strOrgRoomName  室部名称
' 　　　　   (In)     strOrgPostCd    所属コード
' 　　　　   (In)     strOrgPostName  所属名称
' 　　　　   (Out)    strMessage1     メッセージ１
' 　　　　   (Out)    strMessage2     メッセージ２
'
' 戻り値　 : 1   正常終了
' 　　　　   0   レコードあり
' 　　　　   -1  エラー
'
' 備考　　 :
'
Private Function InsertOrgPost( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal strOrgBsdCd As String, _
    ByVal strOrgBsdName As String, _
    ByVal strOrgRoomCd As String, _
    ByVal strOrgRoomName As String, _
    ByVal strOrgPostCd As String, _
    ByVal strOrgPostName As String, _
    ByRef strMessage1 As String, _
    ByRef strMessage2 As String _
) As Long

    Dim objOrgPost      As Object   '所属情報アクセス用
    
    Dim vntOrgPostName  As Variant  '所属名称
    Dim strStdMessage   As String   '基本メッセージ
    
    Dim Ret             As Long     '関数戻り値
    Dim Ret2            As Boolean  '関数戻り値
    Dim Ret3            As Long     '関数戻り値
    
    '初期処理
    strMessage1 = ""
    strMessage2 = ""
    Ret = 0
    
    Do
        
        '未設定コードならば何もしない
        If strOrgPostCd = "" Or strOrgPostCd = UNDEFINED_CODE Then
            Exit Do
        End If
        
'## 2003.01.29 Add 2Lines By T.Takagi@FSIT 事業部・室部未設定時に異常
        strOrgBsdCd = IIf(strOrgBsdCd = "", UNDEFINED_CODE, strOrgBsdCd)
        strOrgRoomCd = IIf(strOrgRoomCd = "", UNDEFINED_CODE, strOrgRoomCd)
'## 2003.01.29 Add End
        
        'オブジェクトのインスタンス作成
        Set objOrgPost = CreateObject("HainsOrgPost.OrgPost")
        
        'メッセージ基本部分の編集
        strStdMessage = "事業部=" & strOrgBsdName & "（" & strOrgBsdCd & "）"
        strStdMessage = strStdMessage & "、室部=" & strOrgRoomName & "（" & strOrgRoomCd & "）"
        strStdMessage = strStdMessage & "、所属=" & strOrgPostName & "（" & strOrgPostCd & "）"
        
        '所属テーブル読み込み
        Ret2 = objOrgPost.SelectOrgPost(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgPostCd, vntOrgPostName)
    
        'レコードが存在する場合
        If Ret2 = True Then
        
'## 2003.04.17 Mod 17Lines By T.Takagi@FSIT 引数の所属名称と現レコードのそれが一致しない場合は更新する
'            '引数の所属名称と現レコードのそれが一致しない場合はエラー
'            If strOrgPostName <> "" And strOrgPostName <> vntOrgPostName Then
'                strMessage1 = "現在の所属情報と名称が異なります。所属は更新されません。"
'                strMessage2 = strStdMessage
'                strMessage2 = strMessage2 & "、現在の所属名称=" & vntOrgPostName
'            End If
            '引数の所属名称と現レコードのそれが一致しない場合
            If strOrgPostName <> "" And strOrgPostName <> vntOrgPostName Then
            
                '所属テーブルレコードを更新、このときカナ名称も強制更新する
                Ret3 = objOrgPost.UpdateOrgPost(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgPostCd, strOrgPostName, strOrgPostName)
                
                strMessage1 = "所属情報が更新されました。"
                strMessage2 = strStdMessage
                Ret = 1
            
            End If
'## 2003.04.17 Mod End
            
            Exit Do
        End If
    
        'レコードが存在しない場合は所属テーブルレコードを挿入、このとき所属名称が存在しない場合はコード値をそのまま所属名称とする
        Ret3 = objOrgPost.InsertOrgPost(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgPostCd, IIf(strOrgPostName = "", strOrgPostCd, strOrgPostName), "")
        Select Case Ret3
            Case INSERT_NORMAL
                strMessage1 = "所属情報が挿入されました。"
                strMessage2 = strStdMessage
                Ret = 1
            Case INSERT_DUPLICATE
            Case Else
                strMessage1 = "所属情報の挿入時にエラーが発生しました。"
                strMessage2 = strStdMessage
                Ret = -1
        End Select
            
        Exit Do
    Loop

    '戻り値の設定
    InsertOrgPost = Ret
    
End Function

'
' 機能　　 : 室部の挿入
'
' 引数　　 : (In)     strOrgCd1       団体コード１
' 　　　　   (In)     strOrgCd2       団体コード２
' 　　　　   (In)     strOrgBsdCd     事業部コード
' 　　　　   (In)     strOrgBsdName   事業部名称
' 　　　　   (In)     strOrgRoomCd    室部コード
' 　　　　   (In)     strOrgRoomName  室部名称
' 　　　　   (Out)    strMessage1     メッセージ１
' 　　　　   (Out)    strMessage2     メッセージ２
'
' 戻り値　 : 1   正常終了
' 　　　　   0   レコードあり
' 　　　　   -1  エラー
'
' 備考　　 :
'
Private Function InsertOrgRoom( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal strOrgBsdCd As String, _
    ByVal strOrgBsdName As String, _
    ByVal strOrgRoomCd As String, _
    ByVal strOrgRoomName As String, _
    ByRef strMessage1 As String, _
    ByRef strMessage2 As String _
) As Long

    Dim objOrgRoom      As Object   '室部情報アクセス用
    
    Dim vntOrgRoomName  As Variant  '室部名称
    Dim strStdMessage   As String   '基本メッセージ
    
    Dim Ret             As Long     '関数戻り値
    Dim Ret2            As Boolean  '関数戻り値
    Dim Ret3            As Long     '関数戻り値
    
    '初期処理
    strMessage1 = ""
    strMessage2 = ""
    Ret = 0
    
    Do
        
        '未設定コードならば何もしない
        If strOrgRoomCd = "" Or strOrgRoomCd = UNDEFINED_CODE Then
            Exit Do
        End If
        
        'オブジェクトのインスタンス作成
        Set objOrgRoom = CreateObject("HainsOrgRoom.OrgRoom")
        
        'メッセージ基本部分の編集
        strStdMessage = "事業部=" & strOrgBsdName & "（" & strOrgBsdCd & "）"
        strStdMessage = strStdMessage & "、室部=" & strOrgRoomName & "（" & strOrgRoomCd & "）"
        
        '室部テーブル読み込み
        Ret2 = objOrgRoom.SelectOrgRoom(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, vntOrgRoomName)
    
        'レコードが存在する場合
        If Ret2 = True Then
        
'## 2003.04.17 Mod 17Lines By T.Takagi@FSIT 引数の室部名称と現レコードのそれが一致しない場合は更新する
'            '引数の室部名称と現レコードのそれが一致しない場合はエラー
'            If strOrgRoomName <> "" And strOrgRoomName <> vntOrgRoomName Then
'                strMessage1 = "現在の室部情報と名称が異なります。室部は更新されません。"
'                strMessage2 = strStdMessage
'                strMessage2 = strMessage2 & "、現在の室部名称=" & vntOrgRoomName
'            End If
            '引数の室部名称と現レコードのそれが一致しない場合
            If strOrgRoomName <> "" And strOrgRoomName <> vntOrgRoomName Then
            
                '室部テーブルレコードを更新、このときカナ名称も強制更新する
                Ret3 = objOrgRoom.UpdateOrgRoom(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, strOrgRoomName, strOrgRoomName)
                
                strMessage1 = "室部情報が更新されました。"
                strMessage2 = strStdMessage
                Ret = 1
            
            End If
'## 2003.04.17 Mod End
            
            Exit Do
        End If
    
        'レコードが存在しない場合は室部テーブルレコードを挿入、このとき室部名称が存在しない場合はコード値をそのまま室部名称とする
        Ret3 = objOrgRoom.InsertOrgRoom(strOrgCd1, strOrgCd2, strOrgBsdCd, strOrgRoomCd, IIf(strOrgRoomName = "", strOrgRoomCd, strOrgRoomName), "")
        Select Case Ret3
            Case INSERT_NORMAL
                strMessage1 = "室部情報が挿入されました。"
                strMessage2 = strStdMessage
                Ret = 1
            Case INSERT_DUPLICATE
            Case Else
                strMessage1 = "室部情報の挿入時にエラーが発生しました。"
                strMessage2 = strStdMessage
                Ret = -1
        End Select
            
        Exit Do
    Loop

    '戻り値の設定
    InsertOrgRoom = Ret
    
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

