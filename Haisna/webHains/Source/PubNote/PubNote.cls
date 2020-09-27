VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "pubNote"
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

Private mobjContext                 As ObjectContext   'オブジェクトコンテキスト

Private mobjOraSession              As OraSession      'OraSessionオブジェクト
Private mobjOraDb                   As OraDatabase     'OraDatabaseオブジェクト

'桁数
Private Const LENGTH_RECEIPT_DAYID          As Integer = 4      '当日ＩＤ

Private Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

'
' 機能　　 : 指定された条件のコメントを取得する
'
' 引数　　 : (In)     lngSelInfo          検索情報（1:受診情報、2:個人、3:団体、4:契約
' 　　　　                                          0:個人＋受診情報)
' 　　　　   (In)     lngHistFlg          0:今回のみ、1:過去のみ、2:全件
' 　　　　   (In)     strStartDate        表示期間（開始日）
' 　　　　   (In)     strEndDate          表示期間（終了日）
' 　　　　   (In)     lngRsvNo            予約番号
' 　　　　   (In)     strPerId            個人ＩＤ
' 　　　　   (In)     strOrgCd1           団体コード１
' 　　　　   (In)     strOrgCd2           団体コード２
' 　　　　   (In)     strCtrPtCd          契約パターンコード
' 　　　　   (In)     lngSeq              ０のとき全件
' 　　　　   (In)     strPubNoteDivCd     受診情報ノート分類コード
' 　　　　   (In)     lngDispKbn          表示対象
' 　　　　   (In)     strUserId           ユーザＩＤ
' 　　　　   (Out)    vntSeq              seq
' 　　　　   (Out)    vntPubNoteDivCd     受診情報ノート分類コード
' 　　　　   (Out)    vntPubNoteDivName   受診情報ノート分類名称
' 　　　　   (Out)    vntDefaultDispKbn   表示対象区分初期値
' 　　　　   (Out)    vntOnlyDispKbn      表示対象区分しばり
' 　　　　   (Out)    vntDispKbn       　 表示対象区分
' 　　　　   (Out)    vntUpdDate       　 登録日時
' 　　　　   (Out)    vntUpdUser       　 登録者
' 　　　　   (Out)    vntUserName      　 登録者名
' 　　　　   (Out)    vntBoldFlg        　太字区分
' 　　　　   (Out)    vntPubNote        　ノート
' 　　　　   (Out)    vntDispColor        表示色
' 　　　　   (Out)    vntSelInfo          検索情報（1:受診情報、2:個人、3:団体、4:契約）
' 　　　　   (Out)    vntRsvNo            予約番号
' 　　　　   (Out)    vntCslDate          受診日
' 　　　　   (Out)    vntCsName           コース名
'### 2004/3/24 Added by Ishihara@FSIT 削除データも考慮に含める
' 　　　　   (In)     strIncDelNote       1:削除データも結果に含める
' 　　　　   (Out)    vntDelFlg           削除フラグ
'### 2004/3/24 Added End
'
'  (In)は検索条件。予約番号か個人ＩＤのいずれかは必ず指定。
'
' 戻り値　 : 0    正常終了
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectPubNote( _
    ByVal lngSelInfo As Long, _
    ByVal lngHistFlg As Long, _
    ByVal strStartDate As String, _
    ByVal strEndDate As String, _
    ByVal lngRsvNo As Long, _
    ByVal strPerId As String, _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal strCtrPtCd As String, _
    ByVal lngSeq As Long, _
    ByVal strPubNoteDivCd As String, _
    ByVal lngDispKbn As Long, _
    ByVal strUserId As String, _
    ByRef vntSeq As Variant, ByRef vntPubNoteDivCd As Variant, ByRef vntPubNoteDivName As Variant, _
    ByRef vntDefaultDispKbn As Variant, ByRef vntOnlyDispKbn As Variant, ByRef vntDispKbn As Variant, _
    ByRef vntUpdDate As Variant, ByRef vntUpdUser As Variant, ByRef vntUserName As Variant, _
    ByRef vntBoldFlg As Variant, ByRef vntPubNote As Variant, ByRef vntDispColor As Variant, _
    Optional ByRef vntSelInfo As Variant, Optional ByRef vntRsvNo As Variant, _
    Optional ByRef vntCslDate As Variant, Optional ByRef vntCsName As Variant, _
    Optional ByVal strIncDelNote As String, Optional ByRef vntDelFlg As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    Dim strStmtKikan        As String           'SQLステートメント(表示期間)
'### 2004/3/24 Added by Ishihara@FSIT 契約パターンコードなしの場合、団体からひっぱる
    Dim strStmtCtrpt        As String           'SQLステートメント(有効契約期間)
'### 2004/3/24 Added End

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objSeq              As OraField         'seq
    Dim objPubNoteDivCd     As OraField         '受診情報ノート分類コード
    Dim objPubNoteDivName   As OraField         '受診情報ノート分類名称
    Dim objDefaultDispKbn   As OraField         '表示対象区分初期値
    Dim objOnlyDispKbn      As OraField         '表示対象区分しばり
    Dim objDispKbn          As OraField         '表示対象区分
    Dim objUpdDate          As OraField         '登録日時
    Dim objUpdUser          As OraField         '登録者
    Dim objUserName         As OraField         '登録者名
    Dim objBoldFlg          As OraField         '太字区分
    Dim objPubNote          As OraField         'ノート
    Dim objDispColor        As OraField         '表示色
    Dim objSelInfo          As OraField         '検索情報
    Dim objRsvNo            As OraField         '予約番号
    Dim objCslDate          As OraField         '受診日
    Dim objCsName           As OraField         'コース名
'### 2004/3/24 Added by Ishihara@FSIT 削除データも考慮に含める
    Dim objDelFlg           As OraField         '削除フラグ
'### 2004/3/24 Added End

    Dim vntArrSeq()             As Variant      'seq
    Dim vntArrPubNoteDivCd()    As Variant      '受診情報ノート分類コード
    Dim vntArrPubNoteDivName()  As Variant      '受診情報ノート分類名称
    Dim vntArrDefaultDispKbn()  As Variant      '表示対象区分初期値
    Dim vntArrOnlyDispKbn()     As Variant      '表示対象区分しばり
    Dim vntArrDispKbn()         As Variant      '表示対象区分
    Dim vntArrUpdDate()         As Variant      '登録日時
    Dim vntArrUpdUser()         As Variant      '登録者
    Dim vntArrUserName()        As Variant      '登録者名
    Dim vntArrBoldFlg()         As Variant      '太字区分
    Dim vntArrPubNote()         As Variant      'ノート
    Dim vntArrDispColor()       As Variant      '表示色
    Dim vntArrSelInfo()         As Variant      '検索情報
    Dim vntArrRsvNo()           As Variant      '予約番号
    Dim vntArrCslDate()         As Variant      '受診日
    Dim vntArrCsName()          As Variant      'コース名
'### 2004/3/24 Added by Ishihara@FSIT 削除データも考慮に含める
    Dim vntArrDelFlg()          As Variant      '削除フラグ
'### 2004/3/24 Added End
    
    Dim lngCount            As Long             'レコード数
    
'MsgBox "IN:lngSelInfo=[" & lngSelInfo & _
       "] lngHistFlg=[" & lngHistFlg & _
       "] strStartDate=[" & strStartDate & _
       "] strEndDate=[" & strEndDate & _
       "] lngRsvNo=[" & lngRsvNo & _
       "] strPerId=[" & strPerId & _
       "] strOrgCd1=[" & strOrgCd1 & _
       "] strOrgCd2=[" & strOrgCd2 & _
       "] strCtrPtCd=[" & strCtrPtCd & _
       "] lngSeq=[" & lngSeq & _
       "] strPubNoteDivCd=[" & strPubNoteDivCd & _
       "] lngDispKbn=[" & lngDispKbn & _
       "] strUserId=[" & strUserId & "]"
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    'パラメータチェック
    Select Case lngSelInfo
        '受診情報, 個人
        Case 1, 2, 0
            If lngRsvNo = 0 And strPerId = "" Then
                SelectPubNote = 0
                Exit Function
            End If
        '団体
        Case 3
            If lngRsvNo = 0 And strOrgCd1 = "" And strOrgCd2 = "" Then
                SelectPubNote = 0
                Exit Function
            End If
        '契約
        Case 4
'### 2004/3/24 Updated by Ishihara@FSIT 契約パターンコードなしの場合、団体からひっぱる
'            If lngRsvNo = 0 And strCtrPtCd = "" Then
            If lngRsvNo = 0 And strCtrPtCd = "" And strOrgCd1 = "" And strOrgCd2 = "" Then
'### 2004/3/24 Updated End
                SelectPubNote = 0
                Exit Function
            End If
        Case Else
            Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
            Exit Function
    End Select
    
    '初期処理
    lngCount = 0
    If Not IsMissing(vntSelInfo) Then vntSelInfo = Empty
    If Not IsMissing(vntRsvNo) Then vntRsvNo = Empty
    If Not IsMissing(vntCslDate) Then vntCslDate = Empty
    If Not IsMissing(vntCsName) Then vntCsName = Empty
       
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "PERID", strPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CTRPTCD", strCtrPtCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "USERID", Trim(strUserId), ORAPARM_INPUT, ORATYPE_VARCHAR2
 
'### 2004/3/24 Added by Ishihara@FSIT 契約パターンコードなしの場合、団体からひっぱる
    strStmtCtrpt = ""
'### 2004/3/24 Added End
 
    '表示期間は過去を含むときだけ検索条件として使用する
    If lngHistFlg = 0 Then
        strStmtKikan = ""
    Else
        '検索条件に表示期間　開始、終了ともあり？
        If strStartDate <> "" And IsEmpty(strStartDate) = False And _
           strEndDate <> "" And IsEmpty(strEndDate) = False Then
            objOraParam.Add "STRDATE", strStartDate, ORAPARM_INPUT, ORATYPE_DATE
            objOraParam.Add "ENDDATE", strEndDate, ORAPARM_INPUT, ORATYPE_DATE
            strStmtKikan = " AND CONSULT.CSLDATE BETWEEN :STRDATE AND :ENDDATE "
'### 2004/3/29 Modify by Ishihara@FSIT これではひっぱれない
'### 2004/3/24 Added by Ishihara@FSIT 契約パターンコードなしの場合、団体からひっぱる
'            strStmtCtrpt = "   AND ( CTRPT.STRDATE <= :ENDDATE AND " & vbLf & _
                           "         CTRPT.ENDDATE >= :STRDATE )"
            strStmtCtrpt = "   AND (( CTRPT.ENDDATE >= :STRDATE AND    " & vbLf & _
                           "          CTRPT.ENDDATE <= :ENDDATE )  OR  " & vbLf & _
                           "        ( CTRPT.STRDATE >= :STRDATE AND    " & vbLf & _
                           "          CTRPT.STRDATE <= :ENDDATE ) )"
'### 2004/3/24 Added End
'### 2004/3/29 Modify End
        Else
            '検索条件に表示期間　開始のみ？
            If strStartDate <> "" And IsEmpty(strStartDate) = False And _
               strEndDate = "" Or IsEmpty(strEndDate) = True Then
                objOraParam.Add "STRDATE", strStartDate, ORAPARM_INPUT, ORATYPE_DATE
                strStmtKikan = " AND CONSULT.CSLDATE >= :STRDATE "
'### 2004/3/24 Added by Ishihara@FSIT 契約パターンコードなしの場合、団体からひっぱる
                strStmtCtrpt = "   AND :STRDATE BETWEEN CTRPT.STRDATE AND CTRPT.ENDDATE " & vbLf
'### 2004/3/24 Added End
            Else
                '検索条件に表示期間　終了のみ？
                If strEndDate <> "" And IsEmpty(strEndDate) = False And _
                   strStartDate = "" Or IsEmpty(strStartDate) = True Then
                    objOraParam.Add "ENDDATE", strEndDate, ORAPARM_INPUT, ORATYPE_DATE
                    strStmtKikan = " AND CONSULT.CSLDATE <= :ENDDATE "
'### 2004/3/24 Added by Ishihara@FSIT 契約パターンコードなしの場合、団体からひっぱる
                    strStmtCtrpt = "   AND :ENDDATE BETWEEN CTRPT.STRDATE AND CTRPT.ENDDATE " & vbLf
'### 2004/3/24 Added End
                Else
                    strStmtKikan = ""
                End If
            End If
        End If
    End If
    
    'ノートを一括取得
'### 2004/3/24 Updated by Ishihara@FSIT 削除データも考慮に含める
'    strStmt = "SELECT PUBNOTE.SELINFO,                      " & vbLf & _
              "       PUBNOTE.RSVNO,                        " & vbLf & _
              "       PUBNOTE.SEQ,                          " & vbLf & _
              "       PUBNOTE.PUBNOTEDIVCD,                 " & vbLf & _
              "       PUBNOTEDIVVIEW.PUBNOTEDIVNAME,        " & vbLf & _
              "       PUBNOTEDIVVIEW.DEFAULTDISPKBN,        " & vbLf & _
              "       PUBNOTEDIVVIEW.ONLYDISPKBN,           " & vbLf & _
              "       PUBNOTE.DISPKBN,                      " & vbLf & _
              "       PUBNOTE.UPDDATE,                      " & vbLf & _
              "       PUBNOTE.UPDUSER,                      " & vbLf & _
              "       HAINSUSER.USERNAME,                   " & vbLf & _
              "       PUBNOTE.BOLDFLG,                      " & vbLf & _
              "       PUBNOTE.PUBNOTE,                      " & vbLf & _
              "       PUBNOTE.DISPCOLOR,                    " & vbLf & _
              "       PUBNOTE.CSLDATE,                      " & vbLf & _
              "       COURSE_P.CSNAME                       " & vbLf & _
              "  FROM HAINSUSER,                            " & vbLf & _
              "       COURSE_P,                             " & vbLf & _
              "       (                                     "
    strStmt = "SELECT PUBNOTE.SELINFO,                      " & vbLf & _
              "       PUBNOTE.RSVNO,                        " & vbLf & _
              "       PUBNOTE.SEQ,                          " & vbLf & _
              "       PUBNOTE.PUBNOTEDIVCD,                 " & vbLf & _
              "       PUBNOTEDIVVIEW.PUBNOTEDIVNAME,        " & vbLf & _
              "       PUBNOTEDIVVIEW.DEFAULTDISPKBN,        " & vbLf & _
              "       PUBNOTEDIVVIEW.ONLYDISPKBN,           " & vbLf & _
              "       PUBNOTE.DISPKBN,                      " & vbLf & _
              "       PUBNOTE.UPDDATE,                      " & vbLf & _
              "       PUBNOTE.UPDUSER,                      " & vbLf & _
              "       HAINSUSER.USERNAME,                   " & vbLf & _
              "       PUBNOTE.BOLDFLG,                      " & vbLf & _
              "       PUBNOTE.PUBNOTE,                      " & vbLf & _
              "       PUBNOTE.DISPCOLOR,                    " & vbLf & _
              "       PUBNOTE.CSLDATE,                      " & vbLf & _
              "       COURSE_P.CSNAME,                      " & vbLf & _
              "       PUBNOTE.DELFLG                        " & vbLf & _
              "  FROM HAINSUSER,                            " & vbLf & _
              "       COURSE_P,                             " & vbLf & _
              "       (                                     "
'### 2004/3/24 Updated End
    
    '個人ノートを取得 ****************************************************Start
    If lngSelInfo = 2 Or lngSelInfo = 0 Then
'### 2004/3/24 Updated by Ishihara@FSIT 削除データも考慮に含める
'        strStmt = strStmt & vbLf & _
                  "         SELECT 2 SELINFO,                   " & vbLf & _
                  "                NULL RSVNO,                  " & vbLf & _
                  "                PERPUBNOTE.SEQ,              " & vbLf & _
                  "                PERPUBNOTE.PUBNOTEDIVCD,     " & vbLf & _
                  "                PERPUBNOTE.DISPKBN,          " & vbLf & _
                  "                PERPUBNOTE.UPDDATE,          " & vbLf & _
                  "                PERPUBNOTE.UPDUSER,          " & vbLf & _
                  "                PERPUBNOTE.BOLDFLG,          " & vbLf & _
                  "                PERPUBNOTE.PUBNOTE,          " & vbLf & _
                  "                PERPUBNOTE.DISPCOLOR,        " & vbLf & _
                  "                0 HISTNO,                    " & vbLf & _
                  "                NULL CSLDATE,                " & vbLf & _
                  "                NULL CSCD                    " & vbLf & _
                  "           FROM PERPUBNOTE                   "
        strStmt = strStmt & vbLf & _
                  "         SELECT 2 SELINFO,                   " & vbLf & _
                  "                NULL RSVNO,                  " & vbLf & _
                  "                PERPUBNOTE.SEQ,              " & vbLf & _
                  "                PERPUBNOTE.PUBNOTEDIVCD,     " & vbLf & _
                  "                PERPUBNOTE.DISPKBN,          " & vbLf & _
                  "                PERPUBNOTE.UPDDATE,          " & vbLf & _
                  "                PERPUBNOTE.UPDUSER,          " & vbLf & _
                  "                PERPUBNOTE.BOLDFLG,          " & vbLf & _
                  "                PERPUBNOTE.PUBNOTE,          " & vbLf & _
                  "                PERPUBNOTE.DISPCOLOR,        " & vbLf & _
                  "                0 HISTNO,                    " & vbLf & _
                  "                NULL CSLDATE,                " & vbLf & _
                  "                NULL CSCD,                   " & vbLf & _
                  "                PERPUBNOTE.DELFLG            " & vbLf & _
                  "           FROM PERPUBNOTE                   " & vbLf
'### 2004/3/24 Updated End

        If lngRsvNo <> 0 Then
            '予約番号が指定されている
            strStmt = strStmt & vbLf & _
                  "          WHERE PERPUBNOTE.PERID =           " & vbLf & _
                  "                (SELECT PERID                " & vbLf & _
                  "                   FROM CONSULT              " & vbLf & _
                  "                  WHERE RSVNO = :RSVNO)      "
        Else
            '個人ＩＤが指定されている
            strStmt = strStmt & vbLf & _
                  "          WHERE PERPUBNOTE.PERID = :PERID    "
        End If
'### 2004/3/24 Updated by Ishihara@FSIT 削除データも考慮に含める
'        strStmt = strStmt & vbLf & _
'                  "            AND PERPUBNOTE.DELFLG IS NULL    "
        '削除データを含めない場合
        If strIncDelNote <> "1" Then
            strStmt = strStmt & vbLf & _
                      "            AND PERPUBNOTE.DELFLG IS NULL    "
        End If
'### 2004/3/24 Updated End
    End If
    '個人ノートを取得 ****************************************************End
    
    If lngSelInfo = 0 Then
        '個人＋受診情報とする
        strStmt = strStmt & vbLf & _
                  "         UNION ALL                           "
    End If
    
    '受診情報ノートを取得 ************************************************Start
    If lngSelInfo = 1 Or lngSelInfo = 0 Then
'### 2004/3/24 Updated by Ishihara@FSIT 削除データも考慮に含める
'        strStmt = strStmt & vbLf & _
                  "         SELECT 1 SELINFO,                   " & vbLf & _
                  "                CSLPUBNOTE.RSVNO,            " & vbLf & _
                  "                CSLPUBNOTE.SEQ,              " & vbLf & _
                  "                CSLPUBNOTE.PUBNOTEDIVCD,     " & vbLf & _
                  "                CSLPUBNOTE.DISPKBN,          " & vbLf & _
                  "                CSLPUBNOTE.UPDDATE,          " & vbLf & _
                  "                CSLPUBNOTE.UPDUSER,          " & vbLf & _
                  "                CSLPUBNOTE.BOLDFLG,          " & vbLf & _
                  "                CSLPUBNOTE.PUBNOTE,          " & vbLf & _
                  "                CSLPUBNOTE.DISPCOLOR,        " & vbLf & _
                  "                CONSULTHIST.HISTNO,          " & vbLf & _
                  "                CONSULTHIST.CSLDATE,         " & vbLf & _
                  "                CONSULTHIST.CSCD             " & vbLf & _
                  "           FROM CSLPUBNOTE,                  "
        strStmt = strStmt & vbLf & _
                  "         SELECT 1 SELINFO,                   " & vbLf & _
                  "                CSLPUBNOTE.RSVNO,            " & vbLf & _
                  "                CSLPUBNOTE.SEQ,              " & vbLf & _
                  "                CSLPUBNOTE.PUBNOTEDIVCD,     " & vbLf & _
                  "                CSLPUBNOTE.DISPKBN,          " & vbLf & _
                  "                CSLPUBNOTE.UPDDATE,          " & vbLf & _
                  "                CSLPUBNOTE.UPDUSER,          " & vbLf & _
                  "                CSLPUBNOTE.BOLDFLG,          " & vbLf & _
                  "                CSLPUBNOTE.PUBNOTE,          " & vbLf & _
                  "                CSLPUBNOTE.DISPCOLOR,        " & vbLf & _
                  "                CONSULTHIST.HISTNO,          " & vbLf & _
                  "                CONSULTHIST.CSLDATE,         " & vbLf & _
                  "                CONSULTHIST.CSCD,            " & vbLf & _
                  "                CSLPUBNOTE.DELFLG            " & vbLf & _
                  "           FROM CSLPUBNOTE,                  "
'### 2004/3/24 Updated End

        strStmt = strStmt & vbLf & _
                  "                ( SELECT ROWNUM HISTNO,                      " & vbLf & _
                  "                         RSVNO,                              " & vbLf & _
                  "                         CSLDATE,                            " & vbLf & _
                  "                         CSCD                                " & vbLf & _
                  "                    FROM ( SELECT CONSULT.RSVNO,             " & vbLf & _
                  "                                  CONSULT.CSLDATE,           " & vbLf & _
                  "                                  CONSULT.CSCD               " & vbLf & _
                  "                             FROM CONSULT                    "
        If lngRsvNo <> 0 Then
            '予約番号が指定されている
            If lngHistFlg = 0 Then
                '今回のみ
                strStmt = strStmt & vbLf & _
                  "                            WHERE CONSULT.RSVNO = :RSVNO     " & vbLf & _
                  "                              AND CONSULT.CANCELFLG = 0 )    "
            Else
                strStmt = strStmt & vbLf & _
                  "                            WHERE CONSULT.PERID =            " & vbLf & _
                  "                                  (SELECT PERID              " & vbLf & _
                  "                                     FROM CONSULT            " & vbLf & _
                  "                                    WHERE RSVNO = :RSVNO)    " & vbLf & _
                  "                              AND CONSULT.CSLDATE " & IIf(lngHistFlg = 1, "< ", "<= ") & vbLf & _
                  "                                  (SELECT CSLDATE            " & vbLf & _
                  "                                     FROM CONSULT            " & vbLf & _
                  "                                    WHERE RSVNO = :RSVNO)    " & vbLf & _
                                                 strStmtKikan & vbLf & _
                  "                              AND CONSULT.CANCELFLG = 0      " & vbLf & _
                  "                           ORDER BY CONSULT.CSLDATE DESC )   "
            End If
        Else
            '個人ＩＤが指定されている
            strStmt = strStmt & vbLf & _
                  "                            WHERE CONSULT.PERID = :PERID     " & vbLf & _
                                                 strStmtKikan & vbLf & _
                  "                              AND CONSULT.CANCELFLG = 0      " & vbLf & _
                  "                           ORDER BY CONSULT.CSLDATE DESC )   "
        End If
'### 2004/3/24 Updated by Ishihara@FSIT 削除データも考慮に含める
'        strStmt = strStmt & vbLf & _
                  "                ) CONSULTHIST                                " & vbLf & _
                  "          WHERE CSLPUBNOTE.RSVNO = CONSULTHIST.RSVNO         " & vbLf & _
                  "            AND CSLPUBNOTE.DELFLG IS NULL    "
        strStmt = strStmt & vbLf & _
                  "                ) CONSULTHIST                                " & vbLf & _
                  "          WHERE CSLPUBNOTE.RSVNO = CONSULTHIST.RSVNO         " & vbLf
        '削除データを含めない場合
        If strIncDelNote <> "1" Then
            strStmt = strStmt & vbLf & _
                      "            AND CSLPUBNOTE.DELFLG IS NULL    "
        End If
'### 2004/3/24 Updated End
    End If
    '受診情報ノートを取得 ************************************************End
    
    '団体ノートを取得 ************************************************Start
    If lngSelInfo = 3 Then
'### 2004/3/24 Updated by Ishihara@FSIT 削除データも考慮に含める
'        strStmt = strStmt & vbLf & _
                  "         SELECT 3 SELINFO,                   " & vbLf & _
                  "                NULL RSVNO,                  " & vbLf & _
                  "                ORGPUBNOTE.SEQ,              " & vbLf & _
                  "                ORGPUBNOTE.PUBNOTEDIVCD,     " & vbLf & _
                  "                ORGPUBNOTE.DISPKBN,          " & vbLf & _
                  "                ORGPUBNOTE.UPDDATE,          " & vbLf & _
                  "                ORGPUBNOTE.UPDUSER,          " & vbLf & _
                  "                ORGPUBNOTE.BOLDFLG,          " & vbLf & _
                  "                ORGPUBNOTE.PUBNOTE,          " & vbLf & _
                  "                ORGPUBNOTE.DISPCOLOR,        " & vbLf & _
                  "                0 HISTNO,                    " & vbLf & _
                  "                NULL CSLDATE,                " & vbLf & _
                  "                NULL CSCD                    " & vbLf & _
                  "           FROM ORGPUBNOTE                   "
        strStmt = strStmt & vbLf & _
                  "         SELECT 3 SELINFO,                   " & vbLf & _
                  "                NULL RSVNO,                  " & vbLf & _
                  "                ORGPUBNOTE.SEQ,              " & vbLf & _
                  "                ORGPUBNOTE.PUBNOTEDIVCD,     " & vbLf & _
                  "                ORGPUBNOTE.DISPKBN,          " & vbLf & _
                  "                ORGPUBNOTE.UPDDATE,          " & vbLf & _
                  "                ORGPUBNOTE.UPDUSER,          " & vbLf & _
                  "                ORGPUBNOTE.BOLDFLG,          " & vbLf & _
                  "                ORGPUBNOTE.PUBNOTE,          " & vbLf & _
                  "                ORGPUBNOTE.DISPCOLOR,        " & vbLf & _
                  "                0 HISTNO,                    " & vbLf & _
                  "                NULL CSLDATE,                " & vbLf & _
                  "                NULL CSCD,                   " & vbLf & _
                  "                ORGPUBNOTE.DELFLG            " & vbLf & _
                  "           FROM ORGPUBNOTE                   " & vbLf
'### 2004/3/24 Updated End

        If lngRsvNo <> 0 Then
            '予約番号が指定されている
            strStmt = strStmt & vbLf & _
                  "          WHERE ORGPUBNOTE.ORGCD1 =          " & vbLf & _
                  "                (SELECT ORGCD1               " & vbLf & _
                  "                   FROM CONSULT              " & vbLf & _
                  "                  WHERE RSVNO = :RSVNO)      " & vbLf & _
                  "            AND ORGPUBNOTE.ORGCD2 =          " & vbLf & _
                  "                (SELECT ORGCD2               " & vbLf & _
                  "                   FROM CONSULT              " & vbLf & _
                  "                  WHERE RSVNO = :RSVNO)      "
        Else
            '団体コードが指定されている
            strStmt = strStmt & vbLf & _
                  "          WHERE ORGPUBNOTE.ORGCD1 = :ORGCD1  " & vbLf & _
                  "            AND ORGPUBNOTE.ORGCD2 = :ORGCD2  "
        End If
'### 2004/3/24 Updated by Ishihara@FSIT 削除データも考慮に含める
'        strStmt = strStmt & vbLf & _
                  "            AND ORGPUBNOTE.DELFLG IS NULL    "
        '削除データを含めない場合
        If strIncDelNote <> "1" Then
            strStmt = strStmt & vbLf & _
                      "            AND ORGPUBNOTE.DELFLG IS NULL    "
        End If
'### 2004/3/24 Updated End
   End If
    '団体ノートを取得 ************************************************End
    
    '契約ノートを取得 ************************************************Start
    If lngSelInfo = 4 Then

'### 2004/3/24 Updated by Ishihara@FSIT 削除データも考慮に含める
'        strStmt = strStmt & vbLf & _
                  "         SELECT 4 SELINFO,                   " & vbLf & _
                  "                NULL RSVNO,                  " & vbLf & _
                  "                CTRPTPUBNOTE.SEQ,            " & vbLf & _
                  "                CTRPTPUBNOTE.PUBNOTEDIVCD,   " & vbLf & _
                  "                CTRPTPUBNOTE.DISPKBN,        " & vbLf & _
                  "                CTRPTPUBNOTE.UPDDATE,        " & vbLf & _
                  "                CTRPTPUBNOTE.UPDUSER,        " & vbLf & _
                  "                CTRPTPUBNOTE.BOLDFLG,        " & vbLf & _
                  "                CTRPTPUBNOTE.PUBNOTE,        " & vbLf & _
                  "                CTRPTPUBNOTE.DISPCOLOR,      " & vbLf & _
                  "                0 HISTNO,                    " & vbLf & _
                  "                NULL CSLDATE,                " & vbLf & _
                  "                NULL CSCD                    " & vbLf & _
                  "           FROM CTRPTPUBNOTE                 "
        strStmt = strStmt & vbLf & _
                  "         SELECT 4 SELINFO,                   " & vbLf & _
                  "                NULL RSVNO,                  " & vbLf & _
                  "                CTRPTPUBNOTE.SEQ,            " & vbLf & _
                  "                CTRPTPUBNOTE.PUBNOTEDIVCD,   " & vbLf & _
                  "                CTRPTPUBNOTE.DISPKBN,        " & vbLf & _
                  "                CTRPTPUBNOTE.UPDDATE,        " & vbLf & _
                  "                CTRPTPUBNOTE.UPDUSER,        " & vbLf & _
                  "                CTRPTPUBNOTE.BOLDFLG,        " & vbLf & _
                  "                CTRPTPUBNOTE.PUBNOTE,        " & vbLf & _
                  "                CTRPTPUBNOTE.DISPCOLOR,      " & vbLf & _
                  "                0 HISTNO,                    " & vbLf & _
                  "                NULL CSLDATE,                " & vbLf & _
                  "                NULL CSCD,                   " & vbLf & _
                  "                CTRPTPUBNOTE.DELFLG          " & vbLf & _
                  "           FROM CTRPTPUBNOTE                 " & vbLf
'### 2004/3/24 Updated End

        If lngRsvNo <> 0 Then
            '予約番号が指定されている
            strStmt = strStmt & vbLf & _
                  "          WHERE CTRPTPUBNOTE.CTRPTCD =       " & vbLf & _
                  "                (SELECT CTRPTCD              " & vbLf & _
                  "                   FROM CONSULT              " & vbLf & _
                  "                  WHERE RSVNO = :RSVNO)      "
        Else
'### 2004/3/24 Updated by Ishihara@FSIT 契約パターンコードなしの場合、団体からひっぱる
'            '団体コードが指定されている
'            strStmt = strStmt & vbLf & _
'                  "          WHERE CTRPTPUBNOTE.CTRPTCD = :CTRPTCD  "
            If (Trim(strCtrPtCd) <> "") And (Trim(strCtrPtCd) <> "0") And IsNumeric(Trim(strCtrPtCd)) Then
                '契約パターンコードが指定されている
                strStmt = strStmt & vbLf & _
                      "          WHERE CTRPTPUBNOTE.CTRPTCD = :CTRPTCD  "
            Else
                '団体コードで検索
                strStmt = strStmt & vbLf & _
                      "          WHERE CTRPTPUBNOTE.CTRPTCD IN                " & vbLf & _
                      "                (SELECT DISTINCT CTRPT.CTRPTCD         " & vbLf & _
                      "                   FROM CTRPT, CTRMNG                  " & vbLf & _
                      "                  WHERE CTRPT.CTRPTCD = CTRMNG.CTRPTCD " & vbLf & _
                      "                    AND ORGCD1 = :ORGCD1               " & vbLf & _
                      "                    AND ORGCD2 = :ORGCD2               " & vbLf & _
                      strStmtCtrpt & " ) "
            End If
'### 2004/3/24 Updated End
        End If
        
'### 2004/3/24 Updated by Ishihara@FSIT 削除データも考慮に含める
'        strStmt = strStmt & vbLf & _
                  "            AND CTRPTPUBNOTE.DELFLG IS NULL  "
        '削除データを含めない場合
        If strIncDelNote <> "1" Then
            strStmt = strStmt & vbLf & _
                      "            AND CTRPTPUBNOTE.DELFLG IS NULL  "
        End If
'### 2004/3/24 Updated End
        
    End If
    '契約ノートを取得 ************************************************End
    strStmt = strStmt & vbLf & _
              "       ) PUBNOTE,                                            "
    
    '### 2004.01.19 Add 参照権限のある表示対象のもののみを検索するためにユーザ情報取得
    strStmt = strStmt & vbLf & _
              "       ( SELECT AUTHNOTE, DEFNOTEDISPKBN         " & vbLf & _
              "           FROM HAINSUSER                        " & vbLf & _
              "          WHERE USERID= :USERID) USERAUTHVIEW,   "

    strStmt = strStmt & vbLf & _
              "       ( SELECT PUBNOTEDIVCD,                                " & vbLf & _
              "                PUBNOTEDIVNAME,                              " & vbLf & _
              "                DECODE(DEFAULTDISPKBN, AUTHNOTE,             " & vbLf & _
              "                             DEFAULTDISPKBN,                 " & vbLf & _
              "                             DEFNOTEDISPKBN ) DEFAULTDISPKBN," & vbLf & _
              "                ONLYDISPKBN                                  " & vbLf & _
              "           FROM (SELECT PUBNOTEDIV.PUBNOTEDIVCD,             " & vbLf & _
              "                        PUBNOTEDIV.PUBNOTEDIVNAME,           " & vbLf & _
              "                        NVL(PUBNOTEDIV.DEFAULTDISPKBN, USERVIEW.DEFNOTEDISPKBN) DEFAULTDISPKBN,  " & vbLf & _
              "                        PUBNOTEDIV.ONLYDISPKBN,              " & vbLf & _
              "                        USERVIEW.AUTHNOTE,                   " & vbLf & _
              "                        USERVIEW.DEFNOTEDISPKBN              " & vbLf & _
              "                   FROM PUBNOTEDIV,                          " & vbLf & _
              "                        (SELECT AUTHNOTE, DEFNOTEDISPKBN     " & vbLf & _
              "                           FROM HAINSUSER                    " & vbLf & _
              "                          WHERE USERID= :USERID) USERVIEW    " & vbLf & _
              "                  WHERE (USERVIEW.AUTHNOTE = 1 AND (PUBNOTEDIV.ONLYDISPKBN = 1 OR PUBNOTEDIV.ONLYDISPKBN IS NULL)) " & vbLf & _
              "                     OR (USERVIEW.AUTHNOTE = 2 AND (PUBNOTEDIV.ONLYDISPKBN = 2 OR PUBNOTEDIV.ONLYDISPKBN IS NULL)) " & vbLf & _
              "                     OR (USERVIEW.AUTHNOTE = 3 )             " & vbLf & _
              "                 )                                           " & vbLf & _
              "       ) PUBNOTEDIVVIEW                                      "

    strStmt = strStmt & vbLf & _
              " WHERE PUBNOTE.PUBNOTEDIVCD = PUBNOTEDIVVIEW.PUBNOTEDIVCD    " & vbLf & _
              "   AND PUBNOTE.UPDUSER      = HAINSUSER.USERID               " & vbLf & _
              "   AND PUBNOTE.CSCD         = COURSE_P.CSCD(+)               "
                
    '### 2004.01.19 Add by Fujii 参照権限のある表示対象のみ
    strStmt = strStmt & vbLf & _
              "   AND ((USERAUTHVIEW.AUTHNOTE = 1 AND (PUBNOTE.DISPKBN = 1 OR PUBNOTE.DISPKBN = 3)) " & vbLf & _
              "    OR  (USERAUTHVIEW.AUTHNOTE = 2 AND (PUBNOTE.DISPKBN = 2 OR PUBNOTE.DISPKBN = 3)) " & vbLf & _
              "    OR  (USERAUTHVIEW.AUTHNOTE = 3 ))             "
    
    'Ｓｅｑ指定あり？
    If lngSeq <> 0 Then
        'キー値の設定
        objOraParam.Add "SEQ", lngSeq, ORAPARM_INPUT, ORATYPE_NUMBER
        strStmt = strStmt & vbLf & _
              "   AND PUBNOTE.SEQ = :SEQ                    "
    End If
    
    '受診情報ノート分類コード指定あり？
    If strPubNoteDivCd <> "" Then
        'キー値の設定
        objOraParam.Add "PUBNOTEDIV", strPubNoteDivCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
        strStmt = strStmt & vbLf & _
              "   AND PUBNOTE.PUBNOTEDIVCD = :PUBNOTEDIV    "
    End If
    
    '表示対象指定あり？
    If lngDispKbn <> 0 Then
        'キー値の設定
        objOraParam.Add "DISPKBN", lngDispKbn, ORAPARM_INPUT, ORATYPE_NUMBER
        '表示対象=3は「共通」なので検索条件に含む
        strStmt = strStmt & vbLf & _
              "   AND ( PUBNOTE.DISPKBN = :DISPKBN          " & vbLf & _
              "      OR PUBNOTE.DISPKBN = 3 )               "
    End If


'### 2009.10.24 張 個人ノート、受診情報ノートを表示する時、①個人＞受診情報・②受診日（最新順）・③登録日時順でソート Start ###
    If lngSelInfo = 0 Or lngSelInfo = 1 Or lngSelInfo = 2 Then
        strStmt = strStmt & vbLf & _
                  " ORDER BY PUBNOTE.SELINFO DESC, PUBNOTE.CSLDATE DESC, PUBNOTE.UPDDATE DESC   "
    Else
        strStmt = strStmt & vbLf & _
                  " ORDER BY PUBNOTE.HISTNO, PUBNOTE.SEQ        "
    End If
'### 2009.10.24 張 個人ノート、受診情報ノートを表示する時、①個人＞受診情報・②受診日（最新順）・③登録日時順でソート End   ###
    
    
    
    'SQL文の実行
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objSeq = objFields("SEQ")
        Set objPubNoteDivCd = objFields("PUBNOTEDIVCD")
        Set objPubNoteDivName = objFields("PUBNOTEDIVNAME")
        Set objDefaultDispKbn = objFields("DEFAULTDISPKBN")
        Set objOnlyDispKbn = objFields("ONLYDISPKBN")
        Set objDispKbn = objFields("DISPKBN")
        Set objUpdDate = objFields("UPDDATE")
        Set objUpdUser = objFields("UPDUSER")
        Set objUserName = objFields("USERNAME")
        Set objBoldFlg = objFields("BOLDFLG")
        Set objPubNote = objFields("PUBNOTE")
        Set objDispColor = objFields("DISPCOLOR")
        Set objSelInfo = objFields("SELINFO")
        Set objRsvNo = objFields("RSVNO")
        Set objCslDate = objFields("CSLDATE")
        Set objCsName = objFields("CSNAME")
'### 2004/3/24 Added by Ishihara@FSIT 削除データも考慮に含める
        Set objDelFlg = objFields("DELFLG")
'### 2004/3/24 Added End
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrSeq(lngCount)
            ReDim Preserve vntArrPubNoteDivCd(lngCount)
            ReDim Preserve vntArrPubNoteDivName(lngCount)
            ReDim Preserve vntArrDefaultDispKbn(lngCount)
            ReDim Preserve vntArrOnlyDispKbn(lngCount)
            ReDim Preserve vntArrDispKbn(lngCount)
            ReDim Preserve vntArrUpdDate(lngCount)
            ReDim Preserve vntArrUpdUser(lngCount)
            ReDim Preserve vntArrUserName(lngCount)
            ReDim Preserve vntArrBoldFlg(lngCount)
            ReDim Preserve vntArrPubNote(lngCount)
            ReDim Preserve vntArrDispColor(lngCount)
            ReDim Preserve vntArrSelInfo(lngCount)
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrCslDate(lngCount)
            ReDim Preserve vntArrCsName(lngCount)
'### 2004/3/24 Added by Ishihara@FSIT 削除データも考慮に含める
            ReDim Preserve vntArrDelFlg(lngCount)
'### 2004/3/24 Added End
           
            vntArrSeq(lngCount) = objSeq.Value & ""
            vntArrPubNoteDivCd(lngCount) = objPubNoteDivCd.Value & ""
            vntArrPubNoteDivName(lngCount) = objPubNoteDivName.Value & ""
            vntArrDefaultDispKbn(lngCount) = objDefaultDispKbn.Value & ""
            vntArrOnlyDispKbn(lngCount) = objOnlyDispKbn.Value & ""
            vntArrDispKbn(lngCount) = objDispKbn.Value & ""
            vntArrUpdDate(lngCount) = objUpdDate.Value & ""
            vntArrUpdUser(lngCount) = objUpdUser.Value & ""
            vntArrUserName(lngCount) = objUserName.Value & ""
            vntArrBoldFlg(lngCount) = objBoldFlg.Value & ""
            vntArrPubNote(lngCount) = objPubNote.Value & ""
            vntArrDispColor(lngCount) = objDispColor.Value & ""
            vntArrSelInfo(lngCount) = objSelInfo.Value & ""
            vntArrRsvNo(lngCount) = objRsvNo.Value & ""
            vntArrCslDate(lngCount) = objCslDate.Value & ""
            vntArrCsName(lngCount) = objCsName.Value & ""
'### 2004/3/24 Added by Ishihara@FSIT 削除データも考慮に含める
            vntArrDelFlg(lngCount) = objDelFlg.Value & ""
'### 2004/3/24 Added End
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        vntSeq = vntArrSeq
        vntPubNoteDivCd = vntArrPubNoteDivCd
        vntPubNoteDivName = vntArrPubNoteDivName
        vntDefaultDispKbn = vntArrDefaultDispKbn
        vntOnlyDispKbn = vntArrOnlyDispKbn
        vntDispKbn = vntArrDispKbn
        vntUpdDate = vntArrUpdDate
        vntUpdUser = vntArrUpdUser
        vntUserName = vntArrUserName
        vntBoldFlg = vntArrBoldFlg
        vntPubNote = vntArrPubNote
        vntDispColor = vntArrDispColor
        If Not IsMissing(vntSelInfo) Then vntSelInfo = vntArrSelInfo
        If Not IsMissing(vntRsvNo) Then vntRsvNo = vntArrRsvNo
        If Not IsMissing(vntCslDate) Then vntCslDate = vntArrCslDate
        If Not IsMissing(vntCsName) Then vntCsName = vntArrCsName
'### 2004/3/24 Added by Ishihara@FSIT 削除データも考慮に含める
        If Not IsMissing(vntDelFlg) Then vntDelFlg = vntArrDelFlg
'### 2004/3/24 Added End
    End If

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    '戻り値の設定
    SelectPubNote = lngCount
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectPubNote = -1

    'イベントログ書き込み
    WriteErrorLog "PubNote.SelectPubNote"
    
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
' 機能　　 : コメントを登録する
'
' 引数　　 : (In)     strMode             挿入："insert", 更新："update"
' 　　　　   (In)     lngSelInfo          検索情報（1:受診情報、2:個人、3:団体、4:契約）
' 　　　　   (In)     lngRsvNo            予約番号
' 　　　　   (In)     strPerId            個人ＩＤ
' 　　　　   (In)     strOrgCd1           団体コード１
' 　　　　   (In)     strOrgCd2           団体コード２
' 　　　　   (In)     strCtrPtCd          契約パターンコード
' 　　　　   (In)     lngSeq              seq
' 　　　　   (In)     strPubNoteDivCd     受診情報ノート分類コード
' 　　　　   (In)     lngDispKbn       　 表示対象
' 　　　　   (In)     strUpdUser       　 登録者
' 　　　　   (In)     lngBoldFlg        　太字区分
' 　　　　   (In)     strPubNote        　ノート
' 　　　　   (In)     strDispColor        表示色
' 　　　　   (Out)    lngNewSeq           新しいＳＥＱ
'
'
' 戻り値　 : 0    正常終了
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function EntryPubNote( _
    ByVal strMode As String, _
    ByVal lngSelInfo As String, _
    ByVal lngRsvNo As Long, _
    ByVal strPerId As String, _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal strCtrPtCd As String, _
    ByVal lngSeq As Long, _
    ByVal strPubNoteDivCd As String, _
    ByVal lngDispKbn As Long, _
    ByVal strUpdUser As String, _
    ByVal lngBoldFlg As Long, _
    ByVal strPubNote As String, _
    ByVal strDispColor As String, _
    Optional ByRef vntNewSeq As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    
    Dim objRet              As OraParameter     '関数復帰値
    

    Dim i                   As Long             'ループカウンタ
    
    Dim Ret                 As Long             '復帰値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntNewSeq) Then vntNewSeq = Empty
    
 'MsgBox "!!" & strMode
    'パラメータチェック
    If strMode <> "insert" And strMode <> "update" Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    
    Select Case lngSelInfo
        '受診情報
        Case 1
            If lngRsvNo = 0 Then
                Err.Raise 5     '「受診情報コメント登録の呼び出し、または引数が不正です。」
                Exit Function
            End If
            If Not IsMissing(vntNewSeq) Then
                Ret = EntryCslPubNote(strMode, lngRsvNo, lngSeq, strPubNoteDivCd, _
                                      lngDispKbn, strUpdUser, lngBoldFlg, _
                                      strPubNote, strDispColor, vntNewSeq)
            Else
                Ret = EntryCslPubNote(strMode, lngRsvNo, lngSeq, strPubNoteDivCd, _
                                      lngDispKbn, strUpdUser, lngBoldFlg, _
                                      strPubNote, strDispColor)
            End If
        '個人
        Case 2
            If strPerId = "" Then
                Err.Raise 5     '「個人コメント登録の呼び出し、または引数が不正です。」
                Exit Function
            End If
            If Not IsMissing(vntNewSeq) Then
                Ret = EntryPerPubNote(strMode, strPerId, lngSeq, strPubNoteDivCd, _
                                    lngDispKbn, strUpdUser, lngBoldFlg, _
                                    strPubNote, strDispColor, vntNewSeq)
            Else
                Ret = EntryPerPubNote(strMode, strPerId, lngSeq, strPubNoteDivCd, _
                                    lngDispKbn, strUpdUser, lngBoldFlg, _
                                    strPubNote, strDispColor)
            End If
        '団体
        Case 3
            If strOrgCd1 = "" Or strOrgCd2 = "" Then
                Err.Raise 5     '「団体コメント登録の呼び出し、または引数が不正です。」
                Exit Function
            End If
            If Not IsMissing(vntNewSeq) Then
                Ret = EntryOrgPubNote(strMode, strOrgCd1, strOrgCd2, lngSeq, strPubNoteDivCd, _
                                      lngDispKbn, strUpdUser, lngBoldFlg, _
                                      strPubNote, strDispColor, vntNewSeq)
            Else
                Ret = EntryOrgPubNote(strMode, strOrgCd1, strOrgCd2, lngSeq, strPubNoteDivCd, _
                                      lngDispKbn, strUpdUser, lngBoldFlg, _
                                      strPubNote, strDispColor)
            End If
        '契約
        Case 4
            If strCtrPtCd = "" Then
                Err.Raise 5     '「契約コメント登録の呼び出し、または引数が不正です。」
                Exit Function
            End If
            If Not IsMissing(vntNewSeq) Then
                Ret = EntryCtrPtPubNote(strMode, strCtrPtCd, lngSeq, strPubNoteDivCd, _
                                    lngDispKbn, strUpdUser, lngBoldFlg, _
                                    strPubNote, strDispColor, vntNewSeq)
            Else
                Ret = EntryCtrPtPubNote(strMode, strCtrPtCd, lngSeq, strPubNoteDivCd, _
                                    lngDispKbn, strUpdUser, lngBoldFlg, _
                                    strPubNote, strDispColor)
            End If
        Case Else
            Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
            Exit Function
    End Select
    

    '戻り値の設定
    EntryPubNote = Ret

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    EntryPubNote = -1

    'イベントログ書き込み
    WriteErrorLog "PubNote.EntryPubNote"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function


'
' 機能　　 : 受診情報コメントを登録する
'
' 引数　　 : (In)     strMode             挿入："insert", 更新："update"
' 　　　　   (In)     lngRsvNo            予約番号
' 　　　　   (In)     lngSeq              seq
' 　　　　   (In)     strPubNoteDivCd     受診情報ノート分類コード
' 　　　　   (In)     lngDispKbn       　 表示対象
' 　　　　   (In)     strUpdUser       　 登録者
' 　　　　   (In)     lngBoldFlg        　太字区分
' 　　　　   (In)     strPubNote        　ノート
' 　　　　   (In)     strDispColor        表示色
' 　　　　   (Out)    vntNewSeq           新しいＳＥＱ
'
'
' 戻り値　 : 0    正常終了
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function EntryCslPubNote( _
    ByVal strMode As String, _
    ByVal lngRsvNo As Long, _
    ByVal lngSeq As Long, _
    ByVal strPubNoteDivCd As String, _
    ByVal lngDispKbn As Long, _
    ByVal strUpdUser As String, _
    ByVal lngBoldFlg As Long, _
    ByVal strPubNote As String, _
    ByVal strDispColor As String, _
    Optional ByRef vntNewSeq As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    
    
    Dim Ret                 As Long             '復帰値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntNewSeq) Then vntNewSeq = Empty
    
    Select Case strMode
        '挿入
        Case "insert"
            If Not IsMissing(vntNewSeq) Then
                Ret = InsertCslPubNote(lngRsvNo, strPubNoteDivCd, _
                                       lngDispKbn, strUpdUser, lngBoldFlg, _
                                       strPubNote, strDispColor, vntNewSeq)
            Else
                Ret = InsertCslPubNote(lngRsvNo, strPubNoteDivCd, _
                                       lngDispKbn, strUpdUser, lngBoldFlg, _
                                       strPubNote, strDispColor)
            End If
        '更新
        Case "update"
            Ret = UpdateCslPubNote(lngRsvNo, lngSeq, strPubNoteDivCd, _
                                  lngDispKbn, strUpdUser, lngBoldFlg, _
                                  strPubNote, strDispColor)
        Case Else
            Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
            Exit Function
    End Select
    

    '戻り値の設定
    EntryCslPubNote = Ret

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    EntryCslPubNote = -1

    'イベントログ書き込み
    WriteErrorLog "PubNote.EntryCslPubNote"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function


'
' 機能　　 : 個人コメントを登録する
'
' 引数　　 : (In)     strMode             挿入："insert", 更新："update"
' 　　　　   (In)     strPerId            個人ＩＤ
' 　　　　   (In)     lngSeq              seq
' 　　　　   (In)     strPubNoteDivCd     受診情報ノート分類コード
' 　　　　   (In)     lngDispKbn       　 表示対象
' 　　　　   (In)     strUpdUser       　 登録者
' 　　　　   (In)     lngBoldFlg        　太字区分
' 　　　　   (In)     strPubNote        　ノート
' 　　　　   (In)     strDispColor        表示色
' 　　　　   (Out)    vntNewSeq           新しいＳＥＱ
'
'
' 戻り値　 : 0    正常終了
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function EntryPerPubNote( _
    ByVal strMode As String, _
    ByVal strPerId As String, _
    ByVal lngSeq As Long, _
    ByVal strPubNoteDivCd As String, _
    ByVal lngDispKbn As Long, _
    ByVal strUpdUser As String, _
    ByVal lngBoldFlg As Long, _
    ByVal strPubNote As String, _
    ByVal strDispColor As String, _
    Optional ByRef vntNewSeq As Variant _
) As Long


    Dim Ret                 As Long             '復帰値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntNewSeq) Then vntNewSeq = Empty
    
    
    Select Case strMode
        '挿入
        Case "insert"
            If Not IsMissing(vntNewSeq) Then
                Ret = InsertPerPubNote(strPerId, strPubNoteDivCd, _
                                       lngDispKbn, strUpdUser, lngBoldFlg, _
                                       strPubNote, strDispColor, vntNewSeq)
            Else
                Ret = InsertPerPubNote(strPerId, strPubNoteDivCd, _
                                       lngDispKbn, strUpdUser, lngBoldFlg, _
                                       strPubNote, strDispColor)
            End If
        '更新
        Case "update"
'MsgBox strPerId & " " & lngSeq & " " & strPubNoteDivCd & " " & _
                                  lngDispKbn & " " & strUpdUser & " " & lngBoldFlg & " " & _
                                  strPubNote & " " & strDispColor
            Ret = UpdatePerPubNote(strPerId, lngSeq, strPubNoteDivCd, _
                                  lngDispKbn, strUpdUser, lngBoldFlg, _
                                  strPubNote, strDispColor)
        Case Else
            Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
            Exit Function
    End Select
    
'MsgBox "ret=" & Ret
    '戻り値の設定
    EntryPerPubNote = Ret

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    EntryPerPubNote = -1

    'イベントログ書き込み
    WriteErrorLog "PubNote.EntryPerPubNote"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 団体コメントを登録する
'
' 引数　　 : (In)     strMode             挿入："insert", 更新："update"
' 　　　　   (In)     strOrgCd1           団体コード１
' 　　　　   (In)     strOrgCd2           団体コード２
' 　　　　   (In)     lngSeq              seq
' 　　　　   (In)     strPubNoteDivCd     受診情報ノート分類コード
' 　　　　   (In)     lngDispKbn       　 表示対象
' 　　　　   (In)     strUpdUser       　 登録者
' 　　　　   (In)     lngBoldFlg        　太字区分
' 　　　　   (In)     strPubNote        　ノート
' 　　　　   (In)     strDispColor        表示色
' 　　　　   (Out)    vntNewSeq           新しいＳＥＱ
'
'
' 戻り値　 : 0    正常終了
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function EntryOrgPubNote( _
    ByVal strMode As String, _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal lngSeq As Long, _
    ByVal strPubNoteDivCd As String, _
    ByVal lngDispKbn As Long, _
    ByVal strUpdUser As String, _
    ByVal lngBoldFlg As Long, _
    ByVal strPubNote As String, _
    ByVal strDispColor As String, _
    Optional ByRef vntNewSeq As Variant _
) As Long


    Dim Ret                 As Long             '復帰値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntNewSeq) Then vntNewSeq = Empty
    
    
    Select Case strMode
        '挿入
        Case "insert"
            If Not IsMissing(vntNewSeq) Then
                Ret = InsertOrgPubNote(strOrgCd1, strOrgCd2, strPubNoteDivCd, _
                                       lngDispKbn, strUpdUser, lngBoldFlg, _
                                       strPubNote, strDispColor, vntNewSeq)
            Else
                Ret = InsertOrgPubNote(strOrgCd1, strOrgCd2, strPubNoteDivCd, _
                                       lngDispKbn, strUpdUser, lngBoldFlg, _
                                       strPubNote, strDispColor)
            End If
        '更新
        Case "update"
'MsgBox strOrgCd1 & " " & strOrgCd2
            Ret = UpdateOrgPubNote(strOrgCd1, strOrgCd2, lngSeq, strPubNoteDivCd, _
                                  lngDispKbn, strUpdUser, lngBoldFlg, _
                                  strPubNote, strDispColor)
        Case Else
            Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
            Exit Function
    End Select
    
'MsgBox "ret=" & Ret
    '戻り値の設定
    EntryOrgPubNote = Ret

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    EntryOrgPubNote = -1

    'イベントログ書き込み
    WriteErrorLog "PubNote.EntryOrgPubNote"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'
' 機能　　 : 契約コメントを登録する
'
' 引数　　 : (In)     strMode             挿入："insert", 更新："update"
' 　　　　   (In)     strCtrPtCd          契約パターン
' 　　　　   (In)     lngSeq              seq
' 　　　　   (In)     strPubNoteDivCd     受診情報ノート分類コード
' 　　　　   (In)     lngDispKbn       　 表示対象
' 　　　　   (In)     strUpdUser       　 登録者
' 　　　　   (In)     lngBoldFlg        　太字区分
' 　　　　   (In)     strPubNote        　ノート
' 　　　　   (In)     strDispColor        表示色
' 　　　　   (Out)    vntNewSeq           新しいＳＥＱ
'
'
' 戻り値　 : 0    正常終了
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function EntryCtrPtPubNote( _
    ByVal strMode As String, _
    ByVal strCtrPtCd As String, _
    ByVal lngSeq As Long, _
    ByVal strPubNoteDivCd As String, _
    ByVal lngDispKbn As Long, _
    ByVal strUpdUser As String, _
    ByVal lngBoldFlg As Long, _
    ByVal strPubNote As String, _
    ByVal strDispColor As String, _
    Optional ByRef vntNewSeq As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    
    
    Dim Ret                 As Long             '復帰値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntNewSeq) Then vntNewSeq = Empty
    
    Select Case strMode
        '挿入
        Case "insert"
            If Not IsMissing(vntNewSeq) Then
                Ret = InsertCtrPtPubNote(strCtrPtCd, strPubNoteDivCd, _
                                       lngDispKbn, strUpdUser, lngBoldFlg, _
                                       strPubNote, strDispColor, vntNewSeq)
            Else
                Ret = InsertCtrPtPubNote(strCtrPtCd, strPubNoteDivCd, _
                                       lngDispKbn, strUpdUser, lngBoldFlg, _
                                       strPubNote, strDispColor)
            End If
        '更新
        Case "update"
            Ret = UpdateCtrPtPubNote(strCtrPtCd, lngSeq, strPubNoteDivCd, _
                                  lngDispKbn, strUpdUser, lngBoldFlg, _
                                  strPubNote, strDispColor)
        Case Else
            Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
            Exit Function
    End Select
    

    '戻り値の設定
    EntryCtrPtPubNote = Ret

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    EntryCtrPtPubNote = -1

    'イベントログ書き込み
    WriteErrorLog "PubNote.EntryCtrPtPubNote"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function


'
' 機能　　 : 受診情報コメントを新規に登録する
'
' 引数　　 : (In)     lngRsvNo            予約番号
' 　　　　   (In)     strPubNoteDivCd     受診情報ノート分類コード
' 　　　　   (In)     lngDispKbn       　 表示対象
' 　　　　   (In)     strUpdUser       　 登録者
' 　　　　   (In)     lngBoldFlg        　太字区分
' 　　　　   (In)     strPubNote        　ノート
' 　　　　   (In)     strDispColor        表示色
' 　　　　   (Out)    vntNewSeq           新しいＳＥＱ
'
'
' 戻り値　 : 0    正常終了
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function InsertCslPubNote( _
    ByVal lngRsvNo As Long, _
    ByVal strPubNoteDivCd As String, _
    ByVal lngDispKbn As Long, _
    ByVal strUpdUser As String, _
    ByVal lngBoldFlg As Long, _
    ByVal strPubNote As String, _
    ByVal strDispColor As String, _
    Optional ByRef vntNewSeq As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objRet              As OraParameter     '関数復帰値
    
    Dim lngNewSeq           As Long             '新しいＳＥＱ
    
    Dim blnSuccess          As Boolean          '処理成功フラグ
    Dim i                   As Long             'ループカウンタ
    
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntNewSeq) Then vntNewSeq = Empty
    
    'ＭＡＸ　ＳＥＱを取得
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    Do
        strStmt = "SELECT NVL(MAX(SEQ), 0) + 1 NEWSEQ " & vbLf & _
                  "  FROM CSLPUBNOTE                  " & vbLf & _
                  " WHERE RSVNO = :RSVNO              "
    
        '新しいSEQを取得する(他で処理中の場合は最大10回までリトライ)
        For i = 1 To 10
        
            blnSuccess = True
            
            '新Ｓｅｑを取得する
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
            Err.Raise 1000, , "現在他業務にてコメント情報を使用中のため、行番号発番処理は行えませんでした。"
        End If
        
        
        '登録ＳＥＱを取得
        lngNewSeq = objOraDyna.Fields("NEWSEQ").Value
        
        objOraParam.Add "SEQ", Trim(lngNewSeq), ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "PUBNOTEDIVCD", Trim(strPubNoteDivCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "DISPKBN", Trim(lngDispKbn), ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "UPDUSER", Trim(strUpdUser), ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "BOLDFLG", Trim(lngBoldFlg), ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "PUBNOTE", Trim(strPubNote), ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "DISPCOLOR", Trim(strDispColor), ORAPARM_INPUT, ORATYPE_VARCHAR2
        
        strStmt = " INSERT INTO CSLPUBNOTE (                " & vbLf & _
                  "       RSVNO, SEQ,                       " & vbLf & _
                  "       PUBNOTEDIVCD, DISPKBN,            " & vbLf & _
                  "       UPDDATE, UPDUSER,                 " & vbLf & _
                  "       BOLDFLG, PUBNOTE, DISPCOLOR       " & vbLf & _
                  "     ) VALUES (                          " & vbLf & _
                  "       :RSVNO, :SEQ,                     " & vbLf & _
                  "       :PUBNOTEDIVCD, :DISPKBN,          " & vbLf & _
                  "       SYSDATE, :UPDUSER,                " & vbLf & _
                  "       :BOLDFLG, :PUBNOTE, :DISPCOLOR )  "
         
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
       
        If Not IsMissing(vntNewSeq) Then vntNewSeq = lngNewSeq
       
        
        Exit Do
    Loop
    
        
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    

    '戻り値の設定
    InsertCslPubNote = 0

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    InsertCslPubNote = -1

    'イベントログ書き込み
    WriteErrorLog "PubNote.InsertCslPubNote"
    
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
' 機能　　 : 受診情報コメントを更新する
'
' 引数　　 : (In)     lngRsvNo            予約番号
' 　　　　   (In)     lngSeq              ＳＥＱ
' 　　　　   (In)     strPubNoteDivCd     受診情報ノート分類コード
' 　　　　   (In)     lngDispKbn       　 表示対象
' 　　　　   (In)     strUpdUser       　 登録者
' 　　　　   (In)     lngBoldFlg        　太字区分
' 　　　　   (In)     strPubNote        　ノート
' 　　　　   (In)     strDispColor        表示色
'
'
' 戻り値　 : 0    正常終了
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function UpdateCslPubNote( _
    ByVal lngRsvNo As Long, _
    ByVal lngSeq As Long, _
    ByVal strPubNoteDivCd As String, _
    ByVal lngDispKbn As Long, _
    ByVal strUpdUser As String, _
    ByVal lngBoldFlg As Long, _
    ByVal strPubNote As String, _
    ByVal strDispColor As String _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objRet              As OraParameter     '関数復帰値
    
    
    Dim lngNewSeq           As Long             '新しいＳＥＱ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SEQ", Trim(lngSeq), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "PUBNOTEDIVCD", Trim(strPubNoteDivCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "DISPKBN", Trim(lngDispKbn), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "UPDUSER", Trim(strUpdUser), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "BOLDFLG", Trim(lngBoldFlg), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "PUBNOTE", Trim(strPubNote), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "DISPCOLOR", Trim(strDispColor), ORAPARM_INPUT, ORATYPE_VARCHAR2
        
'MsgBox lngRsvNo & " " & lngSeq
    strStmt = " UPDATE CSLPUBNOTE                        " & vbLf & _
              "    SET PUBNOTEDIVCD = :PUBNOTEDIVCD,     " & vbLf & _
              "        DISPKBN      = :DISPKBN,          " & vbLf & _
              "        UPDDATE      = SYSDATE,           " & vbLf & _
              "        UPDUSER      = :UPDUSER,          " & vbLf & _
              "        BOLDFLG      = :BOLDFLG,          " & vbLf & _
              "        PUBNOTE      = :PUBNOTE,          " & vbLf & _
              "        DISPCOLOR    = :DISPCOLOR         " & vbLf & _
              "  WHERE RSVNO        = :RSVNO             " & vbLf & _
              "    AND SEQ          = :SEQ               "
         
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
       
        
        
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    

    '戻り値の設定
    UpdateCslPubNote = 0

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    UpdateCslPubNote = -1

    'イベントログ書き込み
    WriteErrorLog "PubNote.UpdateCslPubNote"
    
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
' 機能　　 : 個人コメントを新規に登録する
'
' 引数　　 : (In)     strPerId            個人ＩＤ
' 　　　　   (In)     strPubNoteDivCd     受診情報ノート分類コード
' 　　　　   (In)     lngDispKbn       　 表示対象
' 　　　　   (In)     strUpdUser       　 登録者
' 　　　　   (In)     lngBoldFlg        　太字区分
' 　　　　   (In)     strPubNote        　ノート
' 　　　　   (In)     strDispColor        表示色
' 　　　　   (Out)    lngNewSeq           新しいＳＥＱ
'
'
' 戻り値　 : 0    正常終了
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function InsertPerPubNote( _
    ByVal strPerId As String, _
    ByVal strPubNoteDivCd As String, _
    ByVal lngDispKbn As Long, _
    ByVal strUpdUser As String, _
    ByVal lngBoldFlg As Long, _
    ByVal strPubNote As String, _
    ByVal strDispColor As String, _
    Optional ByRef vntNewSeq As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objRet              As OraParameter     '関数復帰値
    
    Dim blnSuccess          As Boolean          '処理成功フラグ
    Dim i                   As Long             'ループカウンタ
    
    Dim lngNewSeq           As Long             '新しいＳＥＱ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntNewSeq) Then vntNewSeq = Empty
    
    'ＭＡＸ　ＳＥＱを取得
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", Trim(strPerId), ORAPARM_INPUT, ORATYPE_NUMBER
    
    Do
        strStmt = "SELECT NVL(MAX(SEQ), 0) + 1 NEWSEQ " & vbLf & _
                  "  FROM PERPUBNOTE                  " & vbLf & _
                  " WHERE PERID = :PERID              "
    
        '新しいSEQを取得する(他で処理中の場合は最大10回までリトライ)
        For i = 1 To 10
        
            blnSuccess = True
            
            '新Ｓｅｑを取得する
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
            Err.Raise 1000, , "現在他業務にてコメント情報を使用中のため、行番号発番処理は行えませんでした。"
        End If
        
        
        '登録ＳＥＱを取得
        lngNewSeq = objOraDyna.Fields("NEWSEQ").Value
        
        objOraParam.Add "SEQ", Trim(lngNewSeq), ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "PUBNOTEDIVCD", Trim(strPubNoteDivCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "DISPKBN", Trim(lngDispKbn), ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "UPDUSER", Trim(strUpdUser), ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "BOLDFLG", Trim(lngBoldFlg), ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "PUBNOTE", Trim(strPubNote), ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "DISPCOLOR", Trim(strDispColor), ORAPARM_INPUT, ORATYPE_VARCHAR2
        
        strStmt = " INSERT INTO PERPUBNOTE (                " & vbLf & _
                  "       PERID, SEQ,                       " & vbLf & _
                  "       PUBNOTEDIVCD, DISPKBN,            " & vbLf & _
                  "       UPDDATE, UPDUSER,                 " & vbLf & _
                  "       BOLDFLG, PUBNOTE, DISPCOLOR       " & vbLf & _
                  "     ) VALUES (                          " & vbLf & _
                  "       :PERID, :SEQ,                     " & vbLf & _
                  "       :PUBNOTEDIVCD, :DISPKBN,          " & vbLf & _
                  "       SYSDATE, :UPDUSER,                " & vbLf & _
                  "       :BOLDFLG, :PUBNOTE, :DISPCOLOR )  "
         
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
       
        If Not IsMissing(vntNewSeq) Then vntNewSeq = lngNewSeq
        
        Exit Do
    Loop
    
        
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    

    '戻り値の設定
    InsertPerPubNote = 0

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    InsertPerPubNote = -1

    'イベントログ書き込み
    WriteErrorLog "PubNote.InsertPerPubNote"
    
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
' 機能　　 : 個人コメントを更新する
'
' 引数　　 : (In)     srePerId            個人ＩＤ
' 　　　　   (In)     lngSeq              ＳＥＱ
' 　　　　   (In)     strPubNoteDivCd     受診情報ノート分類コード
' 　　　　   (In)     lngDispKbn       　 表示対象
' 　　　　   (In)     strUpdUser       　 登録者
' 　　　　   (In)     lngBoldFlg        　太字区分
' 　　　　   (In)     strPubNote        　ノート
' 　　　　   (In)     strDispColor        表示色
'
'
' 戻り値　 : 0    正常終了
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function UpdatePerPubNote( _
    ByVal strPerId As String, _
    ByVal lngSeq As Long, _
    ByVal strPubNoteDivCd As String, _
    ByVal lngDispKbn As Long, _
    ByVal strUpdUser As String, _
    ByVal lngBoldFlg As Long, _
    ByVal strPubNote As String, _
    ByVal strDispColor As String _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
        
    
    Dim lngNewSeq           As Long             '新しいＳＥＱ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PERID", Trim(strPerId), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SEQ", Trim(lngSeq), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "PUBNOTEDIVCD", Trim(strPubNoteDivCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "DISPKBN", Trim(lngDispKbn), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "UPDUSER", Trim(strUpdUser), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "BOLDFLG", Trim(lngBoldFlg), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "PUBNOTE", Trim(strPubNote), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "DISPCOLOR", Trim(strDispColor), ORAPARM_INPUT, ORATYPE_VARCHAR2
        
    strStmt = " UPDATE PERPUBNOTE                        " & vbLf & _
              "    SET PUBNOTEDIVCD = :PUBNOTEDIVCD,     " & vbLf & _
              "        DISPKBN      = :DISPKBN,          " & vbLf & _
              "        UPDDATE      = SYSDATE,           " & vbLf & _
              "        UPDUSER      = :UPDUSER,          " & vbLf & _
              "        BOLDFLG      = :BOLDFLG,          " & vbLf & _
              "        PUBNOTE      = :PUBNOTE,          " & vbLf & _
              "        DISPCOLOR    = :DISPCOLOR         " & vbLf & _
              "  WHERE PERID        = :PERID             " & vbLf & _
              "    AND SEQ          = :SEQ               "
         
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
       
        
        
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    

    '戻り値の設定
    UpdatePerPubNote = 0

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    UpdatePerPubNote = -1

    'イベントログ書き込み
    WriteErrorLog "PubNote.UpdatePerPubNote"
    
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
' 機能　　 : 団体コメントを新規に登録する
'
' 引数　　 : (In)     strOrgCd1           団体コード１
' 　　　　   (In)     strOrgCd2           団体コード２
' 　　　　   (In)     strPubNoteDivCd     受診情報ノート分類コード
' 　　　　   (In)     lngDispKbn       　 表示対象
' 　　　　   (In)     strUpdUser       　 登録者
' 　　　　   (In)     lngBoldFlg        　太字区分
' 　　　　   (In)     strPubNote        　ノート
' 　　　　   (In)     strDispColor        表示色
' 　　　　   (Out)    lngNewSeq           新しいＳＥＱ
'
'
' 戻り値　 : 0    正常終了
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function InsertOrgPubNote( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal strPubNoteDivCd As String, _
    ByVal lngDispKbn As Long, _
    ByVal strUpdUser As String, _
    ByVal lngBoldFlg As Long, _
    ByVal strPubNote As String, _
    ByVal strDispColor As String, _
    Optional ByRef vntNewSeq As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objRet              As OraParameter     '関数復帰値
    
    Dim blnSuccess          As Boolean          '処理成功フラグ
    Dim i                   As Long             'ループカウンタ
    
    Dim lngNewSeq           As Long             '新しいＳＥＱ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntNewSeq) Then vntNewSeq = Empty
    
    'ＭＡＸ　ＳＥＱを取得
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    Do
        strStmt = "SELECT NVL(MAX(SEQ), 0) + 1 NEWSEQ " & vbLf & _
                  "  FROM ORGPUBNOTE                  " & vbLf & _
                  " WHERE ORGCD1 = :ORGCD1            " & vbLf & _
                  "   AND ORGCD2 = :ORGCD2            "
    
        '新しいSEQを取得する(他で処理中の場合は最大10回までリトライ)
        For i = 1 To 10
        
            blnSuccess = True
            
            '新Ｓｅｑを取得する
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
            Err.Raise 1000, , "現在他業務にてコメント情報を使用中のため、行番号発番処理は行えませんでした。"
        End If
        
        
        '登録ＳＥＱを取得
        lngNewSeq = objOraDyna.Fields("NEWSEQ").Value
        
        objOraParam.Add "SEQ", Trim(lngNewSeq), ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "PUBNOTEDIVCD", Trim(strPubNoteDivCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "DISPKBN", Trim(lngDispKbn), ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "UPDUSER", Trim(strUpdUser), ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "BOLDFLG", Trim(lngBoldFlg), ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "PUBNOTE", Trim(strPubNote), ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "DISPCOLOR", Trim(strDispColor), ORAPARM_INPUT, ORATYPE_VARCHAR2
        
        strStmt = " INSERT INTO ORGPUBNOTE (                " & vbLf & _
                  "       ORGCD1, ORGCD2, SEQ,              " & vbLf & _
                  "       PUBNOTEDIVCD, DISPKBN,            " & vbLf & _
                  "       UPDDATE, UPDUSER,                 " & vbLf & _
                  "       BOLDFLG, PUBNOTE, DISPCOLOR       " & vbLf & _
                  "     ) VALUES (                          " & vbLf & _
                  "       :ORGCD1, :ORGCD2, :SEQ,           " & vbLf & _
                  "       :PUBNOTEDIVCD, :DISPKBN,          " & vbLf & _
                  "       SYSDATE, :UPDUSER,                " & vbLf & _
                  "       :BOLDFLG, :PUBNOTE, :DISPCOLOR )  "
         
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
       
        If Not IsMissing(vntNewSeq) Then vntNewSeq = lngNewSeq
        
        Exit Do
    Loop
    
        
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    

    '戻り値の設定
    InsertOrgPubNote = 0

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    InsertOrgPubNote = -1

    'イベントログ書き込み
    WriteErrorLog "PubNote.InsertOrgPubNote"
    
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
' 機能　　 : 団体コメントを更新する
'
' 引数　　 : (In)     strOrgCd1           団体コード１
' 　　　　   (In)     strOrgCd2           団体コード２
' 　　　　   (In)     lngSeq              ＳＥＱ
' 　　　　   (In)     strPubNoteDivCd     受診情報ノート分類コード
' 　　　　   (In)     lngDispKbn       　 表示対象
' 　　　　   (In)     strUpdUser       　 登録者
' 　　　　   (In)     lngBoldFlg        　太字区分
' 　　　　   (In)     strPubNote        　ノート
' 　　　　   (In)     strDispColor        表示色
'
'
' 戻り値　 : 0    正常終了
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function UpdateOrgPubNote( _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal lngSeq As Long, _
    ByVal strPubNoteDivCd As String, _
    ByVal lngDispKbn As Long, _
    ByVal strUpdUser As String, _
    ByVal lngBoldFlg As Long, _
    ByVal strPubNote As String, _
    ByVal strDispColor As String _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
        
    
    Dim lngNewSeq           As Long             '新しいＳＥＱ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "SEQ", Trim(lngSeq), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "PUBNOTEDIVCD", Trim(strPubNoteDivCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "DISPKBN", Trim(lngDispKbn), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "UPDUSER", Trim(strUpdUser), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "BOLDFLG", Trim(lngBoldFlg), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "PUBNOTE", Trim(strPubNote), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "DISPCOLOR", Trim(strDispColor), ORAPARM_INPUT, ORATYPE_VARCHAR2
        
    strStmt = " UPDATE ORGPUBNOTE                        " & vbLf & _
              "    SET PUBNOTEDIVCD = :PUBNOTEDIVCD,     " & vbLf & _
              "        DISPKBN      = :DISPKBN,          " & vbLf & _
              "        UPDDATE      = SYSDATE,           " & vbLf & _
              "        UPDUSER      = :UPDUSER,          " & vbLf & _
              "        BOLDFLG      = :BOLDFLG,          " & vbLf & _
              "        PUBNOTE      = :PUBNOTE,          " & vbLf & _
              "        DISPCOLOR    = :DISPCOLOR         " & vbLf & _
              "  WHERE ORGCD1       = :ORGCD1            " & vbLf & _
              "    AND ORGCD2       = :ORGCD2            " & vbLf & _
              "    AND SEQ          = :SEQ               "
         
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
       
        
        
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    

    '戻り値の設定
    UpdateOrgPubNote = 0

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    UpdateOrgPubNote = -1

    'イベントログ書き込み
    WriteErrorLog "PubNote.UpdateOrgPubNote"
    
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
' 機能　　 : 契約コメントを新規に登録する
'
' 引数　　 : (In)     strCtrPtCd          契約パターンコード
' 　　　　   (In)     strPubNoteDivCd     受診情報ノート分類コード
' 　　　　   (In)     lngDispKbn       　 表示対象
' 　　　　   (In)     strUpdUser       　 登録者
' 　　　　   (In)     lngBoldFlg        　太字区分
' 　　　　   (In)     strPubNote        　ノート
' 　　　　   (In)     strDispColor        表示色
' 　　　　   (Out)    vntNewSeq           新しいＳＥＱ
'
'
' 戻り値　 : 0    正常終了
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function InsertCtrPtPubNote( _
    ByVal strCtrPtCd As Long, _
    ByVal strPubNoteDivCd As String, _
    ByVal lngDispKbn As Long, _
    ByVal strUpdUser As String, _
    ByVal lngBoldFlg As Long, _
    ByVal strPubNote As String, _
    ByVal strDispColor As String, _
    Optional ByRef vntNewSeq As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objRet              As OraParameter     '関数復帰値
    
    Dim lngNewSeq           As Long             '新しいＳＥＱ
    
    Dim blnSuccess          As Boolean          '処理成功フラグ
    Dim i                   As Long             'ループカウンタ
    
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntNewSeq) Then vntNewSeq = Empty
    
    'ＭＡＸ　ＳＥＱを取得
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", Trim(strCtrPtCd), ORAPARM_INPUT, ORATYPE_NUMBER
    
    Do
        strStmt = "SELECT NVL(MAX(SEQ), 0) + 1 NEWSEQ " & vbLf & _
                  "  FROM CTRPTPUBNOTE                " & vbLf & _
                  " WHERE CTRPTCD = :CTRPTCD          "
    
        '新しいSEQを取得する(他で処理中の場合は最大10回までリトライ)
        For i = 1 To 10
        
            blnSuccess = True
            
            '新Ｓｅｑを取得する
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
            Err.Raise 1000, , "現在他業務にてコメント情報を使用中のため、行番号発番処理は行えませんでした。"
        End If
        
        
        '登録ＳＥＱを取得
        lngNewSeq = objOraDyna.Fields("NEWSEQ").Value
        
        objOraParam.Add "SEQ", Trim(lngNewSeq), ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "PUBNOTEDIVCD", Trim(strPubNoteDivCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "DISPKBN", Trim(lngDispKbn), ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "UPDUSER", Trim(strUpdUser), ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "BOLDFLG", Trim(lngBoldFlg), ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "PUBNOTE", Trim(strPubNote), ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "DISPCOLOR", Trim(strDispColor), ORAPARM_INPUT, ORATYPE_VARCHAR2
        
        strStmt = " INSERT INTO CTRPTPUBNOTE (              " & vbLf & _
                  "       CTRPTCD, SEQ,                     " & vbLf & _
                  "       PUBNOTEDIVCD, DISPKBN,            " & vbLf & _
                  "       UPDDATE, UPDUSER,                 " & vbLf & _
                  "       BOLDFLG, PUBNOTE, DISPCOLOR       " & vbLf & _
                  "     ) VALUES (                          " & vbLf & _
                  "       :CTRPTCD, :SEQ,                   " & vbLf & _
                  "       :PUBNOTEDIVCD, :DISPKBN,          " & vbLf & _
                  "       SYSDATE, :UPDUSER,                " & vbLf & _
                  "       :BOLDFLG, :PUBNOTE, :DISPCOLOR )  "
         
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
       
        If Not IsMissing(vntNewSeq) Then vntNewSeq = lngNewSeq
       
        
        Exit Do
    Loop
    
        
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    

    '戻り値の設定
    InsertCtrPtPubNote = 0

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    InsertCtrPtPubNote = -1

    'イベントログ書き込み
    WriteErrorLog "PubNote.InsertCtrPtPubNote"
    
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
' 機能　　 : 契約コメントを更新する
'
' 引数　　 : (In)     strCtrPtCd          契約パターンコード
' 　　　　   (In)     lngSeq              ＳＥＱ
' 　　　　   (In)     strPubNoteDivCd     受診情報ノート分類コード
' 　　　　   (In)     lngDispKbn       　 表示対象
' 　　　　   (In)     strUpdUser       　 登録者
' 　　　　   (In)     lngBoldFlg        　太字区分
' 　　　　   (In)     strPubNote        　ノート
' 　　　　   (In)     strDispColor        表示色
'
'
' 戻り値　 : 0    正常終了
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function UpdateCtrPtPubNote( _
    ByVal strCtrPtCd As Long, _
    ByVal lngSeq As Long, _
    ByVal strPubNoteDivCd As String, _
    ByVal lngDispKbn As Long, _
    ByVal strUpdUser As String, _
    ByVal lngBoldFlg As Long, _
    ByVal strPubNote As String, _
    ByVal strDispColor As String _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objRet              As OraParameter     '関数復帰値
    
    
    Dim lngNewSeq           As Long             '新しいＳＥＱ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD", Trim(strCtrPtCd), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SEQ", Trim(lngSeq), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "PUBNOTEDIVCD", Trim(strPubNoteDivCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "DISPKBN", Trim(lngDispKbn), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "UPDUSER", Trim(strUpdUser), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "BOLDFLG", Trim(lngBoldFlg), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "PUBNOTE", Trim(strPubNote), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "DISPCOLOR", Trim(strDispColor), ORAPARM_INPUT, ORATYPE_VARCHAR2
        
'MsgBox strCtrPtCd & " " & lngSeq
    strStmt = " UPDATE CTRPTPUBNOTE                      " & vbLf & _
              "    SET PUBNOTEDIVCD = :PUBNOTEDIVCD,     " & vbLf & _
              "        DISPKBN      = :DISPKBN,          " & vbLf & _
              "        UPDDATE      = SYSDATE,           " & vbLf & _
              "        UPDUSER      = :UPDUSER,          " & vbLf & _
              "        BOLDFLG      = :BOLDFLG,          " & vbLf & _
              "        PUBNOTE      = :PUBNOTE,          " & vbLf & _
              "        DISPCOLOR    = :DISPCOLOR         " & vbLf & _
              "  WHERE CTRPTCD      = :CTRPTCD           " & vbLf & _
              "    AND SEQ          = :SEQ               "
         
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
       
        
        
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    

    '戻り値の設定
    UpdateCtrPtPubNote = 0

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    UpdateCtrPtPubNote = -1

    'イベントログ書き込み
    WriteErrorLog "PubNote.UpdateCtrPtPubNote"
    
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
' 機能　　 : コメントを削除する
'
' 引数　　 : (In)     lngSelInfo          検索情報（1:受診情報、2:個人、3:団体、4:契約）
' 　　　　   (In)     lngRsvNo            予約番号
' 　　　　   (In)     strPerId            個人ＩＤ
' 　　　　   (In)     strOrgCd1           団体コード１
' 　　　　   (In)     strOrgCd2           団体コード２
' 　　　　   (In)     strCtrPtCd          契約パターンコード
' 　　　　   (In)     lngSeq              seq
'
'
' 戻り値　 : 0    正常終了
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function DeletePubNote( _
    ByVal lngSelInfo As String, _
    ByVal lngRsvNo As Long, _
    ByVal strPerId As String, _
    ByVal strOrgCd1 As String, _
    ByVal strOrgCd2 As String, _
    ByVal strCtrPtCd As String, _
    ByVal lngSeq As Long _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    

    Dim i                   As Long             'ループカウンタ
    
    Dim Ret                 As Long             '復帰値

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "SEQ", Trim(lngSeq), ORAPARM_INPUT, ORATYPE_NUMBER
    
    Select Case lngSelInfo
        '受診情報
        Case 1
            If lngRsvNo = 0 Then
                Err.Raise 5     '「受診情報コメント削除の呼び出し、または引数が不正です。」
                Exit Function
            End If
            objOraParam.Add "RSVNO", Trim(lngRsvNo), ORAPARM_INPUT, ORATYPE_NUMBER
            
 ''' 削除は論理削除とする 2003.12.02 by FFCS
 '           strStmt = "DELETE CSLPUBNOTE          " & vbLf & _
 '                     " WHERE RSVNO = :RSVNO      " & vbLf & _
 '                     "   AND SEQ   = :SEQ        "
            strStmt = "UPDATE CSLPUBNOTE          " & vbLf & _
                      "   SET DELFLG = 1          " & vbLf & _
                      " WHERE RSVNO = :RSVNO      " & vbLf & _
                      "   AND SEQ   = :SEQ        "

        '個人
        Case 2
            If strPerId = "" Then
                Err.Raise 5     '「個人コメント削除の呼び出し、または引数が不正です。」
                Exit Function
            End If
            objOraParam.Add "PERID", Trim(strPerId), ORAPARM_INPUT, ORATYPE_VARCHAR2
            
''' 削除は論理削除とする 2003.12.02 by FFCS
'            strStmt = "DELETE PERPUBNOTE          " & vbLf & _
'                      " WHERE PERID = :PERID      " & vbLf & _
'                      "   AND SEQ   = :SEQ        "
            strStmt = "UPDATE PERPUBNOTE          " & vbLf & _
                      "   SET DELFLG = 1          " & vbLf & _
                      " WHERE PERID = :PERID      " & vbLf & _
                      "   AND SEQ   = :SEQ        "
        '団体
        Case 3
            If strOrgCd1 = "" Or strOrgCd2 = "" Then
                Err.Raise 5     '「団体コメント削除の呼び出し、または引数が不正です。」
                Exit Function
            End If
            objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
            objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
            
''' 削除は論理削除とする 2003.12.02 by FFCS
'            strStmt = "DELETE ORGPUBNOTE          " & vbLf & _
'                      " WHERE ORGCD1 = :ORGCD1    " & vbLf & _
'                      "   AND ORGCD2 = :ORGCD2    " & vbLf & _
'                      "   AND SEQ    = :SEQ       "
            strStmt = "UPDATE ORGPUBNOTE          " & vbLf & _
                      "   SET DELFLG = 1          " & vbLf & _
                      " WHERE ORGCD1 = :ORGCD1    " & vbLf & _
                      "   AND ORGCD2 = :ORGCD2    " & vbLf & _
                      "   AND SEQ    = :SEQ       "
        '契約
        Case 4
            If strCtrPtCd = "" Then
                Err.Raise 5     '「契約コメント削除の呼び出し、または引数が不正です。」
                Exit Function
            End If
            objOraParam.Add "CTRPTCD", Trim(strCtrPtCd), ORAPARM_INPUT, ORATYPE_NUMBER
            
''' 削除は論理削除とする 2003.12.02 by FFCS
'            strStmt = "DELETE CTRPTPUBNOTE        " & vbLf & _
'                      " WHERE CTRPTCD = :CTRPTCD  " & vbLf & _
'                      "   AND SEQ     = :SEQ      "
            strStmt = "UPDATE CTRPTPUBNOTE        " & vbLf & _
                      "   SET DELFLG = 1          " & vbLf & _
                      " WHERE CTRPTCD = :CTRPTCD  " & vbLf & _
                      "   AND SEQ     = :SEQ      "
        Case Else
            Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
            Exit Function
    End Select
    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    

    '戻り値の設定
    DeletePubNote = 0

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

    DeletePubNote = -1

    'イベントログ書き込み
    WriteErrorLog "PubNote.DeletePubNote"
    
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
' 機能　　 : 指定ユーザに対して権限のあるノート分類の一覧を取得する
'
' 引数　　 : (In)     strUserId           ユーザＩＤ
' 　　　　   (Out)    vntPubNoteDivCd     受診情報ノート分類コード
' 　　　　   (Out)    vntPubNoteDivName   受診情報ノート分類名称
' 　　　　   (Out)    vntDefaultDispKbn   表示対象区分初期値
' 　　　　   (Out)    vntOnlyDispKbn      表示対象区分しばり
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectPubNoteDivList( _
    ByVal strUserId As String, _
    ByRef vntPubNoteDivCd As Variant, _
    ByRef vntPubNoteDivName As Variant, _
    ByRef vntDefaultDispKbn As Variant, _
    ByRef vntOnlyDispKbn As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objPubNoteDivCd     As OraField         '受診情報ノート分類コード
    Dim objPubNoteDivName   As OraField         '受診情報ノート分類名称
    Dim objDefaultDispKbn   As OraField         '表示対象区分初期値
    Dim objOnlyDispKbn      As OraField         '表示対象区分しばり

    Dim vntArrPubNoteDivCd()        As Variant          '受診情報ノート分類コード
    Dim vntArrPubNoteDivName()      As Variant          '受診情報ノート分類名称
    Dim vntArrDefaultDispKbn()      As Variant          '表示対象区分初期値
    Dim vntArrOnlyDispKbn()         As Variant          '表示対象区分しばり
    
    
    Dim lngCount            As Long             'レコード数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    lngCount = 0
    
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "USERID", Trim(strUserId), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '検索条件のレコードを取得
    strStmt = "SELECT PUBNOTEDIVVIEW.PUBNOTEDIVCD,   PUBNOTEDIVVIEW.PUBNOTEDIVNAME,                         " & vbLf & _
              "       PUBNOTEDIVVIEW.DEFAULTDISPKBN,                                                        " & vbLf & _
              "       PUBNOTEDIVVIEW.ONLYDISPKBN                                                            " & vbLf & _
              "  FROM (SELECT PUBNOTEDIV.PUBNOTEDIVCD,   PUBNOTEDIV.PUBNOTEDIVNAME,                         " & vbLf & _
              "               NVL(PUBNOTEDIV.DEFAULTDISPKBN, USERVIEW.DEFNOTEDISPKBN) DEFAULTDISPKBN,       " & vbLf & _
              "               PUBNOTEDIV.ONLYDISPKBN, USERVIEW.AUTHNOTE ,USERVIEW.DEFNOTEDISPKBN            " & vbLf & _
              "          FROM PUBNOTEDIV,                                                                   " & vbLf & _
              "              (SELECT AUTHNOTE, NVL(DEFNOTEDISPKBN, AUTHNOTE) DEFNOTEDISPKBN                 " & vbLf & _
              "                 FROM HAINSUSER                                                              " & vbLf & _
              "                WHERE USERID= :USERID) USERVIEW                                              " & vbLf & _
              "         WHERE (USERVIEW.AUTHNOTE = 1 AND (PUBNOTEDIV.ONLYDISPKBN = 1 OR PUBNOTEDIV.ONLYDISPKBN IS NULL)) " & vbLf & _
              "            OR (USERVIEW.AUTHNOTE = 2 AND (PUBNOTEDIV.ONLYDISPKBN = 2 OR PUBNOTEDIV.ONLYDISPKBN IS NULL)) " & vbLf & _
              "            OR (USERVIEW.AUTHNOTE = 3 )                                                      " & vbLf & _
              "        )PUBNOTEDIVVIEW                                                                      "
    
    
'### 2003/11/29 Added by Ishihara@FSIT ORDER BYを追加
    strStmt = strStmt & vbLf & _
          " ORDER BY PUBNOTEDIVVIEW.PUBNOTEDIVCD"
'### 2003/11/29 Added End
    
        'SQL文の実行
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objPubNoteDivCd = objFields("PUBNOTEDIVCD")
        Set objPubNoteDivName = objFields("PUBNOTEDIVNAME")
        Set objDefaultDispKbn = objFields("DEFAULTDISPKBN")
        Set objOnlyDispKbn = objFields("ONLYDISPKBN")
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrPubNoteDivCd(lngCount)
            ReDim Preserve vntArrPubNoteDivName(lngCount)
            ReDim Preserve vntArrDefaultDispKbn(lngCount)
            ReDim Preserve vntArrOnlyDispKbn(lngCount)
            
            vntArrPubNoteDivCd(lngCount) = objPubNoteDivCd.Value & ""
            vntArrPubNoteDivName(lngCount) = objPubNoteDivName.Value & ""
            vntArrDefaultDispKbn(lngCount) = objDefaultDispKbn.Value & ""
            vntArrOnlyDispKbn(lngCount) = objOnlyDispKbn.Value & ""
'MsgBox vntArrDefaultDispKbn(lngCount)
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        vntPubNoteDivCd = vntArrPubNoteDivCd
        vntPubNoteDivName = vntArrPubNoteDivName
        vntDefaultDispKbn = vntArrDefaultDispKbn
        vntOnlyDispKbn = vntArrOnlyDispKbn
    End If


    '戻り値の設定
    SelectPubNoteDivList = lngCount

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

    SelectPubNoteDivList = -1

    'イベントログ書き込み
    WriteErrorLog "PubNote.SelectPubNoteDivList"
    
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
' 機能　　 : ノート分類の一覧を取得する（マスタメンテナンス用）
'
' 引数　　 : (Out)    vntPubNoteDivCd     受診情報ノート分類コード
' 　　　　   (Out)    vntPubNoteDivName   受診情報ノート分類名称
' 　　　　   (Out)    vntDefaultDispKbn   表示対象区分初期値
' 　　　　   (Out)    vntOnlyDispKbn      表示対象区分しばり
'
' 戻り値　 : レコード件数
'
' 備考　　 :
'
Public Function SelectAllPubNoteDivList( _
    ByRef vntPubNoteDivCd As Variant, _
    ByRef vntPubNoteDivName As Variant, _
    ByRef vntDefaultDispKbn As Variant, _
    ByRef vntOnlyDispKbn As Variant _
) As Long

    Dim objOraParam                 As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna                  As OraDynaset       'ダイナセット
    Dim strStmt                     As String           'SQLステートメント

    Dim objFields                   As OraFields        'フィールドオブジェクト
    Dim objPubNoteDivCd             As OraField         '受診情報ノート分類コード
    Dim objPubNoteDivName           As OraField         '受診情報ノート分類名称
    Dim objDefaultDispKbn           As OraField         '表示対象区分初期値
    Dim objOnlyDispKbn              As OraField         '表示対象区分しばり

    Dim vntArrPubNoteDivCd()        As Variant          '受診情報ノート分類コード
    Dim vntArrPubNoteDivName()      As Variant          '受診情報ノート分類名称
    Dim vntArrDefaultDispKbn()      As Variant          '表示対象区分初期値
    Dim vntArrOnlyDispKbn()         As Variant          '表示対象区分しばり
    
    Dim lngCount            As Long             'レコード数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    lngCount = 0
    
    Set objOraParam = mobjOraDb.Parameters
    
    '検索条件のレコードを取得
    strStmt = " SELECT PUBNOTEDIV.PUBNOTEDIVCD,   PUBNOTEDIV.PUBNOTEDIVNAME, " & vbLf & _
              "        PUBNOTEDIV.DEFAULTDISPKBN, PUBNOTEDIV.ONLYDISPKBN     " & vbLf & _
              "   FROM PUBNOTEDIV                                            " & vbLf & _
              "  ORDER BY PUBNOTEDIV.PUBNOTEDIVCD                            "
    
    'SQL文の実行
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objPubNoteDivCd = objFields("PUBNOTEDIVCD")
        Set objPubNoteDivName = objFields("PUBNOTEDIVNAME")
        Set objDefaultDispKbn = objFields("DEFAULTDISPKBN")
        Set objOnlyDispKbn = objFields("ONLYDISPKBN")
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrPubNoteDivCd(lngCount)
            ReDim Preserve vntArrPubNoteDivName(lngCount)
            ReDim Preserve vntArrDefaultDispKbn(lngCount)
            ReDim Preserve vntArrOnlyDispKbn(lngCount)
            
            vntArrPubNoteDivCd(lngCount) = objPubNoteDivCd.Value & ""
            vntArrPubNoteDivName(lngCount) = objPubNoteDivName.Value & ""
            vntArrDefaultDispKbn(lngCount) = objDefaultDispKbn.Value & ""
            vntArrOnlyDispKbn(lngCount) = objOnlyDispKbn.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        
        Loop

        '戻り値の設定
        vntPubNoteDivCd = vntArrPubNoteDivCd
        vntPubNoteDivName = vntArrPubNoteDivName
        vntDefaultDispKbn = vntArrDefaultDispKbn
        vntOnlyDispKbn = vntArrOnlyDispKbn
    
    End If


    '戻り値の設定
    SelectAllPubNoteDivList = lngCount

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    SelectAllPubNoteDivList = -1

    'イベントログ書き込み
    WriteErrorLog "PubNote.SelectAllPubNoteDivList"
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function
'
' 機能　　 : ノート分類テーブルレコードを削除する
'
' 引数　　 : (In)    strPubNoteDivCd    ノート分類コード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeletePubNoteDiv(ByVal strPubNoteDivCd As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PubNoteDivCD", Trim(strPubNoteDivCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    'ノート分類テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE PubNoteDiv WHERE PubNoteDivCD = :PubNoteDivCD"
    
    'バインド変数の削除
    objOraParam.Remove "PubNoteDivCD"
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeletePubNoteDiv = True

    Exit Function
    
ErrorHandle:

    DeletePubNoteDiv = False

    'イベントログ書き込み
    WriteErrorLog "PubNoteDiv.DeletePubNoteDiv"
    
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
' 機能　　 : ノート分類テーブルレコードを登録する
'
' 引数　　 : (In)    strMode                登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strPubNoteDivCd        ノート分類コード
' 　　　　   (In)    vntPubNoteDivName      ノート分類名
' 　　　　   (In)    vntDefaultDispKbn      ノート分類略称
' 　　　　   (In)    strOnlyDispKbn         表示対象区分しばり
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistPubNoteDiv(ByVal strMode As String, _
                               ByVal strPubNoteDivCd As String, _
                               ByVal strPubNoteDivName As String, _
                               ByVal strDefaultDispKbn As String, _
                               ByVal strOnlyDispKbn As String) As Long

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント
    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PubNoteDivCD", Trim(strPubNoteDivCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "PubNoteDivNAME", Trim(strPubNoteDivName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "DefaultDispKbn", Trim(strDefaultDispKbn), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "OnlyDispKbn", Trim(strOnlyDispKbn), ORAPARM_INPUT, ORATYPE_VARCHAR2

    Do
        'ノート分類テーブルレコードの更新
        If strMode = "UPD" Then
            strStmt = "UPDATE PubNoteDiv " & _
                      "   SET PubNoteDivNAME = :PubNoteDivNAME," & _
                      "       DefaultDispKbn = :DefaultDispKbn," & _
                      "       OnlyDispKbn    = :OnlyDispKbn" & _
                      " WHERE PubNoteDivCD   = :PubNoteDivCD"
            Ret = mobjOraDb.ExecuteSQL(strStmt)
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たすノート分類テーブルのレコードを取得
        strStmt = "SELECT PubNoteDivCD FROM PubNoteDiv WHERE PubNoteDivCD = :PubNoteDivCD"
        Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
            
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
        mobjOraDb.ExecuteSQL "INSERT INTO PubNoteDiv (PubNoteDivCD, PubNoteDivNAME, DefaultDispKbn, OnlyDispKbn) VALUES (:PubNoteDivCD, :PubNoteDivNAME, :DefaultDispKbn, :OnlyDispKbn)"
        Ret = INSERT_NORMAL
    
        Exit Do
    Loop
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    RegistPubNoteDiv = Ret

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistPubNoteDiv = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "PubNoteDiv.RegistPubNoteDiv"
    
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
' 機能　　 : ノート分類コードに対するノート分類名を取得する
'
' 引数　　 : (In)     strPubNoteDivCd     ノート分類コード
' 　　　　 : (Out)    vntPubNoteDivName   ノート分類名
' 　　　　 : (Out)    vntDefaultDispKbn  ノート分類略称
' 　　　　 : (Out)    vntOnlyDispKbn            表示用順番
'
' 戻り値　 : True   正常終了
' 　　　　 : False  レコードなし、または異常終了
'
' 備考　　 :
'
Public Function SelectPubNoteDiv(ByVal strPubNoteDivCd As String, _
                               Optional ByRef vntPubNoteDivName As Variant, _
                               Optional ByRef vntDefaultDispKbn As Variant, _
                               Optional ByRef vntOnlyDispKbn As Variant _
                               ) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objPubNoteDivName   As OraField         'ノート分類名
    Dim objDefaultDispKbn   As OraField         'ノート分類略称
    Dim objOnlyDispKbn      As OraField         '表示対象区分しばり
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '検索条件が設定されていない場合は処理を終了する
    If Trim(strPubNoteDivCd) = "" Then
        Exit Function
    End If
        
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "PubNoteDivCD", Trim(strPubNoteDivCd), ORAPARM_INPUT
    
    '検索条件を満たすノート分類テーブルのレコードを取得
    strStmt = "SELECT PubNoteDivNAME, DefaultDispKbn, OnlyDispKbn FROM PubNoteDiv WHERE PubNoteDivCD = :PubNoteDivCD"
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objPubNoteDivName = objFields("PubNoteDivNAME")
        Set objDefaultDispKbn = objFields("DefaultDispKbn")
        Set objOnlyDispKbn = objFields("OnlyDispKbn")
    
        '戻り値の設定
        If IsMissing(vntPubNoteDivName) = False Then
            vntPubNoteDivName = objPubNoteDivName.Value
        End If
        If IsMissing(vntDefaultDispKbn) = False Then
            vntDefaultDispKbn = objDefaultDispKbn.Value
        End If
        If IsMissing(vntOnlyDispKbn) = False Then
            vntOnlyDispKbn = objOnlyDispKbn.Value
        End If
        
        SelectPubNoteDiv = True
        
    End If
    
    Set objOraDyna = Nothing
        
    'キー値の解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "PubNoteDiv.SelectPubNoteDiv"
    
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

    'オブジェクトコンテキストの解放
    Set mobjContext = Nothing

End Sub
