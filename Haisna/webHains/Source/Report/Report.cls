VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "Report"
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

Private mobjContext     As ObjectContext    'オブジェクトコンテキスト

Private mobjOraSession  As OraSessionClass  'OraSessionオブジェクト
Private mobjOraDb       As OraDatabase      'OraDatabaseオブジェクト

'モジュール名
Private Const MODULE_NAME As String = "WebHains.HainsReport"

'
' 機能　　 : 帳票テーブル情報を取得する
'
' 引数　　 : (Out)      vntReportCd           帳票コード
' 　　　　   (Out)      vntReportName         帳票名
' 　　　　   (In/Out)   vntReportFlg          報告書フラグ
' 　　　　   (Out)      vntDefaultPrinter     デフォルトプリンタ
' 　　　　   (Out)      vntPrtMachine         出力先
' 　　　　   (Out)      vntPreView            出力方法
' 　　　　   (Out)      vntHistoryPrint       過去歴検索方法
' 　　　　   (Out)      vntkarteFlg           カルテフラグ
' 　　　　   (Out)      vntViewOrder          表示順
' 　　　　   (Out)      blnSelectViewOrder    True時は表示順に従い取得
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
'#### 2012.12.14 SL-SN-Y0101-611 MOD START ####
'Public Function SelectReportList(ByRef vntReportCd As Variant,
'                                 ByRef vntReportName As Variant,
'                                 Optional ByRef vntReportFlg As Variant,
'                                 Optional ByRef vntDefaultPrinter As Variant,
'                                 Optional ByRef vntPrtMachine As Variant,
'                                 Optional ByRef vntPreView As Variant,
'                                 Optional ByRef vntHistoryPrint As Variant,
'                                 Optional ByRef vntKarteFlg As Variant
'                                ) As Long
Public Function SelectReportList(ByRef vntReportCd As Variant, _
                                 ByRef vntReportName As Variant, _
                                 Optional ByRef vntReportFlg As Variant, _
                                 Optional ByRef vntDefaultPrinter As Variant, _
                                 Optional ByRef vntPrtMachine As Variant, _
                                 Optional ByRef vntPreView As Variant, _
                                 Optional ByRef vntHistoryPrint As Variant, _
                                 Optional ByRef vntKarteFlg As Variant, _
                                 Optional ByRef vntViewOrder As Variant, _
                                 Optional ByVal blnSelectViewOrder As Boolean = False _
                                ) As Long
'#### 2012.12.14 SL-SN-Y0101-611 MOD END ####

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objReportCd             As OraField         '帳票コード
    Dim objReportName           As OraField         '帳票名
    Dim objDefaultPrinter       As OraField         'デフォルトプリンタ
    Dim objPrtMachine           As OraField         '出力先
    Dim objPreView              As OraField         '出力方法
    Dim objHistoryPrint         As OraField         '過去歴検索方法
    Dim objReportFlg            As OraField         '報告書フラグ
    Dim objKarteFlg             As OraField         'カルテフラグ
'#### 2012.12.14 SL-SN-Y0101-611 ADD START ####
    Dim objViewOrder            As OraField         '表示順
'#### 2012.12.14 SL-SN-Y0101-611 ADD END ####
    
    Dim vntArrReportCd()        As Variant          '帳票コードの配列
    Dim vntArrReportName()      As Variant          '帳票名の配列
    Dim vntArrDefaultPrinter()  As Variant          'デフォルトプリンタの配列
    Dim vntArrPrtMachine()      As Variant          '出力先の配列
    Dim vntArrPreView()         As Variant          '出力方法の配列
    Dim vntArrHistoryPrint()    As Variant          '過去歴検索方法の配列
    
    Dim vntArrReportFlg()       As Variant          '帳票フラグの配列
    Dim vntArrKarteFlg()        As Variant          'カルテフラグの配列
    
'#### 2012.12.14 SL-SN-Y0101-611 ADD START ####
    Dim vntArrViewOrder()       As Variant          '表示順の配列
'#### 2012.12.14 SL-SN-Y0101-611 ADD END ####
    
    Dim lngCount                As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntReportCd = Empty
    vntReportName = Empty
    
    If Not IsMissing(vntDefaultPrinter) Then
        vntDefaultPrinter = Empty
    End If
    
    If Not IsMissing(vntPrtMachine) Then
        vntPrtMachine = Empty
    End If
    
    If Not IsMissing(vntPreView) Then
        vntPreView = Empty
    End If
    
    If Not IsMissing(vntHistoryPrint) Then
        vntHistoryPrint = Empty
    End If

'#### 2012.12.14 SL-SN-Y0101-611 ADD START ####
    If Not IsMissing(vntViewOrder) Then
        vntViewOrder = Empty
    End If
'#### 2012.12.14 SL-SN-Y0101-611 ADD END ####
    
    lngCount = 0
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    
    If Not IsMissing(vntReportFlg) Then
'### 2002.11.12 Mod By H.Ishihara@FSIT リポートフラグはIn/Outにする。
'        objOraParam.Add "REPORTFLG", vntReportFlg, ORAPARM_INPUT, ORATYPE_NUMBER
        If Trim(vntReportFlg) <> "" Then
            objOraParam.Add "REPORTFLG", vntReportFlg, ORAPARM_INPUT, ORATYPE_NUMBER
        End If
'### 2002.11.12 Mod End
    End If

    '帳票テーブル情報を取得する
'### 2002.11.12 Mod By H.Ishihara@FSIT リポートフラグはIn/Outにする。
'    strStmt = "SELECT REPORTCD,   REPORTNAME, DEFAULTPRINTER, " & vbLf & _
              "       PRTMACHINE, PREVIEW,    HISTORYPRINT    " & vbLf & _
              "  FROM REPORT                                  "
'#### 2012.12.14 SL-SN-Y0101-611 MOD START ####
'    strStmt = "SELECT REPORTCD,   REPORTNAME, DEFAULTPRINTER, REPORTFLG, " & vbLf & _
'              "       PRTMACHINE, PREVIEW,    HISTORYPRINT,   KARTEFLG   " & vbLf & _
'              "  FROM REPORT "
    strStmt = "SELECT REPORTCD,   REPORTNAME, DEFAULTPRINTER, REPORTFLG, " & vbLf & _
              "       PRTMACHINE, PREVIEW,    HISTORYPRINT,   KARTEFLG,  " & vbLf & _
              "       VIEWORDER                                          " & vbLf & _
              "  FROM REPORT "
'#### 2012.12.14 SL-SN-Y0101-611 MOD END ####
'### 2002.11.12 Mod End
              
    '報告書フラグ指定時は条件節に追加
    If Not IsMissing(vntReportFlg) Then
'### 2002.11.12 Mod By H.Ishihara@FSIT リポートフラグはIn/Outにする。
'        strStmt = strStmt & vbLf & _
              " WHERE REPORTFLG = :REPORTFLG "
        If Trim(vntReportFlg) <> "" Then
            strStmt = strStmt & vbLf & _
                  " WHERE REPORTFLG = :REPORTFLG "
        End If
'### 2002.11.12 Mod By H.Ishihara@FSIT リポートフラグはIn/Outにする。
    End If
              
              
''    '帳票コードの昇順に取得
''    strStmt = strStmt & vbLf & _
''              " ORDER BY REPORTCD"

'#### 2012.12.14 SL-SN-Y0101-611 MOD START ####
'''## 2007.04.14　修正：新しいファイルを上に表示する。
'    '帳票コードの昇順に取得
'    strStmt = strStmt & vbLf & _
'              " ORDER BY FEDFILE  "
    '表示順指定時は報告書フラグの降順、表示順の昇順、帳票コードの昇順に取得。さもなくば帳票ファイル名１の昇順に取得。
    If blnSelectViewOrder Then
        strStmt = strStmt & vbLf & _
                  "ORDER BY REPORTFLG DESC, VIEWORDER, REPORTCD"
    Else
        strStmt = strStmt & vbLf & _
                  " ORDER BY FEDFILE  "
    End If
'#### 2012.12.14 SL-SN-Y0101-611 MOD END ####
              
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objReportCd = objFields("REPORTCD")
        Set objReportName = objFields("REPORTNAME")
        Set objDefaultPrinter = objFields("DEFAULTPRINTER")
        Set objPrtMachine = objFields("PRTMACHINE")
        Set objPreView = objFields("PREVIEW")
        Set objHistoryPrint = objFields("HISTORYPRINT")
        Set objKarteFlg = objFields("KARTEFLG")
        Set objReportFlg = objFields("REPORTFLG")
'#### 2012.12.14 SL-SN-Y0101-611 ADD START ####
        Set objViewOrder = objFields("VIEWORDER")
'#### 2012.12.14 SL-SN-Y0101-611 ADD END ####
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrReportCd(lngCount)
            ReDim Preserve vntArrReportName(lngCount)
            ReDim Preserve vntArrDefaultPrinter(lngCount)
            ReDim Preserve vntArrPrtMachine(lngCount)
            ReDim Preserve vntArrPreView(lngCount)
            ReDim Preserve vntArrHistoryPrint(lngCount)
            ReDim Preserve vntArrReportFlg(lngCount)
            ReDim Preserve vntArrKarteFlg(lngCount)
'#### 2012.12.14 SL-SN-Y0101-611 ADD START ####
            ReDim Preserve vntArrViewOrder(lngCount)
'#### 2012.12.14 SL-SN-Y0101-611 ADD END ####
            vntArrReportCd(lngCount) = objReportCd.Value & ""
            vntArrReportName(lngCount) = objReportName.Value & ""
            vntArrDefaultPrinter(lngCount) = objDefaultPrinter.Value & ""
            vntArrPrtMachine(lngCount) = objPrtMachine.Value & ""
            vntArrPreView(lngCount) = objPreView.Value & ""
            vntArrHistoryPrint(lngCount) = objHistoryPrint.Value & ""
            vntArrReportFlg(lngCount) = objReportFlg.Value & ""
            vntArrKarteFlg(lngCount) = objKarteFlg.Value & ""
'#### 2012.12.14 SL-SN-Y0101-611 ADD START ####
            vntArrViewOrder(lngCount) = objViewOrder.Value & ""
'#### 2012.12.14 SL-SN-Y0101-611 ADD END ####
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If

    'バインド変数の削除
    objOraParam.Remove "REPORTFLG"
    
    '戻り値の設定
    vntReportCd = vntArrReportCd
    vntReportName = vntArrReportName
    
    If Not IsMissing(vntDefaultPrinter) Then
        vntDefaultPrinter = vntArrDefaultPrinter
    End If
    
    If Not IsMissing(vntPrtMachine) Then
        vntPrtMachine = vntArrPrtMachine
    End If
    
    If Not IsMissing(vntPreView) Then
        vntPreView = vntArrPreView
    End If

    If Not IsMissing(vntHistoryPrint) Then
        vntHistoryPrint = vntArrHistoryPrint
    End If

    If Not IsMissing(vntKarteFlg) Then
        vntKarteFlg = vntArrKarteFlg
    End If

    If Not IsMissing(vntReportFlg) Then
        If Trim(vntReportFlg) = "" Then
            vntReportFlg = vntArrReportFlg
        End If
    End If

'#### 2012.12.14 SL-SN-Y0101-611 ADD START ####
    If Not IsMissing(vntViewOrder) Then
        vntViewOrder = vntArrViewOrder
    End If
'#### 2012.12.14 SL-SN-Y0101-611 ADD END ####

    'トランザクションをコミット
    mobjContext.SetComplete

    '戻り値の設定
    SelectReportList = lngCount
        
    Exit Function
    
ErrorHandle:

    SelectReportList = -1

    'イベントログ書き込み
    WriteErrorLog "Report.SelectReportList"

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, "Report.SelectReportList", Err.Description
    
End Function

'
' 機能　　 : 帳票テーブル情報を取得する
'
' 引数　　 : (Out)      vntReportCd           帳票コード
' 　　　　   (Out)      vntReportName         帳票名
' 　　　　   (In)       vntkarteFlg           カルテフラグ
' 　　　　   (Out)      vntReportFlg          報告書フラグ
' 　　　　   (Out)      vntDefaultPrinter     デフォルトプリンタ
' 　　　　   (Out)      vntPrtMachine         出力先
' 　　　　   (Out)      vntPreView            出力方法
' 　　　　   (Out)      vntHistoryPrint       過去歴検索方法
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectReportList2(ByRef vntReportCd As Variant, _
                                  ByRef vntReportName As Variant, _
                                  Optional ByVal vntKarteFlg As Variant, _
                                  Optional ByRef vntReportFlg As Variant, _
                                  Optional ByRef vntDefaultPrinter As Variant, _
                                  Optional ByRef vntPrtMachine As Variant, _
                                  Optional ByRef vntPreView As Variant, _
                                  Optional ByRef vntHistoryPrint As Variant _
                                 ) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objReportCd             As OraField         '帳票コード
    Dim objReportName           As OraField         '帳票名
    Dim objDefaultPrinter       As OraField         'デフォルトプリンタ
    Dim objPrtMachine           As OraField         '出力先
    Dim objPreView              As OraField         '出力方法
    Dim objHistoryPrint         As OraField         '過去歴検索方法
    Dim objReportFlg            As OraField         '報告書フラグ
    Dim objKarteFlg             As OraField         'カルテフラグ
    
    Dim vntArrReportCd()        As Variant          '帳票コードの配列
    Dim vntArrReportName()      As Variant          '帳票名の配列
    Dim vntArrDefaultPrinter()  As Variant          'デフォルトプリンタの配列
    Dim vntArrPrtMachine()      As Variant          '出力先の配列
    Dim vntArrPreView()         As Variant          '出力方法の配列
    Dim vntArrHistoryPrint()    As Variant          '過去歴検索方法の配列
    
    Dim vntArrReportFlg()       As Variant          '帳票フラグの配列
    Dim vntArrKarteFlg()        As Variant          'カルテフラグの配列
    
    Dim lngCount                As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntReportCd = Empty
    vntReportName = Empty
    
    If Not IsMissing(vntDefaultPrinter) Then
        vntDefaultPrinter = Empty
    End If
    
    If Not IsMissing(vntPrtMachine) Then
        vntPrtMachine = Empty
    End If
    
    If Not IsMissing(vntPreView) Then
        vntPreView = Empty
    End If
    
    If Not IsMissing(vntHistoryPrint) Then
        vntHistoryPrint = Empty
    End If
    
    lngCount = 0
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    
    If Not IsMissing(vntKarteFlg) Then
        If Trim(vntKarteFlg) <> "" Then
            objOraParam.Add "KARTEFLG", vntKarteFlg, ORAPARM_INPUT, ORATYPE_NUMBER
        End If
    End If

    '帳票テーブル情報を取得する
    strStmt = "SELECT REPORTCD,   REPORTNAME, DEFAULTPRINTER, REPORTFLG, " & vbLf & _
              "       PRTMACHINE, PREVIEW,    HISTORYPRINT,   KARTEFLG   " & vbLf & _
              "  FROM REPORT "
              
    '報告書フラグ指定時は条件節に追加
    If Not IsMissing(vntKarteFlg) Then
        If Trim(vntKarteFlg) <> "" Then
            strStmt = strStmt & vbLf & _
                  " WHERE KARTEFLG = :KARTEFLG "
        End If
    End If
              
    '帳票コードの昇順に取得
    strStmt = strStmt & vbLf & _
              " ORDER BY REPORTCD"
              
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objReportCd = objFields("REPORTCD")
        Set objReportName = objFields("REPORTNAME")
        Set objDefaultPrinter = objFields("DEFAULTPRINTER")
        Set objPrtMachine = objFields("PRTMACHINE")
        Set objPreView = objFields("PREVIEW")
        Set objHistoryPrint = objFields("HISTORYPRINT")
        Set objKarteFlg = objFields("KARTEFLG")
        Set objReportFlg = objFields("REPORTFLG")
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrReportCd(lngCount)
            ReDim Preserve vntArrReportName(lngCount)
            ReDim Preserve vntArrDefaultPrinter(lngCount)
            ReDim Preserve vntArrPrtMachine(lngCount)
            ReDim Preserve vntArrPreView(lngCount)
            ReDim Preserve vntArrHistoryPrint(lngCount)
            ReDim Preserve vntArrReportFlg(lngCount)
            ReDim Preserve vntArrKarteFlg(lngCount)
            vntArrReportCd(lngCount) = objReportCd.Value & ""
            vntArrReportName(lngCount) = objReportName.Value & ""
            vntArrDefaultPrinter(lngCount) = objDefaultPrinter.Value & ""
            vntArrPrtMachine(lngCount) = objPrtMachine.Value & ""
            vntArrPreView(lngCount) = objPreView.Value & ""
            vntArrHistoryPrint(lngCount) = objHistoryPrint.Value & ""
            vntArrReportFlg(lngCount) = objReportFlg.Value & ""
            vntArrKarteFlg(lngCount) = objKarteFlg.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If

    'バインド変数の削除
    objOraParam.Remove "KARTEFLG"
    
    '戻り値の設定
    vntReportCd = vntArrReportCd
    vntReportName = vntArrReportName
    
    If Not IsMissing(vntDefaultPrinter) Then
        vntDefaultPrinter = vntArrDefaultPrinter
    End If
    
    If Not IsMissing(vntPrtMachine) Then
        vntPrtMachine = vntArrPrtMachine
    End If
    
    If Not IsMissing(vntPreView) Then
        vntPreView = vntArrPreView
    End If

    If Not IsMissing(vntHistoryPrint) Then
        vntHistoryPrint = vntArrHistoryPrint
    End If

    If Not IsMissing(vntReportFlg) Then
        vntReportFlg = vntArrReportFlg
    End If

    If Not IsMissing(vntKarteFlg) Then
        If Trim(vntKarteFlg) = "" Then
            vntKarteFlg = vntArrKarteFlg
        End If
    End If

    'トランザクションをコミット
    mobjContext.SetComplete

    '戻り値の設定
    SelectReportList2 = lngCount
        
    Exit Function
    
ErrorHandle:

    SelectReportList2 = -1

    'イベントログ書き込み
    WriteErrorLog "Report.SelectReportList"

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, "Report.SelectReportList", Err.Description
    
End Function

'
' 機能　　 : 印刷設定テーブル読み込み
'
' 引数　　 : (In)     strReportCd           帳票コード
' 　　　　 : (Out)    vntReportName         帳票名
' 　　　　 : (Out)    vntPaperSize          用紙サイズ   0-9
' 　　　　 : (Out)    vntOrientation        用紙方向   1,2 1:ポートレイト、2:ランドスケープ
' 　　　　 : (Out)    vntDefaultPrinter     デフォルトプリンタ
' 　　　　 : (Out)    vntPrtMachine         出力先  0,1 0:クライアント、1:サーバ
' 　　　　 : (Out)    vntPreView            出力方法   0,1 0:プレビュー、1:直接出力
' 　　　　 : (Out)    vntFedFile            帳票ファイル名
' 　　　　 : (Out)    vntCopyCount          部数
' 　　　　 : (Out)    vntFedFile2           帳票ファイル名２
' 　　　　 : (Out)    vntFedFile3           帳票ファイル名３
' 　　　　 : (Out)    vntFedFile4           帳票ファイル名４
' 　　　　 : (Out)    vntFedFile5           帳票ファイル名５
' 　　　　 : (Out)    vntReportFlg          報告書フラグ
' 　　　　 : (Out)    vntHistoryPrint       過去歴印刷
' 　　　　 : (Out)    vntKarteFlg           カルテフラグ
' 　　　　 : (Out)    vntViewOrder          表示順
'
' 戻り値　 :  True　                        データあり
' 　　　　 :  False　                       データなし
'
' 備考　　 :
'
'#### 2010.06.15 SL-UI-Y0101-116 MOD START ####'
''''## 2008.02.08 張 帳票ファイル７列追加のため修正（既存帳票ファイル６分についても対応）Start
''''Public Function SelectReport(ByVal strReportCd As String, _
''''                             ByRef vntReportName As Variant, _
''''                             ByRef vntPaperSize As Variant, _
''''                             ByRef vntOrientation As Variant, _
''''                             ByRef vntDefaultPrinter As Variant, _
''''                             ByRef vntPrtMachine As Variant, _
''''                             ByRef vntPreView As Variant, _
''''                             ByRef vntFedFile As Variant, _
''''                             ByRef vntCopyCount As Variant, _
''''                             Optional ByRef vntFedFile2 As Variant, _
''''                             Optional ByRef vntFedFile3 As Variant, _
''''                             Optional ByRef vntFedFile4 As Variant, _
''''                             Optional ByRef vntFedFile5 As Variant, _
''''                             Optional ByRef vntReportFlg As Variant, _
''''                             Optional ByRef vntHistoryPrint As Variant, _
''''                             Optional ByRef vntKarteFlg As Variant) As Boolean
'''Public Function SelectReport(ByVal strReportCd As String, _
'''                             ByRef vntReportName As Variant, _
'''                             ByRef vntPaperSize As Variant, _
'''                             ByRef vntOrientation As Variant, _
'''                             ByRef vntDefaultPrinter As Variant, _
'''                             ByRef vntPrtMachine As Variant, _
'''                             ByRef vntPreView As Variant, _
'''                             ByRef vntFedFile As Variant, _
'''                             ByRef vntCopyCount As Variant, _
'''                             Optional ByRef vntFedFile2 As Variant, _
'''                             Optional ByRef vntFedFile3 As Variant, _
'''                             Optional ByRef vntFedFile4 As Variant, _
'''                             Optional ByRef vntFedFile5 As Variant, _
'''                             Optional ByRef vntFedFile6 As Variant, _
'''                             Optional ByRef vntFedFile7 As Variant, _
'''                             Optional ByRef vntReportFlg As Variant, _
'''                             Optional ByRef vntHistoryPrint As Variant, _
'''                             Optional ByRef vntKarteFlg As Variant) As Boolean
''''## 2008.02.08 張 帳票ファイル７列追加のため修正（既存帳票ファイル６分についても対応）End
'#### 2012.12.14 SL-SN-Y0101-611 ADD START ####
'Public Function SelectReport(ByVal strReportCd As String _
'                           , ByRef vntReportName As Variant _
'                           , ByRef vntPaperSize As Variant _
'                           , ByRef vntOrientation As Variant _
'                           , ByRef vntDefaultPrinter As Variant _
'                           , ByRef vntPrtMachine As Variant _
'                           , ByRef vntPreView As Variant _
'                           , ByRef vntFedFile As Variant _
'                           , ByRef vntCopyCount As Variant _
'                           , Optional ByRef vntFedFile2 As Variant _
'                           , Optional ByRef vntFedFile3 As Variant _
'                           , Optional ByRef vntFedFile4 As Variant _
'                           , Optional ByRef vntFedFile5 As Variant _
'                           , Optional ByRef vntFedFile6 As Variant _
'                           , Optional ByRef vntFedFile7 As Variant _
'                           , Optional ByRef vntReportFlg As Variant _
'                           , Optional ByRef vntHistoryPrint As Variant _
'                           , Optional ByRef vntKarteFlg As Variant _
'                           , Optional ByRef vntFedFile8 As Variant _
'                           , Optional ByRef vntFedFile9 As Variant _
'                           , Optional ByRef vntFedFile10 As Variant _
'                             ) As Boolean
Public Function SelectReport(ByVal strReportCd As String _
                           , ByRef vntReportName As Variant _
                           , ByRef vntPaperSize As Variant _
                           , ByRef vntOrientation As Variant _
                           , ByRef vntDefaultPrinter As Variant _
                           , ByRef vntPrtMachine As Variant _
                           , ByRef vntPreView As Variant _
                           , ByRef vntFedFile As Variant _
                           , ByRef vntCopyCount As Variant _
                           , Optional ByRef vntFedFile2 As Variant _
                           , Optional ByRef vntFedFile3 As Variant _
                           , Optional ByRef vntFedFile4 As Variant _
                           , Optional ByRef vntFedFile5 As Variant _
                           , Optional ByRef vntFedFile6 As Variant _
                           , Optional ByRef vntFedFile7 As Variant _
                           , Optional ByRef vntReportFlg As Variant _
                           , Optional ByRef vntHistoryPrint As Variant _
                           , Optional ByRef vntKarteFlg As Variant _
                           , Optional ByRef vntFedFile8 As Variant _
                           , Optional ByRef vntFedFile9 As Variant _
                           , Optional ByRef vntFedFile10 As Variant _
                           , Optional ByRef vntViewOrder As Variant _
                             ) As Boolean
'#### 2012.12.14 SL-SN-Y0101-611 ADD END ####
'#### 2010.06.15 SL-UI-Y0101-116 MOD END ####'


    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    
    Dim objReportName       As OraField         '帳票名
    Dim objPaperSize        As OraField         '用紙サイズ   0-9
    Dim objOrientation      As OraField         '用紙方向   1,2 1:ポートレイト、2:ランドスケープ
    Dim objDefaultPrinter   As OraField         'デフォルトプリンタ
    Dim objPrtMachine       As OraField         '出力先  0,1 0:クライアント、1:サーバ
    Dim objPreView          As OraField         '出力方法     0,1 0:プレビュー、1:直接出力
    Dim objFedFile          As OraField         '帳票ファイル名1
    Dim objCopyCount        As OraField         '部数
    Dim objFedFile2         As OraField         '帳票ファイル名2
    Dim objFedFile3         As OraField         '帳票ファイル名3
    Dim objFedFile4         As OraField         '帳票ファイル名4
    Dim objFedFile5         As OraField         '帳票ファイル名5
'## 2008.02.08 張 帳票ファイル７列追加のため修正（既存帳票ファイル６分についても対応）Start
    Dim objFedFile6         As OraField         '帳票ファイル名5
    Dim objFedFile7         As OraField         '帳票ファイル名5
'#### 2010.06.15 SL-UI-Y0101-116 ADD START ####'
    Dim objFedFile8         As OraField         '帳票ファイル名8
    Dim objFedFile9         As OraField         '帳票ファイル名9
    Dim objFedFile10        As OraField         '帳票ファイル名10
'#### 2010.06.15 SL-UI-Y0101-116 ADD END ####'
'## 2008.02.08 張 帳票ファイル７列追加のため修正（既存帳票ファイル６分についても対応）End
    Dim objReportFlg        As OraField         '報告書フラグ
    Dim objHistoryPrint     As OraField         '過去歴印刷
'## 2002.11.10 Add 1Line By H.Ishihara@FSIT カルテフラグの追加
    Dim objKarteFlg         As OraField         'カルテフラグ
'## 2002.11.10 Add End
'#### 2012.12.14 SL-SN-Y0101-611 ADD START ####
    Dim objViewOrder        As OraField         '表示順
'#### 2012.12.14 SL-SN-Y0101-611 ADD END ####
    
    SelectReport = True
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "REPORTCD", Trim(strReportCd), ORAPARM_INPUT
    
    Do
        'テーブルデータから取得
        strStmt = ""
        strStmt = strStmt & "SELECT REPORTNAME, PAPERSIZE, ORIENTATION, DEFAULTPRINTER,"
        strStmt = strStmt & "       PRTMACHINE, PREVIEW,   FEDFILE, FEDFILE2, FEDFILE3,"
'## 2008.02.08 張 帳票ファイル７列追加のため修正（既存帳票ファイル６分についても対応）Start
'        strStmt = strStmt & "       FEDFILE4, FEDFILE5, REPORTFLG, HISTORYPRINT,"
        strStmt = strStmt & "       FEDFILE4, FEDFILE5, FEDFILE6, FEDFILE7, REPORTFLG, HISTORYPRINT,"
'## 2008.02.08 張 帳票ファイル７列追加のため修正（既存帳票ファイル６分についても対応）End

'## 2002.11.10 Mod 1Line By H.Ishihara@FSIT カルテフラグの追加
'        strStmt = strStmt & "       COPYCOUNT"
        strStmt = strStmt & "       COPYCOUNT, KARTEFLG"
'## 2002.11.10 Mod End
'#### 2010.06.15 SL-UI-Y0101-116 ADD START ####'
        strStmt = strStmt & "      ,FEDFILE8, FEDFILE9, FEDFILE10 "
'#### 2010.06.15 SL-UI-Y0101-116 ADD END ####'
'#### 2012.12.14 SL-SN-Y0101-611 ADD START ####
        strStmt = strStmt & "      ,VIEWORDER "
'#### 2012.12.14 SL-SN-Y0101-611 ADD END ####
        strStmt = strStmt & "  FROM REPORT"
        strStmt = strStmt & " WHERE REPORTCD   = :REPORTCD"

        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
        If objOraDyna.EOF Then
            SelectReport = False
            Exit Do
        End If
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        
        Set objReportName = objFields("REPORTNAME")
        Set objPaperSize = objFields("PAPERSIZE")
        Set objOrientation = objFields("ORIENTATION")
        Set objDefaultPrinter = objFields("DEFAULTPRINTER")
        Set objPrtMachine = objFields("PRTMACHINE")
        Set objPreView = objFields("PREVIEW")
        Set objFedFile = objFields("FEDFILE")
        Set objCopyCount = objFields("COPYCOUNT")
        Set objFedFile2 = objFields("FEDFILE2")
        Set objFedFile3 = objFields("FEDFILE3")
        Set objFedFile4 = objFields("FEDFILE4")
        Set objFedFile5 = objFields("FEDFILE5")
'## 2008.02.08 張 帳票ファイル７列追加のため修正（既存帳票ファイル６分についても対応）Start
        Set objFedFile6 = objFields("FEDFILE6")
        Set objFedFile7 = objFields("FEDFILE7")
'## 2008.02.08 張 帳票ファイル７列追加のため修正（既存帳票ファイル６分についても対応）End
'#### 2010.06.15 SL-UI-Y0101-116 ADD START ####'
        Set objFedFile8 = objFields("FEDFILE8")
        Set objFedFile9 = objFields("FEDFILE9")
        Set objFedFile10 = objFields("FEDFILE10")
'#### 2010.06.15 SL-UI-Y0101-116 ADD END ####'
        Set objReportFlg = objFields("REPORTFLG")
        Set objHistoryPrint = objFields("HISTORYPRINT")
'## 2002.11.10 Add 1Line By H.Ishihara@FSIT カルテフラグの追加
        Set objKarteFlg = objFields("KARTEFLG")
'## 2002.11.10 Add End
'#### 2012.12.14 SL-SN-Y0101-611 ADD START ####
        Set objViewOrder = objFields("VIEWORDER")
'#### 2012.12.14 SL-SN-Y0101-611 ADD END ####
        
        'データの編集
        vntReportName = objReportName.Value & ""
        vntPaperSize = objPaperSize.Value & ""
        vntOrientation = objOrientation.Value & ""
        vntDefaultPrinter = objDefaultPrinter.Value & ""
        vntPrtMachine = objPrtMachine.Value & ""
        vntPreView = objPreView.Value & ""
        vntFedFile = objFedFile.Value & ""
        vntCopyCount = objCopyCount.Value & ""
        If Not IsMissing(vntFedFile2) Then vntFedFile2 = objFedFile2.Value & ""
        If Not IsMissing(vntFedFile3) Then vntFedFile3 = objFedFile3.Value & ""
        If Not IsMissing(vntFedFile4) Then vntFedFile4 = objFedFile4.Value & ""
        If Not IsMissing(vntFedFile5) Then vntFedFile5 = objFedFile5.Value & ""
'## 2008.02.08 張 帳票ファイル７列追加のため修正（既存帳票ファイル６分についても対応）Start
        If Not IsMissing(vntFedFile6) Then vntFedFile6 = objFedFile6.Value & ""
        If Not IsMissing(vntFedFile7) Then vntFedFile7 = objFedFile7.Value & ""
'## 2008.02.08 張 帳票ファイル７列追加のため修正（既存帳票ファイル６分についても対応）End
'#### 2010.06.15 SL-UI-Y0101-116 ADD START ####'
        If Not IsMissing(vntFedFile8) Then vntFedFile8 = objFedFile8.Value & ""
        If Not IsMissing(vntFedFile9) Then vntFedFile9 = objFedFile9.Value & ""
        If Not IsMissing(vntFedFile10) Then vntFedFile10 = objFedFile10.Value & ""
'#### 2010.06.15 SL-UI-Y0101-116 ADD END ####'
        If Not IsMissing(vntReportFlg) Then vntReportFlg = objReportFlg.Value & ""
        If Not IsMissing(vntHistoryPrint) Then vntHistoryPrint = objHistoryPrint.Value & ""
'## 2002.11.10 Add 1Line By H.Ishihara@FSIT カルテフラグの追加
        If Not IsMissing(vntKarteFlg) Then vntKarteFlg = objKarteFlg.Value & ""
'## 2002.11.10 Add End
'#### 2012.12.14 SL-SN-Y0101-611 ADD START ####
        If Not IsMissing(vntViewOrder) Then vntViewOrder = objViewOrder.Value & ""
'#### 2012.12.14 SL-SN-Y0101-611 ADD END ####
        
        Exit Do
    
    Loop
    
    Do Until objOraParam.Count < 1
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Report.SelectReport"
    
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

    SelectReport = False
    
End Function

'
' 機能　　 : 帳票管理テーブル読み込み
'
' 引数　　 : (In)     strReportCd        帳票コード
' 　　　　   (Out)    vntReportName      帳票名
' 　　　　   (Out)    vntDefaultPrinter  デフォルトプリンタ
' 　　　　   (Out)    vntReportFlg       報告書フラグ
' 　　　　   (Out)    vntHistoryPrint    過去歴印刷
' 　　　　   (Out)    vntCopyCount       部数
' 　　　　   (Out)    vntFedFile         帳票ファイル名1
' 　　　　   (Out)    vntFedFile2        帳票ファイル名2
' 　　　　   (Out)    vntFedFile3        帳票ファイル名3
' 　　　　   (Out)    vntFedFile4        帳票ファイル名4
' 　　　　   (Out)    vntFedFile5        帳票ファイル名5
'
' 戻り値　 :  True   データあり
' 　　　　    False  データなし
'
' 備考　　 :
'
Public Function SelectReport2( _
    ByVal strReportCd As String, _
    Optional ByRef vntReportName As Variant, _
    Optional ByRef vntDefaultPrinter As Variant, _
    Optional ByRef vntReportFlg As Variant, _
    Optional ByRef vntHistoryPrint As Variant, _
    Optional ByRef vntCopyCount As Variant, _
    Optional ByRef vntFedFile As Variant, _
    Optional ByRef vntFedFile2 As Variant, _
    Optional ByRef vntFedFile3 As Variant, _
    Optional ByRef vntFedFile4 As Variant, _
    Optional ByRef vntFedFile5 As Variant _
) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    
    Dim objReportName       As OraField         '帳票名
    Dim objDefaultPrinter   As OraField         'デフォルトプリンタ
    Dim objReportFlg        As OraField         '報告書フラグ
    Dim objHistoryPrint     As OraField         '過去歴印刷
    Dim objCopyCount        As OraField         '部数
    Dim objFedFile          As OraField         '帳票ファイル名1
    Dim objFedFile2         As OraField         '帳票ファイル名2
    Dim objFedFile3         As OraField         '帳票ファイル名3
    Dim objFedFile4         As OraField         '帳票ファイル名4
    Dim objFedFile5         As OraField         '帳票ファイル名5
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntReportName) Then vntReportName = Empty
    If Not IsMissing(vntDefaultPrinter) Then vntDefaultPrinter = Empty
    If Not IsMissing(vntReportFlg) Then vntReportFlg = Empty
    If Not IsMissing(vntHistoryPrint) Then vntHistoryPrint = Empty
    If Not IsMissing(vntCopyCount) Then vntCopyCount = Empty
    If Not IsMissing(vntFedFile) Then vntFedFile = Empty
    If Not IsMissing(vntFedFile2) Then vntFedFile2 = Empty
    If Not IsMissing(vntFedFile3) Then vntFedFile3 = Empty
    If Not IsMissing(vntFedFile4) Then vntFedFile4 = Empty
    If Not IsMissing(vntFedFile5) Then vntFedFile5 = Empty
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "REPORTCD", Trim(strReportCd), ORAPARM_INPUT
    
    '指定帳票コードの帳票情報を取得
    strStmt = "SELECT REPORTNAME, PAPERSIZE,    ORIENTATION, DEFAULTPRINTER, PRTMACHINE, PREVIEW, " & vbLf & _
              "       FEDFILE,    FEDFILE2,     FEDFILE3,    FEDFILE4,       FEDFILE5,            " & vbLf & _
              "       REPORTFLG,  HISTORYPRINT, COPYCOUNT                                         " & vbLf & _
              "  FROM REPORT                                                                      " & vbLf & _
              " WHERE REPORTCD = :REPORTCD                                                        "

    'SQL実行
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objReportName = objFields("REPORTNAME")
        Set objDefaultPrinter = objFields("DEFAULTPRINTER")
        Set objReportFlg = objFields("REPORTFLG")
        Set objHistoryPrint = objFields("HISTORYPRINT")
        Set objCopyCount = objFields("COPYCOUNT")
        Set objFedFile = objFields("FEDFILE")
        Set objFedFile2 = objFields("FEDFILE2")
        Set objFedFile3 = objFields("FEDFILE3")
        Set objFedFile4 = objFields("FEDFILE4")
        Set objFedFile5 = objFields("FEDFILE5")
        
        '戻り値の設定
        If Not IsMissing(vntReportName) Then vntReportName = objReportName.Value & ""
        If Not IsMissing(vntDefaultPrinter) Then vntDefaultPrinter = objDefaultPrinter.Value & ""
        If Not IsMissing(vntReportFlg) Then vntReportFlg = objReportFlg.Value & ""
        If Not IsMissing(vntHistoryPrint) Then vntHistoryPrint = objHistoryPrint.Value & ""
        If Not IsMissing(vntCopyCount) Then vntCopyCount = objCopyCount.Value & ""
        If Not IsMissing(vntFedFile) Then vntFedFile = objFedFile.Value & ""
        If Not IsMissing(vntFedFile2) Then vntFedFile2 = objFedFile2.Value & ""
        If Not IsMissing(vntFedFile3) Then vntFedFile3 = objFedFile3.Value & ""
        If Not IsMissing(vntFedFile4) Then vntFedFile4 = objFedFile4.Value & ""
        If Not IsMissing(vntFedFile5) Then vntFedFile5 = objFedFile5.Value & ""
        
        SelectReport2 = True
        
    End If
    
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
    WriteErrorLog "Report.SelectReport2"
    
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

'## 2003.12.24 Add By R.Terui@TCS ６枚綴り帳票に対応
'
' 機能　　 : 帳票管理テーブル読み込み
'
' 引数　　 : (In)     strReportCd        帳票コード
' 　　　　   (Out)    vntReportName      帳票名
' 　　　　   (Out)    vntDefaultPrinter  デフォルトプリンタ
' 　　　　   (Out)    vntReportFlg       報告書フラグ
' 　　　　   (Out)    vntHistoryPrint    過去歴印刷
' 　　　　   (Out)    vntCopyCount       部数
' 　　　　   (Out)    vntFedFile         帳票ファイル名1
' 　　　　   (Out)    vntFedFile2        帳票ファイル名2
' 　　　　   (Out)    vntFedFile3        帳票ファイル名3
' 　　　　   (Out)    vntFedFile4        帳票ファイル名4
' 　　　　   (Out)    vntFedFile5        帳票ファイル名5
' 　　　　   (Out)    vntFedFile6        帳票ファイル名6
'
' 戻り値　 :  True   データあり
' 　　　　    False  データなし
'
' 備考　　 :
'
Public Function SelectReport3( _
    ByVal strReportCd As String, _
    Optional ByRef vntReportName As Variant, _
    Optional ByRef vntDefaultPrinter As Variant, _
    Optional ByRef vntReportFlg As Variant, _
    Optional ByRef vntHistoryPrint As Variant, _
    Optional ByRef vntCopyCount As Variant, _
    Optional ByRef vntFedFile As Variant, _
    Optional ByRef vntFedFile2 As Variant, _
    Optional ByRef vntFedFile3 As Variant, _
    Optional ByRef vntFedFile4 As Variant, _
    Optional ByRef vntFedFile5 As Variant, _
    Optional ByRef vntFedFile6 As Variant _
) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    
    Dim objReportName       As OraField         '帳票名
    Dim objDefaultPrinter   As OraField         'デフォルトプリンタ
    Dim objReportFlg        As OraField         '報告書フラグ
    Dim objHistoryPrint     As OraField         '過去歴印刷
    Dim objCopyCount        As OraField         '部数
    Dim objFedFile          As OraField         '帳票ファイル名1
    Dim objFedFile2         As OraField         '帳票ファイル名2
    Dim objFedFile3         As OraField         '帳票ファイル名3
    Dim objFedFile4         As OraField         '帳票ファイル名4
    Dim objFedFile5         As OraField         '帳票ファイル名5
    Dim objFedFile6         As OraField         '帳票ファイル名6
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntReportName) Then vntReportName = Empty
    If Not IsMissing(vntDefaultPrinter) Then vntDefaultPrinter = Empty
    If Not IsMissing(vntReportFlg) Then vntReportFlg = Empty
    If Not IsMissing(vntHistoryPrint) Then vntHistoryPrint = Empty
    If Not IsMissing(vntCopyCount) Then vntCopyCount = Empty
    If Not IsMissing(vntFedFile) Then vntFedFile = Empty
    If Not IsMissing(vntFedFile2) Then vntFedFile2 = Empty
    If Not IsMissing(vntFedFile3) Then vntFedFile3 = Empty
    If Not IsMissing(vntFedFile4) Then vntFedFile4 = Empty
    If Not IsMissing(vntFedFile5) Then vntFedFile5 = Empty
    If Not IsMissing(vntFedFile6) Then vntFedFile6 = Empty
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "REPORTCD", Trim(strReportCd), ORAPARM_INPUT
    
    '指定帳票コードの帳票情報を取得
    strStmt = "SELECT REPORTNAME, PAPERSIZE,    ORIENTATION, DEFAULTPRINTER, PRTMACHINE, PREVIEW,  " & vbLf & _
              "       FEDFILE,    FEDFILE2,     FEDFILE3,    FEDFILE4,       FEDFILE5,   FEDFILE6, " & vbLf & _
              "       REPORTFLG,  HISTORYPRINT, COPYCOUNT                                          " & vbLf & _
              "  FROM REPORT                                                                       " & vbLf & _
              " WHERE REPORTCD = :REPORTCD                                                         "

    'SQL実行
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objReportName = objFields("REPORTNAME")
        Set objDefaultPrinter = objFields("DEFAULTPRINTER")
        Set objReportFlg = objFields("REPORTFLG")
        Set objHistoryPrint = objFields("HISTORYPRINT")
        Set objCopyCount = objFields("COPYCOUNT")
        Set objFedFile = objFields("FEDFILE")
        Set objFedFile2 = objFields("FEDFILE2")
        Set objFedFile3 = objFields("FEDFILE3")
        Set objFedFile4 = objFields("FEDFILE4")
        Set objFedFile5 = objFields("FEDFILE5")
        Set objFedFile6 = objFields("FEDFILE6")
        
        '戻り値の設定
        If Not IsMissing(vntReportName) Then vntReportName = objReportName.Value & ""
        If Not IsMissing(vntDefaultPrinter) Then vntDefaultPrinter = objDefaultPrinter.Value & ""
        If Not IsMissing(vntReportFlg) Then vntReportFlg = objReportFlg.Value & ""
        If Not IsMissing(vntHistoryPrint) Then vntHistoryPrint = objHistoryPrint.Value & ""
        If Not IsMissing(vntCopyCount) Then vntCopyCount = objCopyCount.Value & ""
        If Not IsMissing(vntFedFile) Then vntFedFile = objFedFile.Value & ""
        If Not IsMissing(vntFedFile2) Then vntFedFile2 = objFedFile2.Value & ""
        If Not IsMissing(vntFedFile3) Then vntFedFile3 = objFedFile3.Value & ""
        If Not IsMissing(vntFedFile4) Then vntFedFile4 = objFedFile4.Value & ""
        If Not IsMissing(vntFedFile5) Then vntFedFile5 = objFedFile5.Value & ""
        If Not IsMissing(vntFedFile6) Then vntFedFile6 = objFedFile6.Value & ""
        
        SelectReport3 = True
        
    End If
    
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
    WriteErrorLog "Report.SelectReport3"
    
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
'## 2008.02.08 Add By 張 ７枚綴り帳票に対応
'
' 機能　　 : 帳票管理テーブル読み込み
'
' 引数　　 : (In)     strReportCd        帳票コード
' 　　　　   (Out)    vntReportName      帳票名
' 　　　　   (Out)    vntDefaultPrinter  デフォルトプリンタ
' 　　　　   (Out)    vntReportFlg       報告書フラグ
' 　　　　   (Out)    vntHistoryPrint    過去歴印刷
' 　　　　   (Out)    vntCopyCount       部数
' 　　　　   (Out)    vntFedFile         帳票ファイル名1
' 　　　　   (Out)    vntFedFile2        帳票ファイル名2
' 　　　　   (Out)    vntFedFile3        帳票ファイル名3
' 　　　　   (Out)    vntFedFile4        帳票ファイル名4
' 　　　　   (Out)    vntFedFile5        帳票ファイル名5
' 　　　　   (Out)    vntFedFile6        帳票ファイル名6
' 　　　　   (Out)    vntFedFile7        帳票ファイル名7
'
' 戻り値　 :  True   データあり
' 　　　　    False  データなし
'
' 備考　　 :
'
Public Function SelectReport4( _
    ByVal strReportCd As String, _
    Optional ByRef vntReportName As Variant, _
    Optional ByRef vntDefaultPrinter As Variant, _
    Optional ByRef vntReportFlg As Variant, _
    Optional ByRef vntHistoryPrint As Variant, _
    Optional ByRef vntCopyCount As Variant, _
    Optional ByRef vntFedFile As Variant, _
    Optional ByRef vntFedFile2 As Variant, _
    Optional ByRef vntFedFile3 As Variant, _
    Optional ByRef vntFedFile4 As Variant, _
    Optional ByRef vntFedFile5 As Variant, _
    Optional ByRef vntFedFile6 As Variant, _
    Optional ByRef vntFedFile7 As Variant _
) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    
    Dim objReportName       As OraField         '帳票名
    Dim objDefaultPrinter   As OraField         'デフォルトプリンタ
    Dim objReportFlg        As OraField         '報告書フラグ
    Dim objHistoryPrint     As OraField         '過去歴印刷
    Dim objCopyCount        As OraField         '部数
    Dim objFedFile          As OraField         '帳票ファイル名1
    Dim objFedFile2         As OraField         '帳票ファイル名2
    Dim objFedFile3         As OraField         '帳票ファイル名3
    Dim objFedFile4         As OraField         '帳票ファイル名4
    Dim objFedFile5         As OraField         '帳票ファイル名5
    Dim objFedFile6         As OraField         '帳票ファイル名6
    Dim objFedFile7         As OraField         '帳票ファイル名7
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntReportName) Then vntReportName = Empty
    If Not IsMissing(vntDefaultPrinter) Then vntDefaultPrinter = Empty
    If Not IsMissing(vntReportFlg) Then vntReportFlg = Empty
    If Not IsMissing(vntHistoryPrint) Then vntHistoryPrint = Empty
    If Not IsMissing(vntCopyCount) Then vntCopyCount = Empty
    If Not IsMissing(vntFedFile) Then vntFedFile = Empty
    If Not IsMissing(vntFedFile2) Then vntFedFile2 = Empty
    If Not IsMissing(vntFedFile3) Then vntFedFile3 = Empty
    If Not IsMissing(vntFedFile4) Then vntFedFile4 = Empty
    If Not IsMissing(vntFedFile5) Then vntFedFile5 = Empty
    If Not IsMissing(vntFedFile6) Then vntFedFile6 = Empty
    If Not IsMissing(vntFedFile7) Then vntFedFile7 = Empty
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "REPORTCD", Trim(strReportCd), ORAPARM_INPUT
    
    '指定帳票コードの帳票情報を取得
    strStmt = "SELECT REPORTNAME, PAPERSIZE,    ORIENTATION, DEFAULTPRINTER, PRTMACHINE, PREVIEW,  " & vbLf & _
              "       FEDFILE,    FEDFILE2,     FEDFILE3,    FEDFILE4,       FEDFILE5,   FEDFILE6, " & vbLf & _
              "       FEDFILE7,   REPORTFLG,    HISTORYPRINT,COPYCOUNT                             " & vbLf & _
              "  FROM REPORT                                                                       " & vbLf & _
              " WHERE REPORTCD = :REPORTCD                                                         "

    'SQL実行
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objReportName = objFields("REPORTNAME")
        Set objDefaultPrinter = objFields("DEFAULTPRINTER")
        Set objReportFlg = objFields("REPORTFLG")
        Set objHistoryPrint = objFields("HISTORYPRINT")
        Set objCopyCount = objFields("COPYCOUNT")
        Set objFedFile = objFields("FEDFILE")
        Set objFedFile2 = objFields("FEDFILE2")
        Set objFedFile3 = objFields("FEDFILE3")
        Set objFedFile4 = objFields("FEDFILE4")
        Set objFedFile5 = objFields("FEDFILE5")
        Set objFedFile6 = objFields("FEDFILE6")
        Set objFedFile7 = objFields("FEDFILE7")
        
        '戻り値の設定
        If Not IsMissing(vntReportName) Then vntReportName = objReportName.Value & ""
        If Not IsMissing(vntDefaultPrinter) Then vntDefaultPrinter = objDefaultPrinter.Value & ""
        If Not IsMissing(vntReportFlg) Then vntReportFlg = objReportFlg.Value & ""
        If Not IsMissing(vntHistoryPrint) Then vntHistoryPrint = objHistoryPrint.Value & ""
        If Not IsMissing(vntCopyCount) Then vntCopyCount = objCopyCount.Value & ""
        If Not IsMissing(vntFedFile) Then vntFedFile = objFedFile.Value & ""
        If Not IsMissing(vntFedFile2) Then vntFedFile2 = objFedFile2.Value & ""
        If Not IsMissing(vntFedFile3) Then vntFedFile3 = objFedFile3.Value & ""
        If Not IsMissing(vntFedFile4) Then vntFedFile4 = objFedFile4.Value & ""
        If Not IsMissing(vntFedFile5) Then vntFedFile5 = objFedFile5.Value & ""
        If Not IsMissing(vntFedFile6) Then vntFedFile6 = objFedFile6.Value & ""
        If Not IsMissing(vntFedFile7) Then vntFedFile7 = objFedFile7.Value & ""
        
        SelectReport4 = True
        
    End If
    
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
    WriteErrorLog "Report.SelectReport4"
    
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

'#### 2010.06.15 SL-UI-Y0101-116 ADD START ####'
'
' 機能　　 : 帳票管理テーブル読み込み
'
' 引数　　 : (In)     strReportCd        帳票コード
' 　　　　   (Out)    vntReportName      帳票名
' 　　　　   (Out)    vntDefaultPrinter  デフォルトプリンタ
' 　　　　   (Out)    vntReportFlg       報告書フラグ
' 　　　　   (Out)    vntHistoryPrint    過去歴印刷
' 　　　　   (Out)    vntCopyCount       部数
' 　　　　   (Out)    vntFedFile         帳票ファイル名1
' 　　　　   (Out)    vntFedFile2        帳票ファイル名2
' 　　　　   (Out)    vntFedFile3        帳票ファイル名3
' 　　　　   (Out)    vntFedFile4        帳票ファイル名4
' 　　　　   (Out)    vntFedFile5        帳票ファイル名5
' 　　　　   (Out)    vntFedFile6        帳票ファイル名6
' 　　　　   (Out)    vntFedFile7        帳票ファイル名7
' 　　　　   (Out)    vntFedFile8        帳票ファイル名8
' 　　　　   (Out)    vntFedFile9        帳票ファイル名9
' 　　　　   (Out)    vntFedFile10       帳票ファイル名10
'
' 戻り値　 :  True   データあり
' 　　　　    False  データなし
'
' 備考　　 :
'
Public Function SelectReport5( _
    ByVal strReportCd As String _
  , Optional ByRef vntReportName As Variant _
  , Optional ByRef vntDefaultPrinter As Variant _
  , Optional ByRef vntReportFlg As Variant _
  , Optional ByRef vntHistoryPrint As Variant _
  , Optional ByRef vntCopyCount As Variant _
  , Optional ByRef vntFedFile As Variant _
  , Optional ByRef vntFedFile2 As Variant _
  , Optional ByRef vntFedFile3 As Variant _
  , Optional ByRef vntFedFile4 As Variant _
  , Optional ByRef vntFedFile5 As Variant _
  , Optional ByRef vntFedFile6 As Variant _
  , Optional ByRef vntFedFile7 As Variant _
  , Optional ByRef vntFedFile8 As Variant _
  , Optional ByRef vntFedFile9 As Variant _
  , Optional ByRef vntFedFile10 As Variant _
) As Boolean

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    
    Dim objReportName       As OraField         '帳票名
    Dim objDefaultPrinter   As OraField         'デフォルトプリンタ
    Dim objReportFlg        As OraField         '報告書フラグ
    Dim objHistoryPrint     As OraField         '過去歴印刷
    Dim objCopyCount        As OraField         '部数
    Dim objFedFile          As OraField         '帳票ファイル名1
    Dim objFedFile2         As OraField         '帳票ファイル名2
    Dim objFedFile3         As OraField         '帳票ファイル名3
    Dim objFedFile4         As OraField         '帳票ファイル名4
    Dim objFedFile5         As OraField         '帳票ファイル名5
    Dim objFedFile6         As OraField         '帳票ファイル名6
    Dim objFedFile7         As OraField         '帳票ファイル名7
    Dim objFedFile8         As OraField         '帳票ファイル名8
    Dim objFedFile9         As OraField         '帳票ファイル名9
    Dim objFedFile10        As OraField         '帳票ファイル名10
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    If Not IsMissing(vntReportName) Then vntReportName = Empty
    If Not IsMissing(vntDefaultPrinter) Then vntDefaultPrinter = Empty
    If Not IsMissing(vntReportFlg) Then vntReportFlg = Empty
    If Not IsMissing(vntHistoryPrint) Then vntHistoryPrint = Empty
    If Not IsMissing(vntCopyCount) Then vntCopyCount = Empty
    If Not IsMissing(vntFedFile) Then vntFedFile = Empty
    If Not IsMissing(vntFedFile2) Then vntFedFile2 = Empty
    If Not IsMissing(vntFedFile3) Then vntFedFile3 = Empty
    If Not IsMissing(vntFedFile4) Then vntFedFile4 = Empty
    If Not IsMissing(vntFedFile5) Then vntFedFile5 = Empty
    If Not IsMissing(vntFedFile6) Then vntFedFile6 = Empty
    If Not IsMissing(vntFedFile7) Then vntFedFile7 = Empty
    If Not IsMissing(vntFedFile8) Then vntFedFile8 = Empty
    If Not IsMissing(vntFedFile9) Then vntFedFile9 = Empty
    If Not IsMissing(vntFedFile10) Then vntFedFile10 = Empty
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "REPORTCD", Trim(strReportCd), ORAPARM_INPUT
    
    '指定帳票コードの帳票情報を取得
    strStmt = ""
    strStmt = strStmt & "SELECT REPORTNAME, PAPERSIZE,    ORIENTATION, DEFAULTPRINTER, PRTMACHINE, PREVIEW   " & vbLf
    strStmt = strStmt & "     , FEDFILE,    FEDFILE2,     FEDFILE3,    FEDFILE4,       FEDFILE5,   FEDFILE6  " & vbLf
    strStmt = strStmt & "     , FEDFILE7,   REPORTFLG,    HISTORYPRINT,COPYCOUNT                             " & vbLf
    strStmt = strStmt & "     , FEDFILE8,   FEDFILE9,     FEDFILE10                                          " & vbLf
    strStmt = strStmt & "  FROM REPORT                                                                       " & vbLf
    strStmt = strStmt & " WHERE REPORTCD = :REPORTCD                                                         " & vbLf

    'SQL実行
    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objReportName = objFields("REPORTNAME")
        Set objDefaultPrinter = objFields("DEFAULTPRINTER")
        Set objReportFlg = objFields("REPORTFLG")
        Set objHistoryPrint = objFields("HISTORYPRINT")
        Set objCopyCount = objFields("COPYCOUNT")
        Set objFedFile = objFields("FEDFILE")
        Set objFedFile2 = objFields("FEDFILE2")
        Set objFedFile3 = objFields("FEDFILE3")
        Set objFedFile4 = objFields("FEDFILE4")
        Set objFedFile5 = objFields("FEDFILE5")
        Set objFedFile6 = objFields("FEDFILE6")
        Set objFedFile7 = objFields("FEDFILE7")
        Set objFedFile8 = objFields("FEDFILE8")
        Set objFedFile9 = objFields("FEDFILE9")
        Set objFedFile10 = objFields("FEDFILE10")
        
        '戻り値の設定
        If Not IsMissing(vntReportName) Then vntReportName = objReportName.Value & ""
        If Not IsMissing(vntDefaultPrinter) Then vntDefaultPrinter = objDefaultPrinter.Value & ""
        If Not IsMissing(vntReportFlg) Then vntReportFlg = objReportFlg.Value & ""
        If Not IsMissing(vntHistoryPrint) Then vntHistoryPrint = objHistoryPrint.Value & ""
        If Not IsMissing(vntCopyCount) Then vntCopyCount = objCopyCount.Value & ""
        If Not IsMissing(vntFedFile) Then vntFedFile = objFedFile.Value & ""
        If Not IsMissing(vntFedFile2) Then vntFedFile2 = objFedFile2.Value & ""
        If Not IsMissing(vntFedFile3) Then vntFedFile3 = objFedFile3.Value & ""
        If Not IsMissing(vntFedFile4) Then vntFedFile4 = objFedFile4.Value & ""
        If Not IsMissing(vntFedFile5) Then vntFedFile5 = objFedFile5.Value & ""
        If Not IsMissing(vntFedFile6) Then vntFedFile6 = objFedFile6.Value & ""
        If Not IsMissing(vntFedFile7) Then vntFedFile7 = objFedFile7.Value & ""
        If Not IsMissing(vntFedFile8) Then vntFedFile8 = objFedFile8.Value & ""
        If Not IsMissing(vntFedFile9) Then vntFedFile9 = objFedFile9.Value & ""
        If Not IsMissing(vntFedFile10) Then vntFedFile10 = objFedFile10.Value & ""
        
        SelectReport5 = True
        
    End If
    
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
    WriteErrorLog "Report.SelectReport5"
    
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
'#### 2010.06.15 SL-UI-Y0101-116 ADD END ####'

'
' 機能　　 : 帳票テーブルレコードを登録する
'
' 引数　　 : (In)    strMode            登録モード("INS":挿入、"UPD":更新)
' 　　　　   (In)    strReportCd        帳票コード
' 　　　　 : (In)    strReportName      帳票名
' 　　　　 : (In)    strPaperSize       用紙サイズ
' 　　　　 : (In)    strOrientation     用紙方向
' 　　　　 : (In)    strDefaultPrinter  デフォルトプリンタ
' 　　　　 : (In)    intPrtMachine      出力先
' 　　　　 : (In)    intPreView         出力方法
' 　　　　 : (In)    intReportFlg       報告書フラグ
' 　　　　 : (In)    intKarteFlg        カルテフラグ
' 　　　　 : (In)    intHistoryPrint    過去歴印刷
' 　　　　 : (In)    intCopyCount       部数
' 　　　　 : (In)    strFedFile         帳票ファイル名１
' 　　　　 : (In)    strFedFile2        帳票ファイル名２
' 　　　　 : (In)    strFedFile3        帳票ファイル名３
' 　　　　 : (In)    strFedFile4        帳票ファイル名４
' 　　　　 : (In)    strFedFile5        帳票ファイル名５
'## 2008.02.08 張 帳票ファイル７列追加のため修正（既存帳票ファイル６分についても対応）Start
' 　　　　 : (In)    strFedFile6        帳票ファイル名６
' 　　　　 : (In)    strFedFile7        帳票ファイル名７
'## 2008.02.08 張 帳票ファイル７列追加のため修正（既存帳票ファイル６分についても対応）End
'#### 2010.06.15 SL-UI-Y0101-116 ADD START ####'
' 　　　　 : (In)    strFedFile8        帳票ファイル名８
' 　　　　 : (In)    strFedFile9        帳票ファイル名９
' 　　　　 : (In)    strFedFile10       帳票ファイル名１０
'#### 2010.06.15 SL-UI-Y0101-116 ADD END ####'
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_DUPLICATE  同一キーのレコード存在
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
'#### 2010.06.15 SL-UI-Y0101-116 MOD START ####'
''''## 2008.02.08 張 帳票ファイル７列追加のため修正（既存帳票ファイル６分についても対応）Start
''''Public Function RegistReport(ByVal strMode As String, _
''''                             ByVal strReportCd As String, _
''''                             ByVal strReportName As String, _
''''                             ByVal strPaperSize As String, _
''''                             ByVal strOrientation As String, _
''''                             ByVal strDefaultPrinter As String, _
''''                             ByVal intPrtMachine As Integer, _
''''                             ByVal intPreView As Integer, _
''''                             ByVal intReportFlg As Integer, _
''''                             ByVal intKarteFlg As Integer, _
''''                             ByVal intHistoryPrint As Integer, _
''''                             ByVal intCopyCount As Integer, _
''''                             ByVal strFedFile As String, _
''''                             ByVal strFedFile2 As String, _
''''                             ByVal strFedFile3 As String, _
''''                             ByVal strFedFile4 As String, _
''''                             ByVal strFedFile5 As String _
''''                             ) As Long
'''Public Function RegistReport(ByVal strMode As String, _
'''                             ByVal strReportCd As String, _
'''                             ByVal strReportName As String, _
'''                             ByVal strPaperSize As String, _
'''                             ByVal strOrientation As String, _
'''                             ByVal strDefaultPrinter As String, _
'''                             ByVal intPrtMachine As Integer, _
'''                             ByVal intPreView As Integer, _
'''                             ByVal intReportFlg As Integer, _
'''                             ByVal intKarteFlg As Integer, _
'''                             ByVal intHistoryPrint As Integer, _
'''                             ByVal intCopyCount As Integer, _
'''                             ByVal strFedFile As String, _
'''                             ByVal strFedFile2 As String, _
'''                             ByVal strFedFile3 As String, _
'''                             ByVal strFedFile4 As String, _
'''                             ByVal strFedFile5 As String, _
'''                             ByVal strFedFile6 As String, _
'''                             ByVal strFedFile7 As String _
'''                             ) As Long
''''## 2008.02.08 張 帳票ファイル７列追加のため修正（既存帳票ファイル６分についても対応）End
'#### 2012.12.14 SL-SN-Y0101-611 MOD START ####
'Public Function RegistReport(ByVal strMode As String _
'                           , ByVal strReportCd As String _
'                           , ByVal strReportName As String _
'                           , ByVal strPaperSize As String _
'                           , ByVal strOrientation As String _
'                           , ByVal strDefaultPrinter As String _
'                           , ByVal intPrtMachine As Integer _
'                           , ByVal intPreView As Integer _
'                           , ByVal intReportFlg As Integer _
'                           , ByVal intKarteFlg As Integer _
'                           , ByVal intHistoryPrint As Integer _
'                           , ByVal intCopyCount As Integer _
'                           , ByVal strFedFile As String _
'                           , ByVal strFedFile2 As String _
'                           , ByVal strFedFile3 As String _
'                           , ByVal strFedFile4 As String _
'                           , ByVal strFedFile5 As String _
'                           , ByVal strFedFile6 As String _
'                           , ByVal strFedFile7 As String _
'                           , ByVal strFedFile8 As String _
'                           , ByVal strFedFile9 As String _
'                           , ByVal strFedFile10 As String _
'                             ) As Long
Public Function RegistReport(ByVal strMode As String _
                           , ByVal strReportCd As String _
                           , ByVal strReportName As String _
                           , ByVal strPaperSize As String _
                           , ByVal strOrientation As String _
                           , ByVal strDefaultPrinter As String _
                           , ByVal intPrtMachine As Integer _
                           , ByVal intPreView As Integer _
                           , ByVal intReportFlg As Integer _
                           , ByVal intKarteFlg As Integer _
                           , ByVal intHistoryPrint As Integer _
                           , ByVal intCopyCount As Integer _
                           , ByVal strFedFile As String _
                           , ByVal strFedFile2 As String _
                           , ByVal strFedFile3 As String _
                           , ByVal strFedFile4 As String _
                           , ByVal strFedFile5 As String _
                           , ByVal strFedFile6 As String _
                           , ByVal strFedFile7 As String _
                           , ByVal strFedFile8 As String _
                           , ByVal strFedFile9 As String _
                           , ByVal strFedFile10 As String _
                           , ByVal strViewOrder As String _
                             ) As Long
'#### 2012.12.14 SL-SN-Y0101-611 MOD END ####
'#### 2010.06.15 SL-UI-Y0101-116 MOD END ####'


    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna  As OraDynaset       'ダイナセット
    Dim strStmt     As String           'SQLステートメント

'#### 2012.12.14 SL-SN-Y0101-611 ADD START ####
    Dim vntViewOrder    As Variant      '表示順
'#### 2012.12.14 SL-SN-Y0101-611 ADD END ####

    Dim Ret         As Long             '関数戻り値
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "ReportCD", Trim(strReportCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ReportName", Trim(strReportName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "PaperSize", strPaperSize, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "Orientation", strOrientation, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DefaultPrinter", Trim(strDefaultPrinter), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "PrtMachine", intPrtMachine, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "PreView", intPreView, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ReportFlg", intReportFlg, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "karteFlg", intKarteFlg, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "HistoryPrint", intHistoryPrint, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CopyCount", intCopyCount, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "FedFile", Trim(strFedFile), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "FedFile2", Trim(strFedFile2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "FedFile3", Trim(strFedFile3), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "FedFile4", Trim(strFedFile4), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "FedFile5", Trim(strFedFile5), ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2008.02.08 張 帳票ファイル７列追加のため修正（既存帳票ファイル６分についても対応）Start
    objOraParam.Add "FedFile6", Trim(strFedFile6), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "FedFile7", Trim(strFedFile7), ORAPARM_INPUT, ORATYPE_VARCHAR2
'## 2008.02.08 張 帳票ファイル７列追加のため修正（既存帳票ファイル６分についても対応）End
'#### 2010.06.15 SL-UI-Y0101-116 ADD START ####'
    objOraParam.Add "FedFile8", Trim(strFedFile8), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "FedFile9", Trim(strFedFile9), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "FedFile10", Trim(strFedFile10), ORAPARM_INPUT, ORATYPE_VARCHAR2
'#### 2010.06.15 SL-UI-Y0101-116 ADD END ####'
'#### 2012.12.14 SL-SN-Y0101-611 ADD START ####
    vntViewOrder = Null
    strViewOrder = Trim(strViewOrder)
    If IsNumeric(strViewOrder) Then
        vntViewOrder = CLng(strViewOrder)
    End If
    objOraParam.Add "ViewOrder", vntViewOrder, ORAPARM_INPUT, ORATYPE_NUMBER
'#### 2012.12.14 SL-SN-Y0101-611 ADD END ####

    Do
        '帳票テーブルレコードの更新
        If strMode = "UPD" Then
'#### 2010.06.15 SL-UI-Y0101-116 MOD START ####'
''''## 2002.11.10 Mod 1Line By H.Ishihara@FSIT カルテフラグの追加
''''                strStmt = "UPDATE Report " & _
'''                          "   SET REPORTCD        = :REPORTCD," & _
'''                          "       REPORTNAME      = :REPORTNAME," & _
'''                          "       PAPERSIZE       = :PAPERSIZE," & _
'''                          "       ORIENTATION     = :ORIENTATION," & _
'''                          "       DEFAULTPRINTER  = :DEFAULTPRINTER," & _
'''                          "       PRTMACHINE      = :PRTMACHINE," & _
'''                          "       PREVIEW         = :PREVIEW," & _
'''                          "       REPORTFLG       = :REPORTFLG," & _
'''                          "       HISTORYPRINT    = :HISTORYPRINT," & _
'''                          "       COPYCOUNT       = :COPYCOUNT," & _
'''                          "       FEDFILE         = :FEDFILE," & _
'''                          "       FEDFILE2        = :FEDFILE2," & _
'''                          "       FEDFILE3        = :FEDFILE3," & _
'''                          "       FEDFILE4        = :FEDFILE4," & _
'''                          "       FEDFILE5        = :FEDFILE5" & _
'''                          " WHERE REPORTCD = :REPORTCD"
'''    '## 2008.02.08 張 帳票ファイル７列追加のため修正（既存帳票ファイル６分についても対応）Start
''''                strStmt = "UPDATE Report " & _
''''                          "   SET REPORTCD        = :REPORTCD," & _
''''                          "       REPORTNAME      = :REPORTNAME," & _
''''                          "       PAPERSIZE       = :PAPERSIZE," & _
''''                          "       ORIENTATION     = :ORIENTATION," & _
''''                          "       DEFAULTPRINTER  = :DEFAULTPRINTER," & _
''''                          "       PRTMACHINE      = :PRTMACHINE," & _
''''                          "       PREVIEW         = :PREVIEW," & _
''''                          "       REPORTFLG       = :REPORTFLG," & _
''''                          "       KARTEFLG        = :KARTEFLG," & _
''''                          "       HISTORYPRINT    = :HISTORYPRINT," & _
''''                          "       COPYCOUNT       = :COPYCOUNT," & _
''''                          "       FEDFILE         = :FEDFILE," & _
''''                          "       FEDFILE2        = :FEDFILE2," & _
''''                          "       FEDFILE3        = :FEDFILE3," & _
''''                          "       FEDFILE4        = :FEDFILE4," & _
''''                          "       FEDFILE5        = :FEDFILE5" & _
''''                          " WHERE REPORTCD = :REPORTCD"
'''
'''                strStmt = "UPDATE Report " & _
'''                          "   SET REPORTCD        = :REPORTCD," & _
'''                          "       REPORTNAME      = :REPORTNAME," & _
'''                          "       PAPERSIZE       = :PAPERSIZE," & _
'''                          "       ORIENTATION     = :ORIENTATION," & _
'''                          "       DEFAULTPRINTER  = :DEFAULTPRINTER," & _
'''                          "       PRTMACHINE      = :PRTMACHINE," & _
'''                          "       PREVIEW         = :PREVIEW," & _
'''                          "       REPORTFLG       = :REPORTFLG," & _
'''                          "       KARTEFLG        = :KARTEFLG," & _
'''                          "       HISTORYPRINT    = :HISTORYPRINT," & _
'''                          "       COPYCOUNT       = :COPYCOUNT," & _
'''                          "       FEDFILE         = :FEDFILE," & _
'''                          "       FEDFILE2        = :FEDFILE2," & _
'''                          "       FEDFILE3        = :FEDFILE3," & _
'''                          "       FEDFILE4        = :FEDFILE4," & _
'''                          "       FEDFILE5        = :FEDFILE5," & _
'''                          "       FEDFILE6        = :FEDFILE6," & _
'''                          "       FEDFILE7        = :FEDFILE7" & _
'''                          " WHERE REPORTCD = :REPORTCD"
'''    '## 2008.02.08 張 帳票ファイル７列追加のため修正（既存帳票ファイル６分についても対応）End
'''
''''## 2002.11.10 Mod End
'#### 2012.12.14 SL-SN-Y0101-611 MOD START ####
'                strStmt = "UPDATE Report " & _
'                          "   SET REPORTCD        = :REPORTCD" & _
'                          "     , REPORTNAME      = :REPORTNAME" & _
'                          "     , PAPERSIZE       = :PAPERSIZE" & _
'                          "     , ORIENTATION     = :ORIENTATION" & _
'                          "     , DEFAULTPRINTER  = :DEFAULTPRINTER" & _
'                          "     , PRTMACHINE      = :PRTMACHINE " & _
'                          "     , PREVIEW         = :PREVIEW " & _
'                          "     , REPORTFLG       = :REPORTFLG " & _
'                          "     , KARTEFLG        = :KARTEFLG " & _
'                          "     , HISTORYPRINT    = :HISTORYPRINT " & _
'                          "     , COPYCOUNT       = :COPYCOUNT " & _
'                          "     , FEDFILE         = :FEDFILE  " & _
'                          "     , FEDFILE2        = :FEDFILE2 " & _
'                          "     , FEDFILE3        = :FEDFILE3 " & _
'                          "     , FEDFILE4        = :FEDFILE4 " & _
'                          "     , FEDFILE5        = :FEDFILE5 " & _
'                          "     , FEDFILE6        = :FEDFILE6 " & _
'                          "     , FEDFILE7        = :FEDFILE7 " & _
'                          "     , FEDFILE8        = :FEDFILE8 " & _
'                          "     , FEDFILE9        = :FEDFILE9 " & _
'                          "     , FEDFILE10       = :FEDFILE10" & _
'                          " WHERE REPORTCD = :REPORTCD"
                strStmt = "UPDATE Report " & _
                          "   SET REPORTCD        = :REPORTCD" & _
                          "     , REPORTNAME      = :REPORTNAME" & _
                          "     , PAPERSIZE       = :PAPERSIZE" & _
                          "     , ORIENTATION     = :ORIENTATION" & _
                          "     , DEFAULTPRINTER  = :DEFAULTPRINTER" & _
                          "     , PRTMACHINE      = :PRTMACHINE " & _
                          "     , PREVIEW         = :PREVIEW " & _
                          "     , REPORTFLG       = :REPORTFLG " & _
                          "     , KARTEFLG        = :KARTEFLG " & _
                          "     , HISTORYPRINT    = :HISTORYPRINT " & _
                          "     , COPYCOUNT       = :COPYCOUNT " & _
                          "     , FEDFILE         = :FEDFILE  " & _
                          "     , FEDFILE2        = :FEDFILE2 " & _
                          "     , FEDFILE3        = :FEDFILE3 " & _
                          "     , FEDFILE4        = :FEDFILE4 " & _
                          "     , FEDFILE5        = :FEDFILE5 " & _
                          "     , FEDFILE6        = :FEDFILE6 " & _
                          "     , FEDFILE7        = :FEDFILE7 " & _
                          "     , FEDFILE8        = :FEDFILE8 " & _
                          "     , FEDFILE9        = :FEDFILE9 " & _
                          "     , FEDFILE10       = :FEDFILE10" & _
                          "     , VIEWORDER       = :VIEWORDER" & _
                          " WHERE REPORTCD = :REPORTCD"
'#### 2012.12.14 SL-SN-Y0101-611 MOD END ####
'#### 2010.06.15 SL-UI-Y0101-116 MOD END ####'
            
            Ret = mobjOraDb.ExecuteSQL(strStmt)
            If Ret > 0 Then
                Ret = INSERT_NORMAL
                Exit Do
            End If
        End If

        '検索条件を満たす帳票テーブルのレコードを取得
        strStmt = "SELECT REPORTCD FROM REPORT WHERE REPORTCD = :REPORTCD"
        Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
            
        If Not objOraDyna.EOF Then
            Ret = INSERT_DUPLICATE
            Exit Do
        End If

        '更新モードでない場合、または更新レコードがない場合は挿入を行う
'#### 2010.06.15 SL-UI-Y0101-116 MOD START ####'
''''## 2002.11.10 Mod 1Line By H.Ishihara@FSIT カルテフラグの追加
''''        strStmt = "INSERT INTO REPORT ( REPORTCD,  REPORTNAME,  PAPERSIZE,  ORIENTATION,  DEFAULTPRINTER,  PRTMACHINE,  PREVIEW,  REPORTFLG,  HISTORYPRINT,  COPYCOUNT,  FEDFILE,  FEDFILE2,  FEDFILE3,  FEDFILE4,  FEDFILE5)" & _
'''                  "            VALUES (:REPORTCD, :REPORTNAME, :PAPERSIZE, :ORIENTATION, :DEFAULTPRINTER, :PRTMACHINE, :PREVIEW, :REPORTFLG, :HISTORYPRINT, :COPYCOUNT, :FEDFILE, :FEDFILE2, :FEDFILE3, :FEDFILE4, :FEDFILE5)"
'''    '## 2008.02.08 張 帳票ファイル７列追加のため修正（既存帳票ファイル６分についても対応）Start
''''        strStmt = "INSERT INTO REPORT ( REPORTCD,  REPORTNAME,  PAPERSIZE,  ORIENTATION,  DEFAULTPRINTER,  PRTMACHINE,  PREVIEW,  REPORTFLG,  KARTEFLG,  HISTORYPRINT,  COPYCOUNT,  FEDFILE,  FEDFILE2,  FEDFILE3,  FEDFILE4,  FEDFILE5)" & _
''''                  "            VALUES (:REPORTCD, :REPORTNAME, :PAPERSIZE, :ORIENTATION, :DEFAULTPRINTER, :PRTMACHINE, :PREVIEW, :REPORTFLG, :KARTEFLG, :HISTORYPRINT, :COPYCOUNT, :FEDFILE, :FEDFILE2, :FEDFILE3, :FEDFILE4, :FEDFILE5)"
'''
'''        strStmt = "INSERT INTO REPORT ( REPORTCD,  REPORTNAME,  PAPERSIZE,  ORIENTATION,  DEFAULTPRINTER,  PRTMACHINE,  PREVIEW,  REPORTFLG,  KARTEFLG,  HISTORYPRINT,  COPYCOUNT,  FEDFILE,  FEDFILE2,  FEDFILE3,  FEDFILE4,  FEDFILE5,  FEDFILE6,  FEDFILE7)" & _
'''                  "            VALUES (:REPORTCD, :REPORTNAME, :PAPERSIZE, :ORIENTATION, :DEFAULTPRINTER, :PRTMACHINE, :PREVIEW, :REPORTFLG, :KARTEFLG, :HISTORYPRINT, :COPYCOUNT, :FEDFILE, :FEDFILE2, :FEDFILE3, :FEDFILE4, :FEDFILE5, :FEDFILE6, :FEDFILE7)"
'''    '## 2008.02.08 張 帳票ファイル７列追加のため修正（既存帳票ファイル６分についても対応）End
''''## 2002.11.10 Mod End
'#### 2012.12.14 SL-SN-Y0101-611 MOD START ####
'        strStmt = "INSERT INTO REPORT ( REPORTCD,  REPORTNAME,  PAPERSIZE,  ORIENTATION,  DEFAULTPRINTER,  PRTMACHINE,  PREVIEW,  REPORTFLG,  KARTEFLG,  HISTORYPRINT,  COPYCOUNT,  FEDFILE,  FEDFILE2,  FEDFILE3,  FEDFILE4,  FEDFILE5,  FEDFILE6,  FEDFILE7,  FEDFILE8,  FEDFILE9,  FEDFILE10)" & _
'                  "            VALUES (:REPORTCD, :REPORTNAME, :PAPERSIZE, :ORIENTATION, :DEFAULTPRINTER, :PRTMACHINE, :PREVIEW, :REPORTFLG, :KARTEFLG, :HISTORYPRINT, :COPYCOUNT, :FEDFILE, :FEDFILE2, :FEDFILE3, :FEDFILE4, :FEDFILE5, :FEDFILE6, :FEDFILE7, :FEDFILE8, :FEDFILE9, :FEDFILE10)"
        strStmt = "INSERT INTO REPORT ( REPORTCD,  REPORTNAME,  PAPERSIZE,  ORIENTATION,  DEFAULTPRINTER,  PRTMACHINE,  PREVIEW,  REPORTFLG,  KARTEFLG,  HISTORYPRINT,  COPYCOUNT,  FEDFILE,  FEDFILE2,  FEDFILE3,  FEDFILE4,  FEDFILE5,  FEDFILE6,  FEDFILE7,  FEDFILE8,  FEDFILE9,  FEDFILE10,  VIEWORDER)" & _
                  "            VALUES (:REPORTCD, :REPORTNAME, :PAPERSIZE, :ORIENTATION, :DEFAULTPRINTER, :PRTMACHINE, :PREVIEW, :REPORTFLG, :KARTEFLG, :HISTORYPRINT, :COPYCOUNT, :FEDFILE, :FEDFILE2, :FEDFILE3, :FEDFILE4, :FEDFILE5, :FEDFILE6, :FEDFILE7, :FEDFILE8, :FEDFILE9, :FEDFILE10, :VIEWORDER)"
'#### 2012.12.14 SL-SN-Y0101-611 MOD END ####
'#### 2010.06.15 SL-UI-Y0101-116 MOD END ####'


        mobjOraDb.ExecuteSQL strStmt
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
    RegistReport = Ret

    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Report.RegistReport"

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'その他の戻り値設定
    RegistReport = INSERT_ERROR

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, "Report.RegistReport", Err.Description

End Function

'
' 機能　　 : 帳票テーブルレコードを削除する
'
' 引数　　 : (In)   strReportCd    帳票コード
'
' 戻り値　 : True   正常終了
' 　　　　   False  異常終了
'
' 備考　　 :
'
Public Function DeleteReport(ByVal strReportCd As String) As Boolean

    Dim objOraParam As OraParameters    'OraParametersオブジェクト
    Dim strStmt     As String           'SQLステートメント

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "REPORTCD", Trim(strReportCd), ORAPARM_INPUT, ORATYPE_VARCHAR2

    '帳票テーブルレコードの削除
    mobjOraDb.ExecuteSQL "DELETE REPORT WHERE REPORTCD = :REPORTCD"
    
    'バインド変数の削除
    objOraParam.Remove "REPORTCD"
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    '戻り値の設定
    DeleteReport = True

    Exit Function
    
ErrorHandle:

    DeleteReport = False

    'イベントログ書き込み
    WriteErrorLog "Report.DeleteReport"

'### 2010.10.06 SL-HS-Y0101-002 ADD STR ###
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
'### 2010.10.06 SL-HS-Y0101-002 ADD END ###

    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, "Report.DeleteReport", Err.Description

End Function

'
' 機能　　 : Activateイベント
'
' 備考　　 : COMオブジェクトがアクティブ化された時点でデータベースへの接続を行う
'
Private Sub ObjectControl_Activate()

    Dim objCommon   As Common   '共通クラス
    
    '共通クラスのインスタンス作成
    Set objCommon = New Common
    
    'オブジェクトコンテキストを取得
    Set mobjContext = GetObjectContext()
    
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

    'オブジェクトコンテキストを解放
    Set mobjContext = Nothing
    
End Sub
