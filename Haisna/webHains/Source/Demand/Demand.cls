VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 2  'RequiresTransaction
END
Attribute VB_Name = "Demand"
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

'表示順（個人別請求金額修正の受診者一覧）
Private Const DSL_SORT_DEFAULT          As Long = 0     '基本表示順（受診日，当日ID，コース，団体（カナ），氏名（カナ））

'表示順（請求対象受診者一覧）
Private Const DOL_SORT_DEFAULT          As Long = 0     '基本表示順（受診日，当日ID，コース，団体（カナ），氏名（カナ））

'表示順（健診請求チェック表）
Private Const DCL_SORT_DEFAULT          As Long = 0     'デフォルト（受診日，コースコード，受診団体コード，管理番号，当日ＩＤ，予約番号，適用元区分（降順），ＳＥＱ，タイプ，オプションコード，グループコード，検査項目コード）
Private Const DCL_SORT_DAYID            As Long = 1     '当日ＩＤ順（受診日，管理番号，当日ＩＤ，コースコード，受診団体コード，予約番号，適用元区分（降順），ＳＥＱ，タイプ，オプションコード，グループコード，検査項目コード）

'負担元団体名のデフォルト値
Private Const ORGNAME_PERSON            As String = "個人"
Private Const ORGNAME_PERSON2           As String = "自己負担"

'オプション名のデフォルト値
Private Const OPTNAME_COURSE            As String = "基本コース"

'桁数
Private Const LENGTH_EDITPRICE          As Long = 7     '調整金額
Private Const LENGTH_EDITTAX            As Long = 7     '税調整金額
Private Const LENGTH_STADIV             As Long = 1     '統計区分
'2004/01/13 Shiramizu Modified Start
'請求書番号MAXLENGTH変更
'Private Const LENGTH_BILLNO             As Long = 9     '請求書番号
Private Const LENGTH_BILLNO             As Long = 14    '請求書番号
'2004/01/13 Shiramizu Modified End
Private Const LENGTH_PAYMENTPRICE       As Long = 8     '入金額
Private Const LENGTH_DAYCOUNT           As Long = 3     '日数
Private Const LENGTH_SUBTOTAL           As Long = 8     '金額
Private Const LENGTH_TAX                As Long = 8     '消費税
Private Const LENGTH_DISCOUNT           As Long = 8     '値引き
Private Const LENGTH_TOTAL              As Long = 8     '合計
Private Const LENGTH_TAXRATES           As Long = 5     '適用税率
Private Const LENGTH_TAXRATES_DECPOINT  As Long = 2     '適用税率（小数部）

'2004/01/13 Shiramizu Modified Start
'MAXLENGTH追加
Private Const LENGTH_RSVNO              As Long = 9     '受診番号
Private Const LENGTH_PRICE              As Long = 7     '金額
Private Const LENGTH_TAXPRICE           As Long = 7     '税額
Private Const LENGTH_DETAILNAME         As Long = 30    '明細名
Private Const LENGTH_LASTNAME           As Long = 50    '姓
Private Const LENGTH_LASTKNAME          As Long = 50    '名
Private Const LENGTH_FIRSTNAME          As Long = 50    '姓（カナ）
Private Const LENGTH_FIRSTKNAME         As Long = 50    '名（カナ）
'2004/01/13 Shiramizu Modified End
'2004/01/13 Aoyagi Modified
'MAXLENGTH 追加
Private Const LENGTH_PAYNOTE            As Long = 400   '入金コメント

'
' 機能　　 : 個人別請求金額修正入力値の妥当性チェックを行う
'
' 引数　　 : (In)   lngRsvNo        予約番号
' 　　　　 : (In)   lngCtrPtCd      契約パターンコード
' 　　　　 : (In)   strTaxFraction  税端数区分
' 　　　　 : (In)   dblNowTax       適用税率
' 　　　　 : (Out)  vntCloseFlg     締めフラグ（0:締め処理は行われていない, 1:締め処理が完了している）
' 　　　　 : (In)   vntSeq          （配列）ＳＥＱ
' 　　　　 : (In)   vntApDiv        （配列）適用元区分
' 　　　　 : (In)   vntOrgCd1       （配列）団体コード１
' 　　　　 : (In)   vntOrgCd2       （配列）団体コード２
' 　　　　 : (Out)  vntOrgName      （配列）団体名
' 　　　　 : (Out)  vntOrgSName     （配列）団体略称
' 　　　　 : (In)   vntPriceType    （配列）タイプ（0:基本コース, 1:基本コースの削除項目, 2:オプション検査, 3:契約外追加グループ, 4:契約外追加項目）
' 　　　　 : (In)   vntOptCd        （配列）オプションコード
' 　　　　 : (Out)  vntOptName      （配列）オプション名
' 　　　　 : (In)   vntGrpCd        （配列）グループコード
' 　　　　 : (Out)  vntGrpName      （配列）グループ名
' 　　　　 : (In)   vntItemCd       （配列）検査項目コード
' 　　　　 : (Out)  vntRequestName  （配列）依頼項目名
' 　　　　 : (In)   vntPrice        （配列）請求金額（"-9999999"～"9999999":金額）
' 　　　　 : (In)   vntEditPrice    （配列）調整金額（"*-hidden-*":非表示, "":"0"と同義, "-9999999"～"9999999":金額）
' 　　　　 : (Out)  vntTax          （配列）消費税金額（"*-hidden-*":非表示, "-9999999"～"9999999":金額）
' 　　　　 : (In)   vntEditTax      （配列）税調整金額（"*-hidden-*":非表示, "":"0"と同義, "-9999999"～"9999999":金額）
' 　　　　 : (In)   vntTaxFlg       （配列）消費税負担フラグ（0:負担しない, 1:負担する）
' 　　　　 : (In)   lngCount        レコード件数（配列の要素数）
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 : 各名称の取得，消費税再計算も同時に行う
'
Public Function CheckValueDmdPerModify(ByVal lngRsvNo As Long, _
                                       ByVal lngCtrPtCd As Long, ByVal strTaxFraction As String, _
                                       ByVal dblNowTax As Double, ByRef vntCloseFlg As Variant, _
                                       ByVal vntSeq As Variant, ByVal vntApDiv As Variant, _
                                       ByVal vntOrgCd1 As Variant, ByVal vntOrgCd2 As Variant, _
                                       ByRef vntOrgName As Variant, ByRef vntOrgSName As Variant, _
                                       ByVal vntPriceType As Variant, ByVal vntOptCd As Variant, _
                                       ByRef vntOptName As Variant, ByVal vntGrpCd As Variant, _
                                       ByRef vntGrpName As Variant, ByVal vntItemCd As Variant, _
                                       ByRef vntRequestName As Variant, ByVal vntPrice As Variant, _
                                       ByVal vntEditPrice As Variant, ByRef vntTax As Variant, _
                                       ByVal vntEditTax As Variant, ByVal vntTaxFlg As Variant, _
                                       ByVal lngCount As Long _
                                      ) As Variant
    
    Dim objCommon               As Common           '共通クラス
    Dim objOrganization         As Object           '団体クラス
    Dim objGrp                  As Object           'グループクラス
    Dim objItem                 As Object           '検査項目クラス
    
    Dim vntArrMessage           As Variant          'エラーメッセージの集合
    Dim strItemName             As String           '項目名編集用
    Dim strItemName2            As String           '項目名編集用
    Dim i                       As Long             'インデックス
    
    '初期処理
    CheckValueDmdPerModify = Empty
    vntArrMessage = Empty
    
    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    
    '団体クラスのインスタンス作成
    Set objOrganization = mobjContext.CreateInstance("HainsOrganization.Organization")
    
    'グループクラスのインスタンス作成
    Set objGrp = mobjContext.CreateInstance("HainsGrp.Grp")
    
    '検査項目クラスのインスタンス作成
    Set objItem = mobjContext.CreateInstance("HainsItem.Item")
    
    Do
        '各名称取得処理
        For i = 0 To (lngCount - 1)
    
            '適用元区分が０（個人）の場合
            If vntApDiv(i) = APDIV_PERSON Then
    
                '負担元団体名のデフォルト値を設定する
                vntOrgName(i) = ORGNAME_PERSON
                vntOrgSName(i) = ORGNAME_PERSON
    
            '適用元区分が０（個人）以外の場合
            Else
    
                '団体名・団体略称を取得する
                objOrganization.SelectOrgName vntOrgCd1(i), vntOrgCd2(i), vntOrgName(i)
                objOrganization.SelectOrgSName vntOrgCd1(i), vntOrgCd2(i), vntOrgSName(i)
    
            End If
    
            'タイプに従って名称を取得する
            Select Case vntPriceType(i)
    
                Case 0          '（基本コース）の場合
                    'オプション名のデフォルト値を設定する
                    vntOptName(i) = OPTNAME_COURSE
    
                Case 1          '（基本削除）の場合
                    'オプション名を取得する
                    vntOptName(i) = GetOptName(lngCtrPtCd, vntOptCd(i))
    
                Case 2          '（オプション検査）の場合
                    'オプション名を取得する
                    vntOptName(i) = GetOptName(lngCtrPtCd, vntOptCd(i))
    
                Case 3          '（契約外追加グループ）の場合
                    'グループ名を取得する
                    objGrp.SelectGrp_P vntGrpCd(i), vntGrpName(i)
                    
                Case 4          '（契約外追加項目）の場合
                    '依頼項目名を取得する
                    objItem.SelectItem_P vntItemCd(i), vntRequestName(i)
    
            End Select
    
        Next i
    
        '締めフラグを取得する
        vntCloseFlg = GetCloseFlg(lngRsvNo, lngCtrPtCd)
    
        '締め処理が完了している場合
        If vntCloseFlg = 1 Then
            objCommon.AppendArray vntArrMessage, "このデータは既に締め処理が完了しています。"
            Exit Do
        End If
    
        '各値チェック処理
        With objCommon
    
            For i = 0 To (lngCount - 1)
    
                '項目名の編集
                strItemName = ""
                strItemName2 = ""
                If vntApDiv(i) = APDIV_PERSON Then
                    strItemName = strItemName & "個人：　"
                Else
                    strItemName = strItemName & vntOrgName(i) & "：　"
                End If
                Select Case vntPriceType(i)
                    Case 0          '（基本コース）の場合
                        strItemName2 = "基本コースの　"
                    Case 1          '（基本削除）の場合
                        strItemName2 = vntOptName(i) & "の　"
                    Case 2          '（オプション検査）の場合
                        strItemName2 = vntOptName(i) & "の　"
                    Case 3          '（契約外追加グループ）の場合
                        strItemName2 = vntGrpName(i) & "の　"
                    Case 4          '（契約外追加項目）の場合
                        strItemName2 = vntRequestName(i) & "の　"
                End Select
    
                '調整金額のチェック
                If vntEditPrice(i) <> "*-hidden-*" Then
                    .AppendArray vntArrMessage, .CheckNumericWithSign(strItemName & strItemName2 & "調整金額　", vntEditPrice(i), LENGTH_EDITPRICE)
                End If
    
                '税調整金額のチェック
                If vntEditTax(i) <> "*-hidden-*" Then
                    .AppendArray vntArrMessage, .CheckNumericWithSign(strItemName & "税調整金額　", vntEditTax(i), LENGTH_EDITTAX)
                End If
    
            Next i
    
        End With
    
        'エラーがある時、以降のチェックは不要
        If IsArray(vntArrMessage) Then
            Exit Do
        End If
    
        '消費税再計算処理
        CompTax strTaxFraction, dblNowTax, vntSeq, vntPriceType, vntOptCd, vntGrpCd, vntItemCd, vntPrice, vntEditPrice, vntTax, vntTaxFlg, lngCount
    
        Exit Do
    Loop
    
    '戻り値の編集
    If IsArray(vntArrMessage) Then
        CheckValueDmdPerModify = vntArrMessage
    End If
    
    Set objItem = Nothing
    Set objGrp = Nothing
    Set objOrganization = Nothing
    Set objCommon = Nothing
    
End Function

'
' 機能　　 : オプション名を取得する
'
' 引数　　 : (In)   lngCtrPtCd      契約パターンコード
' 　　　　 : (In)   lngOptCd        オプションコード
'
' 戻り値　 : オプション名
'
' 備考　　 :
'
Private Function GetOptName(ByVal lngCtrPtCd As Long, _
                            ByVal lngOptCd As Long _
                           ) As Variant
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objOptName              As OraField         'オプション名
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    GetOptName = ""
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CTRPTCD2", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "OPTCD2", lngOptCd, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '検索条件を満たす契約パターンオプション管理のレコードを取得
    strStmt = "SELECT OPTNAME             " & vbLf & _
              "  FROM CTRPT_OPT           " & vbLf & _
              " WHERE CTRPTCD = :CTRPTCD2 " & vbLf & _
              "   AND OPTCD   = :OPTCD2   "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objOptName = objFields("OPTNAME")
    
        '戻り値の設定
        GetOptName = objOptName.Value & ""
    
    End If
    
    Set objOraDyna = Nothing
    objOraParam.Remove "CTRPTCD2"
    objOraParam.Remove "OPTCD2"
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.GetOptName"
    
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
' 機能　　 : 個人請求金額取得
'
' 引数　　 : (In)     lngRsvNo          予約番号
' 　　　　   (In)     blnSummary        TRUE:合計金額を返す、FALSE:明細で返す
' 　　　　   (Out)    blnWithOther      TRUE:電話代などの医療費も返す、FALSE:医療費のみ
' 　　　　   (Out)    intSumDiv         金額合計分類
'                                       （基本的にCONSULT_Mの金額合計分類に準拠するが、
'                                         電話代などを含んだ場合は、90番台で返す。例；電話代:91)
' 　　　　   (Out)    strItemName       '適用名称（合計の場合は、合計）
' 　　　　   (Out)    lngPrice          '金額
' 　　　　   (Out)    lngTax            '税額
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function GetPersonalPrice(ByVal lngRsvNo As Long, _
                                 ByVal blnSummary As Boolean, _
                                 ByVal blnWithOther As Boolean, _
                                 Optional ByRef vntSumDiv As Variant, _
                                 Optional ByRef vntItemName As Variant, _
                                 Optional ByRef vntPrice As Variant, _
                                 Optional ByRef vntTax As Variant) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objSumDiv           As OraField         '金額合計分類
    Dim objItemName         As OraField         '明細名称
    Dim objPrice            As OraField         '金額税額
    Dim objTax              As OraField         '税額
    Dim objInsDiv           As OraField         '収納区分
    
    Dim vntArrSumDiv()      As Variant          '金額合計分類
    Dim vntArrItemName()    As Variant          '明細名称
    Dim vntArrPrice()       As Variant          '金額税額
    Dim vntArrTax()         As Variant          '税額
    Dim lngCount            As Long             'レコード数
    Dim i                   As Integer
    Dim lngTotalPrice       As Long
    Dim lngTotalTax         As Long
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    lngCount = 0
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '受診金額確定テーブル読み込み
    If blnSummary = True Then
        
        '合計金額を取得する場合
        strStmt = "SELECT SUM(( CONSULT_M.PRICE    + CONSULT_M.EDITPRICE )) PRICE, " & vbLf & _
                  "       SUM(( CONSULT_M.TAXPRICE + CONSULT_M.EDITTAX   )) TAX" & vbLf & _
                  "  FROM CONSULT_M" & vbLf & _
                  " WHERE CONSULT_M.RSVNO = :RSVNO" & vbLf & _
                  "   AND (" & vbLf & _
                  "       (CONSULT_M.ORGCD1 = 'XXXXX' AND CONSULT_M.ORGCD2 = 'XXXXX') OR" & vbLf & _
                  "       (CONSULT_M.ORGCD1 = 'WWWWW' AND CONSULT_M.ORGCD2 = 'WWWWW'))" & vbLf
    
    Else
        
        '明細イメージを取得する場合
        strStmt = "SELECT CONSULT_M.ITEMNAME, CONSULT_M.SUMDIV," & vbLf & _
                  "       ( CONSULT_M.PRICE    + CONSULT_M.EDITPRICE ) PRICE, " & vbLf & _
                  "       ( CONSULT_M.TAXPRICE + CONSULT_M.EDITTAX ) TAX" & vbLf & _
                  "  FROM CONSULT_M" & vbLf & _
                  " WHERE CONSULT_M.RSVNO = :RSVNO" & vbLf & _
                  "   AND (" & vbLf & _
                  "       (CONSULT_M.ORGCD1 = 'XXXXX' AND CONSULT_M.ORGCD2 = 'XXXXX') OR" & vbLf & _
                  "       (CONSULT_M.ORGCD1 = 'WWWWW' AND CONSULT_M.ORGCD2 = 'WWWWW'))" & vbLf & _
                  "       ORDER BY SEQ" & vbLf
    
    End If
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objPrice = objFields("PRICE")
        Set objTax = objFields("TAX")
        
        '明細イメージを取得する場合の設定
        If blnSummary = False Then
            Set objSumDiv = objFields("SUMDIV")
            Set objItemName = objFields("ITEMNAME")
        End If
        
        '配列形式で格納する
        lngCount = 0
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrPrice(lngCount)
            ReDim Preserve vntArrTax(lngCount)
            vntArrPrice(lngCount) = objPrice.Value
            vntArrTax(lngCount) = objTax.Value
            
            '明細イメージを取得する場合の設定
            If blnSummary = False Then
                ReDim Preserve vntArrSumDiv(lngCount)
                ReDim Preserve vntArrItemName(lngCount)
                vntArrSumDiv(lngCount) = objSumDiv.Value
                vntArrItemName(lngCount) = objItemName.Value
            End If
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '一度初期化
    Set objOraDyna = Nothing
    Set objFields = Nothing
    Set objPrice = Nothing
    Set objTax = Nothing
    
    '健診以外の金額も読み込む場合
    If blnWithOther = True Then
    
        '財務連携テーブル読み込み（収納区分が健診以外のもの）
        strStmt = "SELECT INSDIV, SUM(PRICE) PRICE, SUM(TAXPRICE) TAX" & vbLf & _
                  "  FROM CONSULT_ZAIMU" & vbLf & _
                  " WHERE RSVNO = :RSVNO" & vbLf & _
                  "   AND INSDIV != 0" & vbLf & _
                  "   AND INZAIMUSEQ IS NULL" & vbLf & _
                  " GROUP BY INSDIV ORDER BY INSDIV"
        
        Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
        '検索レコードが存在する場合
        If Not objOraDyna.EOF Then
        
            'オブジェクトの参照設定
            Set objFields = objOraDyna.Fields
            Set objPrice = objFields("PRICE")
            Set objTax = objFields("TAX")
            Set objInsDiv = objFields("INSDIV")
        
            '配列形式で格納する
            Do Until objOraDyna.EOF
                
                ReDim Preserve vntArrPrice(lngCount)
                ReDim Preserve vntArrTax(lngCount)
                vntArrPrice(lngCount) = objPrice.Value
                vntArrTax(lngCount) = objTax.Value
                    
                '明細イメージを取得する場合の設定
                If blnSummary = False Then
                    ReDim Preserve vntArrSumDiv(lngCount)
                    ReDim Preserve vntArrItemName(lngCount)
                    Select Case objInsDiv.Value
                        Case "1"
                            vntArrItemName(lngCount) = "電話代"
                        
                        Case "2"
                            vntArrItemName(lngCount) = "文書作成料"
                    
                        Case "3"
                            vntArrItemName(lngCount) = "その他"
                    
                    End Select
                    
                    '医療行為以外の区分は90番台で返す
                    vntArrSumDiv(lngCount) = "9" & objInsDiv.Value
                    
                End If
                
                lngCount = lngCount + 1
                objOraDyna.MoveNext
            Loop
            
        End If
    
    End If
    
    If lngCount > 0 Then
        
        If blnSummary = True Then
            
            'サマリの場合、合計金額を返す
            lngTotalPrice = 0
            lngTotalTax = 0
            For i = 0 To lngCount - 1
                lngTotalPrice = lngTotalPrice + vntArrPrice(i)
                lngTotalTax = lngTotalTax + vntArrTax(i)
            Next i
        
            If IsMissing(vntSumDiv) = False Then vntSumDiv = "*"
            If IsMissing(vntItemName) = False Then vntItemName = "合計"
            If IsMissing(vntPrice) = False Then vntPrice = lngTotalPrice
            If IsMissing(vntTax) = False Then vntTax = lngTotalTax
        
        Else
        
            '明細の場合
            If IsMissing(vntSumDiv) = False Then vntSumDiv = vntArrSumDiv
            If IsMissing(vntItemName) = False Then vntItemName = vntArrItemName
            If IsMissing(vntPrice) = False Then vntPrice = vntArrPrice
            If IsMissing(vntTax) = False Then vntTax = vntArrTax
        
        End If
    
    End If
    
    '戻り値の設定
    GetPersonalPrice = lngCount
        
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

    GetPersonalPrice = -1
    
    'イベントログ書き込み
    WriteErrorLog "Demand.GetPersonalPrice"
    
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
' 機能　　 : 指定予約番号の負担金額情報を取得する
'
' 引数　　 : (In)     lngRsvNo        予約番号
' 　　　　   (Out)    vntOrgName      団体名称
' 　　　　   (Out)    vntCourcePrice  基本コース負担金額
' 　　　　   (Out)    vntOptionPrice  オプション負担金額
' 　　　　   (Out)    vntNoCtrPrice   契約外項目負担金額
' 　　　　   (Out)    vntTax          消費税
' 　　　　   (Out)    vntTotalPrice   負担金額計
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function GetOrgSummaryPriceFromRsvNo( _
    ByVal lngRsvNo As Long, _
    ByRef vntOrgName As Variant, _
    ByRef vntCourcePrice As Variant, _
    ByRef vntOptionPrice As Variant, _
    ByRef vntNoCtrPrice As Variant, _
    ByRef vntTax As Variant, _
    ByRef vntTotalPrice As Variant _
) As Long

    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objOrgCd1           As OraField         '団体コード1
    Dim objOrgCd2           As OraField         '団体コード2
    Dim objOrgName          As OraField         '団体名称
    Dim objCoursePrice      As OraField         '基本コース負担金額
    Dim objOptionPrice      As OraField         'オプション負担金額
    Dim objNoCtrPrice       As OraField         '契約外項目負担金額
    Dim objTax              As OraField         '消費税
    Dim objTotalPrice       As OraField         '負担金額計
    
    Dim vntArrOrgCd1()      As Variant          '団体コード1の配列
    Dim vntArrOrgCd2()      As Variant          '団体コード2の配列
    Dim vntArrOrgName()     As Variant          '団体名称の配列
    Dim vntArrCoursePrice() As Variant          '基本コース負担金額の配列
    Dim vntArrOptionPrice() As Variant          'オプション負担金額の配列
    Dim vntArrNoCtrPrice()  As Variant          '契約外項目負担金額の配列
    Dim vntArrTax()         As Variant          '消費税の配列
    Dim vntArrTotalPrice()  As Variant          '負担金額計の配列
    Dim lngCount            As Long             'レコード数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    vntOrgName = Empty
    vntCourcePrice = Empty
    vntOptionPrice = Empty
    vntNoCtrPrice = Empty
    vntTax = Empty
    vntTotalPrice = Empty

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER

    '請求情報ストアドパッケージの関数呼び出し
    strStmt = "BEGIN DemandPackage.GetOrgSummaryPriceFromRsvNo(:RSVNO, :SummaryInfoCursor); END;"

    Set objOraDyna = mobjOraDb.CreatePlsqlDynaset(strStmt, "SummaryInfoCursor", ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then

        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objOrgName = objFields("ORGNAME")
        Set objCoursePrice = objFields("COURSEPRICE")
        Set objOptionPrice = objFields("OPTIONPRICE")
        Set objNoCtrPrice = objFields("NOCTRPRICE")
        Set objTax = objFields("TAX")
        Set objTotalPrice = objFields("TOTALPRICE")

        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrOrgCd1(lngCount)
            ReDim Preserve vntArrOrgCd2(lngCount)
            ReDim Preserve vntArrOrgName(lngCount)
            ReDim Preserve vntArrCoursePrice(lngCount)
            ReDim Preserve vntArrOptionPrice(lngCount)
            ReDim Preserve vntArrNoCtrPrice(lngCount)
            ReDim Preserve vntArrTax(lngCount)
            ReDim Preserve vntArrTotalPrice(lngCount)
            vntArrOrgCd1(lngCount) = objOrgCd1.Value & ""
            vntArrOrgCd2(lngCount) = objOrgCd2.Value & ""
            vntArrOrgName(lngCount) = objOrgName.Value & ""
            vntArrCoursePrice(lngCount) = objCoursePrice.Value & ""
            vntArrOptionPrice(lngCount) = objOptionPrice.Value & ""
            vntArrNoCtrPrice(lngCount) = objNoCtrPrice.Value & ""
            vntArrTax(lngCount) = objTax.Value & ""
            vntArrTotalPrice(lngCount) = objTotalPrice.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        vntOrgName = vntArrOrgName
        vntCourcePrice = vntArrCoursePrice
        vntOptionPrice = vntArrOptionPrice
        vntNoCtrPrice = vntArrNoCtrPrice
        vntTax = vntArrTax
        vntTotalPrice = vntArrTotalPrice

    End If
    
    '戻り値の設定
    GetOrgSummaryPriceFromRsvNo = lngCount
    
'### 2002.04.29 Added by Ishihara@FSIT 一時表がOracleの仕様から使用できなくなったため、実表に変更
    '一時表（本当は実表だが・・・）のデータを消す
    strStmt = "DELETE MONEY_DETAILS_TEMP WHERE RSVNO = :RSVNO"
    mobjOraDb.ExecuteSQL strStmt
'### 2002.04.15 Added End
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function

ErrorHandle:

    GetOrgSummaryPriceFromRsvNo = -1

    'イベントログ書き込み
    WriteErrorLog "Demand.GetOrgSummaryPriceFromRsvNo"
    
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
' 機能　　 : 締めフラグを取得する
'
' 引数　　 : (In)   lngRsvNo        予約番号
' 　　　　 : (In)   lngCtrPtCd      契約パターンコード
'
' 戻り値　 : 締めフラグ（0:締め処理は行われていない, 1:締め処理が完了している）
'
' 備考　　 :
'
Private Function GetCloseFlg(ByVal lngRsvNo As Long, _
                             ByVal lngCtrPtCd As Long _
                            ) As Variant
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objCloseFlg             As OraField         '締めフラグ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    GetCloseFlg = CLng("0")
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO5", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CTRPTCD5", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '締めフラグを取得
    strStmt = "SELECT DECODE(COUNT(*),0,0,1) CLOSEFLG " & vbLf & _
              "  FROM CLOSEMNG                        " & vbLf & _
              " WHERE CLOSEMNG.RSVNO   = :RSVNO5      " & vbLf & _
              "   AND CLOSEMNG.CTRPTCD = :CTRPTCD5    "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCloseFlg = objFields("CLOSEFLG")
    
        '戻り値の設定
        GetCloseFlg = CLng(objCloseFlg.Value & "")
    
    End If
    
    Set objOraDyna = Nothing
    objOraParam.Remove "RSVNO5"
    objOraParam.Remove "CTRPTCD5"
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.GetCloseFlg"
    
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
' 機能　　 : 消費税を再計算する
'
' 引数　　 : (In)   strTaxFraction  税端数区分
' 　　　　 : (In)   dblNowTax       適用税率
' 　　　　 : (In)   vntSeq          （配列）ＳＥＱ
' 　　　　 : (In)   vntPriceType    （配列）タイプ（0:基本コース, 1:基本コースの削除項目, 2:オプション検査, 3:契約外追加グループ, 4:契約外追加項目）
' 　　　　 : (In)   vntOptCd        （配列）オプションコード
' 　　　　 : (In)   vntGrpCd        （配列）グループコード
' 　　　　 : (In)   vntItemCd       （配列）検査項目コード
' 　　　　 : (In)   vntPrice        （配列）請求金額（"-9999999"～"9999999":金額）
' 　　　　 : (In)   vntEditPrice    （配列）調整金額（"*-hidden-*":非表示, "":"0"と同義, "-9999999"～"9999999":金額）
' 　　　　 : (Out)  vntTax          （配列）消費税金額（"*-hidden-*":非表示, "-9999999"～"9999999":金額）
' 　　　　 : (In)   vntTaxFlg       （配列）消費税負担フラグ（0:負担しない, 1:負担する）
' 　　　　 : (In)   lngCount        レコード件数（配列の要素数）
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function CompTax(ByVal strTaxFraction As String, _
                        ByVal dblNowTax As Double, _
                        ByVal vntSeq As Variant, _
                        ByVal vntPriceType As Variant, _
                        ByVal vntOptCd As Variant, _
                        ByVal vntGrpCd As Variant, _
                        ByVal vntItemCd As Variant, _
                        ByVal vntPrice As Variant, _
                        ByVal vntEditPrice As Variant, _
                        ByRef vntTax As Variant, _
                        ByVal vntTaxFlg As Variant, _
                        ByVal lngCount As Long _
                       ) As Boolean
    
    Dim lngCompTaxType          As Long             '消費税計算方式（1:１つの負担元が負担, 以外:各負担元が負担）
    
    Dim lngCompPrice            As Long             '（計算用）請求金額合計
    Dim dblCompTax              As Double           '（計算用）消費税金額
    Dim lngCompTax              As Long             '（計算用）消費税金額
    
    Dim strSeq                  As String           'ブレイクキー保存（負担元）
    Dim lngTaxFlg               As Long             'ブレイクキー保存（消費税負担フラグ）
    Dim lngIndex                As Long             'ブレイクキー保存（消費税格納位置）
    
    Dim i                       As Long             'インデックス
    
    '初期処理
    CompTax = False
    
    '*******************************************************************************************************************
    
    '消費税計算方式を求める（消費税負担フラグが１つしか立ってないか、複数立っているか）
    lngCompTaxType = 0
    For i = 0 To (lngCount - 1)
        '消費税負担対象数をカウント
        If vntTaxFlg(i) <> 0 Then
            lngCompTaxType = lngCompTaxType + 1
        End If
    Next i
    
    '１つの負担元がすべての消費税を負担する場合
    If lngCompTaxType = 1 Then
    
        '請求金額の総合計を計算
        lngCompPrice = 0
        For i = 0 To (lngCount - 1)
            '請求金額を加算
            lngCompPrice = lngCompPrice + vntPrice(i)
            '調整金額を加算
            If Trim(vntEditPrice(i)) <> "*-hidden-*" Then
                If IsNumeric(Trim(vntEditPrice(i))) Then
                    lngCompPrice = lngCompPrice + CLng(Trim(vntEditPrice(i)))
                End If
            End If
        Next i
    
        '消費税金額を計算（端数処理前）
        dblCompTax = lngCompPrice * dblNowTax
    
        '消費税金額を、税金端数区分の内容に従い計算
        lngCompTax = CompDevideTax(strTaxFraction, dblCompTax)
    
        '計算された消費税金額を格納
        For i = 0 To (lngCount - 1)
            '消費税負担対象の負担元に格納
            If vntTaxFlg(i) <> 0 Then
                vntTax(i) = lngCompTax
                Exit For
            End If
        Next i
    
    '各負担元がそれぞれの消費税を負担する場合
    Else
    
        '負担元ごとに処理する
        strSeq = ""
        For i = 0 To (lngCount - 1)
    
            '負担元キーブレイク時
            If i > 0 And strSeq <> CStr(vntSeq(i)) Then
                '該当負担元が消費税負担対象の場合
                If lngTaxFlg <> 0 Then
                    '消費税金額を計算（端数処理前）
                    dblCompTax = lngCompPrice * dblNowTax
                    '消費税金額を、税金端数区分の内容に従い計算
                    lngCompTax = CompDevideTax(strTaxFraction, dblCompTax)
                    '計算された消費税金額を格納
                    vntTax(lngIndex) = lngCompTax
                End If
            End If
        
            '負担元キーブレイク時
            If i = 0 Or strSeq <> CStr(vntSeq(i)) Then
                '計算用領域のクリア
                lngCompPrice = 0
                '該当負担元の消費税負担フラグと消費税格納位置を保存
                lngTaxFlg = vntTaxFlg(i)
                lngIndex = i
            End If
    
            '該当負担元が消費税負担対象の場合
            If lngTaxFlg <> 0 Then
                '請求金額を加算
                lngCompPrice = lngCompPrice + vntPrice(i)
                '調整金額を加算
                If Trim(vntEditPrice(i)) <> "*-hidden-*" Then
                    If IsNumeric(Trim(vntEditPrice(i))) Then
                        lngCompPrice = lngCompPrice + CLng(Trim(vntEditPrice(i)))
                    End If
                End If
            End If
    
            'ブレイクキー保存（負担元）
            strSeq = CStr(vntSeq(i))
    
        Next i
    
        'データが１つ以上ある時
        If lngCount > 0 Then
            '最後の負担元が消費税負担対象の場合
            If lngTaxFlg <> 0 Then
                '消費税金額を計算（端数処理前）
                dblCompTax = lngCompPrice * dblNowTax
                '消費税金額を、税金端数区分の内容に従い計算
                lngCompTax = CompDevideTax(strTaxFraction, dblCompTax)
                '計算された消費税金額を格納
                vntTax(lngIndex) = lngCompTax
            End If
        End If
    
    End If
    
    '*******************************************************************************************************************
    
    '戻り値の設定
    CompTax = True
    
End Function

'
' 機能　　 : 検索条件を満たす受診者情報の件数を取得する（受診者の検索（個人別請求金額修正））
'
' 引数　　 : (In)   strStrDate      受診日（開始）
' 　　　　 : (In)   strEndDate      受診日（終了）
' 　　　　 : (In)   strOrgCd1       団体コード1
' 　　　　 : (In)   strOrgCd2       団体コード2
' 　　　　 : (In)   strPerID        個人ＩＤ
' 　　　　 : (In)   strCsCd         コースコード
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectDmdSearchListCount(ByVal strStrDate As String, _
                                         ByVal strEndDate As String, _
                                         ByVal strOrgCd1 As String, _
                                         ByVal strOrgCd2 As String, _
                                         ByVal strPerID As String, _
                                         ByVal strCsCd As String _
                                        ) As Long
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objCount                As OraField         '検索件数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    SelectDmdSearchListCount = 0
    
    '検索条件が設定されていない場合はエラー
    If Not (IsDate(Trim(strStrDate)) And IsDate(Trim(strEndDate))) Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "STRDATE", Trim(strStrDate), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ENDDATE", Trim(strEndDate), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "PERID", Trim(strPerID), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CANCELFLG", CLng(CONSULT_USED), ORAPARM_INPUT, ORATYPE_NUMBER
    
    '検索条件を満たす受診者情報のレコード件数を取得
    strStmt = "SELECT COUNT(*) RECCOUNT                       " & vbLf & _
              "  FROM CONSULT                                 " & vbLf & _
              " WHERE CSLDATE   BETWEEN :STRDATE AND :ENDDATE " & vbLf & _
              "   AND CANCELFLG = :CANCELFLG                  "

    '条件節を追加
    If Trim(strOrgCd1) <> "" Or _
       Trim(strOrgCd2) <> "" Then               '団体指定あり
        strStmt = strStmt & vbLf & _
              "   AND ORGCD1    = :ORGCD1 " & vbLf & _
              "   AND ORGCD2    = :ORGCD2 "
    End If
    If Trim(strPerID) <> "" Then                '個人ＩＤ指定あり
        strStmt = strStmt & vbLf & _
              "   AND PERID     = :PERID  "
    End If
    If Trim(strCsCd) <> "" Then                 'コースコード指定あり
        strStmt = strStmt & vbLf & _
              "   AND CSCD      = :CSCD   "
    End If
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    '(COUNT関数を発行しているので必ず1レコード返ってくる)
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCount = objFields("RECCOUNT")
    
        '戻り値の設定
        SelectDmdSearchListCount = CLng(objCount.Value & "")
    
    End If
    
    Set objOraDyna = Nothing
    objOraParam.Remove "STRDATE"
    objOraParam.Remove "ENDDATE"
    objOraParam.Remove "ORGCD1"
    objOraParam.Remove "ORGCD2"
    objOraParam.Remove "PERID"
    objOraParam.Remove "CSCD"
    objOraParam.Remove "CANCELFLG"
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.SelectDmdSearchListCount"
    
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
' 機能　　 : 検索条件を満たす金額情報のCSVファイルを出力する
'
' 引数　　 : (In)   strFileName     ファイル名
' 　　　　 : (In)   strStrDate      受診日（開始）
' 　　　　 : (In)   vntEndDate      受診日（終了）
' 　　　　 : (In)   vntCsCd         コースコード
' 　　　　 : (In)   vntOrgCd1       団体コード1
' 　　　　 : (In)   vntOrgCd2       団体コード2
' 　　　　 : (In)   vntSelectMode   NULL:全て、1:基本コースのみ、2:オプションのみ
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectDmdCsvList(ByVal strFileName As String, _
                                 ByVal strStrDate As String, _
                                 Optional ByVal vntEndDate As Variant, _
                                 Optional ByVal vntCsCd As Variant, _
                                 Optional ByVal vntOrgCd1 As Variant, _
                                 Optional ByVal vntOrgCd2 As Variant, _
                                 Optional ByVal vntSelectMode As Variant _
                                 ) As Long
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント
    
    Dim objFields           As OraFields        'フィールドオブジェクト
    Dim objCslDate          As OraField         '受診日
    Dim objRsvNo            As OraField         '予約番号
    Dim objCsCd             As OraField         'コースコード
    Dim objCsName           As OraField         'コース名
    Dim objOrgCd1           As OraField         '受診団体コード1
    Dim objOrgCd2           As OraField         '受診団体コード2
    Dim objOrgName          As OraField         '受診団体名
    Dim objPerId            As OraField         '個人ID
    Dim objCslName          As OraField         '受診者名
    Dim objBurdenOrgCd1     As OraField         '負担元団体コード1
    Dim objBurdenOrgCd2     As OraField         '負担元団体コード2
    Dim objBurdenOrgName    As OraField         '負担元名
    Dim objItemName         As OraField         '受診項目名
    Dim objPrice            As OraField         '金額
    Dim objTax              As OraField         '税額
    '## 2002.6.6 ADD ST FAS) C.M
    Dim objempNo            As OraField         '従業員番号
    Dim objgender           As OraField         '性別
    Dim obage               As OraField         '年齢
    '## 2002.6.6 ADD ED FAS) C.M
    Dim lngFileNumber       As Long             'ファイル番号
    Dim lngCount            As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    SelectDmdCsvList = 0
    
    '開始日付が設定されていない場合はエラー
    If IsDate(Trim(strStrDate)) = False Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    '終了日付が設定されていない場合は開始日付をセット
    If IsMissing(vntEndDate) = True Then
        vntEndDate = strStrDate
    Else
        If IsDate(Trim(vntEndDate)) = False Then
            Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
            Exit Function
        End If
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "STRDATE", CDate(Trim(strStrDate)), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ENDDATE", CDate(Trim(vntEndDate)), ORAPARM_INPUT, ORATYPE_DATE
    
    '検索条件を満たす金額情報を取得
'## 2002.6.6 ADD ST FAS)C.M
'    strStmt = "SELECT CONSULT.CSLDATE,    CONSULT.RSVNO,  CONSULT.CSCD, COURSE_P.CSNAME," & vbLf & _
'              "       CONSULT.ORGCD1,     CONSULT.ORGCD2, MAINORG.ORGNAME," & vbLf & _
'              "       CONSULT.PERID,      PERSON.LASTNAME || '　' ||  PERSON.FIRSTNAME CSLNAME," & vbLf & _
'              "       CONSULT_M.ORGCD1 BURDENORGCD1,   CONSULT_M.ORGCD2 BURDENORGCD2, BURDENORG.ORGNAME BURDENORGNAME," & vbLf & _
'              "       CONSULT_M.ITEMNAME, CONSULT_M.PRICE + CONSULT_M.EDITPRICE PRICE, CONSULT_M.TAXPRICE + CONSULT_M.EDITTAX TAX" & vbLf & _
'              "  FROM ORG BURDENORG, CONSULT_M, COURSE_P, ORG MAINORG, PERSON, CONSULT" & vbLf & _
'              " WHERE CONSULT.CSLDATE BETWEEN :STRDATE AND :ENDDATE" & vbLf & _
'              "   AND CONSULT.CANCELFLG = 0" & vbLf & _
'              "   AND CONSULT.PERID     = PERSON.PERID" & vbLf & _
'              "   AND CONSULT.ORGCD1    = MAINORG.ORGCD1" & vbLf & _
'              "   AND CONSULT.ORGCD2    = MAINORG.ORGCD2" & vbLf & _
'              "   AND CONSULT.CSCD      = COURSE_P.CSCD" & vbLf & _
'              "   AND CONSULT_M.RSVNO   = CONSULT.RSVNO" & vbLf & _
'              "   AND CONSULT_M.ORGCD1  = BURDENORG.ORGCD1" & vbLf & _
'              "   AND CONSULT_M.ORGCD2  = BURDENORG.ORGCD2" & vbLf & _
'              "   AND ( CONSULT_M.PRICE != 0 OR CONSULT_M.EDITPRICE != 0 OR CONSULT_M.TAXPRICE != 0 OR CONSULT_M.EDITTAX != 0 )" & vbLf
    strStmt = "SELECT CONSULT.CSLDATE,    CONSULT.RSVNO,  CONSULT.CSCD, COURSE_P.CSNAME," & vbLf & _
              "       CONSULT.ORGCD1,     CONSULT.ORGCD2, MAINORG.ORGNAME," & vbLf & _
              "       CONSULT.PERID,      PERSON.LASTNAME || '　' ||  PERSON.FIRSTNAME CSLNAME," & vbLf & _
              "       CONSULT_M.ORGCD1 BURDENORGCD1,   CONSULT_M.ORGCD2 BURDENORGCD2, BURDENORG.ORGNAME BURDENORGNAME," & vbLf & _
              "       CONSULT_M.ITEMNAME, CONSULT_M.PRICE + CONSULT_M.EDITPRICE PRICE, CONSULT_M.TAXPRICE + CONSULT_M.EDITTAX TAX," & vbLf & _
              "       CONSULT.AGE, PERSON.GENDER, PERSONDETAIL.EMPNO " & vbLf & _
              "  FROM ORG BURDENORG, CONSULT_M, COURSE_P, ORG MAINORG, PERSON, PERSONDETAIL, CONSULT" & vbLf & _
              " WHERE CONSULT.CSLDATE BETWEEN :STRDATE AND :ENDDATE" & vbLf & _
              "   AND CONSULT.CANCELFLG = 0" & vbLf & _
              "   AND CONSULT.PERID     = PERSON.PERID" & vbLf & _
              "   AND CONSULT.PERID     = PERSONDETAIL.PERID" & vbLf & _
              "   AND CONSULT.ORGCD1    = MAINORG.ORGCD1" & vbLf & _
              "   AND CONSULT.ORGCD2    = MAINORG.ORGCD2" & vbLf & _
              "   AND CONSULT.CSCD      = COURSE_P.CSCD" & vbLf & _
              "   AND CONSULT_M.RSVNO   = CONSULT.RSVNO" & vbLf & _
              "   AND CONSULT_M.ORGCD1  = BURDENORG.ORGCD1" & vbLf & _
              "   AND CONSULT_M.ORGCD2  = BURDENORG.ORGCD2" & vbLf & _
              "   AND ( CONSULT_M.PRICE != 0 OR CONSULT_M.EDITPRICE != 0 OR CONSULT_M.TAXPRICE != 0 OR CONSULT_M.EDITTAX != 0 )" & vbLf
'## 2002.6.6 ADD ED FAS)C.M

    '省略可能なキー値のセット～コースコード
    If IsMissing(vntCsCd) = False Then
        If Trim(vntCsCd) <> "" Then
            objOraParam.Add "CSCD", Trim(vntCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
            strStmt = strStmt & " AND CONSULT.CSCD = :CSCD" & vbLf
        End If
    End If
    
    '省略可能なキー値のセット～団体コード１
    If IsMissing(vntOrgCd1) = False Then
        If Trim(vntOrgCd1) <> "" Then
            objOraParam.Add "ORGCD1", Trim(vntOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
            strStmt = strStmt & " AND CONSULT.ORGCD1 = :ORGCD1" & vbLf
        End If
    End If
    
    '省略可能なキー値のセット～団体コード２
    If IsMissing(vntOrgCd2) = False Then
        If Trim(vntOrgCd2) <> "" Then
            objOraParam.Add "ORGCD2", Trim(vntOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
            strStmt = strStmt & " AND CONSULT.ORGCD2 = :ORGCD2" & vbLf
        End If
    End If

    '省略可能なキー値のセット～抽出モード
    If IsMissing(vntSelectMode) = False Then
        Select Case Trim(vntSelectMode)
            Case "1"
                strStmt = strStmt & "   AND CONSULT_M.OPTCD = 0" & vbLf
            Case "2"
                strStmt = strStmt & "   AND CONSULT_M.OPTCD != 0" & vbLf
        End Select
    End If

    strStmt = strStmt & _
              " ORDER BY CONSULT.CSLDATE, CONSULT.CSCD, CONSULT.RSVNO, CONSULT_M.SEQ, CONSULT_M.SUMDIV"

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        Set objFields = objOraDyna.Fields
        Set objCslDate = objFields("CSLDATE")
        Set objRsvNo = objFields("RSVNO")
        Set objCsCd = objFields("CSCD")
        Set objCsName = objFields("CSNAME")
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objOrgName = objFields("ORGNAME")
        Set objPerId = objFields("PERID")
        Set objCslName = objFields("CSLNAME")
        Set objBurdenOrgCd1 = objFields("BURDENORGCD1")
        Set objBurdenOrgCd2 = objFields("BURDENORGCD2")
        Set objBurdenOrgName = objFields("BURDENORGNAME")
        Set objItemName = objFields("ITEMNAME")
        Set objPrice = objFields("PRICE")
        Set objTax = objFields("TAX")
        '## 2002.6.6 ADD ST FAS) C.M
        Set objempNo = objFields("EMPNO")
        Set objgender = objFields("GENDER")
        Set obage = objFields("AGE")
        '## 2002.6.6 ADD ED FAS) C.M
        'ファイルオープン
        lngFileNumber = FreeFile
        Open strFileName For Output As #lngFileNumber
    
        'ヘッダー行出力
'## 2002.6.6 ADD ST FAS)C.M
'        Print #lngFileNumber, "受診日,予約番号,コースコード,コース名,受診団体コード1,受診団体コード2,受診団体名,個人ID,受診者名,負担元団体コード1,負担元団体コード2,負担元名,受診項目名,金額,税額"
        Print #lngFileNumber, "受診日,予約番号,コースコード,コース名,受診団体コード1,受診団体コード2,受診団体名,個人ID,従業員ID,性別,受診時年齢,受診者名,負担元団体コード1,負担元団体コード2,負担元名,受診項目名,金額,税額"
'## 2002.6.6 ADD ED FAS)C.M
    
        '明細行出力
        Do Until objOraDyna.EOF
            Write #lngFileNumber, _
                  objCslDate.Value & "", _
                  objRsvNo.Value & "", _
                  objCsCd.Value & "", _
                  objCsName.Value & "", _
                  objOrgCd1.Value & "", _
                  objOrgCd2.Value & "", _
                  objOrgName.Value & "", _
                  objPerId.Value & "", _
                  objempNo.Value & "", _
                  IIf(objgender.Value = "1", "男性", "女性") & "", _
                  obage.Value & "", _
                  objCslName.Value & "", _
                  objBurdenOrgCd1.Value & "", _
                  objBurdenOrgCd2.Value & "", _
                  objBurdenOrgName.Value & "", _
                  objItemName.Value & "", _
                  objPrice.Value & "", _
                  objTax.Value & ""
            
                lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
        'ファイルクローズ
        Close #lngFileNumber
    
    End If
    
    '戻り値の設定
    SelectDmdCsvList = lngCount
    
    Set objOraDyna = Nothing
    With objOraParam
        Do Until .Count <= 0
            .Remove (.Count - 1)
        Loop
    End With
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.SelectDmdCsvList"
    
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
' 機能　　 : 検索条件を満たす受診者の一覧を取得する（受診者の検索（個人別請求金額修正））
'
' 引数　　 : (In)   strStrDate      受診日（開始）
' 　　　　 : (In)   strEndDate      受診日（終了）
' 　　　　 : (In)   strOrgCd1       団体コード1
' 　　　　 : (In)   strOrgCd2       団体コード2
' 　　　　 : (In)   strPerID        個人ＩＤ
' 　　　　 : (In)   strCsCd         コースコード
' 　　　　 : (In)   lngSortKey      ソート順（0:基本表示順（受診日，当日ID，コース，団体（カナ），氏名（カナ）））
' 　　　　 : (In)   lngStartPos     開始位置
' 　　　　 : (In)   strGetCount     取得件数
' 　　　　 : (Out)  vntCslDate      受診日（"yyyy年m月d日"編集）
' 　　　　 : (Out)  vntDayID        当日ID（"0001"編集）
' 　　　　 : (Out)  vntWebColor     コース名表示色
' 　　　　 : (Out)  vntCsName       コース名
' 　　　　 : (Out)  vntLastName     姓
' 　　　　 : (Out)  vntFirstName    名
' 　　　　 : (Out)  vntLastKName    カナ姓
' 　　　　 : (Out)  vntFirstKName   カナ名
' 　　　　 : (Out)  vntOrgName      団体名
' 　　　　 : (Out)  vntOrgSName     団体略称
' 　　　　 : (Out)  vntCoursePrice  基本コース金額（"1,234"編集）
' 　　　　 : (Out)  vntOptionPrice  オプション金額（"1,234"編集）
' 　　　　 : (Out)  vntOtherPrice   契約外金額（"1,234"編集）
' 　　　　 : (Out)  vntTaxPrice     消費税金額（"1,234"編集）
' 　　　　 : (Out)  vntTotalPrice   合計金額（"1,234"編集）
' 　　　　 : (Out)  vntTimeFra      時間枠
' 　　　　 : (Out)  vntTimeFraName  時間枠名称
' 　　　　 : (Out)  vntCntlNo       管理番号（"0001"編集）
' 　　　　 : (Out)  vntGenderName   性別名称
' 　　　　 : (Out)  vntBirth        生年月日（"yyyy/mm/dd"編集）
' 　　　　 : (Out)  vntAge          年齢
' 　　　　 : (Out)  vntRsvDate      予約日（"yyyy年m月d日"編集）
' 　　　　 : (Out)  vntRsvNo        予約番号
' 　　　　 : (Out)  vntPerID        個人ＩＤ
' 　　　　 : (Out)  vntIncomePrice  入金済み金額
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 : 取得件数が"*"の時、検索条件を満たすレコードすべてを抽出する
'
Public Function SelectDmdSearchList(ByVal strStrDate As String, ByVal strEndDate As String, _
                                    ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, _
                                    ByVal strPerID As String, ByVal strCsCd As String, _
                                    ByVal lngSortKey As Long, ByVal lngStartPos As Long, _
                                    ByVal strGetCount As String, _
                                    ByRef vntCslDate As Variant, ByRef vntDayId As Variant, _
                                    ByRef vntWebColor As Variant, ByRef vntCsName As Variant, _
                                    ByRef vntLastName As Variant, ByRef vntFirstName As Variant, _
                                    ByRef vntLastKName As Variant, ByRef vntFirstKName As Variant, _
                                    ByRef vntOrgName As Variant, ByRef vntOrgSName As Variant, _
                                    ByRef vntCoursePrice As Variant, ByRef vntOptionPrice As Variant, _
                                    ByRef vntOtherPrice As Variant, ByRef vntTaxPrice As Variant, _
                                    ByRef vntTotalPrice As Variant, ByRef vntTimeFra As Variant, _
                                    ByRef vntTimeFraName As Variant, ByRef vntCntlNo As Variant, _
                                    ByRef vntGenderName As Variant, ByRef vntBirth As Variant, _
                                    ByRef vntAge As Variant, ByRef vntRsvDate As Variant, _
                                    ByRef vntRsvNo As Variant, ByRef vntPerId As Variant, _
                                    Optional ByRef vntIncomePrice As Variant _
                                   ) As Long
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim objOraDyna2             As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    Dim strIncomeStmt           As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objCslDate              As OraField         '受診日（"yyyy/mm/dd"編集）
    Dim objDayId                As OraField         '当日ID（"0001"編集）
    Dim objWebColor             As OraField         'コース名表示色
    Dim objCsName               As OraField         'コース名
    Dim objLastName             As OraField         '姓
    Dim objFirstName            As OraField         '名
    Dim objLastKName            As OraField         'カナ姓
    Dim objFirstKName           As OraField         'カナ名
    Dim objOrgName              As OraField         '団体名
    Dim objOrgSName             As OraField         '団体略称
    Dim objTimeFra              As OraField         '時間枠
    Dim objCntlNo               As OraField         '管理番号（"0001"編集）
    Dim objgender               As OraField         '性別
    Dim objBirth                As OraField         '生年月日（"yyyy/mm/dd"編集）
    Dim objAge                  As OraField         '年齢
    Dim objRsvDate              As OraField         '予約日（"yyyy/mm/dd"編集）
    Dim objRsvNo                As OraField         '予約番号
    Dim objPerId                As OraField         '個人ＩＤ
    
    Dim objCommon               As Common           '共通クラス
    
    Dim vntArrCslDate()         As Variant          '受診日の配列（"yyyy年m月d日"編集）
    Dim vntArrDayId()           As Variant          '当日IDの配列（"0001"編集）
    Dim vntArrWebColor()        As Variant          'コース名表示色の配列
    Dim vntArrCsName()          As Variant          'コース名の配列
    Dim vntArrLastName()        As Variant          '姓の配列
    Dim vntArrFirstName()       As Variant          '名の配列
    Dim vntArrLastKName()       As Variant          'カナ姓の配列
    Dim vntArrFirstKName()      As Variant          'カナ名の配列
    Dim vntArrOrgName()         As Variant          '団体名の配列
    Dim vntArrOrgSName()        As Variant          '団体略称の配列
    Dim vntArrCoursePrice()     As Variant          '基本コース金額の配列（"1,234"編集）
    Dim vntArrOptionPrice()     As Variant          'オプション金額の配列（"1,234"編集）
    Dim vntArrOtherPrice()      As Variant          '契約外金額の配列（"1,234"編集）
    Dim vntArrTaxPrice()        As Variant          '消費税金額の配列（"1,234"編集）
    Dim vntArrTotalPrice()      As Variant          '合計金額の配列（"1,234"編集）
    Dim vntArrTimeFra()         As Variant          '時間枠の配列
    Dim vntArrTimeFraName()     As Variant          '時間枠名称の配列
    Dim vntArrCntlNo()          As Variant          '管理番号の配列（"0001"編集）
    Dim vntArrGenderName()      As Variant          '性別名称の配列
    Dim vntArrBirth()           As Variant          '生年月日の配列（"yyyy/mm/dd"編集）
    Dim vntArrAge()             As Variant          '年齢の配列
    Dim vntArrRsvDate()         As Variant          '予約日の配列（"yyyy年m月d日"編集）
    Dim vntArrRsvNo()           As Variant          '予約番号の配列
    Dim vntArrPerId()           As Variant          '個人ＩＤの配列
    Dim vntArrIncomePrice()     As Variant          '入金額の配列
    
    Dim lngCount                As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntCslDate = Empty
    vntDayId = Empty
    vntWebColor = Empty
    vntCsName = Empty
    vntLastName = Empty
    vntFirstName = Empty
    vntLastKName = Empty
    vntFirstKName = Empty
    vntOrgName = Empty
    vntOrgSName = Empty
    vntCoursePrice = Empty
    vntOptionPrice = Empty
    vntOtherPrice = Empty
    vntTaxPrice = Empty
    vntTotalPrice = Empty
    vntTimeFra = Empty
    vntTimeFraName = Empty
    vntCntlNo = Empty
    vntGenderName = Empty
    vntBirth = Empty
    vntAge = Empty
    vntRsvDate = Empty
    vntRsvNo = Empty
    vntPerId = Empty
    SelectDmdSearchList = 0
    lngCount = 0
    
    '検索条件が設定されていない場合はエラー
    If Not (IsDate(Trim(strStrDate)) And IsDate(Trim(strEndDate))) Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "STRDATE", Trim(strStrDate), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ENDDATE", Trim(strEndDate), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD1", Trim(strOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "PERID", Trim(strPerID), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    If IsNumeric(strGetCount) Then      '取得件数が「すべて」以外の場合
        objOraParam.Add "SEQ_F", lngStartPos, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "SEQ_T", (lngStartPos + CLng(strGetCount) - 1), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    objOraParam.Add "CANCELFLG", CLng(CONSULT_USED), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "RSVNO", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "COURSEPRICE", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    objOraParam.Add "OPTIONPRICE", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    objOraParam.Add "OTHERPRICE", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    objOraParam.Add "TAXPRICE", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    objOraParam.Add "TOTALPRICE", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    
    '検索条件を満たす受診者情報のレコードを取得
    strStmt = "SELECT CSLDATE,   DAYID,      WEBCOLOR, CSNAME,   LASTNAME, FIRSTNAME,            " & vbLf & _
              "       LASTKNAME, FIRSTKNAME, ORGNAME,  ORGSNAME, TIMEFRA,  CNTLNO,               " & vbLf & _
              "       GENDER,    BIRTH,      AGE,      RSVDATE,  RSVNO,    PERID                 " & vbLf
              
    strStmt = strStmt & vbLf & _
              "  FROM ( SELECT ROWNUM SEQ, CSLDATE,   DAYID,     WEBCOLOR,   CSNAME,             " & vbLf & _
              "                LASTNAME,   FIRSTNAME, LASTKNAME, FIRSTKNAME, ORGNAME,            " & vbLf & _
              "                ORGSNAME,   TIMEFRA,   CNTLNO,    GENDER,     BIRTH,              " & vbLf & _
              "                AGE,        RSVDATE,   RSVNO,     PERID                           " & vbLf & _
              "           FROM ( SELECT TO_CHAR(cs.CSLDATE, 'YYYY/MM/DD') CSLDATE,               " & vbLf & _
              "                         TO_CHAR(rs.DAYID, '0999') DAYID,                         " & vbLf & _
              "                         cp.WEBCOLOR,  cp.CSNAME,                                 " & vbLf & _
              "                         ps.LASTNAME,  ps.FIRSTNAME,                              " & vbLf & _
              "                         ps.LASTKNAME, ps.FIRSTKNAME,                             " & vbLf & _
              "                         og.ORGNAME,   og.ORGSNAME,                               " & vbLf & _
              "                         cs.TIMEFRA,   TO_CHAR(rs.CNTLNO, '0999') CNTLNO,         " & vbLf & _
              "                         ps.GENDER,    TO_CHAR(ps.BIRTH, 'YYYY/MM/DD') BIRTH,     " & vbLf & _
              "                         cs.AGE,       TO_CHAR(cs.RSVDATE, 'YYYY/MM/DD') RSVDATE, " & vbLf & _
              "                         cs.RSVNO,     cs.PERID                                   " & vbLf & _
              "                    FROM CONSULT cs, RECEIPT rs, COURSE_P cp, PERSON ps, ORG og   "
              
    strStmt = strStmt & vbLf & _
              "                   WHERE cs.CSLDATE   BETWEEN :STRDATE AND :ENDDATE               " & vbLf & _
              "                     AND cs.CANCELFLG = :CANCELFLG                                " & vbLf & _
              "                     AND cs.RSVNO     = rs.RSVNO  (+)                             " & vbLf & _
              "                     AND cs.CSLDATE   = rs.CSLDATE(+)                             " & vbLf & _
              "                     AND cs.CSCD      = cp.CSCD   (+)                             " & vbLf & _
              "                     AND cs.PERID     = ps.PERID  (+)                             " & vbLf & _
              "                     AND cs.ORGCD1    = og.ORGCD1 (+)                             " & vbLf & _
              "                     AND cs.ORGCD2    = og.ORGCD2 (+)                             "
    
    '条件節を追加
    If Trim(strOrgCd1) <> "" Or Trim(strOrgCd2) <> "" Then               '団体指定あり
        strStmt = strStmt & vbLf & _
              "                     AND cs.ORGCD1    = :ORGCD1 " & vbLf & _
              "                     AND cs.ORGCD2    = :ORGCD2 "
    End If
    
    If Trim(strPerID) <> "" Then                '個人ＩＤ指定あり
        strStmt = strStmt & vbLf & _
              "                     AND cs.PERID     = :PERID  "
    End If
    
    If Trim(strCsCd) <> "" Then                 'コースコード指定あり
        strStmt = strStmt & vbLf & _
              "                     AND cs.CSCD      = :CSCD   "
    End If
    
    'ソート順を追加
    Select Case lngSortKey
        Case DSL_SORT_DEFAULT                   '基本表示順（受診日，当日ID，コース，団体（カナ），氏名（カナ））
            strStmt = strStmt & vbLf & _
              "                   ORDER BY cs.CSLDATE, rs.DAYID, cs.CSCD, og.ORGKNAME, ps.LASTKNAME, ps.FIRSTKNAME "
    End Select
    strStmt = strStmt & vbLf & _
              "                ) " & vbLf & _
              "       ) "
    
    '開始位置から取得件数分を取得するための条件節を追加
    If IsNumeric(strGetCount) Then      '取得件数が「すべて」以外の場合
        strStmt = strStmt & vbLf & _
              " WHERE SEQ BETWEEN :SEQ_F AND :SEQ_T"
    End If
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '入金情報を取得する場合のSQLBuild
    If IsMissing(vntIncomePrice) = False Then
    
        strIncomeStmt = "SELECT CONSULT_ZAIMU.RSVNO INCOMERSVNO, SUM(CONSULT_ZAIMU.PRICE) + SUM(CONSULT_ZAIMU.TAXPRICE) INCOMEPRICE" & vbLf & _
                        "  FROM ZAIMU ZAIMU, CONSULT_ZAIMU CONSULT_ZAIMU " & vbLf & _
                        " WHERE CONSULT_ZAIMU.RSVNO  = :RSVNO" & vbLf & _
                        "   AND CONSULT_ZAIMU.ORGCD1 = 'XXXXX'" & vbLf & _
                        "   AND CONSULT_ZAIMU.ORGCD2 = 'XXXXX'" & vbLf & _
                        "   AND CONSULT_ZAIMU.INZAIMUSEQ IS NULL" & vbLf & _
                        "   AND ZAIMU.ZAIMUCD        = CONSULT_ZAIMU.ZAIMUCD" & vbLf & _
                        "   AND ( ZAIMU.ZAIMUDIV = '2' OR ZAIMU.ZAIMUDIV = '3' )" & vbLf & _
                        " GROUP BY CONSULT_ZAIMU.RSVNO"
    
    End If
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        '共通クラスのインスタンス作成
        Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCslDate = objFields("CSLDATE")
        Set objDayId = objFields("DAYID")
        Set objWebColor = objFields("WEBCOLOR")
        Set objCsName = objFields("CSNAME")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastKName = objFields("LASTKNAME")
        Set objFirstKName = objFields("FIRSTKNAME")
        Set objOrgName = objFields("ORGNAME")
        Set objOrgSName = objFields("ORGSNAME")
        Set objTimeFra = objFields("TIMEFRA")
        Set objCntlNo = objFields("CNTLNO")
        Set objgender = objFields("GENDER")
        Set objBirth = objFields("BIRTH")
        Set objAge = objFields("AGE")
        Set objRsvDate = objFields("RSVDATE")
        Set objRsvNo = objFields("RSVNO")
        Set objPerId = objFields("PERID")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrCslDate(lngCount)
            ReDim Preserve vntArrDayId(lngCount)
            ReDim Preserve vntArrWebColor(lngCount)
            ReDim Preserve vntArrCsName(lngCount)
            ReDim Preserve vntArrLastName(lngCount)
            ReDim Preserve vntArrFirstName(lngCount)
            ReDim Preserve vntArrLastKName(lngCount)
            ReDim Preserve vntArrFirstKName(lngCount)
            ReDim Preserve vntArrOrgName(lngCount)
            ReDim Preserve vntArrOrgSName(lngCount)
            ReDim Preserve vntArrCoursePrice(lngCount)
            ReDim Preserve vntArrOptionPrice(lngCount)
            ReDim Preserve vntArrOtherPrice(lngCount)
            ReDim Preserve vntArrTaxPrice(lngCount)
            ReDim Preserve vntArrTotalPrice(lngCount)
            ReDim Preserve vntArrTimeFra(lngCount)
            ReDim Preserve vntArrTimeFraName(lngCount)
            ReDim Preserve vntArrCntlNo(lngCount)
            ReDim Preserve vntArrGenderName(lngCount)
            ReDim Preserve vntArrBirth(lngCount)
            ReDim Preserve vntArrAge(lngCount)
            ReDim Preserve vntArrRsvDate(lngCount)
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrPerId(lngCount)
        
            '入金情報を取得する場合は列名を追加する
            If IsMissing(vntIncomePrice) = False Then
                ReDim Preserve vntArrIncomePrice(lngCount)
            End If
            
            vntArrCslDate(lngCount) = Format(CDate(objCslDate.Value & ""), "yyyy年m月d日")
            vntArrDayId(lngCount) = objDayId.Value & ""
            vntArrWebColor(lngCount) = objWebColor.Value & ""
            vntArrCsName(lngCount) = objCsName.Value & ""
            vntArrLastName(lngCount) = objLastName.Value & ""
            vntArrFirstName(lngCount) = objFirstName.Value & ""
            vntArrLastKName(lngCount) = objLastKName.Value & ""
            vntArrFirstKName(lngCount) = objFirstKName.Value & ""
            vntArrOrgName(lngCount) = objOrgName.Value & ""
            vntArrOrgSName(lngCount) = objOrgSName.Value & ""
            'キー値の設定
            objOraParam("RSVNO").Value = CLng(objRsvNo.Value & "")
            'ストアドＣＡＬＬ（予約番号より、基本コース・オプション・契約外・消費税・合計の５つの金額を求める）
            mobjOraDb.ExecuteSQL "BEGIN DEMANDPACKAGE.GETPRICEFROMRSVNO(:RSVNO, :COURSEPRICE, :OPTIONPRICE, :OTHERPRICE, :TAXPRICE, :TOTALPRICE); END;"
            vntArrCoursePrice(lngCount) = Format(CLng(objOraParam("COURSEPRICE").Value), "#,###")
            vntArrOptionPrice(lngCount) = Format(CLng(objOraParam("OPTIONPRICE").Value), "#,###")
            vntArrOtherPrice(lngCount) = Format(CLng(objOraParam("OTHERPRICE").Value), "#,###")
            vntArrTaxPrice(lngCount) = Format(CLng(objOraParam("TAXPRICE").Value), "#,###")
            vntArrTotalPrice(lngCount) = Format(CLng(objOraParam("TOTALPRICE").Value), "#,###")
            vntArrTimeFra(lngCount) = CLng(objTimeFra.Value & "")
            vntArrTimeFraName(lngCount) = objCommon.SelectTimeFraName(CLng(vntArrTimeFra(lngCount))) & ""
            vntArrCntlNo(lngCount) = objCntlNo.Value & ""
            If Trim(objgender.Value) = GENDER_MALE Then
                vntArrGenderName(lngCount) = "男"
            ElseIf Trim(objgender.Value) = GENDER_FEMALE Then
                vntArrGenderName(lngCount) = "女"
            Else
                vntArrGenderName(lngCount) = objgender.Value & ""
            End If
            vntArrBirth(lngCount) = objBirth.Value & ""
            vntArrAge(lngCount) = objAge.Value & ""
            vntArrRsvDate(lngCount) = Format(CDate(objRsvDate.Value & ""), "yyyy年m月d日")
            vntArrRsvNo(lngCount) = CLng(objRsvNo.Value & "")
            vntArrPerId(lngCount) = objPerId.Value & ""
            
            '入金情報を取得する場合
            If IsMissing(vntIncomePrice) = False Then
            
                Set objOraDyna2 = mobjOraDb.CreateDynaset(OmitCharSpc(strIncomeStmt), ORADYN_READONLY + ORADYN_NOCACHE)
                
                '存在する場合は金額セット
                If Not objOraDyna2.EOF Then
                    vntArrIncomePrice(lngCount) = Format(CLng(objOraDyna2.Fields("INCOMEPRICE")), "#,###")
                Else
                    vntArrIncomePrice(lngCount) = ""
                End If
        
                Set objOraDyna2 = Nothing
            End If
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
        Set objCommon = Nothing
    
    End If
    
    '戻り値の設定
    vntCslDate = vntArrCslDate
    vntDayId = vntArrDayId
    vntWebColor = vntArrWebColor
    vntCsName = vntArrCsName
    vntLastName = vntArrLastName
    vntFirstName = vntArrFirstName
    vntLastKName = vntArrLastKName
    vntFirstKName = vntArrFirstKName
    vntOrgName = vntArrOrgName
    vntOrgSName = vntArrOrgSName
    vntCoursePrice = vntArrCoursePrice
    vntOptionPrice = vntArrOptionPrice
    vntOtherPrice = vntArrOtherPrice
    vntTaxPrice = vntArrTaxPrice
    vntTotalPrice = vntArrTotalPrice
    vntTimeFra = vntArrTimeFra
    vntTimeFraName = vntArrTimeFraName
    vntCntlNo = vntArrCntlNo
    vntGenderName = vntArrGenderName
    vntBirth = vntArrBirth
    vntAge = vntArrAge
    vntRsvDate = vntArrRsvDate
    vntRsvNo = vntArrRsvNo
    vntPerId = vntArrPerId
    If IsMissing(vntIncomePrice) = False Then vntIncomePrice = vntArrIncomePrice
    
    SelectDmdSearchList = lngCount
    
    'バインド変数解放
    With objOraParam
        Do Until .Count <= 0
            .Remove (.Count - 1)
        Loop
    End With
    
    Set objOraParam = Nothing
    Set objOraDyna = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.SelectDmdSearchList"
    
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
' 機能　　 : 消費税を計算する（１負担元あたりの消費税金額の端数処理）
'
' 引数　　 : (In)   strTaxFraction  税端数区分
' 　　　　 : (In)   dblDevideTax    １負担元あたりの消費税金額（端数処理前）
'
' 戻り値　 : １負担元あたりの消費税金額（端数処理後）
'
' 備考　　 :
'
Public Function CompDevideTax(ByVal strTaxFraction As String, _
                              ByVal dblDevideTax As Double _
                             ) As Long
    
    Dim lngDevideTax            As Long             '１負担元あたりの消費税金額（端数処理後）
    
    '初期処理
    CompDevideTax = 0
    lngDevideTax = 0
    
    '１負担元あたりの消費税金額を、税金端数区分の内容に従い計算
    Select Case strTaxFraction
        Case "1"                '10円未満切捨て
            lngDevideTax = Fix(dblDevideTax / 10) * 10
        Case "2"                '10円未満四捨五入
            If dblDevideTax >= 0 Then
                lngDevideTax = Fix((dblDevideTax + 5) / 10) * 10
            Else
                lngDevideTax = Fix((dblDevideTax - 5) / 10) * 10
            End If
        Case "3"                '10円未満切上げ
            If dblDevideTax >= 0 Then
                lngDevideTax = Fix((dblDevideTax + 9) / 10) * 10
            Else
                lngDevideTax = Fix((dblDevideTax - 9) / 10) * 10
            End If
        Case "4"                '1円未満切捨て
            lngDevideTax = Fix(dblDevideTax)
        Case "5"                '1円未満四捨五入
            If dblDevideTax >= 0 Then
                lngDevideTax = Fix(dblDevideTax + 0.5)
            Else
                lngDevideTax = Fix(dblDevideTax - 0.5)
            End If
        Case "6"                '1円未満切上げ
            If dblDevideTax >= 0 Then
                lngDevideTax = Fix(dblDevideTax + 0.9)
            Else
                lngDevideTax = Fix(dblDevideTax - 0.9)
            End If
        Case Else               '以外
            lngDevideTax = 0
    End Select
    
    '戻り値の設定
    CompDevideTax = lngDevideTax
    
End Function

'
' 機能　　 : 個人別請求情報を更新する（個人別請求金額修正）
'
' 引数　　 : (In)   lngRsvNo        予約番号
' 　　　　 : (In)   lngCtrPtCd      契約パターンコード
' 　　　　 : (In)   strTaxFraction  税端数区分
' 　　　　 : (In)   dblNowTax       適用税率
' 　　　　 : (In)   lngCloseFlg     締めフラグ（0:締め処理は行われていない, 1:締め処理が完了している）
' 　　　　 : (In)   vntSeq          （配列）ＳＥＱ
' 　　　　 : (In)   vntApDiv        （配列）適用元区分
' 　　　　 : (In)   vntOrgCd1       （配列）団体コード１
' 　　　　 : (In)   vntOrgCd2       （配列）団体コード２
' 　　　　 : (In)   vntOrgName      （配列）団体名
' 　　　　 : (In)   vntOrgSName     （配列）団体略称
' 　　　　 : (In)   vntPriceType    （配列）タイプ（0:基本コース, 1:基本コースの削除項目, 2:オプション検査, 3:契約外追加グループ, 4:契約外追加項目）
' 　　　　 : (In)   vntOptCd        （配列）オプションコード
' 　　　　 : (In)   vntOptName      （配列）オプション名
' 　　　　 : (In)   vntGrpCd        （配列）グループコード
' 　　　　 : (In)   vntGrpName      （配列）グループ名
' 　　　　 : (In)   vntItemCd       （配列）検査項目コード
' 　　　　 : (In)   vntRequestName  （配列）依頼項目名
' 　　　　 : (In)   vntPrice        （配列）請求金額（"-9999999"～"9999999":金額）
' 　　　　 : (In)   vntEditPrice    （配列）調整金額（"*-hidden-*":非表示, "":"0"と同義, "-9999999"～"9999999":金額）
' 　　　　 : (In)   vntTax          （配列）消費税金額（"*-hidden-*":非表示, "-9999999"～"9999999":金額）
' 　　　　 : (In)   vntEditTax      （配列）税調整金額（"*-hidden-*":非表示, "":"0"と同義, "-9999999"～"9999999":金額）
' 　　　　 : (In)   vntTaxFlg       （配列）消費税負担フラグ（0:負担しない, 1:負担する）
' 　　　　 : (In)   lngCount        レコード件数（配列の要素数）
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function UpdateDmdPerModify(ByVal lngRsvNo As Long, _
                                   ByVal lngCtrPtCd As Long, ByVal strTaxFraction As String, _
                                   ByVal dblNowTax As Double, ByVal lngCloseFlg As Long, _
                                   ByVal vntSeq As Variant, ByVal vntApDiv As Variant, _
                                   ByVal vntOrgCd1 As Variant, ByVal vntOrgCd2 As Variant, _
                                   ByVal vntOrgName As Variant, ByVal vntOrgSName As Variant, _
                                   ByVal vntPriceType As Variant, ByVal vntOptCd As Variant, _
                                   ByVal vntOptName As Variant, ByVal vntGrpCd As Variant, _
                                   ByVal vntGrpName As Variant, ByVal vntItemCd As Variant, _
                                   ByVal vntRequestName As Variant, ByVal vntPrice As Variant, _
                                   ByVal vntEditPrice As Variant, ByVal vntTax As Variant, _
                                   ByVal vntEditTax As Variant, ByVal vntTaxFlg As Variant, _
                                   ByVal lngCount As Long _
                                  ) As Boolean
    
    Dim i                       As Long             'インデックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    
    '初期処理
    UpdateDmdPerModify = False
    
    '検索条件が設定されていない場合はエラー
    If lngRsvNo = 0 Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    '配列を処理する
    For i = 0 To (lngCount - 1)
    
        'タイプに従って更新を行う
        Select Case vntPriceType(i)
    
            Case 0          '（基本コース）の場合
                '追加オプション負担金を更新する
                UpdateOptPrice lngRsvNo, lngCtrPtCd, vntSeq(i), 0, vntEditPrice(i), vntEditTax(i)
    
            Case 2          '（オプション検査）の場合
                '追加オプション負担金を更新する
                UpdateOptPrice lngRsvNo, lngCtrPtCd, vntSeq(i), vntOptCd(i), vntEditPrice(i), ""
    
            Case 3          '（契約外追加グループ）の場合
                '追加グループ負担金を更新する
                UpdateGrpPrice lngRsvNo, lngCtrPtCd, vntSeq(i), vntGrpCd(i), vntEditPrice(i)
    
            Case 4          '（契約外追加項目）の場合
                '追加検査項目負担金を更新する
                UpdateItemPrice lngRsvNo, lngCtrPtCd, vntSeq(i), vntItemCd(i), vntEditPrice(i)
    
        End Select
    
    Next i
    
'### 2002.03.27 Added by H.Ishihara@FSIT 保存時に受診金額も確定させる
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER

    '受診金額確定ストアド呼び出し
    mobjOraDb.ExecuteSQL "BEGIN :RET := DemandPackage.DecideConsultPrice(:RSVNO); END;"

    objOraParam.Remove "RET"
    objOraParam.Remove "RSVNO"
'### 2002.03.27 Added End
    
    '戻り値の設定
    UpdateDmdPerModify = True
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.UpdateDmdPerModify"
    
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
' 機能　　 : 追加オプション負担金を更新する
'
' 引数　　 : (In)   lngRsvNo        予約番号
' 　　　　 : (In)   lngCtrPtCd      契約パターンコード
' 　　　　 : (In)   lngSeq          ＳＥＱ
' 　　　　 : (In)   lngOptCd        オプションコード
' 　　　　 : (In)   strEditPrice    調整金額（"":"0"と同義, "-9999999"～"9999999":金額）
' 　　　　 : (In)   strEditTax      税調整金額（"":"0"と同義, "-9999999"～"9999999":金額）
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function UpdateOptPrice(ByVal lngRsvNo As Long, _
                               ByVal lngCtrPtCd As Long, _
                               ByVal lngSeq As Long, _
                               ByVal lngOptCd As Long, _
                               ByVal strEditPrice As String, _
                               ByVal strEditTax As String _
                              ) As Boolean
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    UpdateOptPrice = False
    
    '引数が正しく設定されていない場合はエラー
    If lngRsvNo = 0 Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO1", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CTRPTCD1", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SEQ1", lngSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "OPTCD1", lngOptCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "EDITPRICE1", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "EDITTAX1", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '該当キーの追加オプション負担金を削除
    strStmt = "DELETE                     " & vbLf & _
              "  FROM OPTPRICE            " & vbLf & _
              " WHERE RSVNO   = :RSVNO1   " & vbLf & _
              "   AND CTRPTCD = :CTRPTCD1 " & vbLf & _
              "   AND SEQ     = :SEQ1     " & vbLf & _
              "   AND OPTCD   = :OPTCD1   "
    
    mobjOraDb.ExecuteSQL strStmt
    
    'キー値の設定
    If IsNumeric(Trim(strEditPrice)) Then
        objOraParam("EDITPRICE1").Value = CLng(Trim(strEditPrice))
    Else
        objOraParam("EDITPRICE1").Value = 0
    End If
    If IsNumeric(Trim(strEditTax)) Then
        objOraParam("EDITTAX1").Value = CLng(Trim(strEditTax))
    Else
        objOraParam("EDITTAX1").Value = 0
    End If
    
    '値が設定されている時のみ、追加オプション負担金を登録
    If objOraParam("EDITPRICE1").Value <> 0 Or _
       objOraParam("EDITTAX1").Value <> 0 Then
    
            strStmt = "INSERT INTO OPTPRICE (   " & vbLf & _
                      "            RSVNO,       " & vbLf & _
                      "            CTRPTCD,     " & vbLf & _
                      "            SEQ,         " & vbLf & _
                      "            OPTCD,       " & vbLf & _
                      "            EDITPRICE,   " & vbLf & _
                      "            EDITTAX      " & vbLf & _
                      "       ) VALUES (        " & vbLf & _
                      "            :RSVNO1,     " & vbLf & _
                      "            :CTRPTCD1,   " & vbLf & _
                      "            :SEQ1,       " & vbLf & _
                      "            :OPTCD1,     " & vbLf & _
                      "            :EDITPRICE1, " & vbLf & _
                      "            :EDITTAX1    " & vbLf & _
                      "       )                 "
    
            mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    End If
    
    '戻り値の設定
    UpdateOptPrice = True
    
    objOraParam.Remove "RSVNO1"
    objOraParam.Remove "CTRPTCD1"
    objOraParam.Remove "SEQ1"
    objOraParam.Remove "OPTCD1"
    objOraParam.Remove "EDITPRICE1"
    objOraParam.Remove "EDITTAX1"
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.UpdateOptPrice"
    
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
' 機能　　 : 追加グループ負担金を更新する
'
' 引数　　 : (In)   lngRsvNo        予約番号
' 　　　　 : (In)   lngCtrPtCd      契約パターンコード
' 　　　　 : (In)   lngSeq          ＳＥＱ
' 　　　　 : (In)   strGrpCd        グループコード
' 　　　　 : (In)   strEditPrice    調整金額（"":"0"と同義, "-9999999"～"9999999":金額）
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function UpdateGrpPrice(ByVal lngRsvNo As Long, _
                               ByVal lngCtrPtCd As Long, _
                               ByVal lngSeq As Long, _
                               ByVal strGrpCd As String, _
                               ByVal strEditPrice As String _
                              ) As Boolean
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    UpdateGrpPrice = False
    
    '引数が正しく設定されていない場合はエラー
    If lngRsvNo = 0 Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO2", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CTRPTCD2", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SEQ2", lngSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "GRPCD2", Trim(strGrpCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "EDITPRICE2", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '該当キーの追加グループ負担金を削除
    strStmt = "DELETE                     " & vbLf & _
              "  FROM GRPPRICE            " & vbLf & _
              " WHERE RSVNO   = :RSVNO2   " & vbLf & _
              "   AND CTRPTCD = :CTRPTCD2 " & vbLf & _
              "   AND SEQ     = :SEQ2     " & vbLf & _
              "   AND GRPCD   = :GRPCD2   "
    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    'キー値の設定
    If IsNumeric(Trim(strEditPrice)) Then
        objOraParam("EDITPRICE2").Value = CLng(Trim(strEditPrice))
    Else
        objOraParam("EDITPRICE2").Value = 0
    End If
    
    '値が設定されている時のみ、追加グループ負担金を登録
    If objOraParam("EDITPRICE2").Value <> 0 Then
    
            strStmt = "INSERT INTO GRPPRICE (  " & vbLf & _
                      "            RSVNO,      " & vbLf & _
                      "            CTRPTCD,    " & vbLf & _
                      "            SEQ,        " & vbLf & _
                      "            GRPCD,      " & vbLf & _
                      "            EDITPRICE   " & vbLf & _
                      "       ) VALUES (       " & vbLf & _
                      "            :RSVNO2,    " & vbLf & _
                      "            :CTRPTCD2,  " & vbLf & _
                      "            :SEQ2,      " & vbLf & _
                      "            :GRPCD2,    " & vbLf & _
                      "            :EDITPRICE2 " & vbLf & _
                      "       )                "
    
            mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    End If
    
    '戻り値の設定
    UpdateGrpPrice = True
    
    objOraParam.Remove "RSVNO2"
    objOraParam.Remove "CTRPTCD2"
    objOraParam.Remove "SEQ2"
    objOraParam.Remove "GRPCD2"
    objOraParam.Remove "EDITPRICE2"
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.UpdateGrpPrice"
    
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
' 機能　　 : 追加検査項目負担金を更新する
'
' 引数　　 : (In)   lngRsvNo        予約番号
' 　　　　 : (In)   lngCtrPtCd      契約パターンコード
' 　　　　 : (In)   lngSeq          ＳＥＱ
' 　　　　 : (In)   strItemCd       検査項目コード
' 　　　　 : (In)   strEditPrice    調整金額（"":"0"と同義, "-9999999"～"9999999":金額）
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function UpdateItemPrice(ByVal lngRsvNo As Long, _
                                ByVal lngCtrPtCd As Long, _
                                ByVal lngSeq As Long, _
                                ByVal strItemCd As String, _
                                ByVal strEditPrice As String _
                               ) As Boolean
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    UpdateItemPrice = False
    
    '引数が正しく設定されていない場合はエラー
    If lngRsvNo = 0 Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO3", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CTRPTCD3", lngCtrPtCd, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SEQ3", lngSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ITEMCD3", Trim(strItemCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "EDITPRICE3", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '該当キーの追加検査項目負担金を削除
    strStmt = "DELETE                     " & vbLf & _
              "  FROM ITEMPRICE           " & vbLf & _
              " WHERE RSVNO   = :RSVNO3   " & vbLf & _
              "   AND CTRPTCD = :CTRPTCD3 " & vbLf & _
              "   AND SEQ     = :SEQ3     " & vbLf & _
              "   AND ITEMCD  = :ITEMCD3  "
    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    'キー値の設定
    If IsNumeric(Trim(strEditPrice)) Then
        objOraParam("EDITPRICE3").Value = CLng(Trim(strEditPrice))
    Else
        objOraParam("EDITPRICE3").Value = 0
    End If
    
    '値が設定されている時のみ、追加検査項目負担金を登録
    If objOraParam("EDITPRICE3").Value <> 0 Then
    
            strStmt = "INSERT INTO ITEMPRICE ( " & vbLf & _
                      "            RSVNO,      " & vbLf & _
                      "            CTRPTCD,    " & vbLf & _
                      "            SEQ,        " & vbLf & _
                      "            ITEMCD,     " & vbLf & _
                      "            EDITPRICE   " & vbLf & _
                      "       ) VALUES (       " & vbLf & _
                      "            :RSVNO3,    " & vbLf & _
                      "            :CTRPTCD3,  " & vbLf & _
                      "            :SEQ3,      " & vbLf & _
                      "            :ITEMCD3,   " & vbLf & _
                      "            :EDITPRICE3 " & vbLf & _
                      "       )                "
    
            mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    End If
    
    '戻り値の設定
    UpdateItemPrice = True
    
    objOraParam.Remove "RSVNO3"
    objOraParam.Remove "CTRPTCD3"
    objOraParam.Remove "SEQ3"
    objOraParam.Remove "ITEMCD3"
    objOraParam.Remove "EDITPRICE3"
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.UpdateItemPrice"
    
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
' 機能　　 : 入金情報検索条件の妥当性チェックを行う
'
' 引数　　 : (In)   lngStrYear      開始締め日(年)
' 　　　　 : (In)   lngStrMonth     開始締め日(月)
' 　　　　 : (In)   lngStrDay       開始締め日(日)
' 　　　　 : (Out)  vntStrDate      開始締め日
' 　　　　 : (In)   lngEndYear      終了締め日(年)
' 　　　　 : (In)   lngEndMonth     終了締め日(月)
' 　　　　 : (In)   lngEndDay       終了締め日(日)
' 　　　　 : (Out)  vntEndDate      終了締め日
' 　　　　 : (In)   strBillNo       請求書番号
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
Public Function CheckValueDmdPaymentSearch(ByVal lngStrYear As Long, _
                                           ByVal lngStrMonth As Long, _
                                           ByVal lngStrDay As Long, _
                                           ByRef vntStrDate As Variant, _
                                           ByVal lngEndYear As Long, _
                                           ByVal lngEndMonth As Long, _
                                           ByVal lngEndDay As Long, _
                                           ByRef vntEndDate As Variant, _
                                           ByVal strBillNo As String _
                                          ) As Variant
    
    Dim objCommon               As Common           '共通クラス
    
    Dim lngCheckDay             As Long             'チェック用日
    Dim strStrDate              As String           '編集用開始日
    Dim strEndDate              As String           '編集用終了日
    Dim vntDate                 As Variant          '編集用締め日
    
    Dim vntArrMessage           As Variant          'エラーメッセージの集合
    
    '初期処理
    CheckValueDmdPaymentSearch = Empty
    vntArrMessage = Empty
    
    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    
    Do
        '各値チェック処理
        With objCommon
    
            Do
                '開始終了とも未入力はエラー
                If lngStrYear = 0 And lngStrMonth = 0 And lngStrDay = 0 And _
                   lngEndYear = 0 And lngEndMonth = 0 And lngEndDay = 0 Then
                    .AppendArray vntArrMessage, "締め日を指定してください。"
                    Exit Do
                End If
            
                'どちらかの日付が空の場合、残る片方の日付で妥当性チェック
                If lngStrYear = 0 And lngStrMonth = 0 And lngStrDay = 0 And _
                   lngEndYear <> 0 And lngEndMonth <> 0 Then
                    lngStrYear = lngEndYear
                    lngStrMonth = lngEndMonth
                    If lngEndDay <> 0 Then
                        lngStrDay = lngEndDay
                    End If
                End If
                If lngEndYear = 0 And lngEndMonth = 0 And lngEndDay = 0 And _
                   lngStrYear <> 0 And lngStrMonth <> 0 Then
                    lngEndYear = lngStrYear
                    lngEndMonth = lngStrMonth
                    If lngStrDay <> 0 Then
                        lngEndDay = lngStrDay
                    End If
                End If
                
                '表示開始年月が入力されている場合
                If (lngStrYear <> 0 Or lngStrMonth <> 0) Then
                    '日が未入力の場合、日に１を規定値として設定
                    If lngStrDay = 0 Then
                        lngCheckDay = 1
                    Else
                        lngCheckDay = lngStrDay
                    End If
                    '日付チェック
                    .AppendArray vntArrMessage, .CheckDate("締め日（自）", lngStrYear, lngStrMonth, lngCheckDay, strStrDate, CHECK_NECESSARY)
                End If
            
                '表示終了年月が入力されている場合
                If (lngEndYear <> 0 Or lngEndMonth <> 0) Then
                    '日が未入力の場合、日に１を規定値として設定
                    If lngEndDay = 0 Then
                        lngCheckDay = 1
                    Else
                        lngCheckDay = lngEndDay
                    End If
                    '日付チェック
                    .AppendArray vntArrMessage, .CheckDate("締め日（至）", lngEndYear, lngEndMonth, lngCheckDay, strEndDate, CHECK_NECESSARY)
                End If
                
                '両方とも日付型でない場合は何もしない
                If Not IsDate(strStrDate) And Not IsDate(strEndDate) Then
                    Exit Do
                End If
                
                'どちらかの日付が未入力の場合、残る片方の日付をセットする
                If strStrDate = "" And strEndDate <> "" Then
                    vntStrDate = CDate(strEndDate)
                    vntEndDate = CDate(strEndDate)
                    Exit Do
                End If
                If strEndDate = "" And strStrDate <> "" Then
                    vntStrDate = CDate(strStrDate)
                    vntEndDate = CDate(strStrDate)
                    Exit Do
                End If
                
                '開始・終了日を日付型に変換
                vntStrDate = CDate(strStrDate)
                vntEndDate = CDate(strEndDate)
                
                If vntStrDate <= vntEndDate Then
                    '終了日が指定されていない場合は末日をセット
                    If lngStrDay = 0 Then
                        vntStrDate = CDate(Format(vntStrDate, "yyyy/mm/") & "1")
                    End If
                    If lngEndDay = 0 Then
                        vntEndDate = DateAdd("m", 1, vntEndDate)    '翌月
                        vntEndDate = DateAdd("d", -1, vntEndDate)   '翌月の前日＝当月末日
                    End If
                Else
                    '開始日が指定されていない場合は末日をセット
                    If lngStrDay = 0 Then
                        vntStrDate = DateAdd("m", 1, vntStrDate)    '翌月
                        vntStrDate = DateAdd("d", -1, vntStrDate)   '翌月の前日＝当月末日
                    End If
                    If lngEndDay = 0 Then
                        If lngStrDay <> 0 Then
                            vntEndDate = CDate(Format(vntStrDate, "yyyy/mm/") & "1")
                            vntEndDate = DateAdd("m", 1, vntEndDate)    '翌月
                            vntEndDate = DateAdd("d", -1, vntEndDate)   '翌月の前日＝当月末日
                        Else
                            vntEndDate = CDate(Format(vntEndDate, "yyyy/mm/") & "1")
                        End If
                    End If
                End If
                
                '開始・終了日入れ換え
                If vntStrDate > vntEndDate Then
                    vntDate = vntStrDate
                    vntStrDate = vntEndDate
                    vntEndDate = vntDate
                End If
                
                Exit Do
                
            Loop
            
            '請求書番号
            If Trim(strBillNo) <> "" Then
                .AppendArray vntArrMessage, .CheckNumeric("請求書番号", strBillNo, LENGTH_BILLNO)
            End If
    
        End With
    
        Exit Do
    Loop
    
    '戻り値の編集
    If IsArray(vntArrMessage) Then
        CheckValueDmdPaymentSearch = vntArrMessage
    End If
    
    Set objCommon = Nothing
    
End Function

'## 2003.01.02 Modified Function by ishihara@FSIT 東急殿向け締め処理に合致するよう、メソッドそのものを完全再作成
'
' 機能　　 : 検索条件を満たす請求書情報の一覧を取得する
'
' 引数　　 : (In)   vntMode                 取得モード(NULL:通常取得、"CNT":検索条件での請求書数を数える）
' 　　　　 : (In)   vntIn_StrDate           開始締め日
' 　　　　 : (In)   vntIn_EndDate           終了締め日
' 　　　　 : (In)   vntIn_BillNo            請求書コード
' 　　　　 : (In)   vntIn_BurdenOrgCd1      負担元団体コード１
' 　　　　 : (In)   vntIn_BurdenOrgCd2      負担元団体コード２
' 　　　　 : (In)   vntIn_BillClassCd       請求書分類コード
' 　　　　 : (In)   vntIn_IsPrint           請求書出力状態（1:出力済みのみ、2:未出力のみ）
' 　　　　 : (In)   vntStartPos             SELECT開始位置
' 　　　　 : (In)   vntGetCount             取得件数
' 　　　　 : (Out)  vntBillNo               請求書番号
' 　　　　 : (Out)  vntCloseDate            締め日
' 　　　　 : (Out)  vntOrgCd1               団体コード1
' 　　　　 : (Out)  vntOrgCd2               団体コード2
' 　　　　 : (Out)  vntOrgName              団体名
' 　　　　 : (Out)  vntBillClassCd          請求書分類コード
' 　　　　 : (Out)  vntBillClassName        請求書分類名
' 　　　　 : (Out)  vntTotal                請求額
' 　　　　 : (Out)  vntPaymentTotal         入金合計
' 　　　　 : (Out)  vntSeq                  入金SEQ
' 　　　　 : (Out)  vntPaymentDate          入金日
' 　　　　 : (Out)  vntPaymentPrice         入金額
' 　　　　 : (Out)  vntPaymentDiv           入金区分
' 　　　　 : (Out)  vntUpdUser              更新者
' 　　　　 : (Out)  vntUserName             更新者名
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 : 取得件数が数値以外の時、検索条件を満たすレコードすべてを抽出する
'
Public Function SelectDmdPaymentSearchList(ByVal vntMode As Variant, _
                                           Optional ByVal vntIn_StrDate As Variant, Optional ByVal vntIn_EndDate As Variant, _
                                           Optional ByVal vntIn_BillNo As Variant, _
                                           Optional ByVal vntIn_BurdenOrgCd1 As Variant, Optional ByVal vntIn_BurdenOrgCd2 As Variant, _
                                           Optional ByVal vntIn_BillClassCd As Variant, Optional ByVal vntIn_IsPrint As Variant, _
                                           Optional ByVal vntStartPos As Variant, Optional ByVal vntGetCount As Variant, _
                                           Optional ByRef vntBillNo As Variant, _
                                           Optional ByRef vntCloseDate As Variant, _
                                           Optional ByRef vntOrgCd1 As Variant, _
                                           Optional ByRef vntOrgCd2 As Variant, _
                                           Optional ByRef vntOrgName As Variant, _
                                           Optional ByRef vntBillClassCd As Variant, _
                                           Optional ByRef vntBillClassName As Variant, _
                                           Optional ByRef vntTotal As Variant, _
                                           Optional ByRef vntPaymentTotal As Variant, _
                                           Optional ByRef vntSeq As Variant, _
                                           Optional ByRef vntPaymentDate As Variant, _
                                           Optional ByRef vntPaymentPrice As Variant, _
                                           Optional ByRef vntPaymentDiv As Variant, _
                                           Optional ByRef vntUpdUser As Variant, _
                                           Optional ByRef vntUserName As Variant, _
                                           Optional ByRef vntSubTotal As Variant, _
                                           Optional ByRef vntTax As Variant _
                                          ) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objBillNo               As OraField         '請求書番号
    Dim objRowSeq               As OraField         '取得番号（１請求書で１）
    Dim objCloseDate            As OraField         '締め日
    Dim objOrgCd1               As OraField         '団体コード1
    Dim objOrgCd2               As OraField         '団体コード2
    Dim objOrgName              As OraField         '団体名
    Dim objBillClassCd          As OraField         '請求書分類コード
    Dim objBillClassName        As OraField         '請求書分類名
    Dim objTotal                As OraField         '請求額
    Dim objPaymentTotal         As OraField         '入金合計
    Dim objSeq                  As OraField         '入金SEQ
    Dim objPaymentDate          As OraField         '入金日
    Dim objPaymentPrice         As OraField         '入金額
    Dim objPaymentDiv           As OraField         '入金区分
    Dim objUpdUser              As OraField         '更新者
    Dim objUserName             As OraField         '更新者名
'### 2003.04.02 Updated by Ishihara@FSIT 小計、税額も計算
    Dim objSubTotal             As OraField         '小計
    Dim objTax                  As OraField         '税額
'### 2003.04.02 Updated End
    
    Dim vntArrBillNo()          As Variant          '請求書番号
    Dim vntArrRowSeq()          As Variant          '取得番号（１請求書で１）
    Dim vntArrCloseDate()       As Variant          '締め日
    Dim vntArrOrgCd1()          As Variant          '団体コード1
    Dim vntArrOrgCd2()          As Variant          '団体コード2
    Dim vntArrOrgName()         As Variant          '団体名
    Dim vntArrBillClassCd()     As Variant          '請求書分類コード
    Dim vntArrBillClassName()   As Variant          '請求書分類名
    Dim vntArrTotal()           As Variant          '請求額
    Dim vntArrPaymentTotal()    As Variant          '入金合計
    Dim vntArrSeq()             As Variant          '入金SEQ
    Dim vntArrPaymentDate()     As Variant          '入金日
    Dim vntArrPaymentPrice()    As Variant          '入金額
    Dim vntArrPaymentDiv()      As Variant          '入金区分
    Dim vntArrUpdUser()         As Variant          '更新者
    Dim vntArrUserName()        As Variant          '更新者名
'### 2003.04.02 Updated by Ishihara@FSIT 小計、税額も計算
    Dim vntArrSubTotal()        As Variant          '税額
    Dim vntArrTax()             As Variant          '小計
'### 2003.04.02 Updated End
    
    Dim lngCount                As Long             'レコード数
    Dim blnIsCloseDate          As Boolean          'TRUE:締め日範囲が指定されている
    Dim blnIsBillNo             As Boolean          'TRUE:請求書番号が指定されている
    Dim blnIsBurdenOrgCd        As Boolean          'TRUE:団体が指定されている
    Dim blnIsBillClassCd        As Boolean          'TRUE:請求書分類が指定されている
    Dim blnIsIsPrint            As Boolean          'TRUE:請求書出力状態が指定されている
    Dim blnIsIsNoPrint          As Boolean          'TRUE:請求書未出力状態が指定されている
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    lngCount = 0
    SelectDmdPaymentSearchList = 0
    blnIsCloseDate = False
    blnIsBillNo = False
    blnIsBurdenOrgCd = False
    blnIsBillClassCd = False
    blnIsIsPrint = False
    blnIsIsNoPrint = False
    
    '締め日範囲の妥当性チェック
    If (IsMissing(vntIn_StrDate) = False) And (IsMissing(vntIn_EndDate) = False) Then
        vntIn_StrDate = Trim(vntIn_StrDate)
        vntIn_EndDate = Trim(vntIn_EndDate)
        If (IsDate(vntIn_StrDate) = True) And (IsDate(vntIn_EndDate) = True) Then
            blnIsCloseDate = True
        End If
    End If
       
    '請求書番号の妥当性チェック
    If IsMissing(vntIn_BillNo) = False Then
        vntIn_BillNo = Trim(vntIn_BillNo)
        If IsNumeric(vntIn_BillNo) = True Then
            If CLng(vntIn_BillNo) > 0 Then
                blnIsBillNo = True
            End If
        End If
    End If
    
    '締め日範囲も請求書番号も正しく指定されていない場合はエラー
    If blnIsCloseDate = False And blnIsBillNo = False Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    
    '請求書番号が指定されている
    If blnIsBillNo = True Then
        objOraParam.Add "BILLNO", CLng(vntIn_BillNo), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    
    '締め日範囲が設定されている（請求書番号がない場合のみ）
    If (blnIsCloseDate = True) And (blnIsBillNo = False) Then
        objOraParam.Add "STRDATE", CDate(vntIn_StrDate), ORAPARM_INPUT, ORATYPE_DATE
        objOraParam.Add "ENDDATE", CDate(vntIn_EndDate), ORAPARM_INPUT, ORATYPE_DATE
    End If
    
    '負担元が設定されている
    If (IsMissing(vntIn_BurdenOrgCd1) = False) And (IsMissing(vntIn_BurdenOrgCd2) = False) Then
        If (Trim(vntIn_BurdenOrgCd1) <> "") And (Trim(vntIn_BurdenOrgCd2) <> "") Then
            objOraParam.Add "BURDENORGCD1", Trim(vntIn_BurdenOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
            objOraParam.Add "BURDENORGCD2", Trim(vntIn_BurdenOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
            blnIsBurdenOrgCd = True
        End If
    End If
    
    '請求書分類コードが設定されている。
    If IsMissing(vntIn_BillClassCd) = False Then
        If Trim(vntIn_BillClassCd) <> "" Then
            objOraParam.Add "BILLCLASSCD", Trim(vntIn_BillClassCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
            blnIsBillClassCd = True
        End If
    End If
    
    '請求書出力状態が設定されている。
    If IsMissing(vntIn_IsPrint) = False Then
        If Trim(vntIn_IsPrint) = "1" Then
            blnIsIsPrint = True
        End If
        If Trim(vntIn_IsPrint) = "2" Then
            blnIsIsNoPrint = True
        End If
    End If
    
    '取得件数と開始位置が設定されている場合
    If IsNumeric(vntStartPos) And IsNumeric(vntGetCount) Then
        objOraParam.Add "SEQ_F", CLng(vntStartPos), ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "SEQ_T", (CLng(vntStartPos) + CLng(vntGetCount) - 1), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    
    '検索条件を満たす請求入金情報のレコードを取得
'### 2003.04.02 Updated by Ishihara@FSIT 小計、税額も計算
'    strStmt = " SELECT BASEBILL.BILLNO       BILLNO,        BASEBILL.ROWSEQ        ROWSEQ,        " & vbLf & _
              "        BASEBILL.CLOSEDATE    CLOSEDATE,     BASEBILL.BURDENORGCD1  ORGCD1,        " & vbLf & _
              "        BASEBILL.BURDENORGCD2 ORGCD2,        BASEBILL.BURDENORGNAME ORGNAME,       " & vbLf & _
              "        BASEBILL.BILLCLASSCD  BILLCLASSCD,   BASEBILL.BILLCLASSNAME BILLCLASSNAME, " & vbLf & _
              "        PAYMENT.SEQ           SEQ,           PAYMENT.PAYMENTDATE    PAYMENTDATE,   " & vbLf & _
              "        PAYMENT.PAYMENTPRICE  PAYMENTPRICE,  PAYMENT.PAYMENTDIV     PAYMENTDIV,    " & vbLf & _
              "        PAYMENT.UPDUSER       UPDUSER,       HAINSUSER.USERNAME     USERNAME,      " & vbLf & _
              "        NVL(BILLDETAILSUM.TOTAL, 0) TOTAL,   NVL(PAYMENTTOTAL.PAYMENTTOTALPRICE, 0) PAYMENTTOTAL" & vbLf & _
              "   FROM HAINSUSER, PAYMENT, " & vbLf
    strStmt = " SELECT BASEBILL.BILLNO       BILLNO,        BASEBILL.ROWSEQ        ROWSEQ,        " & vbLf & _
              "        BASEBILL.CLOSEDATE    CLOSEDATE,     BASEBILL.BURDENORGCD1  ORGCD1,        " & vbLf & _
              "        BASEBILL.BURDENORGCD2 ORGCD2,        BASEBILL.BURDENORGNAME ORGNAME,       " & vbLf & _
              "        BASEBILL.BILLCLASSCD  BILLCLASSCD,   BASEBILL.BILLCLASSNAME BILLCLASSNAME, " & vbLf & _
              "        PAYMENT.SEQ           SEQ,           PAYMENT.PAYMENTDATE    PAYMENTDATE,   " & vbLf & _
              "        PAYMENT.PAYMENTPRICE  PAYMENTPRICE,  PAYMENT.PAYMENTDIV     PAYMENTDIV,    " & vbLf & _
              "        PAYMENT.UPDUSER       UPDUSER,       HAINSUSER.USERNAME     USERNAME,      " & vbLf & _
              "        NVL(BILLDETAILSUM.TOTAL, 0) TOTAL,   NVL(PAYMENTTOTAL.PAYMENTTOTALPRICE, 0) PAYMENTTOTAL," & vbLf & _
              "        NVL(BILLDETAILSUM.SUBTOTAL, 0) SUBTOTAL, NVL(BILLDETAILSUM.TAX, 0) TAX" & vbLf & _
              "   FROM HAINSUSER, PAYMENT, " & vbLf
'### 2003.04.02 Updated End

    '入金合計金額計算用内部View
    strStmt = strStmt & _
              "       (" & vbLf & _
              "        SELECT BILL.BILLNO, SUM(PAYMENT.PAYMENTPRICE) PAYMENTTOTALPRICE" & vbLf & _
              "          FROM PAYMENT, BILL" & vbLf

    '請求書番号が指定されている
    If blnIsBillNo = True Then
        strStmt = strStmt & _
              "         WHERE BILL.BILLNO = :BILLNO" & vbLf
    End If

    '締め日範囲が設定されている（請求書番号がない場合のみ）
    If (blnIsCloseDate = True) And (blnIsBillNo = False) Then
        strStmt = strStmt & _
              "         WHERE BILL.CLOSEDATE BETWEEN :STRDATE AND :ENDDATE" & vbLf
    End If
    
    '負担元が設定されている
    If blnIsBurdenOrgCd = True Then
        strStmt = strStmt & _
              "          AND BILL.ORGCD1 = :BURDENORGCD1" & vbLf & _
              "          AND BILL.ORGCD2 = :BURDENORGCD2" & vbLf
    End If
    
    '請求書分類コードが設定されている。
    If blnIsBillClassCd = True Then
        strStmt = strStmt & _
              "          AND BILL.BILLCLASSCD = :BILLCLASSCD" & vbLf
    End If
    
    '請求書出力状態が設定されている。
    If blnIsIsPrint = True Then
        strStmt = strStmt & _
              "          AND BILL.PRTDATE IS NOT NULL" & vbLf
    End If
    
    '請求書未出力状態が設定されている。
    If blnIsIsNoPrint = True Then
        strStmt = strStmt & _
              "          AND BILL.PRTDATE IS NULL" & vbLf
    End If
              
    strStmt = strStmt & _
              "           AND BILL.BILLNO = PAYMENT.BILLNO" & vbLf & _
              "         GROUP BY BILL.BILLNO" & vbLf & _
              "       ) PAYMENTTOTAL," & vbLf
    
'### 2003.04.02 Updated by Ishihara@FSIT 小計、税額も計算
'    strStmt = strStmt & _
              "        (" & vbLf & _
              "         SELECT BILLDETAIL.BILLNO, SUM(BILLDETAIL.TOTAL)    TOTAL          " & vbLf & _
              "           FROM BILLDETAIL, BILL" & vbLf
    strStmt = strStmt & _
              "        (" & vbLf & _
              "         SELECT BILLDETAIL.BILLNO,                 " & vbLf & _
              "                SUM(BILLDETAIL.SUBTOTAL) SUBTOTAL, " & vbLf & _
              "                SUM(BILLDETAIL.TAX)      TAX,      " & vbLf & _
              "                SUM(BILLDETAIL.TOTAL)    TOTAL     " & vbLf & _
              "           FROM BILLDETAIL, BILL" & vbLf
'### 2003.04.02 Updated End

    '請求書番号が指定されている
    If blnIsBillNo = True Then
        strStmt = strStmt & _
              "          WHERE BILL.BILLNO = :BILLNO" & vbLf
    End If

    '締め日範囲が設定されている（請求書番号がない場合のみ）
    If (blnIsCloseDate = True) And (blnIsBillNo = False) Then
        strStmt = strStmt & _
              "          WHERE BILL.CLOSEDATE BETWEEN :STRDATE AND :ENDDATE" & vbLf
    End If
    
    '負担元が設定されている
    If blnIsBurdenOrgCd = True Then
        strStmt = strStmt & _
              "           AND BILL.ORGCD1 = :BURDENORGCD1" & vbLf & _
              "           AND BILL.ORGCD2 = :BURDENORGCD2" & vbLf
    End If
    
    '請求書分類コードが設定されている。
    If blnIsBillClassCd = True Then
        strStmt = strStmt & _
              "           AND BILL.BILLCLASSCD = :BILLCLASSCD" & vbLf
    End If

    '請求書出力状態が設定されている。
    If blnIsIsPrint = True Then
        strStmt = strStmt & _
              "           AND BILL.PRTDATE IS NOT NULL" & vbLf
    End If
    
    '請求書未出力状態が設定されている。
    If blnIsIsNoPrint = True Then
        strStmt = strStmt & _
              "           AND BILL.PRTDATE IS NULL" & vbLf
    End If

    strStmt = strStmt & _
              "           AND BILLDETAIL.BILLNO = BILL.BILLNO" & vbLf & _
              "         GROUP BY BILLDETAIL.BILLNO" & vbLf & _
              "       ) BILLDETAILSUM," & vbLf
    
'## 2003.01.04 Modified *Lines by ishihara@FSIT ORDER BYのROWNUMを効かせるにはもう一度VIEWが必要
'    strStmt = strStmt & _
'              "        (" & vbLf & _
'              "          SELECT ROWNUM                   ROWSEQ,        " & vbLf & _
'              "                 BILL.BILLNO              BILLNO,        " & vbLf & _
'              "                 BILL.CLOSEDATE           CLOSEDATE,     " & vbLf & _
'              "                 BILL.ORGCD1              BURDENORGCD1,  " & vbLf & _
'              "                 BILL.ORGCD2              BURDENORGCD2,  " & vbLf & _
'              "                 ORG.ORGNAME              BURDENORGNAME, " & vbLf & _
'              "                 BILL.BILLCLASSCD         BILLCLASSCD,   " & vbLf & _
'              "                 BILLCLASS.BILLCLASSNAME  BILLCLASSNAME, " & vbLf & _
'              "                 BILL.METHOD              METHOD,        " & vbLf & _
'              "                 BILL.PRTDATE             PRTDATE        " & vbLf & _
'              "            FROM BILLCLASS, ORG, BILL                    " & vbLf
'
'    '請求書番号が指定されている
'    If blnIsBillNo = True Then
'        strStmt = strStmt & _
'              "           WHERE BILL.BILLNO = :BILLNO" & vbLf
'    End If
'
'    '締め日範囲が設定されている（請求書番号がない場合のみ）
'    If (blnIsCloseDate = True) And (blnIsBillNo = False) Then
'        strStmt = strStmt & _
'              "           WHERE BILL.CLOSEDATE BETWEEN :STRDATE AND :ENDDATE" & vbLf
'    End If
'
'    '負担元が設定されている
'    If blnIsBurdenOrgCd = True Then
'        strStmt = strStmt & _
'              "             AND BILL.ORGCD1 = :BURDENORGCD1" & vbLf & _
'              "             AND BILL.ORGCD2 = :BURDENORGCD2" & vbLf
'    End If
'
'    '請求書分類コードが設定されている。
'    If blnIsBillClassCd = True Then
'        strStmt = strStmt & _
'              "             AND BILL.BILLCLASSCD = :BILLCLASSCD" & vbLf
'    End If
'
'    '請求書出力状態が設定されている。
'    If blnIsIsPrint = True Then
'        strStmt = strStmt & _
'              "             AND BILL.PRTDATE IS NOT NULL" & vbLf
'    End If
'
'    '請求書未出力状態が設定されている。
'    If blnIsIsNoPrint = True Then
'        strStmt = strStmt & _
'              "             AND BILL.PRTDATE IS NULL" & vbLf
'    End If
'
'    strStmt = strStmt & _
'              "             AND ORG.ORGCD1            = BILL.ORGCD1     " & vbLf & _
'              "             AND ORG.ORGCD2            = BILL.ORGCD2     " & vbLf & _
'              "             AND BILLCLASS.BILLCLASSCD = BILL.BILLCLASSCD" & vbLf & _
'              "            ORDER BY BILL.CLOSEDATE, BILL.ORGCD1, BILL.ORGCD2, BILL.BILLCLASSCD" & vbLf & _
'              "        ) BASEBILL" & vbLf
    
    strStmt = strStmt & _
              "         (   SELECT ROWNUM ROWSEQ,                          " & vbLf & _
              "                    BASEBILLBEFORESORT.BILLNO,              " & vbLf & _
              "                    BASEBILLBEFORESORT.CLOSEDATE,           " & vbLf & _
              "                    BASEBILLBEFORESORT.BURDENORGCD1,        " & vbLf & _
              "                    BASEBILLBEFORESORT.BURDENORGCD2,        " & vbLf & _
              "                    BASEBILLBEFORESORT.BURDENORGNAME,       " & vbLf & _
              "                    BASEBILLBEFORESORT.BILLCLASSCD,         " & vbLf & _
              "                    BASEBILLBEFORESORT.BILLCLASSNAME,       " & vbLf & _
              "                    BASEBILLBEFORESORT.METHOD,              " & vbLf & _
              "                    BASEBILLBEFORESORT.PRTDATE              " & vbLf & _
              "               FROM                                         " & vbLf

'### 2003.04.02 Updated by Ishihara@FSIT 団体名は略称を使用する。
'    strStmt = strStmt & _
              "         (   SELECT BILL.BILLNO              BILLNO,        " & vbLf & _
              "                    BILL.CLOSEDATE           CLOSEDATE,     " & vbLf & _
              "                    BILL.ORGCD1              BURDENORGCD1,  " & vbLf & _
              "                    BILL.ORGCD2              BURDENORGCD2,  " & vbLf & _
              "                    ORG.ORGNAME              BURDENORGNAME, " & vbLf & _
              "                    BILL.BILLCLASSCD         BILLCLASSCD,   " & vbLf & _
              "                    BILLCLASS.BILLCLASSNAME  BILLCLASSNAME, " & vbLf & _
              "                    BILL.METHOD              METHOD,        " & vbLf & _
              "                    BILL.PRTDATE             PRTDATE        " & vbLf & _
              "               FROM BILLCLASS, ORG, BILL                    " & vbLf
    strStmt = strStmt & _
              "         (   SELECT BILL.BILLNO              BILLNO,        " & vbLf & _
              "                    BILL.CLOSEDATE           CLOSEDATE,     " & vbLf & _
              "                    BILL.ORGCD1              BURDENORGCD1,  " & vbLf & _
              "                    BILL.ORGCD2              BURDENORGCD2,  " & vbLf & _
              "                    ORG.ORGSNAME             BURDENORGNAME, " & vbLf & _
              "                    BILL.BILLCLASSCD         BILLCLASSCD,   " & vbLf & _
              "                    BILLCLASS.BILLCLASSNAME  BILLCLASSNAME, " & vbLf & _
              "                    BILL.METHOD              METHOD,        " & vbLf & _
              "                    BILL.PRTDATE             PRTDATE        " & vbLf & _
              "               FROM BILLCLASS, ORG, BILL                    " & vbLf
'### 2003.04.02 Updated End
    
    '請求書番号が指定されている
    If blnIsBillNo = True Then
        strStmt = strStmt & _
              "              WHERE BILL.BILLNO = :BILLNO" & vbLf
    End If

    '締め日範囲が設定されている（請求書番号がない場合のみ）
    If (blnIsCloseDate = True) And (blnIsBillNo = False) Then
        strStmt = strStmt & _
              "              WHERE BILL.CLOSEDATE BETWEEN :STRDATE AND :ENDDATE" & vbLf
    End If
    
    '負担元が設定されている
    If blnIsBurdenOrgCd = True Then
        strStmt = strStmt & _
              "                AND BILL.ORGCD1 = :BURDENORGCD1" & vbLf & _
              "                AND BILL.ORGCD2 = :BURDENORGCD2" & vbLf
    End If
    
    '請求書分類コードが設定されている。
    If blnIsBillClassCd = True Then
        strStmt = strStmt & _
              "                AND BILL.BILLCLASSCD = :BILLCLASSCD" & vbLf
    End If

    '請求書出力状態が設定されている。
    If blnIsIsPrint = True Then
        strStmt = strStmt & _
              "                AND BILL.PRTDATE IS NOT NULL" & vbLf
    End If
    
    '請求書未出力状態が設定されている。
    If blnIsIsNoPrint = True Then
        strStmt = strStmt & _
              "                AND BILL.PRTDATE IS NULL" & vbLf
    End If

    strStmt = strStmt & _
              "                AND ORG.ORGCD1            = BILL.ORGCD1     " & vbLf & _
              "                AND ORG.ORGCD2            = BILL.ORGCD2     " & vbLf & _
              "                AND BILLCLASS.BILLCLASSCD = BILL.BILLCLASSCD" & vbLf & _
              "               ORDER BY BILL.CLOSEDATE, BILL.ORGCD1, BILL.ORGCD2, BILL.BILLCLASSCD" & vbLf & _
              "         ) BASEBILLBEFORESORT" & vbLf
    
    strStmt = strStmt & _
              "         ) BASEBILL" & vbLf

'## 2003.01.04 Modified End
    
    strStmt = strStmt & _
              "  WHERE BASEBILL.BILLNO  = BILLDETAILSUM.BILLNO(+) " & vbLf & _
              "    AND BASEBILL.BILLNO  = PAYMENT.BILLNO(+)" & vbLf & _
              "    AND PAYMENT.UPDUSER  = HAINSUSER.USERID(+)" & vbLf & _
              "    AND BASEBILL.BILLNO  = PAYMENTTOTAL.BILLNO(+)"
    
    '取得件数と開始位置が設定されている場合
    If (IsMissing(vntGetCount) = False) And (IsMissing(vntGetCount) = False) Then
        If IsNumeric(vntGetCount) And IsNumeric(vntGetCount) And _
           Trim(vntGetCount) <> "" And Trim(vntGetCount) <> "" Then
            strStmt = strStmt & vbLf & _
                  "    AND BASEBILL.ROWSEQ BETWEEN :SEQ_F AND :SEQ_T" & vbLf
        End If
    End If

'### 2003.04.02 Updated by Ishihara@FSIT 締め日を先頭に
'    strStmt = strStmt & _
              " ORDER BY BASEBILL.BILLNO, PAYMENT.SEQ"
    strStmt = strStmt & _
              " ORDER BY BASEBILL.CLOSEDATE, BASEBILL.BILLNO, PAYMENT.SEQ"
'### 2003.04.02 Updated End

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objBillNo = objFields("BILLNO")
        Set objRowSeq = objFields("ROWSEQ")
        Set objCloseDate = objFields("CLOSEDATE")
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objOrgName = objFields("ORGNAME")
        Set objBillClassCd = objFields("BILLCLASSCD")
        Set objBillClassName = objFields("BILLCLASSNAME")
        Set objTotal = objFields("TOTAL")
        Set objPaymentTotal = objFields("PAYMENTTOTAL")
        Set objSeq = objFields("SEQ")
        Set objPaymentDate = objFields("PAYMENTDATE")
        Set objPaymentPrice = objFields("PAYMENTPRICE")
        Set objPaymentDiv = objFields("PAYMENTDIV")
        Set objUpdUser = objFields("UPDUSER")
        Set objUserName = objFields("USERNAME")
'### 2003.04.02 Updated by Ishihara@FSIT 小計、税額も計算
        Set objSubTotal = objFields("SUBTOTAL")
        Set objTax = objFields("TAX")
'### 2003.04.02 Updated End
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            
            If vntMode = "CNT" Then
                
                '件数取得モードの場合、請求書の枚数を返す
                ReDim Preserve vntArrRowSeq(lngCount)
                vntArrRowSeq(lngCount) = objRowSeq.Value & ""
                If CLng(objRowSeq.Value & "") >= lngCount Then
                    lngCount = CLng(objRowSeq.Value & "")
                End If
                
            Else
                
                '通常モードの場合、引数に応じた結果を返す
                ReDim Preserve vntArrBillNo(lngCount)
                ReDim Preserve vntArrCloseDate(lngCount)
                ReDim Preserve vntArrOrgCd1(lngCount)
                ReDim Preserve vntArrOrgCd2(lngCount)
                ReDim Preserve vntArrOrgName(lngCount)
                ReDim Preserve vntArrBillClassCd(lngCount)
                ReDim Preserve vntArrBillClassName(lngCount)
                ReDim Preserve vntArrTotal(lngCount)
                ReDim Preserve vntArrPaymentTotal(lngCount)
                ReDim Preserve vntArrSeq(lngCount)
                ReDim Preserve vntArrPaymentDate(lngCount)
                ReDim Preserve vntArrPaymentPrice(lngCount)
                ReDim Preserve vntArrPaymentDiv(lngCount)
                ReDim Preserve vntArrUpdUser(lngCount)
                ReDim Preserve vntArrUserName(lngCount)
'### 2003.04.02 Updated by Ishihara@FSIT 小計、税額も計算
                ReDim Preserve vntArrSubTotal(lngCount)
                ReDim Preserve vntArrTax(lngCount)
'### 2003.04.02 Updated End
                
                vntArrBillNo(lngCount) = objBillNo.Value & ""
                vntArrCloseDate(lngCount) = objCloseDate.Value & ""
                vntArrOrgCd1(lngCount) = objOrgCd1.Value & ""
                vntArrOrgCd2(lngCount) = objOrgCd2.Value & ""
                vntArrOrgName(lngCount) = objOrgName.Value & ""
                vntArrBillClassCd(lngCount) = objBillClassCd.Value & ""
                vntArrBillClassName(lngCount) = objBillClassName.Value & ""
                vntArrTotal(lngCount) = objTotal.Value & ""
                vntArrPaymentTotal(lngCount) = objPaymentTotal.Value & ""
                vntArrSeq(lngCount) = objSeq.Value & ""
                vntArrPaymentDate(lngCount) = objPaymentDate.Value & ""
                vntArrPaymentPrice(lngCount) = objPaymentPrice.Value & ""
                vntArrPaymentDiv(lngCount) = objPaymentDiv.Value & ""
                vntArrUpdUser(lngCount) = objUpdUser.Value & ""
                vntArrUserName(lngCount) = objUserName.Value & ""
'### 2003.04.02 Updated by Ishihara@FSIT 小計、税額も計算
                vntArrSubTotal(lngCount) = objSubTotal.Value & ""
                vntArrTax(lngCount) = objTax.Value & ""
'### 2003.04.02 Updated End
            
                lngCount = lngCount + 1
            
            End If
            
            objOraDyna.MoveNext
        Loop
    
    End If
    
    '戻り値の設定
    If vntMode <> "CNT" Then
        If IsMissing(vntBillNo) = False Then vntBillNo = vntArrBillNo
        If IsMissing(vntCloseDate) = False Then vntCloseDate = vntArrCloseDate
        If IsMissing(vntOrgCd1) = False Then vntOrgCd1 = vntArrOrgCd1
        If IsMissing(vntOrgCd2) = False Then vntOrgCd2 = vntArrOrgCd2
        If IsMissing(vntOrgName) = False Then vntOrgName = vntArrOrgName
        If IsMissing(vntBillClassCd) = False Then vntBillClassCd = vntArrBillClassCd
        If IsMissing(vntBillClassName) = False Then vntBillClassName = vntArrBillClassName
        If IsMissing(vntTotal) = False Then vntTotal = vntArrTotal
        If IsMissing(vntPaymentTotal) = False Then vntPaymentTotal = vntArrPaymentTotal
        If IsMissing(vntSeq) = False Then vntSeq = vntArrSeq
        If IsMissing(vntPaymentDate) = False Then vntPaymentDate = vntArrPaymentDate
        If IsMissing(vntPaymentPrice) = False Then vntPaymentPrice = vntArrPaymentPrice
        If IsMissing(vntPaymentDiv) = False Then vntPaymentDiv = vntArrPaymentDiv
        If IsMissing(vntUpdUser) = False Then vntUpdUser = vntArrUpdUser
        If IsMissing(vntUserName) = False Then vntUserName = vntArrUserName
'### 2003.04.02 Updated by Ishihara@FSIT 小計、税額も計算
        If IsMissing(vntSubTotal) = False Then vntSubTotal = vntArrSubTotal
        If IsMissing(vntTax) = False Then vntTax = vntArrTax
'### 2003.04.02 Updated End
    End If
    
    SelectDmdPaymentSearchList = lngCount
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraDyna = Nothing
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.SelectDmdPaymentSearchList"
    
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

'## 2004.01.17 聖路加版
'
' 機能　　 : 検索条件を満たす請求書情報を取得する
'
' 引数　　 : (In)   lngCloseYear        締め日(年)
'          : (In)   lngCloseMonth       締め日(月)
'          : (In)   lngCloseDay         締め日(日)
'          : (Out)  strCloseDate        締め日
'          : (In)   lngBillSeq          請求書Seq
'          : (In)   lngBranchNo         請求書枝番
'          : (Out)  vntDelFlg           請求書削除フラグ
' 　　　　 : (Out)  vntOrgName          団体名
' 　　　　 : (Out)  vntTotal            請求額
' 　　　　 : (Out)  vntNotPayment       未収金
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function SelectDmdPaymentBillSum(ByVal lngCloseYear As Long, _
                                        ByVal lngCloseMonth As Long, _
                                        ByVal lngCloseDay As Long, _
                                        ByRef vntCloseDate As Variant, _
                                        ByVal lngBillSeq As Long, _
                                        ByVal lngBranchNo As Long, _
                                        ByRef vntDelFlg As Variant, _
                                        Optional ByRef vntOrgName As Variant, _
                                        Optional ByRef vntTotal As Variant, _
                                        Optional ByRef vntNotPayment As Variant, _
                                        Optional ByRef vntOrgKName As Variant _
                                       ) As Boolean


    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objCloseDate            As OraField         '締め日
    Dim objOrgName              As OraField         '団体名
    Dim objOrgKName             As OraField         '団体名
    Dim objTotal                As OraField         '請求金額
    Dim objPaymentPrice         As OraField         '未収金
    Dim objDelFlg               As OraField         '削除フラグ
    Dim strCloseDate            As String
    
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    SelectDmdPaymentBillSum = False
    
        
    '検索条件が設定されていない場合はエラー
    If lngCloseYear = 0 Or lngCloseMonth = 0 Or lngCloseDay = 0 Or lngBillSeq = 0 Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    strCloseDate = CStr(lngCloseYear) & "/" & CStr(lngCloseMonth) & "/" & CStr(lngCloseDay)
    
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CLOSEDATE", CDate(strCloseDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER

'## 2004.06.11 MOD STR ORB)T.YAGUCHI ２次金額追加
'    '検索条件を満たす受診者情報のレコードを取得
'    strStmt = " SELECT BILL.CLOSEDATE           CLOSEDATE,                             " & vbLf & _
'              "        BILL.BILLSEQ             BILLSEQ,                               " & vbLf & _
'              "        BILL.BRANCHNO            BRANCHNO,                              " & vbLf & _
'              "        BILL.DELFLG              DELFLG,                                " & vbLf & _
'              "        ORG.ORGNAME              ORGNAME,                               " & vbLf & _
'              "        ORG.ORGKNAME             ORGKNAME,                              " & vbLf & _
'              "        NVL(TOTALBASE.TOTAL, 0) TOTAL, NVL(PAYMENTBASE.PAYMENTPRICE, 0) PAYMENTPRICE "
    '検索条件を満たす受診者情報のレコードを取得
    strStmt = " SELECT BILL.CLOSEDATE           CLOSEDATE,                             " & vbLf & _
              "        BILL.BILLSEQ             BILLSEQ,                               " & vbLf & _
              "        BILL.BRANCHNO            BRANCHNO,                              " & vbLf & _
              "        BILL.DELFLG              DELFLG,                                " & vbLf & _
              "        ORG.ORGNAME              ORGNAME,                               " & vbLf & _
              "        ORG.ORGKNAME             ORGKNAME,                              " & vbLf & _
              "        NVL(TOTALBASE.TOTAL, 0)+NVL(TOTALBASE_ITEMS.TOTAL, 0) TOTAL, NVL(PAYMENTBASE.PAYMENTPRICE, 0) PAYMENTPRICE "
'## 2004.06.11 MOD END

    strStmt = strStmt & vbLf & _
              "   FROM ( SELECT CLOSEDATE, BILLSEQ, BRANCHNO,                          " & vbLf & _
              "                 SUM(PRICE + EDITPRICE + TAXPRICE + EDITTAX) TOTAL      " & vbLf & _
              "            FROM BILLDETAIL                                             " & vbLf & _
              "           WHERE CLOSEDATE = :CLOSEDATE                                 " & vbLf & _
              "             AND BILLSEQ   = :BILLSEQ                                   " & vbLf & _
              "             AND BRANCHNO  = :BRANCHNO                                  " & vbLf & _
              "           GROUP BY CLOSEDATE, BILLSEQ, BRANCHNO                        " & vbLf & _
              "        ) TOTALBASE,                                                    "

    strStmt = strStmt & vbLf & _
              "        ( SELECT CLOSEDATE, BILLSEQ, BRANCHNO,                          " & vbLf & _
              "                 SUM(PAYMENTPRICE) PAYMENTPRICE                         " & vbLf & _
              "            FROM PAYMENT                                                " & vbLf & _
              "           WHERE CLOSEDATE = :CLOSEDATE                                 " & vbLf & _
              "             AND BILLSEQ   = :BILLSEQ                                   " & vbLf & _
              "             AND BRANCHNO  = :BRANCHNO                                  " & vbLf & _
              "           GROUP BY CLOSEDATE, BILLSEQ, BRANCHNO                        " & vbLf & _
              "        ) PAYMENTBASE,                                                  " & vbLf & _
              "        ORG, BILL                                                       "

'## 2004.06.11 ADD STR ORB)T.YAGUCHI ２次金額追加
    strStmt = strStmt & vbLf & _
              "       ,( SELECT CLOSEDATE, BILLSEQ, BRANCHNO,                          " & vbLf & _
              "                 SUM(PRICE + EDITPRICE + TAXPRICE + EDITTAX) TOTAL      " & vbLf & _
              "            FROM BILLDETAIL_ITEMS                                       " & vbLf & _
              "           WHERE CLOSEDATE = :CLOSEDATE                                 " & vbLf & _
              "             AND BILLSEQ   = :BILLSEQ                                   " & vbLf & _
              "             AND BRANCHNO  = :BRANCHNO                                  " & vbLf & _
              "           GROUP BY CLOSEDATE, BILLSEQ, BRANCHNO                        " & vbLf & _
              "        ) TOTALBASE_ITEMS                                               "
'## 2004.06.11 ADD END

    strStmt = strStmt & vbLf & _
              "  WHERE BILL.CLOSEDATE        = :CLOSEDATE                              " & vbLf & _
              "    AND BILL.BILLSEQ          = :BILLSEQ                                " & vbLf & _
              "    AND BILL.BRANCHNO         = :BRANCHNO                               " & vbLf & _
              "    AND ORG.ORGCD1            = BILL.ORGCD1                             " & vbLf & _
              "    AND ORG.ORGCD2            = BILL.ORGCD2                             " & vbLf & _
              "    AND BILL.CLOSEDATE        = TOTALBASE.CLOSEDATE(+)                  " & vbLf & _
              "    AND BILL.BILLSEQ          = TOTALBASE.BILLSEQ(+)                    " & vbLf & _
              "    AND BILL.BRANCHNO         = TOTALBASE.BRANCHNO(+)                   " & vbLf & _
              "    AND BILL.CLOSEDATE        = PAYMENTBASE.CLOSEDATE(+)                " & vbLf & _
              "    AND BILL.BILLSEQ          = PAYMENTBASE.BILLSEQ(+)                  " & vbLf & _
              "    AND BILL.BRANCHNO         = PAYMENTBASE.BRANCHNO(+)                   "
'## 2004.06.11 ADD STR ORB)T.YAGUCHI ２次金額追加
    strStmt = strStmt & vbLf & _
              "    AND BILL.CLOSEDATE        = TOTALBASE_ITEMS.CLOSEDATE(+)            " & vbLf & _
              "    AND BILL.BILLSEQ          = TOTALBASE_ITEMS.BILLSEQ(+)              " & vbLf & _
              "    AND BILL.BRANCHNO         = TOTALBASE_ITEMS.BRANCHNO(+)             "
'## 2004.06.11 ADD END

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCloseDate = objFields("CLOSEDATE")
        Set objOrgName = objFields("ORGNAME")
        Set objOrgKName = objFields("ORGKNAME")
        Set objTotal = objFields("TOTAL")
        Set objPaymentPrice = objFields("PAYMENTPRICE")
        Set objDelFlg = objFields("DELFLG")
    
        '戻り値の設定
        vntCloseDate = objCloseDate.Value & ""
        If IsMissing(vntOrgName) = False Then vntOrgName = objOrgName.Value & ""
        If IsMissing(vntTotal) = False Then vntTotal = CLng(objTotal.Value)
        If IsMissing(vntNotPayment) = False Then vntNotPayment = CLng(objTotal.Value) - CLng(objPaymentPrice.Value)
        If IsMissing(vntOrgKName) = False Then vntOrgKName = objOrgKName.Value & ""
        vntDelFlg = CLng(objDelFlg.Value)
    
        SelectDmdPaymentBillSum = True
        'データがないのはエラー
    
    End If
    
    Set objOraDyna = Nothing
    
    'バインド変数削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.SelectDmdPaymentBillSum"
    
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

'## 2004.01.17 聖路加版
'
' 機能　　 : 入金情報を取得する
'
' 引数　　 : (In)   dtmCloseDate        締め日
'          : (In)   lngBillSeq          請求書Seq
'          : (In)   lngBranchNo         請求書枝番
'          : (In)   lngSeq              入金Seq
' 　　　　 : (Out)  vntPaymentPrice     入金額
' 　　　　 : (Out)  vntDuePrice         未収金
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function GetDmdPaymentPrice(ByVal dtmCloseDate As Date, _
                                   ByVal lngBillSeq As Long, _
                                   ByVal lngBranchNo As Long, _
                                   ByVal lngSeq As Long, _
                                   ByRef vntPaymentPrice As Variant, _
                                   ByRef vntDuePrice As Variant) As Boolean
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objPaymentPrice         As OraField         '入金
    Dim objDuePrice             As OraField         '未収金
    
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    GetDmdPaymentPrice = False
    
    '検索条件が設定されていない場合はエラー
    If dtmCloseDate = 0 Or lngBillSeq = 0 Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CLOSEDATE", dtmCloseDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SEQ", lngSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    

    strStmt = "SELECT BILL.CLOSEDATE            CLOSEDATE,                  " & vbLf & _
              "       BILL.BILLSEQ              BILLSEQ,                    " & vbLf & _
              "       BILL.BRANCHNO             BRANCHNO,                   " & vbLf & _
              "       NVL(PAYMENT.PAYMENTPRICE, 0) PAYMENTPRICE,            " & vbLf & _
              "       NVL(TOTALBASE.TOTAL, 0) - NVL(PAYMENTBASE.PAYMENT, 0) DUEPRICE " & vbLf & _
              "  FROM ( SELECT CLOSEDATE, BILLSEQ,                          " & vbLf & _
              "                SUM(PRICE+EDITPRICE+TAXPRICE+EDITTAX) TOTAL  " & vbLf & _
              "           FROM BILLDETAIL                                   " & vbLf & _
              "          WHERE CLOSEDATE = :CLOSEDATE                       " & vbLf & _
              "            AND BILLSEQ = :BILLSEQ                           " & vbLf & _
              "          GROUP BY CLOSEDATE, BILLSEQ ) TOTALBASE,           " & vbLf & _
              "       ( SELECT CLOSEDATE, BILLSEQ,                          " & vbLf & _
              "                SUM(PAYMENTPRICE) PAYMENT                    " & vbLf & _
              "           FROM PAYMENT                                      " & vbLf & _
              "          WHERE CLOSEDATE = :CLOSEDATE                       " & vbLf & _
              "            AND BILLSEQ = :BILLSEQ                           " & vbLf & _
              "          GROUP BY CLOSEDATE, BILLSEQ ) PAYMENTBASE,         " & vbLf & _
              "       ( SELECT CLOSEDATE, BILLSEQ, BRANCHNO, SEQ,           " & vbLf & _
              "                PAYMENTPRICE                                 " & vbLf & _
              "           FROM PAYMENT                                      " & vbLf & _
              "          WHERE CLOSEDATE = :CLOSEDATE                       " & vbLf & _
              "            AND BILLSEQ = :BILLSEQ                           " & vbLf & _
              "            AND BRANCHNO = :BRANCHNO                         " & vbLf & _
              "            AND SEQ = :SEQ ) PAYMENT,                        " & vbLf & _
              "       BILL                                                  "
              
    strStmt = strStmt & vbLf & _
              " WHERE BILL.CLOSEDATE = :CLOSEDATE                           " & vbLf & _
              "   AND BILL.BILLSEQ   = :BILLSEQ                             " & vbLf & _
              "   AND BILL.BRANCHNO  = :BRANCHNO                            " & vbLf & _
              "   AND BILL.CLOSEDATE = PAYMENT.CLOSEDATE(+)                 " & vbLf & _
              "   AND BILL.BILLSEQ   = PAYMENT.BILLSEQ(+)                   " & vbLf & _
              "   AND BILL.BRANCHNO  = PAYMENT.BRANCHNO(+)                  " & vbLf & _
              "   AND BILL.CLOSEDATE = TOTALBASE.CLOSEDATE(+)               " & vbLf & _
              "   AND BILL.BILLSEQ   = TOTALBASE.BILLSEQ(+)                 " & vbLf & _
              "   AND BILL.CLOSEDATE = PAYMENTBASE.CLOSEDATE(+)             " & vbLf & _
              "   AND BILL.BILLSEQ   = PAYMENTBASE.BILLSEQ(+)               "
 
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objPaymentPrice = objFields("PAYMENTPRICE")
        Set objDuePrice = objFields("DUEPRICE")
    
        '戻り値の設定
        vntPaymentPrice = CLng(objPaymentPrice.Value)
        vntDuePrice = CLng(objDuePrice.Value)
    
        GetDmdPaymentPrice = True
        'データがないのはエラー
    
    End If
    
    Set objOraDyna = Nothing
    
    'バインド変数削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    

    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.GetDmdPaymentPrice"
    
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


'## 2004.01.17 聖路加版
'
' 機能　　 : 検索条件を満たす請求書情報を取得する
'
' 引数　　 : (In)   strCloseDate    締め日
' 　　　　 : (In)   lngBillSeq      請求書SEQ
' 　　　　 : (In)   lngBranchNo     請求書枝番
' 　　　　 : (In)   lngSeq          SEQ
' 　　　　 : (Out)  vntPaymentDate  入金日
' 　　　　 : (Out)  vntPaymentPrice 入金額
' 　　　　 : (Out)  vntPaymentDiv   入金種別
' 　　　　 : (Out)  vntUpdUser      更新者
' 　　　　 : (Out)  vntUserName     更新者名
'          : (Out)  vntPayNote      入金コメント
'          : (Out)  vntCardKind     カード種別
'          : (Out)  vntCreditslipno 伝票No.
'          : (Out)  vntBankCode     金融機関
'          : (Out)  vntCardName     カード種別名
'          : (Out)  vntBankName     金融機関名
'### 2004.02.18 Added by H.Ishihara@FSIT いろいろ追加
'          : (Out)  vntRegisterNo   レジ番号
'          : (Out)  vntCash         現金
'### 2004.02.18 Added End
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function SelectPayment(ByVal dtmCloseDate As Date, _
                              ByVal lngBillSeq As Long, _
                              ByVal lngBranchNo As Long, _
                              ByVal lngSeq As Long, _
                              ByRef vntPaymentDate As Variant, _
                              ByRef vntPaymentPrice As Variant, _
                              ByRef vntPaymentDiv As Variant, _
                              ByRef vntUpdUser As Variant, _
                              ByRef vntUserName As Variant, _
                              ByRef vntPayNote As Variant, _
                              ByRef vntCardKind As Variant, _
                              ByRef vntCreditslipno As Variant, _
                              ByRef vntBankCode As Variant, _
                              ByRef vntCardName As Variant, _
                              ByRef vntBankName As Variant, _
                              Optional ByRef vntRegisterNo As Variant, _
                              Optional ByRef vntCash As Variant _
                             ) As Boolean
'Public Function SelectPayment(ByVal dtmCloseDate As Date, _
                              ByVal lngBillSeq As Long, _
                              ByVal lngBranchNo As Long, _
                              ByVal lngSeq As Long, _
                              ByRef vntPaymentDate As Variant, _
                              ByRef vntPaymentPrice As Variant, _
                              ByRef vntPaymentDiv As Variant, _
                              ByRef vntUpdUser As Variant, _
                              ByRef vntUserName As Variant, _
                              ByRef vntPayNote As Variant, _
                              ByRef vntCardKind As Variant, _
                              ByRef vntCreditslipno As Variant, _
                              ByRef vntBankCode As Variant, _
                              ByRef vntCardName As Variant, _
                              ByRef vntBankName As Variant _
                             ) As Boolean
'Public Function SelectPayment(ByVal lngBillNo As Long, _
'                              ByVal lngSeq As Long, _
'                              ByRef vntPaymentDate As Variant, _
'                              ByRef vntPaymentPrice As Variant, _
'                              ByRef vntPaymentDiv As Variant, _
'                              ByRef vntUpdUser As Variant, _
'                              ByRef vntUserName As Variant _
'                             ) As Boolean
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objPaymentDate          As OraField         '入金日
    Dim objPaymentPrice         As OraField         '入金額
    Dim objPaymentDiv           As OraField         '入金種別
    Dim objUpdUser              As OraField         '更新者
    Dim objUserName             As OraField         '更新者名
    Dim objPayNote              As OraField         '入金コメント
    Dim objCardKind             As OraField         'カード種別
    Dim objCreditSlipNo         As OraField         '伝票No.
    Dim objBankCode             As OraField         '金融機関
    Dim objCardName             As OraField         'カード種別名
    Dim objBankName             As OraField         '金融機関名
    
'### 2004.02.18 Added by H.Ishihara@FSIT いろいろ追加
    Dim objRegisterNo           As OraField         'レジ番号
    Dim objCash                 As OraField         '現金
'### 2004.02.18 Added End
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    SelectPayment = False
    
    '検索条件が設定されていない場合はエラー
    If dtmCloseDate = 0 Or lngBillSeq = 0 Or lngSeq = 0 Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CLOSEDATE", dtmCloseDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SEQ", lngSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '検索条件を満たす入金情報のレコードを取得
'### 2004.02.18 Added by H.Ishihara@FSIT いろいろ追加
'    strStmt = "SELECT PM.PAYMENTDATE, PM.PAYMENTPRICE, PM.PAYMENTDIV,   " & vbLf & _
              "       PM.UPDUSER, HU.USERNAME,                          " & vbLf & _
              "       PM.PAYNOTE,                                       " & vbLf & _
              "       PM.CARDKIND,                                      " & vbLf & _
              "       PM.CREDITSLIPNO,                                  " & vbLf & _
              "       PM.BANKCODE,                                      " & vbLf & _
              "       CARD.CARDNAME,                                    " & vbLf & _
              "       BANK.BANKNAME                                     " & vbLf & _
              "  FROM PAYMENT PM, HAINSUSER HU,                         " & vbLf & _
              "      (SELECT FREECD, FREEFIELD1 CARDNAME FROM FREE) CARD, " & vbLf & _
              "      (SELECT FREECD, FREEFIELD1 BANKNAME FROM FREE) BANK  " & vbLf & _
              " WHERE PM.CLOSEDATE  = :CLOSEDATE                        " & vbLf & _
              "   AND PM.BILLSEQ    = :BILLSEQ                          " & vbLf & _
              "   AND PM.BRANCHNO   = :BRANCHNO                         " & vbLf & _
              "   AND PM.SEQ        = :SEQ                              " & vbLf & _
              "   AND PM.UPDUSER    = HU.USERID                         " & vbLf & _
              "   AND PM.CARDKIND   = CARD.FREECD(+)                    " & vbLf & _
              "   AND PM.BANKCODE   = BANK.FREECD(+)                    "
    strStmt = "SELECT PM.PAYMENTDATE, PM.PAYMENTPRICE, PM.PAYMENTDIV,   " & vbLf & _
              "       PM.UPDUSER, HU.USERNAME,                          " & vbLf & _
              "       PM.PAYNOTE,                                       " & vbLf & _
              "       PM.CARDKIND,                                      " & vbLf & _
              "       PM.CREDITSLIPNO,                                  " & vbLf & _
              "       PM.BANKCODE,                                      " & vbLf & _
              "       PM.REGISTERNO,                                    " & vbLf & _
              "       PM.CASH,                                          " & vbLf & _
              "       CARD.CARDNAME,                                    " & vbLf & _
              "       BANK.BANKNAME                                     " & vbLf & _
              "  FROM PAYMENT PM, HAINSUSER HU,                         " & vbLf & _
              "      (SELECT FREECD, FREEFIELD1 CARDNAME FROM FREE) CARD, " & vbLf & _
              "      (SELECT FREECD, FREEFIELD1 BANKNAME FROM FREE) BANK  " & vbLf & _
              " WHERE PM.CLOSEDATE  = :CLOSEDATE                        " & vbLf & _
              "   AND PM.BILLSEQ    = :BILLSEQ                          " & vbLf & _
              "   AND PM.BRANCHNO   = :BRANCHNO                         " & vbLf & _
              "   AND PM.SEQ        = :SEQ                              " & vbLf & _
              "   AND PM.UPDUSER    = HU.USERID                         " & vbLf & _
              "   AND PM.CARDKIND   = CARD.FREECD(+)                    " & vbLf & _
              "   AND PM.BANKCODE   = BANK.FREECD(+)                    "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
'### 2004.02.18 Added End
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objPaymentDate = objFields("PAYMENTDATE")
        Set objPaymentPrice = objFields("PAYMENTPRICE")
        Set objPaymentDiv = objFields("PAYMENTDIV")
        Set objUpdUser = objFields("UPDUSER")
        Set objUserName = objFields("USERNAME")
        Set objPayNote = objFields("PAYNOTE")
        Set objCardKind = objFields("CARDKIND")
        Set objCreditSlipNo = objFields("CREDITSLIPNO")
        Set objBankCode = objFields("BANKCODE")
        Set objCardName = objFields("CARDNAME")
        Set objBankName = objFields("BANKNAME")
    
'### 2004.02.18 Added by H.Ishihara@FSIT いろいろ追加
        Set objRegisterNo = objFields("REGISTERNO")
        Set objCash = objFields("CASH")
'### 2004.02.18 Added End
    
        '戻り値の設定
        vntPaymentDate = CDate(objPaymentDate.Value)
        vntPaymentPrice = CLng(objPaymentPrice.Value)
        vntPaymentDiv = objPaymentDiv.Value
        vntUpdUser = objUpdUser.Value
        vntUserName = objUserName.Value
        vntPayNote = objPayNote.Value
        vntCardKind = IIf(IsNull(objCardKind.Value), "", objCardKind.Value)
        vntCreditslipno = IIf(IsNull(objCreditSlipNo.Value), "", objCreditSlipNo.Value)
        vntBankCode = IIf(IsNull(objBankCode.Value), "", objBankCode.Value)
        vntCardName = IIf(IsNull(objCardName.Value), "", objCardName.Value)
        vntBankName = IIf(IsNull(objBankName.Value), "", objBankName.Value)
        
'### 2004.02.18 Added by H.Ishihara@FSIT いろいろ追加
        If Not IsMissing(vntRegisterNo) Then vntRegisterNo = objRegisterNo.Value & ""
        If Not IsMissing(vntCash) Then vntCash = objCash.Value & ""
'### 2004.02.18 Added End
        
    End If
    
    Set objOraDyna = Nothing
    
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing
    
    SelectPayment = True
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.SelectPayment"
    
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




' 機能　　 : 発送情報を更新する
'
' 引数　　 : (In)   strCloseDate     締め日
' 　　　　 : (In)   lngBillSeq       請求書SEQ
' 　　　　 : (In)   lngBranchNo      請求書枝番
' 　　　　 : (In)   lngSeq           SEQ
' 　　　　 : (In)   dtmPaymentDate   発送日
'          : (In)   lngMaxSeq        1:MAX(SEQ)のレコードを更新する
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function UpdateDispatch(ByVal dtmCloseDate As Date, _
                              ByVal lngBillSeq As Long, _
                              ByVal lngBranchNo As Long, _
                              ByVal lngSeq As Long, _
                              ByVal dtmDispatchDate As Date, _
                              ByVal strUpdUser As String, _
                              Optional ByVal lngMaxSeq As Variant) As Boolean
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    UpdateDispatch = False
    
    '検索条件が設定されていない場合はエラー
    If dtmCloseDate = 0 Or lngBillSeq = 0 Or lngSeq = 0 Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CLOSEDATE", dtmCloseDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SEQ", lngSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DISPATCHDATE", dtmDispatchDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '該当キーの入金情報を更新
    strStmt = "UPDATE DISPATCH                      " & vbLf & _
              "   SET DISPATCHDATE = :DISPATCHDATE, " & vbLf & _
              "       UPDDATE      = SYSDATE,       " & vbLf & _
              "       UPDUSER      = :UPDUSER       " & vbLf & _
              " WHERE CLOSEDATE    = :CLOSEDATE     " & vbLf & _
              "   AND BILLSEQ      = :BILLSEQ       " & vbLf & _
              "   AND BRANCHNO     = :BRANCHNO      "
              
    If Not IsMissing(lngMaxSeq) Then
        strStmt = strStmt & vbLf & _
                  "   AND SEQ      =                " & vbLf & _
                  "( SELECT MAX(SEQ) FROM DISPATCH  " & vbLf & _
                  "   WHERE CLOSEDATE = :CLOSEDATE  " & vbLf & _
                  "     AND BILLSEQ   = :BILLSEQ    " & vbLf & _
                  "     AND BRANCHNO  = :BRANCHNO)  "
    Else
        strStmt = strStmt & vbLf & _
                  "   AND SEQ      = :SEQ           "
    End If

    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing
    
    '戻り値の設定
    UpdateDispatch = True
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.UpdateDispatch"
    
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


'## 2004.01.17 聖路加版
' 機能　　 : 入金情報検索条件の妥当性チェックを行う
'
' 引数　　 : (In)   strCloseDate    締め日
' 　　　　 : (In)   lngBillSeq      請求書SEQ
' 　　　　 : (In)   lngBranchNo     請求書枝番
' 　　　　 : (In)   strSeq          入金SEQ
' 　　　　 : (In)   lngPaymenYear   入金日（年）
' 　　　　 : (In)   lngPaymentMonth 入金日（月）
' 　　　　 : (Out)  vntPaymentDate  入金日
' 　　　　 : (In)   vntPaymentPrice 入金額
' 　　　　 : (In)   vntPaymentDiv   入金種別
' 　　　　 : (In)   vntPayNote      コメント
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
Public Function CheckValuePayment(ByVal strCloseDate As Date, _
                                  ByVal lngBillSeq As Long, _
                                  ByVal lngBranchNo As Long, _
                                  ByVal strSeq As String, _
                                  ByVal lngPaymentYear As Long, _
                                  ByVal lngPaymentMonth As Long, _
                                  ByVal lngPaymentDay As Long, _
                                  ByRef vntPaymentDate As Variant, _
                                  ByVal vntPaymentPrice As Variant, _
                                  ByVal vntPaymentDiv As Variant, _
                                  ByVal vntPayNote As Variant _
                                 ) As Variant
'Public Function CheckValuePayment(ByVal lngBillNo As Long, _
'                                  ByVal strSeq As String, _
'                                  ByVal dtmCloseDate As Date, _
'                                  ByVal lngPaymenYear As Long, _
'                                  ByVal lngPaymentMonth As Long, _
'                                  ByVal lngPaymentDay As Long, _
'                                  ByRef vntPaymentDate As Variant, _
'                                  ByVal vntPaymentPrice As Variant, _
'                                  ByVal vntPaymentDiv As Variant, _
'                                  ByVal vntUpdUser As Variant _
'                                 ) As Variant
    
    Dim objCommon               As Common           '共通クラス
    
    Dim strPaymentDate          As String           '編集用入金日
    
    Dim vntPriceMessage         As Variant          '入金額メッセージ
    Dim vntArrMessage           As Variant          'エラーメッセージの集合
    
    '初期処理
    CheckValuePayment = Empty
    vntArrMessage = Empty
    
    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    
    Do
        '各値チェック処理
        With objCommon
    
            '入金日チェック
            .AppendArray vntArrMessage, .CheckDate("入金日", lngPaymentYear, lngPaymentMonth, lngPaymentDay, strPaymentDate, CHECK_NECESSARY)
            
            If IsDate(strPaymentDate) Then
                '締め日関連チェック
                If CDate(strPaymentDate) < strCloseDate Then
                    .AppendArray vntArrMessage, "入金日は締め日以降の日付を入力してください"
                End If
                vntPaymentDate = CDate(strPaymentDate)
            End If
            
            '入金額チェック
            vntPriceMessage = .CheckNumericWithSign("入金額", vntPaymentPrice, LENGTH_PAYMENTPRICE, CHECK_NECESSARY)
            .AppendArray vntArrMessage, vntPriceMessage
            If vntPriceMessage = "" Then
                '未収金関連チェック
                .AppendArray vntArrMessage, CheckValuePaymentPrice(strCloseDate, lngBillSeq, lngBranchNo, strSeq, vntPaymentPrice)
            End If
            
            '入金種別チェック
            If vntPaymentDiv = "" Then
                .AppendArray vntArrMessage, "入金種別を指定してください"
            End If
            
'            '処理担当者チェック
'            If vntUpdUser = "" Then
'                .AppendArray vntArrMessage, "処理担当者を指定してください"
'            End If
            
            'コメントチェック
            If vntPayNote <> "" Then
                .AppendArray vntArrMessage, .CheckWideValue("入金コメント", vntPayNote, LENGTH_PAYNOTE)
            End If
    
        End With
    
        Exit Do
    Loop
    
    '戻り値の編集
    If IsArray(vntArrMessage) Then
        CheckValuePayment = vntArrMessage
    End If
    
    Set objCommon = Nothing
    
End Function



'## 2004.01.17 聖路加版
'
' 機能　　 : 入金額の合計が請求額を超えていないかチェックする
'
' 引数　　 : (In)   strCloseDate    締め日
' 　　　　 : (In)   lngBillSeq      請求書SEQ
' 　　　　 : (In)   lngBranchNo     請求書枝番
' 　　　　 : (In)   strSeq          SEQ
' 　　　　 : (In)   vntPaymentPrice 入金額
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
Private Function CheckValuePaymentPrice(ByVal dtmCloseDate As Date, _
                                       ByVal lngBillSeq As Long, _
                                       ByVal lngBranchNo As Long, _
                                       ByVal strSeq As String, _
                                       ByRef vntPaymentPrice As Variant _
                                      ) As String
'Private Function CheckValuePaymentPrice(ByVal lngBillNo As Long, _
'                                       ByVal strSeq As String, _
'                                       ByRef vntPaymentPrice As Variant _
'                                      ) As String
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objNotPayment           As OraField         '未収金額
    Dim objDelFlg               As OraField         '削除フラグ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    CheckValuePaymentPrice = Empty
    
    '検索条件が設定されていない場合はエラー
    If dtmCloseDate = 0 Or lngBillSeq = 0 Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CLOSEDATE", dtmCloseDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    If Trim(strSeq) <> "" Then
        objOraParam.Add "SEQ", CLng(strSeq), ORAPARM_INPUT, ORATYPE_NUMBER
    End If

'## 2004.06.11 MOD STR ORB)T.YAGUCHI ２次金額追加
'    '検索条件を満たす入金情報のレコードを取得
'    strStmt = " SELECT BILL.DELFLG,                                                          " & vbLf & _
'              "        NVL(TOTALBASE.TOTAL, 0) - NVL(PAYMENTBASE.PAYMENTPRICE, 0) NOTPAYMENT " & vbLf & _
'              "   FROM BILL,                                                                 " & vbLf & _
'              "        ( SELECT CLOSEDATE, BILLSEQ, BRANCHNO,                                " & vbLf & _
'              "                 SUM(PRICE + EDITPRICE + TAXPRICE + EDITTAX) TOTAL            " & vbLf & _
'              "            FROM BILLDETAIL                                                   " & vbLf & _
'              "           WHERE CLOSEDATE = :CLOSEDATE                                       " & vbLf & _
'              "             AND BILLSEQ   = :BILLSEQ                                         " & vbLf & _
'              "             AND BRANCHNO  = :BRANCHNO                                        " & vbLf & _
'              "           GROUP BY CLOSEDATE, BILLSEQ, BRANCHNO                              " & vbLf & _
'              "        ) TOTALBASE,                                                          " & vbLf & _
'              "        ( SELECT CLOSEDATE, BILLSEQ, BRANCHNO,                                " & vbLf & _
'              "                 SUM(PAYMENTPRICE) PAYMENTPRICE                               " & vbLf & _
'              "            FROM PAYMENT                                                      " & vbLf & _
'              "           WHERE CLOSEDATE = :CLOSEDATE                                       " & vbLf & _
'              "             AND BILLSEQ   = :BILLSEQ                                         " & vbLf & _
'              "             AND BRANCHNO  = :BRANCHNO                                        " & vbLf
'
'    '今回修正分の入金情報を除く
'    If Trim(strSeq) <> "" Then
'        strStmt = strStmt & vbLf & _
'                  "         AND SEQ      != :SEQ                                             " & vbLf
'    End If
'
'    strStmt = strStmt & vbLf & _
'              "           GROUP BY CLOSEDATE, BILLSEQ, BRANCHNO                              " & vbLf & _
'              "        ) PAYMENTBASE                                                         " & vbLf & _
'              "  WHERE BILL.CLOSEDATE        = :CLOSEDATE                                    " & vbLf & _
'              "    AND BILL.BILLSEQ          = :BILLSEQ                                      " & vbLf & _
'              "    AND BILL.BRANCHNO         = :BRANCHNO                                     " & vbLf & _
'              "    AND BILL.CLOSEDATE        = TOTALBASE.CLOSEDATE(+)                        " & vbLf & _
'              "    AND BILL.BILLSEQ          = TOTALBASE.BILLSEQ(+)                          " & vbLf & _
'              "    AND BILL.BRANCHNO         = TOTALBASE.BRANCHNO(+)                         " & vbLf & _
'              "    AND BILL.CLOSEDATE        = PAYMENTBASE.CLOSEDATE(+)                      " & vbLf & _
'              "    AND BILL.BILLSEQ          = PAYMENTBASE.BILLSEQ(+)                        " & vbLf & _
'              "    AND BILL.BRANCHNO         = PAYMENTBASE.BRANCHNO(+)                       "
    '検索条件を満たす入金情報のレコードを取得
    strStmt = " SELECT BILL.DELFLG,                                                          " & vbLf & _
              "        NVL(TOTALBASE.TOTAL, 0) + NVL(TOTALBASE_ITEMS.TOTAL, 0) - NVL(PAYMENTBASE.PAYMENTPRICE, 0) NOTPAYMENT " & vbLf & _
              "   FROM BILL,                                                                 " & vbLf & _
              "        ( SELECT CLOSEDATE, BILLSEQ, BRANCHNO,                                " & vbLf & _
              "                 SUM(PRICE + EDITPRICE + TAXPRICE + EDITTAX) TOTAL            " & vbLf & _
              "            FROM BILLDETAIL                                                   " & vbLf & _
              "           WHERE CLOSEDATE = :CLOSEDATE                                       " & vbLf & _
              "             AND BILLSEQ   = :BILLSEQ                                         " & vbLf & _
              "             AND BRANCHNO  = :BRANCHNO                                        " & vbLf & _
              "           GROUP BY CLOSEDATE, BILLSEQ, BRANCHNO                              " & vbLf & _
              "        ) TOTALBASE,                                                          " & vbLf & _
              "        ( SELECT CLOSEDATE, BILLSEQ, BRANCHNO,                                " & vbLf & _
              "                 SUM(PAYMENTPRICE) PAYMENTPRICE                               " & vbLf & _
              "            FROM PAYMENT                                                      " & vbLf & _
              "           WHERE CLOSEDATE = :CLOSEDATE                                       " & vbLf & _
              "             AND BILLSEQ   = :BILLSEQ                                         " & vbLf & _
              "             AND BRANCHNO  = :BRANCHNO                                        " & vbLf

    '今回修正分の入金情報を除く
    If Trim(strSeq) <> "" Then
        strStmt = strStmt & vbLf & _
                  "         AND SEQ      != :SEQ                                             " & vbLf
    End If
    
    strStmt = strStmt & vbLf & _
              "           GROUP BY CLOSEDATE, BILLSEQ, BRANCHNO                              " & vbLf & _
              "        ) PAYMENTBASE,                                                        " & vbLf & _
              "        ( SELECT CLOSEDATE, BILLSEQ, BRANCHNO,                                " & vbLf & _
              "                 SUM(PRICE + EDITPRICE + TAXPRICE + EDITTAX) TOTAL            " & vbLf & _
              "            FROM BILLDETAIL_ITEMS                                             " & vbLf & _
              "           WHERE CLOSEDATE = :CLOSEDATE                                       " & vbLf & _
              "             AND BILLSEQ   = :BILLSEQ                                         " & vbLf & _
              "             AND BRANCHNO  = :BRANCHNO                                        " & vbLf & _
              "           GROUP BY CLOSEDATE, BILLSEQ, BRANCHNO                              " & vbLf & _
              "        ) TOTALBASE_ITEMS                                                     " & vbLf & _
              "  WHERE BILL.CLOSEDATE        = :CLOSEDATE                                    " & vbLf & _
              "    AND BILL.BILLSEQ          = :BILLSEQ                                      " & vbLf & _
              "    AND BILL.BRANCHNO         = :BRANCHNO                                     " & vbLf & _
              "    AND BILL.CLOSEDATE        = TOTALBASE.CLOSEDATE(+)                        " & vbLf & _
              "    AND BILL.BILLSEQ          = TOTALBASE.BILLSEQ(+)                          " & vbLf & _
              "    AND BILL.BRANCHNO         = TOTALBASE.BRANCHNO(+)                         " & vbLf & _
              "    AND BILL.CLOSEDATE        = PAYMENTBASE.CLOSEDATE(+)                      " & vbLf & _
              "    AND BILL.BILLSEQ          = PAYMENTBASE.BILLSEQ(+)                        " & vbLf & _
              "    AND BILL.BRANCHNO         = PAYMENTBASE.BRANCHNO(+)                       " & vbLf & _
              "    AND BILL.CLOSEDATE        = TOTALBASE_ITEMS.CLOSEDATE(+)                  " & vbLf & _
              "    AND BILL.BILLSEQ          = TOTALBASE_ITEMS.BILLSEQ(+)                    " & vbLf & _
              "    AND BILL.BRANCHNO         = TOTALBASE_ITEMS.BRANCHNO(+)                   "
'## 2004.06.11 ADD END

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objNotPayment = objFields("NOTPAYMENT")
        Set objDelFlg = objFields("DELFLG")
    
        '入金額のチェック
        '返金額の場合もある
        If lngBranchNo <> 0 And CLng(objDelFlg.Value) = 1 Then      '取消伝票の返金用伝票
            If CLng(vntPaymentPrice) < CLng(objNotPayment.Value) Or _
               CLng(vntPaymentPrice) >= 0 Then
                CheckValuePaymentPrice = "入金額は未収金額以上0円未満を入力してください"
            End If
        ElseIf CLng(objDelFlg.Value) <> 1 Then                      '通常伝票
            If CLng(vntPaymentPrice) > CLng(objNotPayment.Value) Or _
               CLng(vntPaymentPrice) <= 0 Then
                CheckValuePaymentPrice = "入金額は0円超で未収金額以下を入力してください"
            End If
        End If
        vntPaymentPrice = CLng(vntPaymentPrice)
    Else
        CheckValuePaymentPrice = "請求書情報が見つかりません。"
    End If
    
    Set objOraDyna = Nothing
    
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.CheckValuePaymentPrice"
    
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

'## 2004.01.17 聖路加版
' 機能　　 : 発送日設定情報の妥当性チェックを行う
'
' 引数　　 : (In)   lngSendYear     発送日(年)
' 　　　　 : (In)   lngSendMonth    発送日(月)
' 　　　　 : (In)   lngSendDay      発送日(日)
' 　　　　 : (Out)  vntSendDate     発送日
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
Public Function CheckValueSendCheckDay(ByVal lngSendYear As Long, _
                                        ByVal lngSendMonth As Long, _
                                        ByVal lngSendDay As Long, _
                                        ByRef vntSendDate As Variant) As Variant


    Dim objCommon           As Common           '共通クラス
    Dim vntArrMessage       As Variant          'エラーメッセージの集合
    
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    CheckValueSendCheckDay = Empty
    vntArrMessage = Empty
    
    
    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    
    Do
        '各値チェック処理
        With objCommon
    
            '発送日チェック
            .AppendArray vntArrMessage, .CheckDate("発送日", lngSendYear, lngSendMonth, lngSendDay, vntSendDate, CHECK_NECESSARY)

        End With
        
        Exit Do
    Loop

    If IsArray(vntArrMessage) Then
        CheckValueSendCheckDay = vntArrMessage
    End If
    Set objCommon = Nothing

End Function

'
' 機能　　 : 発送情報を削除する
'
' 引数　　 : (In)   strCloseDate    締め日
'          : (In)   lngBillSeq      請求書Seq
'          : (In)   lngBranchNo     請求書枝番
' 　　　　 : (In)   lngSeq          発送SEQ
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
Public Function DeleteDispatch(ByVal dtmCloseDate As Date, _
                               ByVal lngBillSeq As Long, _
                               ByVal lngBranchNo As Long, _
                               ByVal lngSeq As Long) As Boolean
                                                

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    DeleteDispatch = False
    
    '検索条件が設定されていない場合はエラー
    If dtmCloseDate = 0 Or lngBillSeq = 0 Or lngSeq = 0 Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CLOSEDATE", dtmCloseDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SEQ", lngSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '該当キーの発送情報を削除
    strStmt = "DELETE                        " & vbLf & _
              "  FROM DISPATCH               " & vbLf & _
              " WHERE CLOSEDATE = :CLOSEDATE " & vbLf & _
              "   AND BILLSEQ   = :BILLSEQ   " & vbLf & _
              "   AND BRANCHNO  = :BRANCHNO  " & vbLf & _
              "   AND SEQ       = :SEQ     "
    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing
    
    '戻り値の設定
    DeleteDispatch = True
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.DeleteDispatch"
    
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



'## 2004.01.17 聖路加版
'
' 機能　　 : 入金情報を挿入する
'
' 引数　　 : (In)   strCloseDate     締め日
' 　　　　 : (In)   lngBillSeq       請求書SEQ
' 　　　　 : (In)   lngBranchNo      請求書枝番
' 　　　　 : (In)   dtmPaymentDate   入金日
' 　　　　 : (In)   lngPaymentPrice  入金額
' 　　　　 : (In)   lngPaymentDiv    入金種別
' 　　　　 : (In)   strUpdUser       更新者
' 　　　　 : (In)   strPayNote       コメント
'          : (In)   strCardKind      カード種別
'          : (In)   strCreditslipno  伝票No.
'          : (In)   strBankCode      金融機関
'### 2004.02.18 Added by H.Ishihara@FSIT いろいろ追加
'          : (In)   strRegisterNo    レジ番号
'          : (In)   strCash          現金
'### 2004.02.18 Added End
'
' 戻り値　 : 1   正常終了
' 　　　　 : 0   同一キーのレコード存在
' 　　　　 : -1  異常終了
'
' 備考　　 :
'
Public Function InsertPayment(ByVal dtmCloseDate As Date, _
                              ByVal lngBillSeq As Long, _
                              ByVal lngBranchNo As Long, _
                              ByVal dtmPaymentDate As Date, _
                              ByVal vntPaymentPrice As Variant, _
                              ByVal vntPaymentDiv As Variant, _
                              ByVal strUpdUser As String, _
                              ByVal strPayNote As String, _
                              ByVal strCardKind As String, _
                              ByVal strCreditslipno As String, _
                              ByVal strBankCode As String, _
                              ByVal strRegisterNo As String, _
                              ByVal strCash As String _
                             ) As Long
'Public Function InsertPayment(ByVal lngBillNo As Long, _
'                              ByVal dtmPaymentDate As Date, _
'                              ByVal lngPaymentPrice As Long, _
'                              ByVal lngPaymentDiv As Long, _
'                              ByVal strUpdUser As String _
'                             ) As Long
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '検索条件が設定されていない場合はエラー
    If dtmCloseDate = 0 Or lngBillSeq = 0 Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CLOSEDATE", dtmCloseDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "PAYMENTDATE", dtmPaymentDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "PAYMENTPRICE", CLng(vntPaymentPrice), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "PAYMENTDIV", CLng(vntPaymentDiv), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "PAYNOTE", strPayNote, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CARDKIND", strCardKind, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CREDITSLIPNO", strCreditslipno, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BANKCODE", strBankCode, ORAPARM_INPUT, ORATYPE_VARCHAR2
'### 2004.02.18 Added by H.Ishihara@FSIT いろいろ追加
    objOraParam.Add "REGISTERNO", strRegisterNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CASH", strCash, ORAPARM_INPUT, ORATYPE_VARCHAR2
'### 2004.02.18 Added End
    
    '該当キーの入金情報を挿入
'### 2004.02.18 Added by H.Ishihara@FSIT いろいろ追加
'    strStmt = "INSERT INTO PAYMENT (" & vbLf & _
'              "       CLOSEDATE,    " & vbLf & _
'              "       BILLSEQ,      " & vbLf & _
'              "       BRANCHNO,     " & vbLf & _
'              "       SEQ,          " & vbLf & _
'              "       PAYMENTDATE,  " & vbLf & _
'              "       PAYMENTPRICE, " & vbLf & _
'              "       PAYMENTDIV,   " & vbLf & _
'              "       UPDUSER,      " & vbLf & _
'              "       PAYNOTE,      " & vbLf & _
'              "       CARDKIND,     " & vbLf & _
'              "       CREDITSLIPNO, " & vbLf & _
'              "       BANKCODE      "
'
'    strStmt = strStmt & vbLf & _
'              "       ) VALUES (    " & vbLf & _
'              "       :CLOSEDATE,   " & vbLf & _
'              "       :BILLSEQ,     " & vbLf & _
'              "       :BRANCHNO,    " & vbLf & _
'              "       1,            " & vbLf & _
'              "       :PAYMENTDATE, " & vbLf & _
'              "       :PAYMENTPRICE," & vbLf & _
'              "       :PAYMENTDIV,  " & vbLf & _
'              "       :UPDUSER,     " & vbLf & _
'              "       :PAYNOTE,     " & vbLf & _
'              "       :CARDKIND,    " & vbLf & _
'              "       :CREDITSLIPNO," & vbLf & _
'              "       :BANKCODE     " & vbLf & _
'              "       )"
    strStmt = "INSERT INTO PAYMENT (" & vbLf & _
              "       CLOSEDATE,    " & vbLf & _
              "       BILLSEQ,      " & vbLf & _
              "       BRANCHNO,     " & vbLf & _
              "       SEQ,          " & vbLf & _
              "       PAYMENTDATE,  " & vbLf & _
              "       PAYMENTPRICE, " & vbLf & _
              "       PAYMENTDIV,   " & vbLf & _
              "       UPDUSER,      " & vbLf & _
              "       PAYNOTE,      " & vbLf & _
              "       CARDKIND,     " & vbLf & _
              "       CREDITSLIPNO, " & vbLf & _
              "       BANKCODE,     " & vbLf & _
              "       REGISTERNO,   " & vbLf & _
              "       CASH          "

    strStmt = strStmt & vbLf & _
              "       ) VALUES (    " & vbLf & _
              "       :CLOSEDATE,   " & vbLf & _
              "       :BILLSEQ,     " & vbLf & _
              "       :BRANCHNO,    " & vbLf & _
              "       1,            " & vbLf & _
              "       :PAYMENTDATE, " & vbLf & _
              "       :PAYMENTPRICE," & vbLf & _
              "       :PAYMENTDIV,  " & vbLf & _
              "       :UPDUSER,     " & vbLf & _
              "       :PAYNOTE,     " & vbLf & _
              "       :CARDKIND,    " & vbLf & _
              "       :CREDITSLIPNO," & vbLf & _
              "       :BANKCODE,    " & vbLf & _
              "       :REGISTERNO,  " & vbLf & _
              "       :CASH         " & vbLf & _
              "       )"
'### 2004.02.18 Added End
'              "       (SELECT NVL(MAX(SEQ),0)+1 FROM PAYMENT " & vbLf & _
'              "         WHERE CLOSEDATE = :CLOSEDATE         " & vbLf & _
'              "           AND BILLSEQ   = :BILLSEQ           " & vbLf & _
'              "           AND BRANCHNO  = :BRANCHNO ),       " & vbLf & _

    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing
    
    '戻り値の設定
    InsertPayment = 1
    
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
    
    'キー重複時はRaise文を使用せず、戻り値を設定して正常終了させる
    If mobjOraDb.LastServerErr = 1 Then
        InsertPayment = INSERT_DUPLICATE
        Exit Function
    End If
        
    'イベントログ書き込み
    WriteErrorLog "Demand.InsertPayment"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

    InsertPayment = INSERT_ERROR

End Function

'
' 機能　　 : 検索条件を満たす発送情報を取得する
'
' 引数　　 : (In)   strCloseDate    締め日
' 　　　　 : (In)   lngBillSeq      請求書SEQ
' 　　　　 : (In)   lngBranchNo     請求書枝番
' 　　　　 : (In)   lngSeq          SEQ
' 　　　　 : (Out)  vntPaymentDate  入金日

'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
Public Function SelectDispatch(ByVal dtmCloseDate As Date, _
                              ByVal lngBillSeq As Long, _
                              ByVal lngBranchNo As Long, _
                              ByVal lngSeq As Long, _
                              ByRef vntDispatchDate As Variant) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objDispatchDate         As OraField         '発送日
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    SelectDispatch = False
    
    '検索条件が設定されていない場合はエラー
    If dtmCloseDate = 0 Or lngBillSeq = 0 Or lngSeq = 0 Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CLOSEDATE", dtmCloseDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SEQ", lngSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '検索条件を満たす入金情報のレコードを取得
    strStmt = "SELECT DISPATCHDATE                                      " & vbLf & _
              "  FROM DISPATCH                                          " & vbLf & _
              " WHERE CLOSEDATE  = :CLOSEDATE                        " & vbLf & _
              "   AND BILLSEQ    = :BILLSEQ                          " & vbLf & _
              "   AND BRANCHNO   = :BRANCHNO                         " & vbLf & _
              "   AND SEQ        = :SEQ                              "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objDispatchDate = objFields("DISPATCHDATE")
    
        '戻り値の設定
        vntDispatchDate = CDate(objDispatchDate.Value)
        
    End If
    
    Set objOraDyna = Nothing
    
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing
    
    SelectDispatch = True
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.SelectDispatch"
    
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


'## 2004.01.17 聖路加版
' 機能　　 : 入金情報を挿入する
'
' 引数　　 : (In)   strCloseDate     締め日
' 　　　　 : (In)   lngBillSeq       請求書SEQ
' 　　　　 : (In)   lngBranchNo      請求書枝番
' 　　　　 : (In)   lngSeq           SEQ
' 　　　　 : (In)   dtmPaymentDate   入金日
' 　　　　 : (In)   lngPaymentPrice  入金額
' 　　　　 : (In)   lngPaymentDiv    入金種別
' 　　　　 : (In)   strUpdUser       更新者
'          : (In)   strPayNote       入金コメント
'          : (In)   strCardKind      カード種別
'          : (In)   strCreditslipno  伝票No.
'          : (In)   strBankCode      金融機関
'### 2004.02.18 Added by H.Ishihara@FSIT いろいろ追加
'          : (In)   strRegisterNo   レジ番号
'          : (In)   strCash         現金
'### 2004.02.18 Added End
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function UpdatePayment(ByVal dtmCloseDate As Date, _
                              ByVal lngBillSeq As Long, _
                              ByVal lngBranchNo As Long, _
                              ByVal lngSeq As Long, _
                              ByVal dtmPaymentDate As Date, _
                              ByVal vntPaymentPrice As Variant, _
                              ByVal vntPaymentDiv As Variant, _
                              ByVal strUpdUser As String, _
                              ByVal strPayNote As String, _
                              ByVal strCardKind As String, _
                              ByVal strCreditslipno As String, _
                              ByVal strBankCode As String, _
                              ByVal strRegisterNo As String, _
                              ByVal strCash As String _
                             ) As Boolean
'Public Function UpdatePayment(ByVal lngBillNo As Long, _
'                              ByVal lngSeq As Long, _
'                              ByVal dtmPaymentDate As Date, _
'                              ByVal lngPaymentPrice As Long, _
'                              ByVal lngPaymentDiv As Long, _
'                              ByVal strUpdUser As String _
'                             ) As Boolean
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    UpdatePayment = False
    
    '検索条件が設定されていない場合はエラー
    If dtmCloseDate = 0 Or lngBillSeq = 0 Or lngSeq = 0 Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CLOSEDATE", dtmCloseDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SEQ", lngSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "PAYMENTDATE", dtmPaymentDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "PAYMENTPRICE", CLng(vntPaymentPrice), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "PAYMENTDIV", CLng(vntPaymentDiv), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "PAYNOTE", strPayNote, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CARDKIND", strCardKind, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CREDITSLIPNO", strCreditslipno, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BANKCODE", strBankCode, ORAPARM_INPUT, ORATYPE_VARCHAR2
'### 2004.02.18 Added by H.Ishihara@FSIT いろいろ追加
    objOraParam.Add "REGISTERNO", strRegisterNo, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CASH", strCash, ORAPARM_INPUT, ORATYPE_VARCHAR2
'### 2004.02.18 Added End
    
    
    '該当キーの入金情報を更新
'### 2004.02.18 Added by H.Ishihara@FSIT いろいろ追加
'    strStmt = "UPDATE PAYMENT                       " & vbLf & _
              "   SET PAYMENTDATE  = :PAYMENTDATE,  " & vbLf & _
              "       PAYMENTPRICE = :PAYMENTPRICE, " & vbLf & _
              "       PAYMENTDIV   = :PAYMENTDIV,   " & vbLf & _
              "       UPDUSER      = :UPDUSER,      " & vbLf & _
              "       PAYNOTE      = :PAYNOTE,      " & vbLf & _
              "       CARDKIND     = :CARDKIND,     " & vbLf & _
              "       CREDITSLIPNO = :CREDITSLIPNO, " & vbLf & _
              "       BANKCODE     = :BANKCODE      " & vbLf & _
              " WHERE CLOSEDATE    = :CLOSEDATE     " & vbLf & _
              "   AND BILLSEQ      = :BILLSEQ       " & vbLf & _
              "   AND BRANCHNO     = :BRANCHNO      " & vbLf & _
              "   AND SEQ          = :SEQ           "
    strStmt = "UPDATE PAYMENT                       " & vbLf & _
              "   SET PAYMENTDATE  = :PAYMENTDATE,  " & vbLf & _
              "       PAYMENTPRICE = :PAYMENTPRICE, " & vbLf & _
              "       PAYMENTDIV   = :PAYMENTDIV,   " & vbLf & _
              "       UPDUSER      = :UPDUSER,      " & vbLf & _
              "       PAYNOTE      = :PAYNOTE,      " & vbLf & _
              "       CARDKIND     = :CARDKIND,     " & vbLf & _
              "       CREDITSLIPNO = :CREDITSLIPNO, " & vbLf & _
              "       BANKCODE     = :BANKCODE,     " & vbLf & _
              "       REGISTERNO   = :REGISTERNO,   " & vbLf & _
              "       CASH         = :CASH          " & vbLf & _
              " WHERE CLOSEDATE    = :CLOSEDATE     " & vbLf & _
              "   AND BILLSEQ      = :BILLSEQ       " & vbLf & _
              "   AND BRANCHNO     = :BRANCHNO      " & vbLf & _
              "   AND SEQ          = :SEQ           "
'### 2004.02.18 Added End

    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing
    
    '戻り値の設定
    UpdatePayment = True
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.UpdatePayment"
    
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





'## 2004.01.19 聖路加版
' 機能　　 : 入金情報を削除する
'
' 引数　　 : (In)   strCloseDate     締め日
' 　　　　 : (In)   lngBillSeq       請求書SEQ
' 　　　　 : (In)   lngBranchNo      請求書枝番
' 　　　　 : (In)   lngSeq           SEQ
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function DeletePayment(ByVal dtmCloseDate As Date, _
                              ByVal lngBillSeq As Long, _
                              ByVal lngBranchNo As Long, _
                              ByVal lngSeq As Long _
                             ) As Boolean
'Public Function DeletePayment(ByVal lngBillNo As Long, _
'                              ByVal lngSeq As Long _
'                             ) As Boolean
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    DeletePayment = False
    
    '検索条件が設定されていない場合はエラー
    If dtmCloseDate = 0 Or lngBillSeq = 0 Or lngSeq = 0 Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CLOSEDATE", dtmCloseDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SEQ", lngSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '該当キーの入金情報を削除
    strStmt = "DELETE                   " & vbLf & _
              "  FROM PAYMENT           " & vbLf & _
              " WHERE CLOSEDATE = :CLOSEDATE " & vbLf & _
              "   AND BILLSEQ   = :BILLSEQ   " & vbLf & _
              "   AND BRANCHNO  = :BRANCHNO  " & vbLf & _
              "   AND SEQ       = :SEQ       "
    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing
    
    '戻り値の設定
    DeletePayment = True
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.DeletePayment"
    
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
' 機能　　 : 発送Seqの最大値を取得する
'
' 引数　　 : (In)   dtmCloseDate    締め日
'          : (In)   lngBillSeq      請求書Seq
'          : (In)   lngBranchNo     請求書枝番
'          : (Out)  vntSeqMax       Max(発送Seq)
' 　　　　 : (Out)  vntDelFlg       削除フラグ
'
' 戻り値　 : True / False
'
' 備考　　 :
'
Public Function GetDispatchSeqMax(ByVal dtmCloseDate As Date, _
                                  ByVal lngBillSeq As Long, _
                                  ByVal lngBranchNo As Long, _
                                  ByRef vntSeqMax As Variant, _
                                  ByRef vntDelFlg As Variant) As Boolean
                                  
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objMaxSeq               As OraField         'Max(発送Seq)
    Dim objDelFlg               As OraField         '削除フラグ
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    GetDispatchSeqMax = False
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CLOSEDATE", dtmCloseDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    strStmt = "SELECT NVL(MAX(DISPATCH.SEQ), 0) MAXSEQ,      " & vbLf & _
              "       BILL.DELFLG                            " & vbLf & _
              "  FROM BILL, DISPATCH                         " & vbLf & _
              " WHERE BILL.CLOSEDATE = :CLOSEDATE            " & vbLf & _
              "   AND BILL.BILLSEQ   = :BILLSEQ              " & vbLf & _
              "   AND BILL.BRANCHNO  = :BRANCHNO             " & vbLf & _
              "   AND BILL.CLOSEDATE = DISPATCH.CLOSEDATE(+) " & vbLf & _
              "   AND BILL.BILLSEQ   = DISPATCH.BILLSEQ(+)   " & vbLf & _
              "   AND BILL.BRANCHNO  = DISPATCH.BRANCHNO(+)  " & vbLf & _
              " GROUP BY                                     " & vbLf & _
              "       BILL.CLOSEDATE,                        " & vbLf & _
              "       BILL.BILLSEQ,                          " & vbLf & _
              "       BILL.BRANCHNO,                         " & vbLf & _
              "       BILL.DELFLG                            "

              
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        
        Set objFields = objOraDyna.Fields
        Set objMaxSeq = objFields("MAXSEQ")
        Set objDelFlg = objFields("DELFLG")
    
        vntSeqMax = CLng(objMaxSeq.Value)
        vntDelFlg = CLng(objDelFlg.Value)
        
        'レコードが存在しなければエラーを返す
        GetDispatchSeqMax = True
        
    End If
    
    Set objOraDyna = Nothing
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.GetDispatchSeqMax"
    
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

' 機能　　 : 発送情報を挿入する
'
' 引数　　 : (In)   strCloseDate     締め日
' 　　　　 : (In)   lngBillSeq       請求書SEQ
' 　　　　 : (In)   lngBranchNo      請求書枝番
' 　　　　 : (In)   lngSeq           SEQ
' 　　　　 : (In)   dtmPaymentDate   発送日
'          : (In)   lngMaxSeq        1:MAX(SEQ)のレコードを更新する
'
' 戻り値　 : 1   正常終了
' 　　　　 : 0   同一キーのレコード存在
' 　　　　 : -1  異常終了
'
' 備考　　 :
'
Public Function InsertDispatch(ByVal dtmCloseDate As Date, _
                              ByVal lngBillSeq As Long, _
                              ByVal lngBranchNo As Long, _
                              ByVal dtmDispatchDate As Date, _
                              ByVal strUpdUser As String) As Long

    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '検索条件が設定されていない場合はエラー
    If dtmCloseDate = 0 Or lngBillSeq = 0 Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CLOSEDATE", dtmCloseDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DISPATCHDATE", dtmDispatchDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "UPDUSER", strUpdUser, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '該当キーの入金情報を挿入
    strStmt = "INSERT INTO DISPATCH  (" & vbLf & _
              "       CLOSEDATE,      " & vbLf & _
              "       BILLSEQ,        " & vbLf & _
              "       BRANCHNO,       " & vbLf & _
              "       SEQ,            " & vbLf & _
              "       DISPATCHDATE,   " & vbLf & _
              "       UPDDATE,        " & vbLf & _
              "       UPDUSER         "
    
    strStmt = strStmt & vbLf & _
              "       ) VALUES (     " & vbLf & _
              "       :CLOSEDATE,    " & vbLf & _
              "       :BILLSEQ,      " & vbLf & _
              "       :BRANCHNO,     " & vbLf & _
              "       (SELECT NVL(MAX(SEQ),0)+1 FROM DISPATCH " & vbLf & _
              "         WHERE CLOSEDATE = :CLOSEDATE          " & vbLf & _
              "           AND BILLSEQ   = :BILLSEQ            " & vbLf & _
              "           AND BRANCHNO  = :BRANCHNO ),        " & vbLf & _
              "       :DISPATCHDATE, " & vbLf & _
              "       SYSDATE,       " & vbLf & _
              "       :UPDUSER       " & vbLf & _
              "       )"
    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing
    
    '戻り値の設定
    InsertDispatch = INSERT_NORMAL
    
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
    
    'キー重複時はRaise文を使用せず、戻り値を設定して正常終了させる
    If mobjOraDb.LastServerErr = 1 Then
        InsertDispatch = INSERT_DUPLICATE
        Exit Function
    End If
        
    'イベントログ書き込み
    WriteErrorLog "Demand.InsertDispatch"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description
    
    InsertDispatch = INSERT_ERROR

End Function


'## 2002.12.30 Modified Function by ishihara@FSIT 東急殿向け締め処理に合致するよう、メソッドそのものを完全再作成
'
' 機能　　 : 検索条件を満たす請求書情報を取得する
'
' 引数　　 : (In)   vntBillNo           請求書番号
' 　　　　 : (Out)  vntCloseDate        締め日
' 　　　　 : (Out)  vntOrgCd1           団体コード１
' 　　　　 : (Out)  vntOrgCd2           団体コード２
' 　　　　 : (Out)  vntOrgName          団体名
' 　　　　 : (Out)  vntBillClassCd      請求書分類コード
' 　　　　 : (Out)  vntBillClassName    請求書分類名
' 　　　　 : (Out)  vntMethod           作成方法
' 　　　　 : (Out)  vntTaxRates         適用税率
' 　　　　 : (Out)  vntPrtDate          請求書出力日
' 　　　　 : (Out)  vntPaymentFlg       入金データ存在フラグ(True:あり、False:なし)
' 　　　　 : (Out)  vntOrgDiv           団体種別
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function SelectDmdOrgMasterBurden(ByVal vntBillNo As Variant, _
                                         Optional ByRef vntCloseDate As Variant, _
                                         Optional ByRef vntOrgCd1 As Variant, _
                                         Optional ByRef vntOrgCd2 As Variant, _
                                         Optional ByRef vntOrgName As Variant, _
                                         Optional ByRef vntBillClassCd As Variant, _
                                         Optional ByRef vntBillClassName As Variant, _
                                         Optional ByRef vntMethod As Variant, _
                                         Optional ByRef vntTaxRates As Variant, _
                                         Optional ByRef vntPrtDate As Variant, _
                                         Optional ByRef vntPaymentFlg As Variant, _
                                         Optional ByRef vntOrgDiv As Variant _
                                        ) As Boolean
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objCloseDate            As OraField         '締め日
    Dim objOrgCd1               As OraField         '団体コード１
    Dim objOrgCd2               As OraField         '団体コード２
    Dim objOrgName              As OraField         '団体名
    Dim objBillClassCd          As OraField         '請求書分類コード
    Dim objBillClassName        As OraField         '請求書分類名
    Dim objMethod               As OraField         '作成方法
    Dim objTaxRates             As OraField         '適用税率
    Dim objPrtDate              As OraField         '請求書出力日
    Dim objSeqCount             As OraField         '入金レコード件数
    Dim objOrgDiv               As OraField         '団体種別

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    SelectDmdOrgMasterBurden = False
    
    '検索条件が設定されていない場合はエラー
    If Not IsNumeric(vntBillNo) Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "BILLNO", CStr(vntBillNo), ORAPARM_INPUT, ORATYPE_NUMBER
    
    '検索条件を満たす請求情報のレコードを取得
    strStmt = "SELECT BILL.CLOSEDATE,   BILL.ORGCD1,   BILL.ORGCD2,  ORG.ORGNAME, " & vbLf & _
              "       BILL.BILLCLASSCD, BILLCLASS.BILLCLASSNAME,     BILL.METHOD, " & vbLf & _
              "       BILL.TAXRATES, BILL.PRTDATE, PAYMENTINFO.SEQCOUNT,          " & vbLf & _
              "       ORG.ORGDIV                                                  " & vbLf & _
              "  FROM ( SELECT BILLNO, COUNT(SEQ) SEQCOUNT                        " & vbLf & _
              "           FROM PAYMENT                                            " & vbLf & _
              "          WHERE BILLNO = :BILLNO                                   " & vbLf & _
              "          GROUP BY BILLNO) PAYMENTINFO, BILLCLASS, ORG , BILL      " & vbLf & _
              " WHERE BILL.BILLNO = :BILLNO                                       " & vbLf & _
              "   AND BILL.ORGCD1 = ORG.ORGCD1                                    " & vbLf & _
              "   AND BILL.ORGCD2 = ORG.ORGCD2                                    " & vbLf & _
              "   AND BILLCLASS.BILLCLASSCD = BILL.BILLCLASSCD                    " & vbLf & _
              "   AND BILL.BILLNO = PAYMENTINFO.BILLNO(+)                         "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCloseDate = objFields("CLOSEDATE")
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objOrgName = objFields("ORGNAME")
        Set objBillClassCd = objFields("BILLCLASSCD")
        Set objBillClassName = objFields("BILLCLASSNAME")
        Set objMethod = objFields("METHOD")
        Set objTaxRates = objFields("TAXRATES")
        Set objPrtDate = objFields("PRTDATE")
        Set objSeqCount = objFields("SEQCOUNT")
        Set objOrgDiv = objFields("ORGDIV")
    
        '戻り値の設定
        If IsMissing(vntCloseDate) = False Then vntCloseDate = CDate(objCloseDate.Value)
        If IsMissing(vntOrgCd1) = False Then vntOrgCd1 = objOrgCd1.Value
        If IsMissing(vntOrgCd2) = False Then vntOrgCd2 = objOrgCd2.Value
        If IsMissing(vntOrgName) = False Then vntOrgName = objOrgName.Value
        If IsMissing(vntBillClassCd) = False Then vntBillClassCd = objBillClassCd.Value
        If IsMissing(vntBillClassName) = False Then vntBillClassName = objBillClassName.Value
        If IsMissing(vntMethod) = False Then vntMethod = CLng("0" & objMethod.Value)
        If IsMissing(vntTaxRates) = False Then vntTaxRates = IIf(IsNumeric(objTaxRates.Value & ""), Format("0" & objTaxRates.Value, "0.00"), "")
        If IsMissing(vntPaymentFlg) = False Then vntPaymentFlg = (CLng("0" & objSeqCount.Value) > 0)
        If IsMissing(vntOrgDiv) = False Then vntOrgDiv = objOrgDiv.Value & ""
        
        If IsMissing(vntPrtDate) = False Then
            If IsDate(objPrtDate.Value & "") Then
                vntPrtDate = CDate(objPrtDate.Value & "")
            Else
                vntPrtDate = ""
            End If
        End If
                    
        SelectDmdOrgMasterBurden = True
    End If
    
    Set objOraDyna = Nothing
    
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.SelectDmdOrgMasterBurden"
    
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
' 機能　　 : 適用税率を取得する
'
' 引数　　 : (In)   strCslDate      受診日
' 　　　　 : (Out)  dblNowTax       適用税率
' 　　　　 : (In)   lngErrFlg       エラー時の扱い（0:エラーをもう一回引き起こす, 1:エラーメッセージを返す）
'
' 戻り値　 : エラー時の扱い＝１の時、エラーメッセージを返す
'
' 備考　　 :
'
Public Function GetNowTax(ByVal strCslDate As String, _
                          ByRef vntNowTax As Variant, _
                          Optional ByVal lngErrFlg As Long = 0 _
                         ) As String
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objNowTax               As OraField         '適用税率
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntNowTax = 0
    GetNowTax = ""
    
    '検索条件が設定されていない場合はエラー
    If Not IsDate(Trim(strCslDate)) Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        GoTo ErrorHandle
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CSLDATE", Trim(strCslDate), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '適用税率を取得
    strStmt = "SELECT (CASE WHEN :CSLDATE < FREE.FREEDATE THEN FREE.FREEFIELD1 ELSE FREE.FREEFIELD2 END) NOWTAX " & vbLf & _
              "  FROM FREE                " & vbLf & _
              " WHERE FREE.FREECD = 'TAX' " & vbLf & _
              "   AND ROWNUM      = 1     "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objNowTax = objFields("NOWTAX")
    
        '戻り値の設定
        vntNowTax = CDbl("0" & objNowTax.Value)
    
    End If
    
    Set objOraDyna = Nothing
    objOraParam.Remove "CSLDATE"
    Set objOraParam = Nothing
    
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

    If lngErrFlg = 1 Then
    
        'エラーメッセージを返す
        GetNowTax = "Demand.GetNowTaxにてエラー発生　(" & mobjOraDb.LastServerErr & ")　" & Err.Description
    
'        'エラー発生時はトランザクションをアボートに設定
'        mobjContext.SetAbort
    
    Else
    
        'イベントログ書き込み
        WriteErrorLog "Demand.GetNowTax"
    
        'エラー発生時はトランザクションをアボートに設定
        mobjContext.SetAbort
    
        'エラーをもう一回引き起こす
        Err.Raise Err.Number, Err.Source, Err.Description
    
    End If
    
End Function

'
' 機能　　 : 請求書Ｎｏを発番する
'
' 引数　　 : (Out)  lngBillNo       請求書Ｎｏ
' 　　　　 : (In)   lngErrFlg       エラー時の扱い（0:エラーをもう一回引き起こす, 1:エラーメッセージを返す）
'
' 戻り値　 : エラー時の扱い＝１の時、エラーメッセージを返す
'
' 備考　　 :
'
Public Function GetBillNo(ByRef lngBillNo As Long, _
                          Optional ByVal lngErrFlg As Long = 0 _
                         ) As String
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objPrefix               As OraField         'プレフィックス
    Dim objBillNo               As OraField         '請求書Ｎｏ
    
    Dim strPrefix               As String           'プレフィックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    lngBillNo = 0
    GetBillNo = ""
    
'## 2002.12.30 Modified 32Lines by ishihara@FSIT 現在番号の最大値を取得する（プレフィックスって何？（笑））
'    'プレフィックスを取得
'    strStmt = "SELECT FREEFIELD1 BILLNOPREFIX " & vbLf & _
'              "  FROM FREE                    " & vbLf & _
'              " WHERE FREECD = 'BILLNO'       " & vbLf & _
'              "   AND ROWNUM = 1              "
'
'    '検索レコードが存在する場合
'    If Not objOraDyna.EOF Then
'
'        'オブジェクトの参照設定
'        Set objFields = objOraDyna.Fields
'        Set objPrefix = objFields("BILLNOPREFIX")
'
'        'プレフィックスの設定
'        strPrefix = objPrefix.Value & ""
'
'    '検索レコードが存在しない場合
'    Else
'
'        'プレフィックスは無し
'        strPrefix = ""
'
'    End If
'
    strStmt = "SELECT ( NVL(MAX(BILLNO),0) + 1 ) MAXBILLNO" & vbLf & _
              "  FROM BILL                                "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'オブジェクトの参照設定
    Set objFields = objOraDyna.Fields
    lngBillNo = CLng(objFields("MAXBILLNO").Value & "")
    
    Set objOraDyna = Nothing
    
'## 2002.12.30 Modified 32Lines by ishihara@FSIT 請求書番号はただのSEQです
'    'キー値の設定
'    Set objOraParam = mobjOraDb.Parameters
'    If Trim(strPrefix) <> "" Then
'        objOraParam.Add "BILLNOMIN", CLng(Trim(strPrefix) & String((LENGTH_BILLNO - Len(Trim(strPrefix)) - 1), "0") & "1"), ORAPARM_INPUT, ORATYPE_NUMBER
'        objOraParam.Add "BILLNOMAX", CLng(Trim(strPrefix) & String((LENGTH_BILLNO - Len(Trim(strPrefix))), "9")), ORAPARM_INPUT, ORATYPE_NUMBER
'    End If
'
'    '最大発番値を取得
'    strStmt = "SELECT NVL(MAX(BILLNO), 0) BILLNO " & vbLf & _
'              "  FROM BILL                       "
'    If Trim(strPrefix) <> "" Then
'        strStmt = strStmt & vbLf & _
'              " WHERE BILLNO BETWEEN :BILLNOMIN AND :BILLNOMAX "
'    End If
'
'    Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
'
'    '検索レコードが存在する場合
'    '(MAX関数を発行しているので必ず1レコード返ってくる)
'    If Not objOraDyna.EOF Then
'
'        'オブジェクトの参照設定
'        Set objFields = objOraDyna.Fields
'        Set objBillNo = objFields("BILLNO")
'
'        '戻り値の設定
'        If Trim(strPrefix) <> "" And CLng(objBillNo.Value & "") = 0 Then
'            lngBillNo = CLng(Trim(strPrefix) & String((LENGTH_BILLNO - Len(Trim(strPrefix)) - 1), "0") & "1")
'        Else
'            lngBillNo = CLng(objBillNo.Value & "") + 1
'        End If
'
'    End If
'## 2002.12.30 Modified End
    
'## 2002.12.30 Deleted 3Lines by ishihara@FSIT パラメタは１個も使いません
'    Do Until objOraParam.Count <= 0
'        objOraParam.Remove (objOraParam.Count - 1)
'    Loop
'    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    If lngErrFlg = 1 Then
    
        'エラーメッセージを返す
        GetBillNo = "Demand.GetBillNoにてエラー発生　(" & mobjOraDb.LastServerErr & ")　" & Err.Description
    
'        'エラー発生時はトランザクションをアボートに設定
'        mobjContext.SetAbort
    
    Else
    
        'イベントログ書き込み
        WriteErrorLog "Demand.GetBillNo"
    
        'エラー発生時はトランザクションをアボートに設定
        mobjContext.SetAbort
    
        'エラーをもう一回引き起こす
        Err.Raise Err.Number, Err.Source, Err.Description
    
    End If
    
End Function

'## 2004.01.17 Added Function by Shiramizu@CS 聖路加病院殿向けに、メソッドを新規作成
'
' 機能　　 : 請求書Seqを発番する
'
' 引数　　 : (Out)  vntBillSeq      請求書Seq
' 　　　　 : (In)   vntCloseDate    締め日
'
' 戻り値　 : なし
'
' 備考　　 :
'
Private Function GetBillSeq(ByRef vntBillSeq As Variant, _
                          ByVal vntCloseDate As Variant _
                         ) As String
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objPrefix               As OraField         'プレフィックス
    Dim objBillNo               As OraField         '請求書Ｎｏ
    
    Dim strPrefix               As String           'プレフィックス
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntBillSeq = Null
    GetBillSeq = ""
    
    'パラメータが指定されていない場合はエラー
    If IsNull(vntCloseDate) Or vntCloseDate = "" Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CLOSEDATE", CDate(vntCloseDate), ORAPARM_INPUT, ORATYPE_DATE
    
    strStmt = "SELECT NVL(MAX(BILLSEQ)+1,1) AS MAXBILLSEQ " & vbLf & _
              "FROM BILL " & vbLf & _
              "WHERE CLOSEDATE = :CLOSEDATE " & vbLf
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    'オブジェクトの参照設定
    Set objFields = objOraDyna.Fields
    vntBillSeq = CLng(objFields("MAXBILLSEQ").Value & "")
    
    Set objOraDyna = Nothing

    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.GetBillSeq"

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
' 機能　　 : 検索条件を満たす受診者情報の件数を取得する（請求対象受診者一覧）
'
' 引数　　 : (In)   lngBillNo       請求書Ｎｏ
' 　　　　 : (In)   strCslOrgCd1    受診団体コード1
' 　　　　 : (In)   strCslOrgCd2    受診団体コード2
' 　　　　 : (In)   strCsCd         コースコード
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectDmdOrgListCount(ByVal lngBillNo As String, _
                                      ByVal strCslOrgCd1 As String, _
                                      ByVal strCslOrgCd2 As String, _
                                      ByVal strCsCd As String _
                                     ) As Long
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objCount                As OraField         '検索件数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    SelectDmdOrgListCount = 0
    
    '検索条件が設定されていない場合はエラー
    If lngBillNo = 0 Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "BILLNO", lngBillNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ORGCD1", Trim(strCslOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strCslOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CANCELFLG", CLng(CONSULT_USED), ORAPARM_INPUT, ORATYPE_NUMBER
    
    '検索条件を満たす受診者情報のレコード件数を取得
    strStmt = "SELECT COUNT(*) RECCOUNT                 " & vbLf & _
              "  FROM CONSULT                           " & vbLf & _
              " WHERE RSVNO IN (SELECT DISTINCT RSVNO   " & vbLf & _
              "                   FROM CLOSEMNG         " & vbLf & _
              "                  WHERE BILLNO = :BILLNO " & vbLf & _
              "                )                        " & vbLf & _
              "   AND CANCELFLG = :CANCELFLG            "

    '条件節を追加
    If Trim(strCslOrgCd1) <> "" Or _
       Trim(strCslOrgCd2) <> "" Then            '受診団体指定あり
        strStmt = strStmt & vbLf & _
              "   AND ORGCD1    = :ORGCD1 " & vbLf & _
              "   AND ORGCD2    = :ORGCD2 "
    End If
    If Trim(strCsCd) <> "" Then                 'コースコード指定あり
        strStmt = strStmt & vbLf & _
              "   AND CSCD      = :CSCD   "
    End If
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    '(COUNT関数を発行しているので必ず1レコード返ってくる)
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCount = objFields("RECCOUNT")
    
        '戻り値の設定
        SelectDmdOrgListCount = CLng(objCount.Value & "")
    
    End If
    
    Set objOraDyna = Nothing
    objOraParam.Remove "BILLNO"
    objOraParam.Remove "ORGCD1"
    objOraParam.Remove "ORGCD2"
    objOraParam.Remove "CSCD"
    objOraParam.Remove "CANCELFLG"
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.SelectDmdOrgListCount"
    
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
' 機能　　 : 検索条件を満たす受診者の一覧を取得する（請求対象受診者一覧）
'
' 引数　　 : (In)   lngBillNo       請求書Ｎｏ
' 　　　　 : (In)   strCslOrgCd1    受診団体コード1
' 　　　　 : (In)   strCslOrgCd2    受診団体コード2
' 　　　　 : (In)   strCsCd         コースコード
' 　　　　 : (In)   lngSortKey      ソート順（0:基本表示順（受診日，当日ID，コース，団体（カナ），氏名（カナ）））
' 　　　　 : (In)   lngStartPos     開始位置
' 　　　　 : (In)   strGetCount     取得件数
' 　　　　 : (Out)  vntCslDate      受診日（"yyyy年m月d日"編集）
' 　　　　 : (Out)  vntDayID        当日ID（"0001"編集）
' 　　　　 : (Out)  vntWebColor     コース名表示色
' 　　　　 : (Out)  vntCsName       コース名
' 　　　　 : (Out)  vntLastName     姓
' 　　　　 : (Out)  vntFirstName    名
' 　　　　 : (Out)  vntLastKName    カナ姓
' 　　　　 : (Out)  vntFirstKName   カナ名
' 　　　　 : (Out)  vntOrgName      団体名
' 　　　　 : (Out)  vntOrgSName     団体略称
' 　　　　 : (Out)  vntCoursePrice  基本コース金額（"1,234"編集）
' 　　　　 : (Out)  vntOptionPrice  オプション金額（"1,234"編集）
' 　　　　 : (Out)  vntOtherPrice   契約外金額（"1,234"編集）
' 　　　　 : (Out)  vntTaxPrice     消費税金額（"1,234"編集）
' 　　　　 : (Out)  vntTotalPrice   合計金額（"1,234"編集）
' 　　　　 : (Out)  vntTimeFra      時間枠
' 　　　　 : (Out)  vntTimeFraName  時間枠名称
' 　　　　 : (Out)  vntCntlNo       管理番号（"0001"編集）
' 　　　　 : (Out)  vntGenderName   性別名称
' 　　　　 : (Out)  vntBirth        生年月日（"yyyy/mm/dd"編集）
' 　　　　 : (Out)  vntAge          年齢
' 　　　　 : (Out)  vntRsvDate      予約日（"yyyy年m月d日"編集）
' 　　　　 : (Out)  vntRsvNo        予約番号
' 　　　　 : (Out)  vntPerID        個人ＩＤ
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 : 取得件数が"*"の時、検索条件を満たすレコードすべてを抽出する
'
Public Function SelectDmdOrgList(ByVal lngBillNo As String, ByVal strCslOrgCd1 As String, _
                                 ByVal strCslOrgCd2 As String, ByVal strCsCd As String, _
                                 ByVal lngSortKey As Long, ByVal lngStartPos As Long, _
                                 ByVal strGetCount As String, _
                                 Optional ByRef vntCslDate As Variant, Optional ByRef vntDayId As Variant, _
                                 Optional ByRef vntWebColor As Variant, Optional ByRef vntCsName As Variant, _
                                 Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant, _
                                 Optional ByRef vntLastKName As Variant, Optional ByRef vntFirstKName As Variant, _
                                 Optional ByRef vntOrgName As Variant, Optional ByRef vntOrgSName As Variant, _
                                 Optional ByRef vntCoursePrice As Variant, Optional ByRef vntOptionPrice As Variant, _
                                 Optional ByRef vntOtherPrice As Variant, Optional ByRef vntTaxPrice As Variant, _
                                 Optional ByRef vntTotalPrice As Variant, Optional ByRef vntTimeFra As Variant, _
                                 Optional ByRef vntTimeFraName As Variant, Optional ByRef vntCntlNo As Variant, _
                                 Optional ByRef vntGenderName As Variant, Optional ByRef vntBirth As Variant, _
                                 Optional ByRef vntAge As Variant, Optional ByRef vntRsvDate As Variant, _
                                 Optional ByRef vntRsvNo As Variant, Optional ByRef vntPerId As Variant _
                                ) As Long
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objCslDate              As OraField         '受診日（"yyyy/mm/dd"編集）
    Dim objDayId                As OraField         '当日ID（"0001"編集）
    Dim objWebColor             As OraField         'コース名表示色
    Dim objCsName               As OraField         'コース名
    Dim objLastName             As OraField         '姓
    Dim objFirstName            As OraField         '名
    Dim objLastKName            As OraField         'カナ姓
    Dim objFirstKName           As OraField         'カナ名
    Dim objOrgName              As OraField         '団体名
    Dim objOrgSName             As OraField         '団体略称
    Dim objTimeFra              As OraField         '時間枠
    Dim objCntlNo               As OraField         '管理番号（"0001"編集）
    Dim objgender               As OraField         '性別
    Dim objBirth                As OraField         '生年月日（"yyyy/mm/dd"編集）
    Dim objAge                  As OraField         '年齢
    Dim objRsvDate              As OraField         '予約日（"yyyy/mm/dd"編集）
    Dim objRsvNo                As OraField         '予約番号
    Dim objPerId                As OraField         '個人ＩＤ
    
    Dim objCommon               As Common           '共通クラス
    
    Dim vntArrCslDate()         As Variant          '受診日の配列（"yyyy年m月d日"編集）
    Dim vntArrDayId()           As Variant          '当日IDの配列（"0001"編集）
    Dim vntArrWebColor()        As Variant          'コース名表示色の配列
    Dim vntArrCsName()          As Variant          'コース名の配列
    Dim vntArrLastName()        As Variant          '姓の配列
    Dim vntArrFirstName()       As Variant          '名の配列
    Dim vntArrLastKName()       As Variant          'カナ姓の配列
    Dim vntArrFirstKName()      As Variant          'カナ名の配列
    Dim vntArrOrgName()         As Variant          '団体名の配列
    Dim vntArrOrgSName()        As Variant          '団体略称の配列
    Dim vntArrCoursePrice()     As Variant          '基本コース金額の配列（"1,234"編集）
    Dim vntArrOptionPrice()     As Variant          'オプション金額の配列（"1,234"編集）
    Dim vntArrOtherPrice()      As Variant          '契約外金額の配列（"1,234"編集）
    Dim vntArrTaxPrice()        As Variant          '消費税金額の配列（"1,234"編集）
    Dim vntArrTotalPrice()      As Variant          '合計金額の配列（"1,234"編集）
    Dim vntArrTimeFra()         As Variant          '時間枠の配列
    Dim vntArrTimeFraName()     As Variant          '時間枠名称の配列
    Dim vntArrCntlNo()          As Variant          '管理番号の配列（"0001"編集）
    Dim vntArrGenderName()      As Variant          '性別名称の配列
    Dim vntArrBirth()           As Variant          '生年月日の配列（"yyyy/mm/dd"編集）
    Dim vntArrAge()             As Variant          '年齢の配列
    Dim vntArrRsvDate()         As Variant          '予約日の配列（"yyyy年m月d日"編集）
    Dim vntArrRsvNo()           As Variant          '予約番号の配列
    Dim vntArrPerId()           As Variant          '個人ＩＤの配列
    
    Dim lngCount                As Long             'レコード数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    vntCslDate = Empty
    vntDayId = Empty
    vntWebColor = Empty
    vntCsName = Empty
    vntLastName = Empty
    vntFirstName = Empty
    vntLastKName = Empty
    vntFirstKName = Empty
    vntOrgName = Empty
    vntOrgSName = Empty
    vntCoursePrice = Empty
    vntOptionPrice = Empty
    vntOtherPrice = Empty
    vntTaxPrice = Empty
    vntTotalPrice = Empty
    vntTimeFra = Empty
    vntTimeFraName = Empty
    vntCntlNo = Empty
    vntGenderName = Empty
    vntBirth = Empty
    vntAge = Empty
    vntRsvDate = Empty
    vntRsvNo = Empty
    vntPerId = Empty
    SelectDmdOrgList = 0
    lngCount = 0
    
    '検索条件が設定されていない場合はエラー
    If lngBillNo = 0 Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "BILLNO", lngBillNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ORGCD1", Trim(strCslOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", Trim(strCslOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSCD", Trim(strCsCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    If IsNumeric(strGetCount) Then      '取得件数が「すべて」以外の場合
        objOraParam.Add "SEQ_F", lngStartPos, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "SEQ_T", (lngStartPos + CLng(strGetCount) - 1), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    objOraParam.Add "CANCELFLG", CLng(CONSULT_USED), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "RSVNO", 0, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "COURSEPRICE", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    objOraParam.Add "OPTIONPRICE", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    objOraParam.Add "OTHERPRICE", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    objOraParam.Add "TAXPRICE", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    objOraParam.Add "TOTALPRICE", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    
    '検索条件を満たす受診者情報のレコードを取得
    strStmt = "SELECT CSLDATE,   DAYID,      WEBCOLOR, CSNAME,   LASTNAME, FIRSTNAME,            " & vbLf & _
              "       LASTKNAME, FIRSTKNAME, ORGNAME,  ORGSNAME, TIMEFRA,  CNTLNO,               " & vbLf & _
              "       GENDER,    BIRTH,      AGE,      RSVDATE,  RSVNO,    PERID                 " & vbLf & _
              "  FROM ( SELECT ROWNUM SEQ, CSLDATE,   DAYID,     WEBCOLOR,   CSNAME,             " & vbLf & _
              "                LASTNAME,   FIRSTNAME, LASTKNAME, FIRSTKNAME, ORGNAME,            " & vbLf & _
              "                ORGSNAME,   TIMEFRA,   CNTLNO,    GENDER,     BIRTH,              " & vbLf & _
              "                AGE,        RSVDATE,   RSVNO,     PERID                           " & vbLf & _
              "           FROM ( SELECT TO_CHAR(cs.CSLDATE, 'YYYY/MM/DD') CSLDATE,               " & vbLf & _
              "                         TO_CHAR(rs.DAYID, '0999') DAYID,                         " & vbLf & _
              "                         cp.WEBCOLOR,  cp.CSNAME,                                 " & vbLf & _
              "                         ps.LASTNAME,  ps.FIRSTNAME,                              " & vbLf & _
              "                         ps.LASTKNAME, ps.FIRSTKNAME,                             " & vbLf & _
              "                         og.ORGNAME,   og.ORGSNAME,                               " & vbLf & _
              "                         cs.TIMEFRA,   TO_CHAR(rs.CNTLNO, '0999') CNTLNO,         " & vbLf & _
              "                         ps.GENDER,    TO_CHAR(ps.BIRTH, 'YYYY/MM/DD') BIRTH,     " & vbLf & _
              "                         cs.AGE,       TO_CHAR(cs.RSVDATE, 'YYYY/MM/DD') RSVDATE, " & vbLf & _
              "                         cs.RSVNO,     cs.PERID                                   " & vbLf & _
              "                    FROM CONSULT cs, RECEIPT rs, COURSE_P cp, PERSON ps, ORG og   "
    
    strStmt = strStmt & vbLf & _
              "                   WHERE cs.RSVNO IN (SELECT DISTINCT RSVNO                       " & vbLf & _
              "                                        FROM CLOSEMNG                             " & vbLf & _
              "                                       WHERE BILLNO = :BILLNO                     " & vbLf & _
              "                                     )                                            " & vbLf & _
              "                     AND cs.CANCELFLG = :CANCELFLG                                " & vbLf & _
              "                     AND cs.RSVNO     = rs.RSVNO  (+)                             " & vbLf & _
              "                     AND cs.CSLDATE   = rs.CSLDATE(+)                             " & vbLf & _
              "                     AND cs.CSCD      = cp.CSCD   (+)                             " & vbLf & _
              "                     AND cs.PERID     = ps.PERID  (+)                             " & vbLf & _
              "                     AND cs.ORGCD1    = og.ORGCD1 (+)                             " & vbLf & _
              "                     AND cs.ORGCD2    = og.ORGCD2 (+)                             "
    
    '条件節を追加
    If Trim(strCslOrgCd1) <> "" Or _
       Trim(strCslOrgCd2) <> "" Then            '受診団体指定あり
        strStmt = strStmt & vbLf & _
              "                     AND cs.ORGCD1    = :ORGCD1 " & vbLf & _
              "                     AND cs.ORGCD2    = :ORGCD2 "
    End If
    If Trim(strCsCd) <> "" Then                 'コースコード指定あり
        strStmt = strStmt & vbLf & _
              "                     AND cs.CSCD      = :CSCD   "
    End If
    
    'ソート順を追加
    Select Case lngSortKey
        Case DOL_SORT_DEFAULT                   '基本表示順（受診日，当日ID，コース，団体（カナ），氏名（カナ））
            strStmt = strStmt & vbLf & _
              "                   ORDER BY cs.CSLDATE, rs.DAYID, cs.CSCD, og.ORGKNAME, ps.LASTKNAME, ps.FIRSTKNAME "
    End Select
    strStmt = strStmt & vbLf & _
              "                )                               " & vbLf & _
              "       )                                        "
    
    '開始位置から取得件数分を取得するための条件節を追加
    If IsNumeric(strGetCount) Then      '取得件数が「すべて」以外の場合
        strStmt = strStmt & vbLf & _
              " WHERE SEQ BETWEEN :SEQ_F AND :SEQ_T"
    End If
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        '共通クラスのインスタンス作成
        Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCslDate = objFields("CSLDATE")
        Set objDayId = objFields("DAYID")
        Set objWebColor = objFields("WEBCOLOR")
        Set objCsName = objFields("CSNAME")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastKName = objFields("LASTKNAME")
        Set objFirstKName = objFields("FIRSTKNAME")
        Set objOrgName = objFields("ORGNAME")
        Set objOrgSName = objFields("ORGSNAME")
        Set objTimeFra = objFields("TIMEFRA")
        Set objCntlNo = objFields("CNTLNO")
        Set objgender = objFields("GENDER")
        Set objBirth = objFields("BIRTH")
        Set objAge = objFields("AGE")
        Set objRsvDate = objFields("RSVDATE")
        Set objRsvNo = objFields("RSVNO")
        Set objPerId = objFields("PERID")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrCslDate(lngCount)
            ReDim Preserve vntArrDayId(lngCount)
            ReDim Preserve vntArrWebColor(lngCount)
            ReDim Preserve vntArrCsName(lngCount)
            ReDim Preserve vntArrLastName(lngCount)
            ReDim Preserve vntArrFirstName(lngCount)
            ReDim Preserve vntArrLastKName(lngCount)
            ReDim Preserve vntArrFirstKName(lngCount)
            ReDim Preserve vntArrOrgName(lngCount)
            ReDim Preserve vntArrOrgSName(lngCount)
            ReDim Preserve vntArrCoursePrice(lngCount)
            ReDim Preserve vntArrOptionPrice(lngCount)
            ReDim Preserve vntArrOtherPrice(lngCount)
            ReDim Preserve vntArrTaxPrice(lngCount)
            ReDim Preserve vntArrTotalPrice(lngCount)
            ReDim Preserve vntArrTimeFra(lngCount)
            ReDim Preserve vntArrTimeFraName(lngCount)
            ReDim Preserve vntArrCntlNo(lngCount)
            ReDim Preserve vntArrGenderName(lngCount)
            ReDim Preserve vntArrBirth(lngCount)
            ReDim Preserve vntArrAge(lngCount)
            ReDim Preserve vntArrRsvDate(lngCount)
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrPerId(lngCount)
            vntArrCslDate(lngCount) = Format(CDate(objCslDate.Value & ""), "yyyy年m月d日")
            vntArrDayId(lngCount) = objDayId.Value & ""
            vntArrWebColor(lngCount) = objWebColor.Value & ""
            vntArrCsName(lngCount) = objCsName.Value & ""
            vntArrLastName(lngCount) = objLastName.Value & ""
            vntArrFirstName(lngCount) = objFirstName.Value & ""
            vntArrLastKName(lngCount) = objLastKName.Value & ""
            vntArrFirstKName(lngCount) = objFirstKName.Value & ""
            vntArrOrgName(lngCount) = objOrgName.Value & ""
            vntArrOrgSName(lngCount) = objOrgSName.Value & ""
            'キー値の設定
            objOraParam("RSVNO").Value = CLng(objRsvNo.Value & "")
            'ストアドＣＡＬＬ（予約番号より、基本コース・オプション・契約外・消費税・合計の５つの金額を求める）
            mobjOraDb.ExecuteSQL "BEGIN DEMANDPACKAGE.GETPRICEFROMRSVNO(:RSVNO, :COURSEPRICE, :OPTIONPRICE, :OTHERPRICE, :TAXPRICE, :TOTALPRICE); END;"
            vntArrCoursePrice(lngCount) = Format(CLng(objOraParam("COURSEPRICE").Value), "#,###")
            vntArrOptionPrice(lngCount) = Format(CLng(objOraParam("OPTIONPRICE").Value), "#,###")
            vntArrOtherPrice(lngCount) = Format(CLng(objOraParam("OTHERPRICE").Value), "#,###")
            vntArrTaxPrice(lngCount) = Format(CLng(objOraParam("TAXPRICE").Value), "#,###")
            vntArrTotalPrice(lngCount) = Format(CLng(objOraParam("TOTALPRICE").Value), "#,###")
            vntArrTimeFra(lngCount) = CLng(objTimeFra.Value & "")
            vntArrTimeFraName(lngCount) = objCommon.SelectTimeFraName(CLng(vntArrTimeFra(lngCount))) & ""
            vntArrCntlNo(lngCount) = objCntlNo.Value & ""
            If Trim(objgender.Value) = GENDER_MALE Then
                vntArrGenderName(lngCount) = "男"
            ElseIf Trim(objgender.Value) = GENDER_FEMALE Then
                vntArrGenderName(lngCount) = "女"
            Else
                vntArrGenderName(lngCount) = objgender.Value & ""
            End If
            vntArrBirth(lngCount) = objBirth.Value & ""
            vntArrAge(lngCount) = objAge.Value & ""
            vntArrRsvDate(lngCount) = Format(CDate(objRsvDate.Value & ""), "yyyy年m月d日")
            vntArrRsvNo(lngCount) = CLng(objRsvNo.Value & "")
            vntArrPerId(lngCount) = objPerId.Value & ""
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
        Set objCommon = Nothing
    
    End If
    
    '戻り値の設定
    vntCslDate = vntArrCslDate
    vntDayId = vntArrDayId
    vntWebColor = vntArrWebColor
    vntCsName = vntArrCsName
    vntLastName = vntArrLastName
    vntFirstName = vntArrFirstName
    vntLastKName = vntArrLastKName
    vntFirstKName = vntArrFirstKName
    vntOrgName = vntArrOrgName
    vntOrgSName = vntArrOrgSName
    vntCoursePrice = vntArrCoursePrice
    vntOptionPrice = vntArrOptionPrice
    vntOtherPrice = vntArrOtherPrice
    vntTaxPrice = vntArrTaxPrice
    vntTotalPrice = vntArrTotalPrice
    vntTimeFra = vntArrTimeFra
    vntTimeFraName = vntArrTimeFraName
    vntCntlNo = vntArrCntlNo
    vntGenderName = vntArrGenderName
    vntBirth = vntArrBirth
    vntAge = vntArrAge
    vntRsvDate = vntArrRsvDate
    vntRsvNo = vntArrRsvNo
    vntPerId = vntArrPerId
    SelectDmdOrgList = lngCount
    
    Set objOraDyna = Nothing
    objOraParam.Remove "BILLNO"
    objOraParam.Remove "ORGCD1"
    objOraParam.Remove "ORGCD2"
    objOraParam.Remove "CSCD"
    If IsNumeric(strGetCount) Then      '取得件数が「すべて」以外の場合
        objOraParam.Remove "SEQ_F"
        objOraParam.Remove "SEQ_T"
    End If
    objOraParam.Remove "CANCELFLG"
    objOraParam.Remove "RSVNO"
    objOraParam.Remove "COURSEPRICE"
    objOraParam.Remove "OPTIONPRICE"
    objOraParam.Remove "OTHERPRICE"
    objOraParam.Remove "TAXPRICE"
    objOraParam.Remove "TOTALPRICE"
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.SelectDmdOrgList"
    
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

'## 2002.12.30 Modified Function by ishihara@FSIT 東急殿向け締め処理に合致するよう、メソッドそのものを完全再作成
'## 2004.01.28 Modified Function by Shiramizu@CS メッセージ変更（聖路加対応）
'
' 機能　　 : 請求書基本情報更新時の妥当性チェックを行う
'
' 引数　　 : (In)   lngCloseYear    締め日（年）
' 　　　　 : (In)   lngCloseMonth   締め日（月）
' 　　　　 : (In)   lngCloseDay     締め日（日）
' 　　　　 : (Out)  vntCloseDate    締め日
' 　　　　 : (In)   strOrgCd1       団体コード１
' 　　　　 : (In)   strOrgCd2       団体コード２
' 　　　　 : (In)   vntTaxRates     税率
' 　　　　 : (In)   lngPrtYear      請求書出力日（年）
' 　　　　 : (In)   lngPrtMonth     請求書出力日（月）
' 　　　　 : (In)   lngPrtDay       請求書出力日（日）
' 　　　　 : (Out)  vntPrtDate      請求書出力日
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
Public Function CheckValueDmdOrgMasterBurden(ByVal lngCloseYear As Long, ByVal lngCloseMonth As Long, _
                                             ByVal lngCloseDay As Long, ByRef vntCloseDate As Variant, _
                                             ByVal strOrgCd1 As String, ByVal strOrgCd2 As String, _
                                             ByVal vntTaxRates As Variant, _
                                             ByVal lngPrtYear As Long, ByVal lngPrtMonth As Long, _
                                             ByVal lngPrtDay As Long, ByRef vntPrtDate As Variant _
                                            ) As Variant
    
    Dim objCommon               As Common           '共通クラス
    
    Dim vntPriceMessage         As Variant          '入金額メッセージ
    Dim vntArrMessage           As Variant          'エラーメッセージの集合
    
    Dim vntEditPrtDate          As Variant          '編集用出力日
    
    '初期処理
    CheckValueDmdOrgMasterBurden = Empty
    vntArrMessage = Empty
    
    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    
    Do
        '各値チェック処理
        With objCommon
    
            '締め日チェック
            .AppendArray vntArrMessage, .CheckDate("締め日", lngCloseYear, lngCloseMonth, lngCloseDay, vntCloseDate, CHECK_NECESSARY)
            
            '請求先団体チェック
            If strOrgCd1 = "" Or strOrgCd2 = "" Then
'                .AppendArray vntArrMessage, "負担元団体を指定してください"
                .AppendArray vntArrMessage, "請求先団体を指定してください"
            End If
            
            '請求書出力日チェック
            .AppendArray vntArrMessage, .CheckDate("請求書出力日", lngPrtYear, lngPrtMonth, lngPrtDay, vntEditPrtDate)
            
            '税率チェック
            .AppendArray vntArrMessage, .CheckNumericDecimalPoint("税率", vntTaxRates, LENGTH_TAXRATES, LENGTH_TAXRATES_DECPOINT, CHECK_NECESSARY)

        End With
    
        Exit Do
    Loop
    
    '戻り値の編集
    If IsArray(vntArrMessage) Then
        CheckValueDmdOrgMasterBurden = vntArrMessage
    Else
        vntPrtDate = vntEditPrtDate
    End If
    
    Set objCommon = Nothing
    
End Function

'## 2004.01.17 Modified Function by Shiramizu@CS 聖路加病院殿向けに、メソッドそのものを完全再作成
'
' 機能　　 : 請求書を挿入する
'
' 引数　　 : (Out)  vntBillNo        請求書番号
' 　　　　 : (In)   vntCloseDate     締め日
' 　　　　 : (In)   vntOrgCd1        団体コード１
' 　　　　 : (In)   vntOrgCd2        団体コード２
' 　　　　 : (In)   vntPrtDate       請求書出力日
' 　　　　 : (In)   vntTaxRates      適用税率
'## 2004.06.02 ADD STR ORB)T.YAGUCHI 項目追加
' 　　　　 : (In)   vntSecondFlg     ２次検査フラグ
'## 2004.06.02 ADD END
'
' 戻り値　 : TRUE   正常終了
' 　　　　 : FALSE  異常終了
'
' 備考　　 :
'
'## 2004.06.02 MOD STR ORB)T.YAGUCHI 項目追加
'Public Function InsertBill(ByRef vntBillNo As Variant,
'                           ByVal vntCloseDate As Variant,
'                           ByVal vntOrgCd1 As Variant,
'                           ByVal vntOrgCd2 As Variant,
'                           ByVal vntPrtDate As Variant,
'                           ByVal vntTaxRates As Variant
'                          ) As Boolean
Public Function InsertBill(ByRef vntBillNo As Variant, _
                           ByVal vntCloseDate As Variant, _
                           ByVal vntOrgCd1 As Variant, _
                           ByVal vntOrgCd2 As Variant, _
                           ByVal vntPrtDate As Variant, _
                           ByVal vntTaxRates As Variant, _
                           ByVal vntSecondFlg As Variant _
                          ) As Boolean
'## 2004.06.02 MOD END

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    Dim vntBillSeq              As Variant          '請求書Seq
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    If IsNull(vntCloseDate) Or vntCloseDate = "" Or _
       IsNull(vntOrgCd1) Or vntOrgCd1 = "" Or _
       IsNull(vntOrgCd2) Or vntOrgCd2 = "" Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    '請求書番号取得
    Call GetBillSeq(vntBillSeq, vntCloseDate)
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CLOSEDATE", CDate(vntCloseDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", vntBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ORGCD1", vntOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", vntOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "PRTDATE", Trim(vntPrtDate), ORAPARM_INPUT, IIf(IsDate(vntPrtDate), ORATYPE_DATE, ORATYPE_VARCHAR2)
    objOraParam.Add "TAXRATES", Trim(vntTaxRates), ORAPARM_INPUT, IIf(Not IsNumeric(vntTaxRates), ORATYPE_VARCHAR2, ORATYPE_NUMBER)
'## 2004.06.02 ADD STR ORB)T.YAGUCHI 項目追加
    objOraParam.Add "SECONDFLG", IIf(IsNull(vntSecondFlg), Null, vntSecondFlg), ORAPARM_INPUT, ORATYPE_NUMBER
'## 2004.06.02 ADD END

'## 2004.06.02 MOD STR ORB)T.YAGUCHI 項目追加
'    '該当キーの請求書を挿入
'    strStmt = "INSERT INTO BILL (   " & vbLf & _
'              "       CLOSEDATE,    " & vbLf & _
'              "       BILLSEQ,      " & vbLf & _
'              "       BRANCHNO,     " & vbLf & _
'              "       DELFLG,       " & vbLf & _
'              "       ORGCD1,       " & vbLf & _
'              "       ORGCD2,       " & vbLf & _
'              "       METHOD,       " & vbLf & _
'              "       TAXRATES,     " & vbLf & _
'              "       PRTDATE       " & vbLf
'
'    strStmt = strStmt & vbLf & _
'              "       ) VALUES (    " & vbLf & _
'              "       :CLOSEDATE,   " & vbLf & _
'              "       :BILLSEQ,     " & vbLf & _
'              "       0,            " & vbLf & _
'              "       0,            " & vbLf & _
'              "       :ORGCD1,      " & vbLf & _
'              "       :ORGCD2,      " & vbLf & _
'              "       0,            " & vbLf & _
'              "       :TAXRATES,    " & vbLf & _
'              "       :PRTDATE      " & vbLf & _
'              "       )"
    '該当キーの請求書を挿入
    strStmt = "INSERT INTO BILL (   " & vbLf & _
              "       CLOSEDATE,    " & vbLf & _
              "       BILLSEQ,      " & vbLf & _
              "       BRANCHNO,     " & vbLf & _
              "       DELFLG,       " & vbLf & _
              "       ORGCD1,       " & vbLf & _
              "       ORGCD2,       " & vbLf & _
              "       METHOD,       " & vbLf & _
              "       TAXRATES,     " & vbLf & _
              "       PRTDATE,      " & vbLf & _
              "       SECONDFLG     " & vbLf
          
    strStmt = strStmt & vbLf & _
              "       ) VALUES (    " & vbLf & _
              "       :CLOSEDATE,   " & vbLf & _
              "       :BILLSEQ,     " & vbLf & _
              "       0,            " & vbLf & _
              "       0,            " & vbLf & _
              "       :ORGCD1,      " & vbLf & _
              "       :ORGCD2,      " & vbLf & _
              "       0,            " & vbLf & _
              "       :TAXRATES,    " & vbLf & _
              "       :PRTDATE,     " & vbLf & _
              "       :SECONDFLG    " & vbLf & _
              "       )"
'## 2004.06.02 MOD END
    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing
    
    vntBillNo = Format(vntCloseDate, "YYYYMMDD") & Format(vntBillSeq, "00000") & "0"
    
    '戻り値の設定
    InsertBill = INSERT_NORMAL
    
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
    
    'キー重複時はRaise文を使用せず、戻り値を設定して正常終了させる
    If mobjOraDb.LastServerErr = 1 Then
        InsertBill = INSERT_DUPLICATE
        Exit Function
    End If
        
    InsertBill = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Demand.InsertBill"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function


'## 2004.01.17 Modified Function by Shiramizu@CS 聖路加病院殿向けに、メソッドそのものを完全再作成
'
' 機能　　 : 請求明細を更新する
'
' 引数　　 : (In)   vntBillNo               請求書番号
' 　　　　 : (In)   vntCslDate              受診日
' 　　　　 : (In)   vntRsvNo                予約番号
' 　　　　 : (In)   vntDayId                当日ID
' 　　　　 : (In)   vntDetailName           名称
' 　　　　 : (In)   vntPerId                個人ID
' 　　　　 : (In)   vntPrice                金額
' 　　　　 : (In)   vntEditPrice            調整金額
' 　　　　 : (In)   vntTaxPrice             税額
' 　　　　 : (In)   vntEditTax              調整税額
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function InsertBillDetail(ByVal vntBillNo As Variant, _
                                  ByVal vntCslDate As Variant, _
                                  ByVal vntRsvNo As Variant, _
                                  ByVal vntDayId As Variant, _
                                  ByVal vntDetailName As Variant, _
                                  ByVal vntPerId As Variant, _
                                  ByVal vntPrice As Variant, _
                                  ByVal vntEditPrice As Variant, _
                                  ByVal vntTaxPrice As Variant, _
                                  ByVal vntEditTax As Variant) As Boolean
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    
    Dim blnPerId                As Boolean          'TRUE:個人ID入力
    
    Dim strCloseDate            As String           '締め日
    Dim lngBillSeq              As Long             '請求書Seq
    Dim lngBranchNo             As Long             '請求書枝番
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
 
    '初期処理
    InsertBillDetail = False
    blnPerId = False
    
    '検索条件が設定されていない場合はエラー
    If Not IsNumeric(vntBillNo) Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    If IsMissing(vntPerId) = False Then
        If Not IsNull(vntPerId) And vntPerId <> "" Then
            blnPerId = True
        End If
    End If
    
    '請求書番号の妥当性チェック
    If IsMissing(vntBillNo) = False Then
        vntBillNo = Trim(vntBillNo)
        If IsNumeric(vntBillNo) = True Then
            If CDbl(vntBillNo) > 0 Then
                If (Len(vntBillNo) = LENGTH_BILLNO) Then
                    '請求書番号を分解
                    strCloseDate = Mid(vntBillNo, 1, 4) & "/" & Mid(vntBillNo, 5, 2) & "/" & Mid(vntBillNo, 7, 2)
                    lngBillSeq = CLng(Mid(vntBillNo, 9, 5))
                    lngBranchNo = CLng(Mid(vntBillNo, 14, 1))
                End If
            End If
        End If
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    
    objOraParam.Add "CSLDATE", CDate(vntCslDate), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "RSVNO", vntRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DAYID", vntDayId, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DETAILNAME", Trim(vntDetailName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    If blnPerId = True Then
        objOraParam.Add "PERID", vntPerId, ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    objOraParam.Add "PRICE", vntPrice, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "EDITPRICE", vntEditPrice, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TAXPRICE", vntTaxPrice, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "EDITTAX", vntEditTax, ORAPARM_INPUT, ORATYPE_NUMBER
    
    objOraParam.Add "CLOSEDATE", CDate(strCloseDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '該当キーの請求書を更新
    If blnPerId = True Then
        strStmt = "INSERT INTO BILLDETAIL " & vbLf & _
                  "( " & vbLf & _
                  "CLOSEDATE, BILLSEQ, BRANCHNO, " & vbLf & _
                  "LINENO, " & vbLf & _
                  "DETAILNAME, PRICE, EDITPRICE, " & vbLf & _
                  "TAXPRICE, EDITTAX, RSVNO, " & vbLf & _
                  "PERID, LASTNAME, FIRSTNAME, LASTKNAME, " & vbLf & _
                  "FIRSTKNAME, CSLDATE, DAYID, METHOD " & vbLf & _
                  ") " & vbLf
        strStmt = strStmt & "( " & vbLf & _
                            "SELECT " & vbLf & _
                            ":CLOSEDATE, :BILLSEQ, :BRANCHNO, " & vbLf & _
                            "BILLDETAIL_VIEW.MAXLINENO, " & vbLf & _
                            ":DETAILNAME, :PRICE, :EDITPRICE, " & vbLf & _
                            ":TAXPRICE, :EDITTAX, :RSVNO, " & vbLf & _
                            "PERSON.PERID, PERSON.LASTNAME, PERSON.FIRSTNAME, PERSON.LASTKNAME,  " & vbLf & _
                            "PERSON.FIRSTKNAME, :CSLDATE, :DAYID, 0 " & vbLf & _
                            "FROM " & vbLf & _
                            "PERSON, " & vbLf & _
                            "( " & vbLf & _
                            "SELECT " & vbLf & _
                            "NVL(MAX(BILLDETAIL.LINENO),0) + 1 AS MAXLINENO " & vbLf & _
                            "FROM " & vbLf & _
                            "BILLDETAIL " & vbLf & _
                            "WHERE " & vbLf & _
                            "BILLDETAIL.CLOSEDATE = :CLOSEDATE " & vbLf & _
                            "AND BILLDETAIL.BILLSEQ = :BILLSEQ " & vbLf & _
                            "AND BILLDETAIL.BRANCHNO = :BRANCHNO " & vbLf & _
                            ") BILLDETAIL_VIEW " & vbLf & _
                            "WHERE " & vbLf & _
                            "PERID = :PERID " & vbLf & _
                            ") " & vbLf
        

    Else
    
        strStmt = "INSERT INTO BILLDETAIL " & vbLf & _
                  "(CLOSEDATE, BILLSEQ, BRANCHNO, LINENO,  " & vbLf & _
                  "DETAILNAME, PRICE, EDITPRICE, TAXPRICE,  " & vbLf & _
                  "EDITTAX, RSVNO, CSLDATE, DAYID, METHOD) " & vbLf & _
                  "( " & vbLf & _
                  "SELECT " & vbLf & _
                  ":CLOSEDATE, :BILLSEQ, :BRANCHNO, NVL(MAX(LINENO),0)+1, " & vbLf & _
                  ":DETAILNAME, :PRICE, :EDITPRICE, :TAXPRICE,  " & vbLf & _
                  ":EDITTAX, :RSVNO, :CSLDATE, :DAYID, 0 " & vbLf & _
                  "FROM BILLDETAIL " & vbLf & _
                  "WHERE " & vbLf & _
                  "CLOSEDATE = :CLOSEDATE " & vbLf & _
                  "AND BILLSEQ = :BILLSEQ " & vbLf & _
                  "AND BRANCHNO = : BRANCHNO " & vbLf & _
                  ")" & vbLf
    End If
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing
    
    '戻り値の設定
    InsertBillDetail = True
    
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
    
    'キー重複時はRaise文を使用せず、戻り値を設定して正常終了させる
    If mobjOraDb.LastServerErr = 1 Then
        InsertBillDetail = INSERT_DUPLICATE
        Exit Function
    End If
        
    InsertBillDetail = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Demand.InsertBillDetail"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'## 2004.05.24 Add Str Orb)T.Yaguchi 請求明細内訳の追加
'
' 機能　　 : 請求明細内訳を更新する
'
' 引数　　 : (In)   vntBillNo               請求書番号
' 　　　　 : (In)   vntLineNo               明細No
' 　　　　 : (In)   vntSecondLineDivCd      ２次請求明細コード
' 　　　　 : (In)   vntPrice                金額
' 　　　　 : (In)   vntEditPrice            調整金額
' 　　　　 : (In)   vntTaxPrice             税額
' 　　　　 : (In)   vntEditTax              調整税額
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function InsertBillDetail_Items(ByVal vntBillNo As Variant, _
                                       ByVal vntLineNo As Variant, _
                                       ByVal vntSecondLineDivCd As Variant, _
                                       ByVal vntPrice As Variant, _
                                       ByVal vntEditPrice As Variant, _
                                       ByVal vntTaxPrice As Variant, _
                                       ByVal vntEditTax As Variant) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント

    Dim blnPerId                As Boolean          'TRUE:個人ID入力

    Dim strCloseDate            As String           '締め日
    Dim lngBillSeq              As Long             '請求書Seq
    Dim lngBranchNo             As Long             '請求書枝番

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
 
    '初期処理
    InsertBillDetail_Items = False
    blnPerId = False

    '検索条件が設定されていない場合はエラー
    If Not IsNumeric(vntBillNo) Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    If IsNull(vntLineNo) Or vntLineNo = "" Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If

    '請求書番号の妥当性チェック
    If IsMissing(vntBillNo) = False Then
        vntBillNo = Trim(vntBillNo)
        If IsNumeric(vntBillNo) = True Then
            If CDbl(vntBillNo) > 0 Then
                If (Len(vntBillNo) = LENGTH_BILLNO) Then
                    '請求書番号を分解
                    strCloseDate = Mid(vntBillNo, 1, 4) & "/" & Mid(vntBillNo, 5, 2) & "/" & Mid(vntBillNo, 7, 2)
                    lngBillSeq = CLng(Mid(vntBillNo, 9, 5))
                    lngBranchNo = CLng(Mid(vntBillNo, 14, 1))
                End If
            End If
        End If
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    
    objOraParam.Add "SECONDLINEDIVCD", Trim(vntSecondLineDivCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "PRICE", vntPrice, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "EDITPRICE", vntEditPrice, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TAXPRICE", vntTaxPrice, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "EDITTAX", vntEditTax, ORAPARM_INPUT, ORATYPE_NUMBER

    objOraParam.Add "CLOSEDATE", CDate(strCloseDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "LINENO", vntLineNo, ORAPARM_INPUT, ORATYPE_NUMBER

    '該当キーの請求書を更新
    strStmt = "INSERT INTO BILLDETAIL_ITEMS " & vbLf & _
              "(CLOSEDATE, BILLSEQ, BRANCHNO, LINENO,  " & vbLf & _
              "ITEMNO, SECONDLINEDIVCD, PRICE, EDITPRICE,  " & vbLf & _
              "TAXPRICE, EDITTAX) " & vbLf & _
              "( " & vbLf & _
              "SELECT " & vbLf & _
              ":CLOSEDATE, :BILLSEQ, :BRANCHNO, :LINENO, " & vbLf & _
              "NVL(MAX(ITEMNO),0)+1, :SECONDLINEDIVCD, :PRICE, :EDITPRICE, " & vbLf & _
              ":TAXPRICE, :EDITTAX " & vbLf & _
              "FROM BILLDETAIL_ITEMS " & vbLf & _
              "WHERE " & vbLf & _
              "CLOSEDATE = :CLOSEDATE " & vbLf & _
              "AND BILLSEQ = :BILLSEQ " & vbLf & _
              "AND BRANCHNO = :BRANCHNO " & vbLf & _
              "AND LINENO = :LINENO " & vbLf & _
              ")" & vbLf
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing

    '戻り値の設定
    InsertBillDetail_Items = True

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

    'キー重複時はRaise文を使用せず、戻り値を設定して正常終了させる
    If mobjOraDb.LastServerErr = 1 Then
        InsertBillDetail_Items = INSERT_DUPLICATE
        Exit Function
    End If

    InsertBillDetail_Items = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Demand.InsertBillDetail_Items"

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function


'## 2002.12.30 Modified Function by ishihara@FSIT 東急殿向け締め処理に合致するよう、メソッドそのものを完全再作成
'
' 機能　　 : 請求書を更新する
'
' 引数　　 : (In)   lngBillNo        請求書番号
' 　　　　 : (In)   lngMethod        作成方法
' 　　　　 : (In)   dtmCloseDate     締め日
' 　　　　 : (In)   strOrgCd1        団体コード１
' 　　　　 : (In)   strOrgCd2        団体コード２
' 　　　　 : (In)   strBillClassCd   請求書分類コード
' 　　　　 : (In)   strTaxRates      適用税率
' 　　　　 : (In)   strPrtDate       請求書出力日
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function UpdateBill(ByVal strBillNo As String, _
                           ByVal lngMethod As Long, _
                           ByVal dtmCloseDate As Date, _
                           ByVal strOrgCd1 As String, _
                           ByVal strOrgCd2 As String, _
                           ByVal strBillClassCd As String, _
                           ByVal strTaxRates As String, _
                           ByVal vntPrtDate As Variant _
                          ) As Boolean
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    UpdateBill = False
    
    '検索条件が設定されていない場合はエラー
    If Not IsNumeric(strBillNo) Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    Select Case lngMethod
        Case BILL_METHOD_MAN, BILL_METHOD_PRG
        Case Else
            Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
            Exit Function
    End Select
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "BILLNO", strBillNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    If lngMethod = BILL_METHOD_MAN Then
        '手入力のときだけ団体を変更可とする
        objOraParam.Add "ORGCD1", strOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "ORGCD2", strOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    
    objOraParam.Add "BILLCLASSCD", Trim(strBillClassCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CLOSEDATE", dtmCloseDate, ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "TAXRATES", Trim(strTaxRates), ORAPARM_INPUT, IIf(Not IsNumeric(strTaxRates), ORATYPE_VARCHAR2, ORATYPE_NUMBER)
    objOraParam.Add "PRTDATE", Trim(vntPrtDate), ORAPARM_INPUT, IIf(IsDate(vntPrtDate), ORATYPE_DATE, ORATYPE_VARCHAR2)
    
    '該当キーの請求書を更新
    strStmt = "UPDATE BILL                        " & vbLf & _
              "   SET CLOSEDATE   = :CLOSEDATE,   " & vbLf & _
              "       BILLCLASSCD = :BILLCLASSCD, " & vbLf
    
    If lngMethod = BILL_METHOD_MAN Then
        strStmt = strStmt & vbLf & _
              "       ORGCD1      = :ORGCD1,      " & vbLf & _
              "       ORGCD2      = :ORGCD2,      " & vbLf
    End If
    
    strStmt = strStmt & vbLf & _
              "       PRTDATE     = :PRTDATE,     " & vbLf & _
              "       TAXRATES    = :TAXRATES     " & vbLf & _
              " WHERE BILLNO = :BILLNO       "
    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing
    
    '戻り値の設定
    UpdateBill = True
    
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
    
    'キー重複時はRaise文を使用せず、戻り値を設定して正常終了させる
    If mobjOraDb.LastServerErr = 1 Then
        UpdateBill = INSERT_DUPLICATE
        Exit Function
    End If
        
    UpdateBill = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Demand.UpdateBill"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'## 2004.01.17 Modified Function by Shiramizu@CS 聖路加病院殿向けに、メソッドそのものを完全再作成
'
' 機能　　 : 請求書を削除する
'
' 引数　　 : (In)   vntIn_BillNo       請求書番号
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 : パラメタの指定状態によって、削除テーブルをハンドリング
'
Public Function DeleteBill(ByVal vntIn_BillNo As Variant) As Long
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim objFields               As OraFields        'フィールドオブジェクト
    
    Dim strStmt                 As String           'SQLステートメント
    
    Dim blnIsBillNo            As Boolean
    Dim strCloseDate            As String           '締め日
    Dim lngBillSeq              As Long             '請求書Seq
    Dim lngBranchNo             As Long             '請求書枝番
    
    Dim objDelResult            As OraField         '削除結果（1：物理削除、2:論理削除、0：データなし、-1：例外）
    Dim lngDelResult            As Long
    Dim Ret                     As Long
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    DeleteBill = -1
    strStmt = ""
    
    '請求書番号の妥当性チェック
    If IsMissing(vntIn_BillNo) = False Then
        vntIn_BillNo = Trim(vntIn_BillNo)
        
        If IsNumeric(vntIn_BillNo) = True Then
            If CDbl(vntIn_BillNo) > 0 Then
                If (Len(vntIn_BillNo) = LENGTH_BILLNO) Then
                    '請求書番号を分解
                    strCloseDate = Mid(vntIn_BillNo, 1, 4) & "/" & Mid(vntIn_BillNo, 5, 2) & "/" & Mid(vntIn_BillNo, 7, 2)
                    lngBillSeq = CLng(Mid(vntIn_BillNo, 9, 5))
                    lngBranchNo = CLng(Mid(vntIn_BillNo, 14, 1))
                    If IsDate(strCloseDate) Then
                        blnIsBillNo = True
                    End If
                End If
            End If
        End If
    End If
    
    '請求書番号が正しく指定されていない場合はエラー
    If blnIsBillNo = False Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CLOSEDATE", CDate(strCloseDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '戻り値の設定
    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    
    '該当キーの請求書明細を削除
    strStmt = "BEGIN DELETE_BILL(:CLOSEDATE, :BILLSEQ,:RET); END;"
    
     'PL/SQL文の実行
    mobjOraDb.ExecuteSQL strStmt

    '戻り値の取得
    Ret = objOraParam("RET").Value
   
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing
    
    '戻り値の設定
    DeleteBill = Ret
    
    'トランザクションをコミット
    If Ret > 0 Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If
'    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.DeleteBill"
    
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

'## 2004.01.17 Modified Function by Shiramizu@CS 聖路加病院殿向けに、メソッドそのものを完全再作成
'
' 機能　　 : 請求明細を更新する
'
' 引数　　 : (In)   vntBillNo               請求書番号
' 　　　　 : (In)   vntLineNo               明細No.
' 　　　　 : (In)   vntRsvNo                予約番号
' 　　　　 : (In)   vntOrgCd1               団体コード１
' 　　　　 : (In)   vntOrgCd2               団体コード２
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function DeleteBillDetail(ByVal vntBillNo As Variant, _
                                  ByVal vntLineNo As Variant, _
                                  ByVal vntRsvNo As Variant, _
                                  ByVal vntOrgCd1 As Variant, _
                                  ByVal vntOrgCd2 As Variant) As Boolean
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    
'    Dim objOraDyna                  As OraDynaset       'ダイナセット
'    Dim objFields                   As OraFields        'フィールドオブジェクト
'    Dim objMethod                   As OraField         '作成方法
'    Dim strMethod                   As String           '作成方法
    
    Dim strCloseDate            As String           '締め日
    Dim lngBillSeq              As Long             '請求書Seq
    Dim lngBranchNo             As Long             '請求書枝番
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
 
    '初期処理
    DeleteBillDetail = False
    
    '検索条件が設定されていない場合はエラー
    If Not IsNumeric(vntBillNo) Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    If IsNull(vntLineNo) Or vntLineNo = "" Or _
       IsNull(vntOrgCd1) Or vntOrgCd1 = "" Or _
       IsNull(vntOrgCd2) Or vntOrgCd2 = "" Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    '請求書番号の妥当性チェック
    If IsMissing(vntBillNo) = False Then
        vntBillNo = Trim(vntBillNo)
        If IsNumeric(vntBillNo) = True Then
            If CDbl(vntBillNo) > 0 Then
                If (Len(vntBillNo) = LENGTH_BILLNO) Then
                    '請求書番号を分解
                    strCloseDate = Mid(vntBillNo, 1, 4) & "/" & Mid(vntBillNo, 5, 2) & "/" & Mid(vntBillNo, 7, 2)
                    lngBillSeq = CLng(Mid(vntBillNo, 9, 5))
                    lngBranchNo = CLng(Mid(vntBillNo, 14, 1))
                End If
            End If
        End If
    End If
    
    
'    'キー値の設定
'    Set objOraParam = mobjOraDb.Parameters
'
'    objOraParam.Add "CLOSEDATE", CDate(strCloseDate), ORAPARM_INPUT, ORATYPE_DATE
'    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
'    objOraParam.Add "LINENO", vntLineNo, ORAPARM_INPUT, ORATYPE_NUMBER
'
'    '削除する明細の作成方法を取得
'    strStmt = "SELECT " & vbLf & _
'                    "METHOD " & vbLf & _
'                    "FROM " & vbLf & _
'                    "BILLDETAIL " & vbLf
'
'    strStmt = strStmt & "WHERE " & vbLf & _
'                        "BILLDETAIL.CLOSEDATE = :CLOSEDATE " & vbLf & _
'                        "AND BILLDETAIL.BILLSEQ = :BILLSEQ " & vbLf & _
'                        "AND BILLDETAIL.BRANCHNO = :BRANCHNO " & vbLf & _
'                        "AND BILLDETAIL.LINENO=:LINENO " & vbLf
'
'    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
'
'    '検索レコードが存在する場合
'    If Not objOraDyna.EOF Then
'        'オブジェクトの参照設定
'        Set objFields = objOraDyna.Fields
'        Set objMethod = objFields("METHOD")
'        strMethod = objMethod.Value
'    End If
'    objOraDyna.Close
'    Set objOraDyna = Nothing
'
'    Do Until objOraParam.Count <= 0
'        objOraParam.Remove (objOraParam.Count - 1)
'    Loop
'    Set objOraParam = Nothing
'
'    '該当する明細がない場合は終了
'    If strMethod = "" Then
'        DeleteBillDetail = True
'        Exit Function
'    End If


    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    
    objOraParam.Add "CLOSEDATE", CDate(strCloseDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "LINENO", vntLineNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '該当キーの請求書明細を削除
    strStmt = "DELETE FROM BILLDETAIL " & vbLf & _
              "WHERE " & vbLf & _
              "CLOSEDATE = :CLOSEDATE " & vbLf & _
              "AND BILLSEQ = :BILLSEQ " & vbLf & _
              "AND BRANCHNO = :BRANCHNO " & vbLf & _
              "AND LINENO = :LINENO " & vbLf
    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing
    
    If Not IsNull(vntRsvNo) And vntRsvNo <> "" Then
        'キー値の設定
        Set objOraParam = mobjOraDb.Parameters
        
'        objOraParam.Add "CLOSEDATE", CDate(strCloseDate), ORAPARM_INPUT, ORATYPE_DATE
'        objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
'        objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
'        objOraParam.Add "RSVNO", vntRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
        
        objOraParam.Add "RSVNO", vntRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "ORGCD1", vntOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "ORGCD2", vntOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
        
        '削除した請求書明細と同一の予約番号を持つ明細を削除
        strStmt = "DELETE FROM BILLDETAIL " & vbLf & _
                  "WHERE " & vbLf & _
                  "(CLOSEDATE, BILLSEQ, BRANCHNO, RSVNO) IN( " & _
                  "SELECT CLOSEDATE, BILLSEQ, BRANCHNO, RSVNO " & vbLf & _
                  "FROM CLOSEMNG " & vbLf & _
                  "WHERE RSVNO = :RSVNO " & vbLf & _
                  "AND ORGCD1 = :ORGCD1 " & vbLf & _
                  "AND ORGCD2 = :ORGCD2) " & vbLf

'                  "WHERE " & vbLf & _
'                  "CLOSEDATE = :CLOSEDATE " & vbLf & _
'                  "AND BILLSEQ = :BILLSEQ " & vbLf & _
'                  "AND BRANCHNO = :BRANCHNO " & vbLf & _
'                  "AND RSVNO = :RSVNO " & vbLf
        
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
        
        Do Until objOraParam.Count <= 0
            objOraParam.Remove (objOraParam.Count - 1)
        Loop
        Set objOraParam = Nothing
        
        'キー値の設定
        Set objOraParam = mobjOraDb.Parameters
    
        objOraParam.Add "RSVNO", vntRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "ORGCD1", vntOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "ORGCD2", vntOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
        
        '該当キーの締め管理を削除
        strStmt = "DELETE FROM CLOSEMNG " & vbLf & _
                  "WHERE " & vbLf & _
                  "RSVNO = :RSVNO " & vbLf & _
                  "AND ORGCD1 = :ORGCD1 " & vbLf & _
                  "AND ORGCD2 = :ORGCD2 " & vbLf
    
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
        
        Do Until objOraParam.Count <= 0
            objOraParam.Remove (objOraParam.Count - 1)
        Loop
        Set objOraParam = Nothing
    
    
    End If
    
    '戻り値の設定
    DeleteBillDetail = True
    
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

    DeleteBillDetail = False

    'イベントログ書き込み
    WriteErrorLog "Demand.DeleteBillDetail"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'## 2004.05.24 Add Str Orb)T.Yaguchi 請求明細内訳の追加
'
' 機能　　 : 請求明細を更新する
'
' 引数　　 : (In)   vntBillNo               請求書番号
' 　　　　 : (In)   vntLineNo               明細No.
' 　　　　 : (In)   vntItemNo               内訳No.
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function DeleteBillDetail_Items(ByVal vntBillNo As Variant, _
                                       ByVal vntLineNo As Variant, _
                                       ByVal vntItemNo As Variant) As Boolean
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
   
    Dim strCloseDate            As String           '締め日
    Dim lngBillSeq              As Long             '請求書Seq
    Dim lngBranchNo             As Long             '請求書枝番

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
 
    '初期処理
    DeleteBillDetail_Items = False

    '検索条件が設定されていない場合はエラー
    If Not IsNumeric(vntBillNo) Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    If IsNull(vntLineNo) Or vntLineNo = "" Or _
       IsNull(vntItemNo) Or vntItemNo = "" Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If

    '請求書番号の妥当性チェック
    If IsMissing(vntBillNo) = False Then
        vntBillNo = Trim(vntBillNo)
        If IsNumeric(vntBillNo) = True Then
            If CDbl(vntBillNo) > 0 Then
                If (Len(vntBillNo) = LENGTH_BILLNO) Then
                    '請求書番号を分解
                    strCloseDate = Mid(vntBillNo, 1, 4) & "/" & Mid(vntBillNo, 5, 2) & "/" & Mid(vntBillNo, 7, 2)
                    lngBillSeq = CLng(Mid(vntBillNo, 9, 5))
                    lngBranchNo = CLng(Mid(vntBillNo, 14, 1))
                End If
            End If
        End If
    End If

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters

    objOraParam.Add "CLOSEDATE", CDate(strCloseDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "LINENO", vntLineNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ITEMNO", vntItemNo, ORAPARM_INPUT, ORATYPE_NUMBER

    '該当キーの請求書明細を削除
    strStmt = "DELETE FROM BILLDETAIL_ITEMS " & vbLf & _
              "WHERE " & vbLf & _
              "CLOSEDATE = :CLOSEDATE " & vbLf & _
              "AND BILLSEQ = :BILLSEQ " & vbLf & _
              "AND BRANCHNO = :BRANCHNO " & vbLf & _
              "AND LINENO = :LINENO " & vbLf & _
              "AND ITEMNO = :ITEMNO " & vbLf

    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing

    '戻り値の設定
    DeleteBillDetail_Items = True

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

    DeleteBillDetail_Items = False

    'イベントログ書き込み
    WriteErrorLog "Demand.DeleteBillDetail_Items"

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function


'## 2004.01.17 Modified Function by Shiramizu@CS 聖路加病院殿向けに、メソッドそのものを完全再作成
'
' 機能　　 : 請求書一括削除
'
' 引数　　 : (In)   vntCloseDate        請求締め日
' 　　　　 : (In)   vntOrgCd1           団体コード１
' 　　　　 : (In)   vntOrgCd1           団体コード２
'
' 戻り値　 : 削除件数（マイナスはエラー）
'
' 備考　　 : パラメタの指定状態によって、削除テーブルをハンドリング
'
Public Function DeleteAllBill(ByVal vntCloseDate As Date, _
                              Optional ByVal vntOrgCd1 As Variant, _
                              Optional ByVal vntOrgCd2 As Variant) As Long
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    Dim lngDeleteCount          As Long             '削除件数
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    DeleteAllBill = -1
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CLOSEDATE", CDate(vntCloseDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "ORGCD1", vntOrgCd1, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ORGCD2", vntOrgCd2, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    '戻り値の設定
    objOraParam.Add "RET", 0, ORAPARM_OUTPUT, ORATYPE_NUMBER
    
    '該当キーの請求書明細を削除
    strStmt = "BEGIN DELETE_BILL_FETCH(:CLOSEDATE, :ORGCD1, :ORGCD2, :RET); END;"
    
     'PL/SQL文の実行
    mobjOraDb.ExecuteSQL strStmt

    '戻り値の取得
    lngDeleteCount = objOraParam("RET").Value
    
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing
    
    '戻り値の設定
    DeleteAllBill = lngDeleteCount
    
    'トランザクションをコミット
    If lngDeleteCount > 0 Then
        mobjContext.SetComplete
    Else
        mobjContext.SetAbort
    End If
'    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.DeleteAllBill"
    
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

'## 2003.01.02 Modified Function by ishihara@FSIT 東急殿向け締め処理に合致するよう、メソッドそのものを完全再作成
'
' 機能　　 : 検索条件を満たす請求書団体管理情報を取得する
'
' 引数　　 : (In)   lngBillNo         請求書番号
' 　　　　 : (In)   lngSeq            SEQ
' 　　　　 : (Out)  vntCslOrgCd1      受診団体コード１
' 　　　　 : (Out)  vntCslOrgCd2      受診団体コード２
' 　　　　 : (Out)  vntCslOrgName     受診団体名称
' 　　　　 : (Out)  vntIsrSign        健保記号
' 　　　　 : (Out)  vntIsrSignName    健保記号からの団体名
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function SelectDmdBurdenModifyBillOrg(ByVal lngBillNo As Long, _
                                             ByVal lngSeq As Long, _
                                             Optional ByRef vntCslOrgCd1 As Variant, _
                                             Optional ByRef vntCslOrgCd2 As Variant, _
                                             Optional ByRef vntCslOrgName As Variant, _
                                             Optional ByRef vntIsrSign As Variant, _
                                             Optional ByRef vntIsrSignName As Variant _
                                            ) As Boolean
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objCslOrgCd1            As OraField         '受診団体コード１
    Dim objCslOrgCd2            As OraField         '受診団体コード２
    Dim objCslOrgName           As OraField         '受診団体名称
    Dim objIsrSign              As OraField         '健保記号
    Dim objIsrSignName          As OraField         '健保記号からの団体名

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    SelectDmdBurdenModifyBillOrg = False
    
    '検索条件が設定されていない場合はエラー
    If lngBillNo = 0 Or lngSeq = 0 Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "BILLNO", CStr(lngBillNo), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SEQ", CStr(lngSeq), ORAPARM_INPUT, ORATYPE_NUMBER
    
    '検索条件を満たす請求書団体管理情報のレコードを取得
'### 2003.03.23 Updated by Ishihara@FSIT 健保記号からの名称索引方法変更
'    strStmt = "SELECT BILL_ORG.CSLORGCD1, BILL_ORG.CSLORGCD2,      " & vbLf & _
              "       ORG.ORGNAME,                                 " & vbLf & _
              "       BILL_ORG.ISRSIGN, ISRORG.ORGNAME ISRSIGNNAME " & vbLf & _
              "  FROM ORG ISRORG, ORG, BILL_ORG                    " & vbLf & _
              " WHERE BILL_ORG.BILLNO  = :BILLNO                   " & vbLf & _
              "   AND BILL_ORG.SEQ     = :SEQ                      " & vbLf & _
              "   AND ORG.ORGCD1       = BILL_ORG.CSLORGCD1        " & vbLf & _
              "   AND ORG.ORGCD2       = BILL_ORG.CSLORGCD2        " & vbLf & _
              "   AND BILL_ORG.ISRSIGN = ISRORG.ISRSIGN(+)         " & vbLf & _
              "   AND '00' = ISRORG.ORGCD2(+) "
    strStmt = "SELECT BILL_ORG.CSLORGCD1, BILL_ORG.CSLORGCD2,      " & vbLf & _
              "       ORG.ORGNAME,        BILL_ORG.ISRSIGN,        " & vbLf & _
              "       BILL_ORG.ISRSIGN,                            " & vbLf & _
              "        ( SELECT DISTINCT ORGSNAME FROM ORG         " & vbLf & _
              "           WHERE ORG.ISRSIGN    = BILL_ORG.ISRSIGN  " & vbLf & _
              "             AND ORG.ISRGETNAME = 1                 " & vbLf & _
              "             AND ROWNUM         = 1 ) ISRSIGNNAME   " & vbLf & _
              "  FROM ORG, BILL_ORG                                " & vbLf & _
              " WHERE BILL_ORG.BILLNO  = :BILLNO                   " & vbLf & _
              "   AND BILL_ORG.SEQ     = :SEQ                      " & vbLf & _
              "   AND ORG.ORGCD1       = BILL_ORG.CSLORGCD1        " & vbLf & _
              "   AND ORG.ORGCD2       = BILL_ORG.CSLORGCD2        " & vbLf
'### 2003.03.23 Updated End
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCslOrgCd1 = objFields("CSLORGCD1")
        Set objCslOrgCd2 = objFields("CSLORGCD2")
        Set objCslOrgName = objFields("ORGNAME")
        Set objIsrSign = objFields("ISRSIGN")
        Set objIsrSignName = objFields("ISRSIGNNAME")
    
        '戻り値の設定
        If IsMissing(vntCslOrgCd1) = False Then vntCslOrgCd1 = objCslOrgCd1.Value & ""
        If IsMissing(vntCslOrgCd2) = False Then vntCslOrgCd2 = objCslOrgCd2.Value & ""
        If IsMissing(vntCslOrgName) = False Then vntCslOrgName = objCslOrgName.Value & ""
        If IsMissing(vntIsrSign) = False Then vntIsrSign = objIsrSign.Value & ""
        If IsMissing(vntIsrSignName) = False Then vntIsrSignName = objIsrSignName.Value & ""
        
        SelectDmdBurdenModifyBillOrg = True
    
    End If
    
    Set objOraDyna = Nothing
    
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.SelectDmdBurdenModifyBillOrg"
    
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

'## 2003.01.02 Modified Function by ishihara@FSIT メソッド新規作成
'
' 機能　　 : 検索条件を満たす請求書団体別コース管理情報を取得する
'
' 引数　　 : (In)   lngBillNo         請求書番号
' 　　　　 : (In)   lngSeq            SEQ
' 　　　　 : (In)   lngCsSeq          コースSEQ
' 　　　　 : (Out)  vntCsCd           コースコード
' 　　　　 : (Out)  vntCsName         コース名称
' 　　　　 : (Out)  vntStrDate        開始受診日
' 　　　　 : (Out)  vntEndDate　　　　終了受診日
' 　　　　 : (Out)  vntcslCnt　　　　 受診人数
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function SelectDmdBurdenModifyBillCourse(ByVal lngBillNo As Long, _
                                                ByVal lngSeq As Long, _
                                                ByVal lngCsSeq As Long, _
                                                Optional ByRef vntCsCd As Variant, _
                                                Optional ByRef vntCsName As Variant, _
                                                Optional ByRef vntStrDate As Variant, _
                                                Optional ByRef vntEndDate As Variant, _
                                                Optional ByRef vntCslCnt As Variant _
                                                ) As Boolean
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objCsCd                 As OraField         'コースコード
    Dim objCsName               As OraField         'コース名称
    Dim objStrDate              As OraField         '開始受診日
    Dim objEndDate              As OraField         '終了受診日
    Dim objCslCnt               As OraField         '受診人数

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    SelectDmdBurdenModifyBillCourse = False
    
    '検索条件が設定されていない場合はエラー
    If lngBillNo = 0 Or lngSeq = 0 Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "BILLNO", CStr(lngBillNo), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SEQ", CStr(lngSeq), ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CSSEQ", CStr(lngCsSeq), ORAPARM_INPUT, ORATYPE_NUMBER
    
    '検索条件を満たす請求書団体管理情報のレコードを取得
    strStmt = "SELECT BILL_COURSE.CSCD,    COURSE_P.CSNAME,     " & vbLf & _
              "       BILL_COURSE.STRDATE, BILL_COURSE.ENDDATE, " & vbLf & _
              "       BILL_COURSE.CSLCNT                        " & vbLf & _
              "  FROM COURSE_P, BILL_COURSE                     " & vbLf & _
              " WHERE BILL_COURSE.BILLNO  = :BILLNO             " & vbLf & _
              "   AND BILL_COURSE.SEQ     = :SEQ                " & vbLf & _
              "   AND BILL_COURSE.CSSEQ   = :CSSEQ              " & vbLf & _
              "   AND BILL_COURSE.CSCD    = COURSE_P.CSCD(+)    "
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCsCd = objFields("CSCD")
        Set objCsName = objFields("CSNAME")
        Set objStrDate = objFields("STRDATE")
        Set objEndDate = objFields("ENDDATE")
        Set objCslCnt = objFields("CSLCNT")
    
        '戻り値の設定
        If IsMissing(vntCsCd) = False Then vntCsCd = objCsCd.Value & ""
        If IsMissing(vntCsName) = False Then vntCsName = objCsName.Value & ""
        If IsMissing(vntStrDate) = False Then vntStrDate = objStrDate.Value & ""
        If IsMissing(vntEndDate) = False Then vntEndDate = objEndDate.Value & ""
        If IsMissing(vntCslCnt) = False Then vntCslCnt = objCslCnt.Value & ""
        
        SelectDmdBurdenModifyBillCourse = True
    
    End If
    
    Set objOraDyna = Nothing
    
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.SelectDmdBurdenModifyBillCourse"
    
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


'## 2004.01.15 Modified Function by Shiramizu@CS 聖路加病院殿向けにメソッドを新規作成
'
' 機能　　 : 検索条件を満たす入金、発送件数を取得する
'
' 引数　　 : (In)   vntIn_BillNo            請求書番号
' 　　　　 : (Out)  vntPaymentCnt           入金件数
' 　　　　 : (Out)  vntDispatchCnt          発送件数
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectPaymentAndDispatchCnt(ByVal vntIn_BillNo As Variant, _
                                            Optional ByRef vntPaymentCnt As Variant, _
                                            Optional ByRef vntDispatchCnt As Variant) As Long

    
    Dim objOraParam                 As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna                  As OraDynaset       'ダイナセット
    Dim strStmt                     As String           'SQLステートメント
    
    Dim objFields                   As OraFields        'フィールドオブジェクト
    
    Dim objPaymentCnt               As OraField         '入金件数
    Dim objDispatchCnt              As OraField         '発送件数
    
    Dim lngCount                    As Long             'レコード数
    
    Dim vntArrPaymentCnt()          As Variant          '入金件数
    Dim vntArrDispatchCnt()         As Variant          '発送方法
    Dim blnIsBillNo             As Boolean          '請求書番号指定判定
    Dim strCloseDate            As String           '締め日
    Dim lngBillSeq              As Long             '請求書Seq
    Dim lngBranchNo             As Long             '請求書枝番

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    SelectPaymentAndDispatchCnt = False
    lngCount = 0
    blnIsBillNo = False
    
    '請求書番号の妥当性チェック
    If IsMissing(vntIn_BillNo) = False Then
        vntIn_BillNo = Trim(vntIn_BillNo)
        
        If IsNumeric(vntIn_BillNo) = True Then
            If CDbl(vntIn_BillNo) > 0 Then
                If (Len(vntIn_BillNo) = LENGTH_BILLNO) Then
                    '請求書番号を分解
                    strCloseDate = Mid(vntIn_BillNo, 1, 4) & "/" & Mid(vntIn_BillNo, 5, 2) & "/" & Mid(vntIn_BillNo, 7, 2)
                    lngBillSeq = CLng(Mid(vntIn_BillNo, 9, 5))
                    lngBranchNo = CLng(Mid(vntIn_BillNo, 14, 1))
                    If IsDate(strCloseDate) Then
                        blnIsBillNo = True
                    End If
                End If
            End If
        End If
    End If
    
    '請求書番号が正しく指定されていない場合はエラー
    If blnIsBillNo = False Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    
    '請求書番号が指定されている
    If blnIsBillNo = True Then
        objOraParam.Add "CLOSEDATE", CDate(strCloseDate), ORAPARM_INPUT, ORATYPE_DATE
        objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    End If

    strStmt = "SELECT " & vbLf & _
              "PAYMENT_VIEW.CNT AS PAYMENT_CNT, " & vbLf & _
              "DISPATCH_VIEW.CNT AS DISPATCH_CNT " & vbLf & _
              "FROM " & vbLf & _
              "(SELECT COUNT(*) AS CNT " & vbLf & _
              "FROM PAYMENT " & vbLf & _
              "WHERE " & vbLf & _
              "CLOSEDATE = :CLOSEDATE " & vbLf & _
              "AND BILLSEQ = :BILLSEQ " & vbLf & _
              "AND BRANCHNO = :BRANCHNO ) PAYMENT_VIEW, " & vbLf & _
              "(SELECT COUNT(*) AS CNT " & vbLf & _
              "FROM DISPATCH " & vbLf & _
              "WHERE " & vbLf & _
              "CLOSEDATE = :CLOSEDATE " & vbLf & _
              "AND BILLSEQ = :BILLSEQ " & vbLf & _
              "AND BRANCHNO = :BRANCHNO ) DISPATCH_VIEW " & vbLf

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        
        Set objPaymentCnt = objFields("PAYMENT_CNT")
        Set objDispatchCnt = objFields("DISPATCH_CNT")
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrPaymentCnt(lngCount)
            ReDim Preserve vntArrDispatchCnt(lngCount)
            
            vntArrPaymentCnt(lngCount) = objPaymentCnt.Value & ""
            vntArrDispatchCnt(lngCount) = objDispatchCnt.Value & ""
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
        
    End If
    
    '戻り値の設定
    If IsMissing(vntPaymentCnt) = False Then vntPaymentCnt = vntArrPaymentCnt
    If IsMissing(vntDispatchCnt) = False Then vntDispatchCnt = vntArrDispatchCnt

    SelectPaymentAndDispatchCnt = lngCount
    
    Set objOraDyna = Nothing
    
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.SelectPaymentAndDispatchCnt"
    WriteErrorLog "ErrNo:" & Err.Number & ":" & Err.Description & ":" & Err.Source
    
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

'## 2004.01.15 Modified Function by Shiramizu@CS 聖路加病院殿向けにメソッドそのものを完全再作成
'
' 機能　　 : 検索条件を満たす請求明細情報を取得する
'
' 引数　　 : (In)   vntIn_BillNo            請求書番号
' 　　　　 : (In)   vntIn_LineNo            明細No
' 　　　　 : (In)   vntStartPos             開始位置
' 　　　　 : (In)   vntGetCount             取得件数
' 　　　　 : (Out)  vntBillNo               請求書番号
' 　　　　 : (Out)  vntLineNo               明細No
' 　　　　 : (Out)  vntCloseDate            締め日
' 　　　　 : (Out)  vntBillSeq              請求書Seq
' 　　　　 : (Out)  vntBranchno             請求書枝番
' 　　　　 : (Out)  vntDayId                当日ID
' 　　　　 : (Out)  vntRsvNo                予約番号
' 　　　　 : (Out)  vntCslDate              受診日
' 　　　　 : (Out)  vntDetailName           名称
' 　　　　 : (Out)  vntPerId                個人ID
' 　　　　 : (Out)  vntLastName             姓
' 　　　　 : (Out)  vntFirstName            名
' 　　　　 : (Out)  vntLastKName            カナ姓
' 　　　　 : (Out)  vntFirstKName           カナ名
' 　　　　 : (Out)  vntPrice                金額
' 　　　　 : (Out)  vntEditPrice            調整金額
' 　　　　 : (Out)  vntTaxPrice             税額
' 　　　　 : (Out)  vntEditTax              調整税額
' 　　　　 : (Out)  vntOrgName              団体名
' 　　　　 : (Out)  vntOrgKName             団体カナ名
' 　　　　 : (Out)  vntMethod               作成方法
'## 2004.06.02 ADD STR ORB)T.YAGUCHI 項目追加
' 　　　　 : (Out)  vntSecondFlg            ２次検査フラグ
'## 2004.06.02 ADD END
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
'## 2004.06.02 MOD STR ORB)T.YAGUCHI 項目追加
'Public Function SelectDmdBurdenBillDetail(ByVal vntIn_BillNo As Variant,
'                                                Optional ByVal vntIn_LineNo As Variant, Optional ByVal vntStartPos As Variant,
'                                                Optional ByVal vntGetCount As Variant, Optional ByRef vntBillNo As Variant,
'                                                Optional ByRef vntLineNo As Variant, Optional ByRef vntCloseDate As Variant,
'                                                Optional ByRef vntBillSeq As Variant, Optional ByRef vntBranchNo As Variant,
'                                                Optional ByRef vntDayId As Variant, Optional ByRef vntRsvNo As Variant, Optional ByRef vntCslDate As Variant,
'                                                Optional ByRef vntDetailName As Variant, Optional ByRef vntPerId As Variant,
'                                                Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant,
'                                                Optional ByRef vntLastKName As Variant, Optional ByRef vntFirstKName As Variant,
'                                                Optional ByRef vntPrice As Variant, Optional ByRef vntEditPrice As Variant,
'                                                Optional ByRef vntTaxPrice As Variant, Optional ByRef vntEditTax As Variant,
'                                                Optional ByRef vntOrgName As Variant, Optional ByRef vntOrgKName As Variant,
'                                                Optional ByRef vntMethod As Variant) As Long
Public Function SelectDmdBurdenBillDetail(ByVal vntIn_BillNo As Variant, _
                                                Optional ByVal vntIn_LineNo As Variant, Optional ByVal vntStartPos As Variant, _
                                                Optional ByVal vntGetCount As Variant, Optional ByRef vntBillNo As Variant, _
                                                Optional ByRef vntLineNo As Variant, Optional ByRef vntCloseDate As Variant, _
                                                Optional ByRef vntBillSeq As Variant, Optional ByRef vntBranchNo As Variant, _
                                                Optional ByRef vntDayId As Variant, Optional ByRef vntRsvNo As Variant, Optional ByRef vntCslDate As Variant, _
                                                Optional ByRef vntDetailName As Variant, Optional ByRef vntPerId As Variant, _
                                                Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant, _
                                                Optional ByRef vntLastKName As Variant, Optional ByRef vntFirstKName As Variant, _
                                                Optional ByRef vntPrice As Variant, Optional ByRef vntEditPrice As Variant, _
                                                Optional ByRef vntTaxPrice As Variant, Optional ByRef vntEditTax As Variant, _
                                                Optional ByRef vntOrgName As Variant, Optional ByRef vntOrgKName As Variant, _
                                                Optional ByRef vntMethod As Variant, Optional ByRef vntSecondFlg As Variant) As Long
'## 2004.06.02 MOD END

    Dim objOraParam                 As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna                  As OraDynaset       'ダイナセット
    Dim strStmt                     As String           'SQLステートメント

    Dim objFields                   As OraFields        'フィールドオブジェクト

    Dim objBillNo                   As OraField         '請求書番号
    Dim objLineNo                   As OraField         '明細Ｎｏ
    Dim objCloseDate                As OraField         '締め日
    Dim objBillSeq                  As OraField         '請求書Seq
    Dim objBranchNo                 As OraField         '請求書枝番
    Dim objDayId                    As OraField         '当日ID
    Dim objRsvNo                    As OraField         '予約番号
    Dim objCslDate                  As OraField         '受診日
    Dim objDetailName               As OraField         '名称
    Dim objPerId                    As OraField         '個人ID
    Dim objLastName                 As OraField         '姓
    Dim objFirstName                As OraField         '名
    Dim objLastKName                As OraField         'カナ姓
    Dim objFirstKName               As OraField         'カナ名
    Dim objPrice                    As OraField         '金額
    Dim objEditPrice                As OraField         '調整金額
    Dim objTaxPrice                 As OraField         '税額
    Dim objEditTax                  As OraField         '調整税額
    Dim objOrgName                  As OraField         '団体名
    Dim objOrgKName                 As OraField         '団体カナ名
    Dim objMethod                   As OraField         '作成方法
'## 2004.06.02 ADD STR ORB)T.YAGUCHI 項目追加
    Dim objSecondFlg                As OraField         '２次検査フラグ
'## 2004.06.02 ADD END
'    Dim objPaymentCnt               As OraField         '入金件数
'    Dim objDispatchCnt              As OraField         '発送件数
    
    Dim lngCount                    As Long             'レコード数
    
    Dim vntArrBillNo()              As Variant          '請求書番号
    Dim vntArrLineNo()              As Variant          '明細Ｎｏ
    Dim vntArrCloseDate()           As Variant          '締め日
    Dim vntArrBillSeq()             As Variant          '請求書Seq
    Dim vntArrBranchNo()            As Variant          '請求書枝番
    Dim vntArrDayId()               As Variant          '当日ID
    Dim vntArrRsvNo()               As Variant          '予約番号
    Dim vntArrCslDate()             As Variant          '受診日
    Dim vntArrDetailName()          As Variant          '名称
    Dim vntArrPerId()               As Variant          '個人ID
    Dim vntArrLastName()            As Variant          '姓
    Dim vntArrFirstName()           As Variant          '名
    Dim vntArrLastKName()           As Variant          'カナ姓
    Dim vntArrFirstKName()          As Variant          'カナ名
    Dim vntArrPrice()               As Variant          '金額
    Dim vntArrEditPrice()           As Variant          '調整金額
    Dim vntArrTaxPrice()            As Variant          '税額
    Dim vntArrEditTax()             As Variant          '調整税額
    Dim vntArrOrgName()             As Variant          '団体名
    Dim vntArrOrgKName()            As Variant          '団体カナ名
    Dim vntArrMethod()              As Variant          '作成方法
'## 2004.06.02 ADD STR ORB)T.YAGUCHI 項目追加
    Dim vntArrSecondFlg()           As Variant          '２次検査フラグ
'## 2004.06.02 ADD END

    Dim strCloseDate            As String           '締め日
    Dim lngBillSeq              As Long             '請求書Seq
    Dim lngBranchNo             As Long             '請求書枝番
    
    Dim blnIsBillNo                 As Boolean          'パラメタに請求書番号が指定されている
    Dim blnIsLineNo                 As Boolean          'パラメタに明細NOが指定されている
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    SelectDmdBurdenBillDetail = False
    lngCount = 0
    blnIsBillNo = False
    blnIsLineNo = False
    
    '請求書番号の妥当性チェック
    If IsMissing(vntIn_BillNo) = False Then
        vntIn_BillNo = Trim(vntIn_BillNo)
        
        If IsNumeric(vntIn_BillNo) = True Then
            If CDbl(vntIn_BillNo) > 0 Then
                If (Len(vntIn_BillNo) = LENGTH_BILLNO) Then
                    '請求書番号を分解
                    strCloseDate = Mid(vntIn_BillNo, 1, 4) & "/" & Mid(vntIn_BillNo, 5, 2) & "/" & Mid(vntIn_BillNo, 7, 2)
                    lngBillSeq = CLng(Mid(vntIn_BillNo, 9, 5))
                    lngBranchNo = CLng(Mid(vntIn_BillNo, 14, 1))
                    If IsDate(strCloseDate) Then
                        blnIsBillNo = True
                    End If
                End If
            End If
        End If
    End If
    
    '請求書番号が正しく指定されていない場合はエラー
    If blnIsBillNo = False Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    
    '請求書番号が指定されている
    If blnIsBillNo = True Then
        objOraParam.Add "CLOSEDATE", CDate(strCloseDate), ORAPARM_INPUT, ORATYPE_DATE
        objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    End If

    
'    明細Noが指定されている
    If IsMissing(vntIn_LineNo) = False Then
        If IsNumeric(vntIn_LineNo) Then
            objOraParam.Add "LINENO", vntIn_LineNo, ORAPARM_INPUT, ORATYPE_NUMBER
            blnIsLineNo = True
        End If
    End If

    '取得件数と開始位置が設定されている場合
    If IsNumeric(vntStartPos) And IsNumeric(vntGetCount) Then
        objOraParam.Add "SEQ_F", CLng(vntStartPos), ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "SEQ_T", (CLng(vntStartPos) + CLng(vntGetCount) - 1), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    
    'ROWNUMにより範囲指定するため、全体をVIEWにする
    strStmt = "SELECT " & vbLf & _
                        "MAIN_VIEW.* " & vbLf & _
                        "FROM " & vbLf

'## 2004.06.02 MOD STR ORB)T.YAGUCHI 項目追加
'    '基本部分
'    strStmt = strStmt & "( " & vbLf & _
'                        "SELECT " & vbLf & _
'                        "ROWNUM AS ROWSEQ, " & vbLf & _
'                        "TO_CHAR(BILLDETAIL.CLOSEDATE,'YYYY/MM/DD') AS CLOSEDATE, " & vbLf & _
'                        "BILLDETAIL.BILLSEQ, BILLDETAIL.BRANCHNO, " & vbLf & _
'                        "TO_CHAR(BILLDETAIL.CLOSEDATE,'YYYYMMDD') || " & vbLf & _
'                        "TRIM(TO_CHAR(BILLDETAIL.BILLSEQ,'00000')) || " & vbLf & _
'                        "TO_CHAR(BILLDETAIL.BRANCHNO) AS BILLNO, " & vbLf & _
'                        "BILLDETAIL.LINENO, BILLDETAIL.DAYID, BILLDETAIL.RSVNO, " & vbLf & _
'                        "TO_CHAR(BILLDETAIL.CSLDATE,'YYYY/MM/DD') AS CSLDATE, " & vbLf & _
'                        "BILLDETAIL.DETAILNAME, BILLDETAIL.PERID, " & vbLf & _
'                        "BILLDETAIL.LASTNAME, BILLDETAIL.FIRSTNAME, " & vbLf & _
'                        "BILLDETAIL.LASTKNAME, BILLDETAIL.FIRSTKNAME, " & vbLf & _
'                        "BILLDETAIL.PRICE, BILLDETAIL.EDITPRICE, " & vbLf & _
'                        "BILLDETAIL.TAXPRICE, BILLDETAIL.EDITTAX, " & vbLf & _
'                        "ORG.ORGNAME, ORG.ORGKNAME, BILLDETAIL.METHOD " & vbLf & _
'                        "FROM " & vbLf & _
'                        "BILLDETAIL, " & vbLf & _
'                        "ORG, " & vbLf & _
'                        "BILL " & vbLf
    '基本部分
    strStmt = strStmt & "( " & vbLf & _
                        "SELECT " & vbLf & _
                        "ROWNUM AS ROWSEQ, " & vbLf & _
                        "TO_CHAR(BILLDETAIL.CLOSEDATE,'YYYY/MM/DD') AS CLOSEDATE, " & vbLf & _
                        "BILLDETAIL.BILLSEQ, BILLDETAIL.BRANCHNO, " & vbLf & _
                        "TO_CHAR(BILLDETAIL.CLOSEDATE,'YYYYMMDD') || " & vbLf & _
                        "TRIM(TO_CHAR(BILLDETAIL.BILLSEQ,'00000')) || " & vbLf & _
                        "TO_CHAR(BILLDETAIL.BRANCHNO) AS BILLNO, " & vbLf & _
                        "BILLDETAIL.LINENO, BILLDETAIL.DAYID, BILLDETAIL.RSVNO, " & vbLf & _
                        "TO_CHAR(BILLDETAIL.CSLDATE,'YYYY/MM/DD') AS CSLDATE, " & vbLf & _
                        "BILLDETAIL.DETAILNAME, BILLDETAIL.PERID, " & vbLf & _
                        "BILLDETAIL.LASTNAME, BILLDETAIL.FIRSTNAME, " & vbLf & _
                        "BILLDETAIL.LASTKNAME, BILLDETAIL.FIRSTKNAME, " & vbLf & _
                        "BILLDETAIL.PRICE, BILLDETAIL.EDITPRICE, " & vbLf & _
                        "BILLDETAIL.TAXPRICE, BILLDETAIL.EDITTAX, " & vbLf & _
                        "ORG.ORGNAME, ORG.ORGKNAME, BILLDETAIL.METHOD ,BILL.SECONDFLG " & vbLf & _
                        "FROM " & vbLf & _
                        "BILLDETAIL, " & vbLf & _
                        "ORG, " & vbLf & _
                        "BILL " & vbLf
'## 2004.06.02 MOD END

    If blnIsBillNo = True Then
        strStmt = strStmt & "WHERE " & vbLf & _
                            "BILLDETAIL.CLOSEDATE = :CLOSEDATE " & vbLf & _
                            "AND BILLDETAIL.BILLSEQ = :BILLSEQ " & vbLf & _
                            "AND BILLDETAIL.BRANCHNO = :BRANCHNO " & vbLf
    End If

    If blnIsLineNo = True Then
        strStmt = strStmt & "AND BILLDETAIL.LINENO=:LINENO " & vbLf
    End If
    
    strStmt = strStmt & "AND BILLDETAIL.CLOSEDATE=BILL.CLOSEDATE " & vbLf & _
                        "AND BILLDETAIL.BILLSEQ=BILL.BILLSEQ " & vbLf & _
                        "AND BILLDETAIL.BRANCHNO=BILL.BRANCHNO " & vbLf & _
                        "AND BILL.ORGCD1=ORG.ORGCD1 " & vbLf & _
                        "AND BILL.ORGCD2=ORG.ORGCD2 " & vbLf
    
    strStmt = strStmt & ") MAIN_VIEW " & vbLf

    '取得件数と開始位置が設定されている場合
    If (IsMissing(vntStartPos) = False) And (IsMissing(vntGetCount) = False) Then
        If IsNumeric(vntStartPos) And IsNumeric(vntGetCount) And _
           Trim(vntStartPos) <> "" And Trim(vntGetCount) <> "" Then
                strStmt = strStmt & vbLf & _
                          " WHERE MAIN_VIEW.ROWSEQ BETWEEN :SEQ_F AND :SEQ_T" & vbLf
        End If
    End If

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)


    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        
        Set objCloseDate = objFields("CLOSEDATE")
        Set objBillSeq = objFields("BILLSEQ")
        Set objBranchNo = objFields("BRANCHNO")
        Set objBillNo = objFields("BILLNO")
        Set objLineNo = objFields("LINENO")
        Set objDayId = objFields("DAYID")
        Set objRsvNo = objFields("RSVNO")
        Set objCslDate = objFields("CSLDATE")
        Set objDetailName = objFields("DETAILNAME")
        Set objPerId = objFields("PERID")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastKName = objFields("LASTKNAME")
        Set objFirstKName = objFields("FIRSTKNAME")
        Set objPrice = objFields("PRICE")
        Set objEditPrice = objFields("EDITPRICE")
        Set objTaxPrice = objFields("TAXPRICE")
        Set objEditTax = objFields("EDITTAX")
        Set objOrgName = objFields("ORGNAME")
        Set objOrgKName = objFields("ORGKNAME")
        Set objMethod = objFields("METHOD")
'## 2004.06.02 ADD STR ORB)T.YAGUCHI 項目追加
        Set objSecondFlg = objFields("SECONDFLG")
'## 2004.06.02 ADD END

        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrCloseDate(lngCount)
            ReDim Preserve vntArrBillSeq(lngCount)
            ReDim Preserve vntArrBranchNo(lngCount)
            ReDim Preserve vntArrBillNo(lngCount)
            ReDim Preserve vntArrLineNo(lngCount)
            ReDim Preserve vntArrDayId(lngCount)
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrCslDate(lngCount)
            ReDim Preserve vntArrDetailName(lngCount)
            ReDim Preserve vntArrLastName(lngCount)
            ReDim Preserve vntArrFirstName(lngCount)
            ReDim Preserve vntArrLastKName(lngCount)
            ReDim Preserve vntArrFirstKName(lngCount)
            ReDim Preserve vntArrPerId(lngCount)
            ReDim Preserve vntArrPrice(lngCount)
            ReDim Preserve vntArrEditPrice(lngCount)
            ReDim Preserve vntArrTaxPrice(lngCount)
            ReDim Preserve vntArrEditTax(lngCount)
            ReDim Preserve vntArrOrgName(lngCount)
            ReDim Preserve vntArrOrgKName(lngCount)
            ReDim Preserve vntArrMethod(lngCount)
'## 2004.06.02 ADD STR ORB)T.YAGUCHI 項目追加
            ReDim Preserve vntArrSecondFlg(lngCount)
'## 2004.06.02 ADD END

            vntArrCloseDate(lngCount) = objCloseDate.Value & ""
            vntArrBillSeq(lngCount) = objBillSeq.Value & ""
            vntArrBranchNo(lngCount) = objBranchNo.Value & ""
            vntArrBillNo(lngCount) = objBillNo.Value & ""
            vntArrLineNo(lngCount) = objLineNo.Value & ""
            vntArrDayId(lngCount) = objDayId.Value & ""
            vntArrRsvNo(lngCount) = objRsvNo.Value & ""
            vntArrCslDate(lngCount) = objCslDate.Value & ""
            vntArrDetailName(lngCount) = objDetailName.Value & ""
            vntArrLastName(lngCount) = objLastName.Value & ""
            vntArrFirstName(lngCount) = objFirstName.Value & ""
            vntArrLastKName(lngCount) = objLastKName.Value & ""
            vntArrFirstKName(lngCount) = objFirstKName.Value & ""
            vntArrPerId(lngCount) = objPerId.Value & ""
            vntArrPrice(lngCount) = objPrice.Value & ""
            vntArrEditPrice(lngCount) = objEditPrice.Value & ""
            vntArrTaxPrice(lngCount) = objTaxPrice.Value & ""
            vntArrEditTax(lngCount) = objEditTax.Value & ""
            vntArrOrgName(lngCount) = objOrgName.Value & ""
            vntArrOrgKName(lngCount) = objOrgKName.Value & ""
            vntArrMethod(lngCount) = objMethod.Value & ""
'## 2004.06.02 ADD STR ORB)T.YAGUCHI 項目追加
            vntArrSecondFlg(lngCount) = objSecondFlg.Value & ""
'## 2004.06.02 ADD END

            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    End If
    
    '戻り値の設定
    If IsMissing(vntCloseDate) = False Then vntCloseDate = vntArrCloseDate
    If IsMissing(vntBillSeq) = False Then vntBillSeq = vntArrBillSeq
    If IsMissing(vntBranchNo) = False Then vntBranchNo = vntArrBranchNo
    If IsMissing(vntBillNo) = False Then vntBillNo = vntArrBillNo
    If IsMissing(vntLineNo) = False Then vntLineNo = vntArrLineNo
    If IsMissing(vntDayId) = False Then vntDayId = vntArrDayId
    If IsMissing(vntRsvNo) = False Then vntRsvNo = vntArrRsvNo
    If IsMissing(vntCslDate) = False Then vntCslDate = vntArrCslDate
    If IsMissing(vntDetailName) = False Then vntDetailName = vntArrDetailName
    If IsMissing(vntLastName) = False Then vntLastName = vntArrLastName
    If IsMissing(vntFirstName) = False Then vntFirstName = vntArrFirstName
    If IsMissing(vntLastKName) = False Then vntLastKName = vntArrLastKName
    If IsMissing(vntFirstKName) = False Then vntFirstKName = vntArrFirstKName
    If IsMissing(vntPerId) = False Then vntPerId = vntArrPerId
    If IsMissing(vntPrice) = False Then vntPrice = vntArrPrice
    If IsMissing(vntEditPrice) = False Then vntEditPrice = vntArrEditPrice
    If IsMissing(vntTaxPrice) = False Then vntTaxPrice = vntArrTaxPrice
    If IsMissing(vntEditTax) = False Then vntEditTax = vntArrEditTax
    If IsMissing(vntOrgName) = False Then vntOrgName = vntArrOrgName
    If IsMissing(vntOrgKName) = False Then vntOrgKName = vntArrOrgKName
    If IsMissing(vntMethod) = False Then vntMethod = vntArrMethod
'## 2004.06.02 ADD STR ORB)T.YAGUCHI 項目追加
    If IsMissing(vntSecondFlg) = False Then vntSecondFlg = vntArrSecondFlg
'## 2004.06.02 ADD END

    SelectDmdBurdenBillDetail = lngCount
    
    Set objOraDyna = Nothing
    
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.SelectDmdBurdenBillDetail"
    WriteErrorLog "ErrNo:" & Err.Number & ":" & Err.Description & ":" & Err.Source
    
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

'## 2004.01.15 Modified Function by Shiramizu@CS 聖路加病院殿向けにメソッドそのものを完全再作成
'
' 機能　　 : 検索条件を満たす請求明細情報を取得する
'
' 引数　　 : (In)   vntIn_BillNo            請求書番号
' 　　　　 : (In)   vntIn_LineNo            明細No
' 　　　　 : (In)   vntStartPos             開始位置
' 　　　　 : (In)   vntGetCount             取得件数
' 　　　　 : (Out)  vntBillNo               請求書番号
' 　　　　 : (Out)  vntLineNo               明細No
' 　　　　 : (Out)  vntCloseDate            締め日
' 　　　　 : (Out)  vntBillSeq              請求書Seq
' 　　　　 : (Out)  vntBranchno             請求書枝番
' 　　　　 : (Out)  vntDayId                当日ID
' 　　　　 : (Out)  vntRsvNo                予約番号
' 　　　　 : (Out)  vntCslDate              受診日
' 　　　　 : (Out)  vntDetailName           名称
' 　　　　 : (Out)  vntPerId                個人ID
' 　　　　 : (Out)  vntLastName             姓
' 　　　　 : (Out)  vntFirstName            名
' 　　　　 : (Out)  vntLastKName            カナ姓
' 　　　　 : (Out)  vntFirstKName           カナ名
' 　　　　 : (Out)  vntPrice                金額
' 　　　　 : (Out)  vntEditPrice            調整金額
' 　　　　 : (Out)  vntTaxPrice             税額
' 　　　　 : (Out)  vntEditTax              調整税額
' 　　　　 : (Out)  vntOrgCd1               団体コード１
' 　　　　 : (Out)  vntOrgCd2               団体コード２
' 　　　　 : (Out)  vntOrgName              団体名
' 　　　　 : (Out)  vntOrgKName             団体カナ名
' 　　　　 : (Out)  vntMethod               作成方法
' 　　　　 : (Out)  vntDelFlg               取消伝票フラグ
'## 2004.06.02 ADD STR ORB)T.YAGUCHI 項目追加
' 　　　　 : (Out)  vntSecondFlg            ２次検査フラグ
'## 2004.06.02 ADD END
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
'## 2004.06.02 MOD STR ORB)T.YAGUCHI 項目追加
'Public Function SelectDmdBurdenModifyBillDetail(ByVal vntIn_BillNo As Variant,
'                                                Optional ByVal vntIn_LineNo As Variant, Optional ByVal vntStartPos As Variant,
'                                                Optional ByVal vntGetCount As Variant, Optional ByRef vntBillNo As Variant,
'                                                Optional ByRef vntLineNo As Variant, Optional ByRef vntCloseDate As Variant,
'                                                Optional ByRef vntBillSeq As Variant, Optional ByRef vntBranchNo As Variant,
'                                                Optional ByRef vntDayId As Variant, Optional ByRef vntRsvNo As Variant, Optional ByRef vntCslDate As Variant,
'                                                Optional ByRef vntDetailName As Variant, Optional ByRef vntPerId As Variant,
'                                                Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant,
'                                                Optional ByRef vntLastKName As Variant, Optional ByRef vntFirstKName As Variant,
'                                                Optional ByRef vntPrice As Variant, Optional ByRef vntEditPrice As Variant,
'                                                Optional ByRef vntTaxPrice As Variant, Optional ByRef vntEditTax As Variant,
'                                                Optional ByRef vntOrgCd1 As Variant, Optional ByRef vntOrgCd2 As Variant,
'                                                Optional ByRef vntOrgName As Variant, Optional ByRef vntOrgKName As Variant,
'                                                Optional ByRef vntMethod As Variant, Optional ByRef vntDelFlg As Variant) As Long
Public Function SelectDmdBurdenModifyBillDetail(ByVal vntIn_BillNo As Variant, _
                                                Optional ByVal vntIn_LineNo As Variant, Optional ByVal vntStartPos As Variant, _
                                                Optional ByVal vntGetCount As Variant, Optional ByRef vntBillNo As Variant, _
                                                Optional ByRef vntLineNo As Variant, Optional ByRef vntCloseDate As Variant, _
                                                Optional ByRef vntBillSeq As Variant, Optional ByRef vntBranchNo As Variant, _
                                                Optional ByRef vntDayId As Variant, Optional ByRef vntRsvNo As Variant, Optional ByRef vntCslDate As Variant, _
                                                Optional ByRef vntDetailName As Variant, Optional ByRef vntPerId As Variant, _
                                                Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant, _
                                                Optional ByRef vntLastKName As Variant, Optional ByRef vntFirstKName As Variant, _
                                                Optional ByRef vntPrice As Variant, Optional ByRef vntEditPrice As Variant, _
                                                Optional ByRef vntTaxPrice As Variant, Optional ByRef vntEditTax As Variant, _
                                                Optional ByRef vntOrgCd1 As Variant, Optional ByRef vntOrgCd2 As Variant, _
                                                Optional ByRef vntOrgName As Variant, Optional ByRef vntOrgKName As Variant, _
                                                Optional ByRef vntMethod As Variant, Optional ByRef vntDelFlg As Variant, _
                                                Optional ByRef vntSecondFlg As Variant) As Long
'## 2004.06.02 MOD END
    
    Dim objOraParam                 As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna                  As OraDynaset       'ダイナセット
    Dim strStmt                     As String           'SQLステートメント
    
    Dim objFields                   As OraFields        'フィールドオブジェクト
    
    Dim objBillNo                   As OraField         '請求書番号
    Dim objLineNo                   As OraField         '明細Ｎｏ
    Dim objCloseDate                As OraField         '締め日
    Dim objBillSeq                  As OraField         '請求書Seq
    Dim objBranchNo                 As OraField         '請求書枝番
    Dim objDayId                    As OraField         '当日ID
    Dim objRsvNo                    As OraField         '予約番号
    Dim objCslDate                  As OraField         '受診日
    Dim objDetailName               As OraField         '名称
    Dim objPerId                    As OraField         '個人ID
    Dim objLastName                 As OraField         '姓
    Dim objFirstName                As OraField         '名
    Dim objLastKName                As OraField         'カナ姓
    Dim objFirstKName               As OraField         'カナ名
    Dim objPrice                    As OraField         '金額
    Dim objEditPrice                As OraField         '調整金額
    Dim objTaxPrice                 As OraField         '税額
    Dim objEditTax                  As OraField         '調整税額
    Dim objOrgCd1                   As OraField         '団体コード１
    Dim objOrgCd2                   As OraField         '団体コード２
    Dim objOrgName                  As OraField         '団体名
    Dim objOrgKName                 As OraField         '団体カナ名
    Dim objMethod                   As OraField         '作成方法
    Dim objDelFlg                   As OraField         '取消伝票フラグ
'## 2004.06.02 ADD STR ORB)T.YAGUCHI 項目追加
    Dim objSecondFlg                As OraField         '２次検査フラグ
'## 2004.06.02 ADD END

    Dim lngCount                    As Long             'レコード数
    
    Dim vntArrBillNo()              As Variant          '請求書番号
    Dim vntArrLineNo()              As Variant          '明細Ｎｏ
    Dim vntArrCloseDate()           As Variant          '締め日
    Dim vntArrBillSeq()             As Variant          '請求書Seq
    Dim vntArrBranchNo()            As Variant          '請求書枝番
    Dim vntArrDayId()               As Variant          '当日ID
    Dim vntArrRsvNo()               As Variant          '予約番号
    Dim vntArrCslDate()             As Variant          '受診日
    Dim vntArrDetailName()          As Variant          '名称
    Dim vntArrPerId()               As Variant          '個人ID
    Dim vntArrLastName()            As Variant          '姓
    Dim vntArrFirstName()           As Variant          '名
    Dim vntArrLastKName()           As Variant          'カナ姓
    Dim vntArrFirstKName()          As Variant          'カナ名
    Dim vntArrPrice()               As Variant          '金額
    Dim vntArrEditPrice()           As Variant          '調整金額
    Dim vntArrTaxPrice()            As Variant          '税額
    Dim vntArrEditTax()             As Variant          '調整税額
    Dim vntArrOrgCd1()              As Variant          '団体コード１
    Dim vntArrOrgCd2()              As Variant          '団体コード２
    Dim vntArrOrgName()             As Variant          '団体名
    Dim vntArrOrgKName()            As Variant          '団体カナ名
    Dim vntArrMethod()              As Variant          '作成方法
    Dim vntArrDelFlg()              As Variant          '取消伝票フラグ
'## 2004.06.02 ADD STR ORB)T.YAGUCHI 項目追加
    Dim vntArrSecondFlg()           As Variant          '２次検査フラグ
'## 2004.06.02 ADD END

    Dim strCloseDate            As String           '締め日
    Dim lngBillSeq              As Long             '請求書Seq
    Dim lngBranchNo             As Long             '請求書枝番
    
    Dim blnIsBillNo                 As Boolean          'パラメタに請求書番号が指定されている
    Dim blnIsLineNo                 As Boolean          'パラメタに明細NOが指定されている
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    SelectDmdBurdenModifyBillDetail = False
    lngCount = 0
    blnIsBillNo = False
    blnIsLineNo = False
    
    '請求書番号の妥当性チェック
    If IsMissing(vntIn_BillNo) = False Then
        vntIn_BillNo = Trim(vntIn_BillNo)
        
        If IsNumeric(vntIn_BillNo) = True Then
            If CDbl(vntIn_BillNo) > 0 Then
                If (Len(vntIn_BillNo) = LENGTH_BILLNO) Then
                    '請求書番号を分解
                    strCloseDate = Mid(vntIn_BillNo, 1, 4) & "/" & Mid(vntIn_BillNo, 5, 2) & "/" & Mid(vntIn_BillNo, 7, 2)
                    lngBillSeq = CLng(Mid(vntIn_BillNo, 9, 5))
                    lngBranchNo = CLng(Mid(vntIn_BillNo, 14, 1))
                    If IsDate(strCloseDate) Then
                        blnIsBillNo = True
                    End If
                End If
            End If
        End If
    End If
    
    '請求書番号が正しく指定されていない場合はエラー
    If blnIsBillNo = False Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    
    '請求書番号が指定されている
    If blnIsBillNo = True Then
        objOraParam.Add "CLOSEDATE", CDate(strCloseDate), ORAPARM_INPUT, ORATYPE_DATE
        objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    End If

    
'    明細Noが指定されている
    If IsMissing(vntIn_LineNo) = False Then
        If IsNumeric(vntIn_LineNo) Then
            objOraParam.Add "LINENO", vntIn_LineNo, ORAPARM_INPUT, ORATYPE_NUMBER
            blnIsLineNo = True
        End If
    End If

    '取得件数と開始位置が設定されている場合
    If IsNumeric(vntStartPos) And IsNumeric(vntGetCount) Then
        objOraParam.Add "SEQ_F", CLng(vntStartPos), ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "SEQ_T", (CLng(vntStartPos) + CLng(vntGetCount) - 1), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    
    'ROWNUMにより範囲指定するため、全体をVIEWにする
    strStmt = "SELECT " & vbLf & _
              "MAIN_VIEW.* " & vbLf & _
              "FROM " & vbLf

'## 2004.06.02 MOD STR ORB)T.YAGUCHI 項目追加
'    '基本部分SELECT句
'    strStmt = strStmt & "( SELECT  " & vbLf & _
'                        "ROWNUM AS ROWSEQ,  " & vbLf & _
'                        "TO_CHAR(BILL.CLOSEDATE,'YYYY/MM/DD') AS CLOSEDATE,  " & vbLf & _
'                        "BILL.BILLSEQ, BILL.BRANCHNO,  BILL.DELFLG, " & vbLf & _
'                        "TO_CHAR(BILL.CLOSEDATE,'YYYYMMDD') ||  " & vbLf & _
'                        "TRIM(TO_CHAR(BILL.BILLSEQ,'00000')) ||  " & vbLf & _
'                        "TO_CHAR(BILL.BRANCHNO) AS BILLNO,  " & vbLf & _
'                        "ORG.ORGCD1, ORG.ORGCD2,  " & vbLf & _
'                        "ORG.ORGNAME, ORG.ORGKNAME,  " & vbLf & _
'                        "BILLDETAIL_VIEW.LINENO, BILLDETAIL_VIEW.RSVNO,  " & vbLf & _
'                        "BILLDETAIL_VIEW.DAYID, " & vbLf & _
'                        "TO_CHAR(BILLDETAIL_VIEW.CSLDATE,'YYYY/MM/DD') AS CSLDATE,  " & vbLf & _
'                        "BILLDETAIL_VIEW.DETAILNAME, BILLDETAIL_VIEW.PERID,  " & vbLf & _
'                        "BILLDETAIL_VIEW.LASTNAME, BILLDETAIL_VIEW.FIRSTNAME,  " & vbLf & _
'                        "BILLDETAIL_VIEW.LASTKNAME, BILLDETAIL_VIEW.FIRSTKNAME,  " & vbLf & _
'                        "BILLDETAIL_VIEW.PRICE, BILLDETAIL_VIEW.EDITPRICE,  " & vbLf & _
'                        "BILLDETAIL_VIEW.TAXPRICE, BILLDETAIL_VIEW.EDITTAX, BILLDETAIL_VIEW.METHOD  " & vbLf & _
'                        "FROM  " & vbLf
    '基本部分SELECT句
    strStmt = strStmt & "( SELECT  " & vbLf & _
                        "ROWNUM AS ROWSEQ,  " & vbLf & _
                        "TO_CHAR(BILL.CLOSEDATE,'YYYY/MM/DD') AS CLOSEDATE,  " & vbLf & _
                        "BILL.BILLSEQ, BILL.BRANCHNO,  BILL.DELFLG, " & vbLf & _
                        "BILL.SECONDFLG, " & vbLf & _
                        "TO_CHAR(BILL.CLOSEDATE,'YYYYMMDD') ||  " & vbLf & _
                        "TRIM(TO_CHAR(BILL.BILLSEQ,'00000')) ||  " & vbLf & _
                        "TO_CHAR(BILL.BRANCHNO) AS BILLNO,  " & vbLf & _
                        "ORG.ORGCD1, ORG.ORGCD2,  " & vbLf & _
                        "ORG.ORGNAME, ORG.ORGKNAME,  " & vbLf & _
                        "BILLDETAIL_VIEW.LINENO, BILLDETAIL_VIEW.RSVNO,  " & vbLf & _
                        "BILLDETAIL_VIEW.DAYID, " & vbLf & _
                        "TO_CHAR(BILLDETAIL_VIEW.CSLDATE,'YYYY/MM/DD') AS CSLDATE,  " & vbLf & _
                        "BILLDETAIL_VIEW.DETAILNAME, BILLDETAIL_VIEW.PERID,  " & vbLf & _
                        "BILLDETAIL_VIEW.LASTNAME, BILLDETAIL_VIEW.FIRSTNAME,  " & vbLf & _
                        "BILLDETAIL_VIEW.LASTKNAME, BILLDETAIL_VIEW.FIRSTKNAME,  " & vbLf & _
                        "BILLDETAIL_VIEW.PRICE, BILLDETAIL_VIEW.EDITPRICE,  " & vbLf & _
                        "BILLDETAIL_VIEW.TAXPRICE, BILLDETAIL_VIEW.EDITTAX, BILLDETAIL_VIEW.METHOD  " & vbLf & _
                        "FROM  " & vbLf
'## 2004.06.02 MOD END

    '請求書明細部分SELECT句
    strStmt = strStmt & "(SELECT " & vbLf & _
                        "BILLDETAIL.CLOSEDATE, BILLDETAIL.BILLSEQ, " & vbLf & _
                        "BILLDETAIL.BRANCHNO, BILLDETAIL.LINENO, " & vbLf & _
                        "BILLDETAIL.RSVNO, BILLDETAIL.DAYID, BILLDETAIL.CSLDATE, " & vbLf & _
                        "BILLDETAIL.DETAILNAME, BILLDETAIL.LASTNAME, " & vbLf & _
                        "BILLDETAIL.FIRSTNAME, BILLDETAIL.LASTKNAME, " & vbLf & _
                        "BILLDETAIL.FIRSTKNAME, BILLDETAIL.PRICE, " & vbLf & _
                        "BILLDETAIL.EDITPRICE, BILLDETAIL.TAXPRICE, " & vbLf & _
                        "BILLDETAIL.EDITTAX, BILLDETAIL.PERID, BILLDETAIL.METHOD " & vbLf & _
                        "FROM BILLDETAIL, CONSULT  " & vbLf & _
                        "WHERE " & vbLf

    '請求書明細部分WHERE句
    strStmt = strStmt & "BILLDETAIL.CLOSEDATE = :CLOSEDATE " & vbLf & _
                        "AND BILLDETAIL.BILLSEQ = :BILLSEQ " & vbLf & _
                        "AND BILLDETAIL.BRANCHNO = :BRANCHNO " & vbLf

    '明細No指定
    If blnIsLineNo = True Then
        strStmt = strStmt & "AND BILLDETAIL.LINENO = :LINENO " & vbLf
    Else
        strStmt = strStmt & "AND BILLDETAIL.LINENO IS NULL " & vbLf
    End If

    strStmt = strStmt & "AND CONSULT.RSVNO(+)=BILLDETAIL.RSVNO " & vbLf & _
                        ") BILLDETAIL_VIEW, ORG, BILL " & vbLf

    '基本部分WHERE句
    strStmt = strStmt & "WHERE  " & vbLf & _
                        "BILL.CLOSEDATE = :CLOSEDATE " & vbLf & _
                        "AND BILL.BILLSEQ = :BILLSEQ " & vbLf & _
                        "AND BILL.BRANCHNO = :BRANCHNO " & vbLf & _
                        "AND BILLDETAIL_VIEW.CLOSEDATE(+)=BILL.CLOSEDATE  " & vbLf & _
                        "AND BILLDETAIL_VIEW.BILLSEQ(+)=BILL.BILLSEQ  " & vbLf & _
                        "AND BILLDETAIL_VIEW.BRANCHNO(+)=BILL.BRANCHNO  " & vbLf & _
                        "AND BILL.ORGCD1=ORG.ORGCD1  " & vbLf & _
                        "AND BILL.ORGCD2=ORG.ORGCD2  " & vbLf
    
    strStmt = strStmt & ") MAIN_VIEW  " & vbLf
    
    '取得件数と開始位置が設定されている場合
    If (IsMissing(vntStartPos) = False) And (IsMissing(vntGetCount) = False) Then
        If IsNumeric(vntStartPos) And IsNumeric(vntGetCount) And _
           Trim(vntStartPos) <> "" And Trim(vntGetCount) <> "" Then
                strStmt = strStmt & vbLf & _
                          " WHERE MAIN_VIEW.ROWSEQ BETWEEN :SEQ_F AND :SEQ_T" & vbLf
        End If
    End If

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        
        Set objCloseDate = objFields("CLOSEDATE")
        Set objBillSeq = objFields("BILLSEQ")
        Set objBranchNo = objFields("BRANCHNO")
        Set objBillNo = objFields("BILLNO")
        Set objLineNo = objFields("LINENO")
        Set objDayId = objFields("DAYID")
        Set objRsvNo = objFields("RSVNO")
        Set objCslDate = objFields("CSLDATE")
        Set objDetailName = objFields("DETAILNAME")
        Set objPerId = objFields("PERID")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastKName = objFields("LASTKNAME")
        Set objFirstKName = objFields("FIRSTKNAME")
        Set objPrice = objFields("PRICE")
        Set objEditPrice = objFields("EDITPRICE")
        Set objTaxPrice = objFields("TAXPRICE")
        Set objEditTax = objFields("EDITTAX")
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objOrgName = objFields("ORGNAME")
        Set objOrgKName = objFields("ORGKNAME")
        Set objMethod = objFields("METHOD")
        Set objDelFlg = objFields("DELFLG")
'## 2004.06.02 ADD STR ORB)T.YAGUCHI 項目追加
        Set objSecondFlg = objFields("SECONDFLG")
'## 2004.06.02 ADD END

        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrCloseDate(lngCount)
            ReDim Preserve vntArrBillSeq(lngCount)
            ReDim Preserve vntArrBranchNo(lngCount)
            ReDim Preserve vntArrBillNo(lngCount)
            ReDim Preserve vntArrLineNo(lngCount)
            ReDim Preserve vntArrDayId(lngCount)
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrCslDate(lngCount)
            ReDim Preserve vntArrDetailName(lngCount)
            ReDim Preserve vntArrLastName(lngCount)
            ReDim Preserve vntArrFirstName(lngCount)
            ReDim Preserve vntArrLastKName(lngCount)
            ReDim Preserve vntArrFirstKName(lngCount)
            ReDim Preserve vntArrPerId(lngCount)
            ReDim Preserve vntArrPrice(lngCount)
            ReDim Preserve vntArrEditPrice(lngCount)
            ReDim Preserve vntArrTaxPrice(lngCount)
            ReDim Preserve vntArrEditTax(lngCount)
            ReDim Preserve vntArrOrgCd1(lngCount)
            ReDim Preserve vntArrOrgCd2(lngCount)
            ReDim Preserve vntArrOrgName(lngCount)
            ReDim Preserve vntArrOrgKName(lngCount)
            ReDim Preserve vntArrMethod(lngCount)
            ReDim Preserve vntArrDelFlg(lngCount)
'## 2004.06.02 ADD STR ORB)T.YAGUCHI 項目追加
            ReDim Preserve vntArrSecondFlg(lngCount)
'## 2004.06.02 ADD END

            vntArrCloseDate(lngCount) = objCloseDate.Value & ""
            vntArrBillSeq(lngCount) = objBillSeq.Value & ""
            vntArrBranchNo(lngCount) = objBranchNo.Value & ""
            vntArrBillNo(lngCount) = objBillNo.Value & ""
            vntArrLineNo(lngCount) = objLineNo.Value & ""
            vntArrDayId(lngCount) = objDayId.Value & ""
            vntArrRsvNo(lngCount) = objRsvNo.Value & ""
            vntArrCslDate(lngCount) = objCslDate.Value & ""
            vntArrDetailName(lngCount) = objDetailName.Value & ""
            vntArrLastName(lngCount) = objLastName.Value & ""
            vntArrFirstName(lngCount) = objFirstName.Value & ""
            vntArrLastKName(lngCount) = objLastKName.Value & ""
            vntArrFirstKName(lngCount) = objFirstKName.Value & ""
            vntArrPerId(lngCount) = objPerId.Value & ""
            vntArrPrice(lngCount) = objPrice.Value & ""
            vntArrEditPrice(lngCount) = objEditPrice.Value & ""
            vntArrTaxPrice(lngCount) = objTaxPrice.Value & ""
            vntArrEditTax(lngCount) = objEditTax.Value & ""
            vntArrOrgCd1(lngCount) = objOrgCd1.Value & ""
            vntArrOrgCd2(lngCount) = objOrgCd2.Value & ""
            vntArrOrgName(lngCount) = objOrgName.Value & ""
            vntArrOrgKName(lngCount) = objOrgKName.Value & ""
            vntArrMethod(lngCount) = objMethod.Value & ""
            vntArrDelFlg(lngCount) = objDelFlg.Value & ""
'## 2004.06.02 ADD STR ORB)T.YAGUCHI 項目追加
            vntArrSecondFlg(lngCount) = objSecondFlg.Value & ""
'## 2004.06.02 ADD END

            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    End If
    
    '戻り値の設定
    If IsMissing(vntCloseDate) = False Then vntCloseDate = vntArrCloseDate
    If IsMissing(vntBillSeq) = False Then vntBillSeq = vntArrBillSeq
    If IsMissing(vntBranchNo) = False Then vntBranchNo = vntArrBranchNo
    If IsMissing(vntBillNo) = False Then vntBillNo = vntArrBillNo
    If IsMissing(vntLineNo) = False Then vntLineNo = vntArrLineNo
    If IsMissing(vntDayId) = False Then vntDayId = vntArrDayId
    If IsMissing(vntRsvNo) = False Then vntRsvNo = vntArrRsvNo
    If IsMissing(vntCslDate) = False Then vntCslDate = vntArrCslDate
    If IsMissing(vntDetailName) = False Then vntDetailName = vntArrDetailName
    If IsMissing(vntLastName) = False Then vntLastName = vntArrLastName
    If IsMissing(vntFirstName) = False Then vntFirstName = vntArrFirstName
    If IsMissing(vntLastKName) = False Then vntLastKName = vntArrLastKName
    If IsMissing(vntFirstKName) = False Then vntFirstKName = vntArrFirstKName
    If IsMissing(vntPerId) = False Then vntPerId = vntArrPerId
    If IsMissing(vntPrice) = False Then vntPrice = vntArrPrice
    If IsMissing(vntEditPrice) = False Then vntEditPrice = vntArrEditPrice
    If IsMissing(vntTaxPrice) = False Then vntTaxPrice = vntArrTaxPrice
    If IsMissing(vntEditTax) = False Then vntEditTax = vntArrEditTax
    If IsMissing(vntOrgCd1) = False Then vntOrgCd1 = vntArrOrgCd1
    If IsMissing(vntOrgCd2) = False Then vntOrgCd2 = vntArrOrgCd2
    If IsMissing(vntOrgName) = False Then vntOrgName = vntArrOrgName
    If IsMissing(vntOrgKName) = False Then vntOrgKName = vntArrOrgKName
    If IsMissing(vntMethod) = False Then vntMethod = vntArrMethod
    If IsMissing(vntDelFlg) = False Then vntDelFlg = vntArrDelFlg
'## 2004.06.02 ADD STR ORB)T.YAGUCHI 項目追加
    If IsMissing(vntSecondFlg) = False Then vntSecondFlg = vntArrSecondFlg
'## 2004.06.02 ADD END

    SelectDmdBurdenModifyBillDetail = lngCount
    
    Set objOraDyna = Nothing
    
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.SelectDmdBurdenModifyBillDetail"
    WriteErrorLog "ErrNo:" & Err.Number & ":" & Err.Description & ":" & Err.Source
    
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

'## 2004.05.24 Add Str Orb)T.Yaguchi 請求明細内訳の追加
'
' 機能　　 : 検索条件を満たす請求明細情報を取得する
'
' 引数　　 : (In)   vntIn_BillNo            請求書番号
' 　　　　 : (In)   vntIn_LineNo            明細No
' 　　　　 : (In)   vntIn_ItemNo            内訳No
' 　　　　 : (In)   vntStartPos             開始位置
' 　　　　 : (In)   vntGetCount             取得件数
' 　　　　 : (Out)  vntBillNo               請求書番号
' 　　　　 : (Out)  vntLineNo               明細No
' 　　　　 : (Out)  vntCloseDate            締め日
' 　　　　 : (Out)  vntBillSeq              請求書Seq
' 　　　　 : (Out)  vntBranchno             請求書枝番
' 　　　　 : (Out)  vntDayId                当日ID
' 　　　　 : (Out)  vntRsvNo                予約番号
' 　　　　 : (Out)  vntCslDate              受診日
' 　　　　 : (Out)  vntDetailName           名称
' 　　　　 : (Out)  vntPerId                個人ID
' 　　　　 : (Out)  vntLastName             姓
' 　　　　 : (Out)  vntFirstName            名
' 　　　　 : (Out)  vntLastKName            カナ姓
' 　　　　 : (Out)  vntFirstKName           カナ名
' 　　　　 : (Out)  vntPrice                金額
' 　　　　 : (Out)  vntEditPrice            調整金額
' 　　　　 : (Out)  vntTaxPrice             税額
' 　　　　 : (Out)  vntEditTax              調整税額
' 　　　　 : (Out)  vntOrgCd1               団体コード１
' 　　　　 : (Out)  vntOrgCd2               団体コード２
' 　　　　 : (Out)  vntOrgName              団体名
' 　　　　 : (Out)  vntOrgKName             団体カナ名
' 　　　　 : (Out)  vntMethod               作成方法
' 　　　　 : (Out)  vntDelFlg               取消伝票フラグ
' 　　　　 : (Out)  vntItemNo               内訳no
' 　　　　 : (Out)  vntSecondLineDivCd      ２次請求明細コード
' 　　　　 : (Out)  vntSecondLineDivName    ２次請求明細名
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectDmdDetailItmList(ByVal vntIn_BillNo As Variant, _
                                            Optional ByVal vntIn_LineNo As Variant, Optional ByVal vntIn_ItemNo As Variant, _
                                            Optional ByVal vntStartPos As Variant, Optional ByVal vntGetCount As Variant, _
                                            Optional ByRef vntBillNo As Variant, _
                                            Optional ByRef vntLineNo As Variant, Optional ByRef vntCloseDate As Variant, _
                                            Optional ByRef vntBillSeq As Variant, Optional ByRef vntBranchNo As Variant, _
                                            Optional ByRef vntDayId As Variant, Optional ByRef vntRsvNo As Variant, Optional ByRef vntCslDate As Variant, _
                                            Optional ByRef vntDetailName As Variant, Optional ByRef vntPerId As Variant, _
                                            Optional ByRef vntLastName As Variant, Optional ByRef vntFirstName As Variant, _
                                            Optional ByRef vntLastKName As Variant, Optional ByRef vntFirstKName As Variant, _
                                            Optional ByRef vntPrice As Variant, Optional ByRef vntEditPrice As Variant, _
                                            Optional ByRef vntTaxPrice As Variant, Optional ByRef vntEditTax As Variant, _
                                            Optional ByRef vntOrgCd1 As Variant, Optional ByRef vntOrgCd2 As Variant, _
                                            Optional ByRef vntOrgName As Variant, Optional ByRef vntOrgKName As Variant, _
                                            Optional ByRef vntMethod As Variant, Optional ByRef vntDelFlg As Variant, _
                                            Optional ByRef vntItemNo As Variant, Optional ByRef vntSecondLineDivCd As Variant, _
                                            Optional ByRef vntSecondLineDivName As Variant) As Long

    
    Dim objOraParam                 As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna                  As OraDynaset       'ダイナセット
    Dim strStmt                     As String           'SQLステートメント
    
    Dim objFields                   As OraFields        'フィールドオブジェクト
    
    Dim objBillNo                   As OraField         '請求書番号
    Dim objLineNo                   As OraField         '明細Ｎｏ
    Dim objCloseDate                As OraField         '締め日
    Dim objBillSeq                  As OraField         '請求書Seq
    Dim objBranchNo                 As OraField         '請求書枝番
    Dim objDayId                    As OraField         '当日ID
    Dim objRsvNo                    As OraField         '予約番号
    Dim objCslDate                  As OraField         '受診日
    Dim objDetailName               As OraField         '名称
    Dim objPerId                    As OraField         '個人ID
    Dim objLastName                 As OraField         '姓
    Dim objFirstName                As OraField         '名
    Dim objLastKName                As OraField         'カナ姓
    Dim objFirstKName               As OraField         'カナ名
    Dim objPrice                    As OraField         '金額
    Dim objEditPrice                As OraField         '調整金額
    Dim objTaxPrice                 As OraField         '税額
    Dim objEditTax                  As OraField         '調整税額
    Dim objOrgCd1                   As OraField         '団体コード１
    Dim objOrgCd2                   As OraField         '団体コード２
    Dim objOrgName                  As OraField         '団体名
    Dim objOrgKName                 As OraField         '団体カナ名
    Dim objMethod                   As OraField         '作成方法
    Dim objDelFlg                   As OraField         '取消伝票フラグ
    Dim objItemNo                   As OraField         '内訳コード
    Dim objSecondLineDivCd          As OraField         '２次請求明細コード
    Dim objSecondLineDivName        As OraField         '２次請求明細名

    Dim lngCount                    As Long             'レコード数

    Dim vntArrBillNo()              As Variant          '請求書番号
    Dim vntArrLineNo()              As Variant          '明細Ｎｏ
    Dim vntArrCloseDate()           As Variant          '締め日
    Dim vntArrBillSeq()             As Variant          '請求書Seq
    Dim vntArrBranchNo()            As Variant          '請求書枝番
    Dim vntArrDayId()               As Variant          '当日ID
    Dim vntArrRsvNo()               As Variant          '予約番号
    Dim vntArrCslDate()             As Variant          '受診日
    Dim vntArrDetailName()          As Variant          '名称
    Dim vntArrPerId()               As Variant          '個人ID
    Dim vntArrLastName()            As Variant          '姓
    Dim vntArrFirstName()           As Variant          '名
    Dim vntArrLastKName()           As Variant          'カナ姓
    Dim vntArrFirstKName()          As Variant          'カナ名
    Dim vntArrPrice()               As Variant          '金額
    Dim vntArrEditPrice()           As Variant          '調整金額
    Dim vntArrTaxPrice()            As Variant          '税額
    Dim vntArrEditTax()             As Variant          '調整税額
    Dim vntArrOrgCd1()              As Variant          '団体コード１
    Dim vntArrOrgCd2()              As Variant          '団体コード２
    Dim vntArrOrgName()             As Variant          '団体名
    Dim vntArrOrgKName()            As Variant          '団体カナ名
    Dim vntArrMethod()              As Variant          '作成方法
    Dim vntArrDelFlg()              As Variant          '取消伝票フラグ
    Dim vntArrItemNo()              As Variant          '内訳コード
    Dim vntArrSecondLineDivCd()     As Variant          '２次請求明細コード
    Dim vntArrSecondLineDivName()   As Variant          '２次請求明細名

    Dim strCloseDate            As String           '締め日
    Dim lngBillSeq              As Long             '請求書Seq
    Dim lngBranchNo             As Long             '請求書枝番

    Dim blnIsBillNo                 As Boolean          'パラメタに請求書番号が指定されている
    Dim blnIsLineNo                 As Boolean          'パラメタに明細NOが指定されている
    Dim blnIsItemNo                 As Boolean          'パラメタに内訳NOが指定されている

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    SelectDmdDetailItmList = False
    lngCount = 0
    blnIsBillNo = False
    blnIsLineNo = False

    '請求書番号の妥当性チェック
    If IsMissing(vntIn_BillNo) = False Then
        vntIn_BillNo = Trim(vntIn_BillNo)

        If IsNumeric(vntIn_BillNo) = True Then
            If CDbl(vntIn_BillNo) > 0 Then
                If (Len(vntIn_BillNo) = LENGTH_BILLNO) Then
                    '請求書番号を分解
                    strCloseDate = Mid(vntIn_BillNo, 1, 4) & "/" & Mid(vntIn_BillNo, 5, 2) & "/" & Mid(vntIn_BillNo, 7, 2)
                    lngBillSeq = CLng(Mid(vntIn_BillNo, 9, 5))
                    lngBranchNo = CLng(Mid(vntIn_BillNo, 14, 1))
                    If IsDate(strCloseDate) Then
                        blnIsBillNo = True
                    End If
                End If
            End If
        End If
    End If

    '請求書番号が正しく指定されていない場合はエラー
    If blnIsBillNo = False Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters

    '請求書番号が指定されている
    If blnIsBillNo = True Then
        objOraParam.Add "CLOSEDATE", CDate(strCloseDate), ORAPARM_INPUT, ORATYPE_DATE
        objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    
'    明細Noが指定されている
    If IsMissing(vntIn_LineNo) = False Then
        If IsNumeric(vntIn_LineNo) Then
            objOraParam.Add "LINENO", vntIn_LineNo, ORAPARM_INPUT, ORATYPE_NUMBER
            blnIsLineNo = True
        End If
    End If

'    内訳Noが指定されている
    If IsMissing(vntIn_ItemNo) = False Then
        If IsNumeric(vntIn_ItemNo) Then
            objOraParam.Add "ITEMNO", vntIn_ItemNo, ORAPARM_INPUT, ORATYPE_NUMBER
            blnIsItemNo = True
        End If
    End If

    '取得件数と開始位置が設定されている場合
    If IsNumeric(vntStartPos) And IsNumeric(vntGetCount) Then
        objOraParam.Add "SEQ_F", CLng(vntStartPos), ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "SEQ_T", (CLng(vntStartPos) + CLng(vntGetCount) - 1), ORAPARM_INPUT, ORATYPE_NUMBER
    End If

    'ROWNUMにより範囲指定するため、全体をVIEWにする
    strStmt = "SELECT " & vbLf & _
              "MAIN_VIEW.* " & vbLf & _
              "FROM " & vbLf

    '基本部分SELECT句
    strStmt = strStmt & "( SELECT  " & vbLf & _
                        "ROWNUM AS ROWSEQ,  " & vbLf & _
                        "TO_CHAR(BILL.CLOSEDATE,'YYYY/MM/DD') AS CLOSEDATE,  " & vbLf & _
                        "BILL.BILLSEQ, BILL.BRANCHNO,  BILL.DELFLG, " & vbLf & _
                        "TO_CHAR(BILL.CLOSEDATE,'YYYYMMDD') ||  " & vbLf & _
                        "TRIM(TO_CHAR(BILL.BILLSEQ,'00000')) ||  " & vbLf & _
                        "TO_CHAR(BILL.BRANCHNO) AS BILLNO,  " & vbLf & _
                        "ORG.ORGCD1, ORG.ORGCD2,  " & vbLf & _
                        "ORG.ORGNAME, ORG.ORGKNAME,  " & vbLf & _
                        "BILLDETAIL_VIEW.LINENO, BILLDETAIL_VIEW.RSVNO,  " & vbLf & _
                        "BILLDETAIL_VIEW.DAYID, " & vbLf & _
                        "TO_CHAR(BILLDETAIL_VIEW.CSLDATE,'YYYY/MM/DD') AS CSLDATE,  " & vbLf & _
                        "BILLDETAIL_VIEW.DETAILNAME, BILLDETAIL_VIEW.PERID,  " & vbLf & _
                        "BILLDETAIL_VIEW.LASTNAME, BILLDETAIL_VIEW.FIRSTNAME,  " & vbLf & _
                        "BILLDETAIL_VIEW.LASTKNAME, BILLDETAIL_VIEW.FIRSTKNAME,  " & vbLf & _
                        "BILLDETAIL_VIEW.METHOD, " & vbLf & _
                        "BILLDETAIL_ITEMS.ITEMNO, BILLDETAIL_ITEMS.SECONDLINEDIVCD, " & vbLf & _
                        "BILLDETAIL_ITEMS.PRICE, BILLDETAIL_ITEMS.EDITPRICE,  " & vbLf & _
                        "BILLDETAIL_ITEMS.TAXPRICE, BILLDETAIL_ITEMS.EDITTAX,  " & vbLf & _
                        "SECONDLINEDIV.SECONDLINEDIVNAME  " & vbLf & _
                        "FROM  " & vbLf

    '請求書明細部分SELECT句
    strStmt = strStmt & "(SELECT " & vbLf & _
                        "BILLDETAIL.CLOSEDATE, BILLDETAIL.BILLSEQ, " & vbLf & _
                        "BILLDETAIL.BRANCHNO, BILLDETAIL.LINENO, " & vbLf & _
                        "BILLDETAIL.RSVNO, BILLDETAIL.DAYID, BILLDETAIL.CSLDATE, " & vbLf & _
                        "BILLDETAIL.DETAILNAME, BILLDETAIL.LASTNAME, " & vbLf & _
                        "BILLDETAIL.FIRSTNAME, BILLDETAIL.LASTKNAME, " & vbLf & _
                        "BILLDETAIL.FIRSTKNAME, BILLDETAIL.PERID, BILLDETAIL.METHOD " & vbLf & _
                        "FROM BILLDETAIL, CONSULT  " & vbLf & _
                        "WHERE " & vbLf

    '請求書明細部分WHERE句
    strStmt = strStmt & "BILLDETAIL.CLOSEDATE = :CLOSEDATE " & vbLf & _
                        "AND BILLDETAIL.BILLSEQ = :BILLSEQ " & vbLf & _
                        "AND BILLDETAIL.BRANCHNO = :BRANCHNO " & vbLf & _
                        "AND BILLDETAIL.LINENO = :LINENO " & vbLf

    strStmt = strStmt & "AND CONSULT.RSVNO(+)=BILLDETAIL.RSVNO " & vbLf & _
                        ") BILLDETAIL_VIEW, ORG, BILL ,BILLDETAIL_ITEMS, SECONDLINEDIV" & vbLf

    '基本部分WHERE句
    strStmt = strStmt & "WHERE  " & vbLf & _
                        "BILL.CLOSEDATE = :CLOSEDATE " & vbLf & _
                        "AND BILL.BILLSEQ = :BILLSEQ " & vbLf & _
                        "AND BILL.BRANCHNO = :BRANCHNO " & vbLf & _
                        "AND BILLDETAIL_VIEW.CLOSEDATE(+)=BILL.CLOSEDATE  " & vbLf & _
                        "AND BILLDETAIL_VIEW.BILLSEQ(+)=BILL.BILLSEQ  " & vbLf & _
                        "AND BILLDETAIL_VIEW.BRANCHNO(+)=BILL.BRANCHNO  " & vbLf & _
                        "AND BILL.ORGCD1=ORG.ORGCD1  " & vbLf & _
                        "AND BILL.ORGCD2=ORG.ORGCD2  " & vbLf & _
                        "AND BILLDETAIL_ITEMS.CLOSEDATE = :CLOSEDATE " & vbLf & _
                        "AND BILLDETAIL_ITEMS.BILLSEQ = :BILLSEQ " & vbLf & _
                        "AND BILLDETAIL_ITEMS.BRANCHNO = :BRANCHNO " & vbLf & _
                        "AND BILLDETAIL_ITEMS.LINENO = :LINENO " & vbLf & _
                        "AND BILLDETAIL_ITEMS.SECONDLINEDIVCD = SECONDLINEDIV.SECONDLINEDIVCD " & vbLf

    '明細No指定
    If blnIsItemNo = True Then
        strStmt = strStmt & "AND BILLDETAIL_ITEMS.ITEMNO = :ITEMNO " & vbLf
    End If
    
    strStmt = strStmt & ") MAIN_VIEW  " & vbLf
    
    '取得件数と開始位置が設定されている場合
    If (IsMissing(vntStartPos) = False) And (IsMissing(vntGetCount) = False) Then
        If IsNumeric(vntStartPos) And IsNumeric(vntGetCount) And _
           Trim(vntStartPos) <> "" And Trim(vntGetCount) <> "" Then
                strStmt = strStmt & vbLf & _
                          " WHERE MAIN_VIEW.ROWSEQ BETWEEN :SEQ_F AND :SEQ_T" & vbLf
        End If
    End If

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        
        Set objCloseDate = objFields("CLOSEDATE")
        Set objBillSeq = objFields("BILLSEQ")
        Set objBranchNo = objFields("BRANCHNO")
        Set objBillNo = objFields("BILLNO")
        Set objLineNo = objFields("LINENO")
        Set objDayId = objFields("DAYID")
        Set objRsvNo = objFields("RSVNO")
        Set objCslDate = objFields("CSLDATE")
        Set objDetailName = objFields("DETAILNAME")
        Set objPerId = objFields("PERID")
        Set objLastName = objFields("LASTNAME")
        Set objFirstName = objFields("FIRSTNAME")
        Set objLastKName = objFields("LASTKNAME")
        Set objFirstKName = objFields("FIRSTKNAME")
        Set objPrice = objFields("PRICE")
        Set objEditPrice = objFields("EDITPRICE")
        Set objTaxPrice = objFields("TAXPRICE")
        Set objEditTax = objFields("EDITTAX")
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objOrgName = objFields("ORGNAME")
        Set objOrgKName = objFields("ORGKNAME")
        Set objMethod = objFields("METHOD")
        Set objDelFlg = objFields("DELFLG")
        Set objItemNo = objFields("ITEMNO")
        Set objSecondLineDivCd = objFields("SECONDLINEDIVCD")
        Set objSecondLineDivName = objFields("SECONDLINEDIVNAME")

        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrCloseDate(lngCount)
            ReDim Preserve vntArrBillSeq(lngCount)
            ReDim Preserve vntArrBranchNo(lngCount)
            ReDim Preserve vntArrBillNo(lngCount)
            ReDim Preserve vntArrLineNo(lngCount)
            ReDim Preserve vntArrDayId(lngCount)
            ReDim Preserve vntArrRsvNo(lngCount)
            ReDim Preserve vntArrCslDate(lngCount)
            ReDim Preserve vntArrDetailName(lngCount)
            ReDim Preserve vntArrLastName(lngCount)
            ReDim Preserve vntArrFirstName(lngCount)
            ReDim Preserve vntArrLastKName(lngCount)
            ReDim Preserve vntArrFirstKName(lngCount)
            ReDim Preserve vntArrPerId(lngCount)
            ReDim Preserve vntArrPrice(lngCount)
            ReDim Preserve vntArrEditPrice(lngCount)
            ReDim Preserve vntArrTaxPrice(lngCount)
            ReDim Preserve vntArrEditTax(lngCount)
            ReDim Preserve vntArrOrgCd1(lngCount)
            ReDim Preserve vntArrOrgCd2(lngCount)
            ReDim Preserve vntArrOrgName(lngCount)
            ReDim Preserve vntArrOrgKName(lngCount)
            ReDim Preserve vntArrMethod(lngCount)
            ReDim Preserve vntArrDelFlg(lngCount)
            ReDim Preserve vntArrItemNo(lngCount)
            ReDim Preserve vntArrSecondLineDivCd(lngCount)
            ReDim Preserve vntArrSecondLineDivName(lngCount)

            vntArrCloseDate(lngCount) = objCloseDate.Value & ""
            vntArrBillSeq(lngCount) = objBillSeq.Value & ""
            vntArrBranchNo(lngCount) = objBranchNo.Value & ""
            vntArrBillNo(lngCount) = objBillNo.Value & ""
            vntArrLineNo(lngCount) = objLineNo.Value & ""
            vntArrDayId(lngCount) = objDayId.Value & ""
            vntArrRsvNo(lngCount) = objRsvNo.Value & ""
            vntArrCslDate(lngCount) = objCslDate.Value & ""
            vntArrDetailName(lngCount) = objDetailName.Value & ""
            vntArrLastName(lngCount) = objLastName.Value & ""
            vntArrFirstName(lngCount) = objFirstName.Value & ""
            vntArrLastKName(lngCount) = objLastKName.Value & ""
            vntArrFirstKName(lngCount) = objFirstKName.Value & ""
            vntArrPerId(lngCount) = objPerId.Value & ""
            vntArrPrice(lngCount) = objPrice.Value & ""
            vntArrEditPrice(lngCount) = objEditPrice.Value & ""
            vntArrTaxPrice(lngCount) = objTaxPrice.Value & ""
            vntArrEditTax(lngCount) = objEditTax.Value & ""
            vntArrOrgCd1(lngCount) = objOrgCd1.Value & ""
            vntArrOrgCd2(lngCount) = objOrgCd2.Value & ""
            vntArrOrgName(lngCount) = objOrgName.Value & ""
            vntArrOrgKName(lngCount) = objOrgKName.Value & ""
            vntArrMethod(lngCount) = objMethod.Value & ""
            vntArrDelFlg(lngCount) = objDelFlg.Value & ""
            vntArrItemNo(lngCount) = objItemNo.Value & ""
            vntArrSecondLineDivCd(lngCount) = objSecondLineDivCd.Value & ""
            vntArrSecondLineDivName(lngCount) = objSecondLineDivName.Value & ""

            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    End If
    
    '戻り値の設定
    If IsMissing(vntCloseDate) = False Then vntCloseDate = vntArrCloseDate
    If IsMissing(vntBillSeq) = False Then vntBillSeq = vntArrBillSeq
    If IsMissing(vntBranchNo) = False Then vntBranchNo = vntArrBranchNo
    If IsMissing(vntBillNo) = False Then vntBillNo = vntArrBillNo
    If IsMissing(vntLineNo) = False Then vntLineNo = vntArrLineNo
    If IsMissing(vntDayId) = False Then vntDayId = vntArrDayId
    If IsMissing(vntRsvNo) = False Then vntRsvNo = vntArrRsvNo
    If IsMissing(vntCslDate) = False Then vntCslDate = vntArrCslDate
    If IsMissing(vntDetailName) = False Then vntDetailName = vntArrDetailName
    If IsMissing(vntLastName) = False Then vntLastName = vntArrLastName
    If IsMissing(vntFirstName) = False Then vntFirstName = vntArrFirstName
    If IsMissing(vntLastKName) = False Then vntLastKName = vntArrLastKName
    If IsMissing(vntFirstKName) = False Then vntFirstKName = vntArrFirstKName
    If IsMissing(vntPerId) = False Then vntPerId = vntArrPerId
    If IsMissing(vntPrice) = False Then vntPrice = vntArrPrice
    If IsMissing(vntEditPrice) = False Then vntEditPrice = vntArrEditPrice
    If IsMissing(vntTaxPrice) = False Then vntTaxPrice = vntArrTaxPrice
    If IsMissing(vntEditTax) = False Then vntEditTax = vntArrEditTax
    If IsMissing(vntOrgCd1) = False Then vntOrgCd1 = vntArrOrgCd1
    If IsMissing(vntOrgCd2) = False Then vntOrgCd2 = vntArrOrgCd2
    If IsMissing(vntOrgName) = False Then vntOrgName = vntArrOrgName
    If IsMissing(vntOrgKName) = False Then vntOrgKName = vntArrOrgKName
    If IsMissing(vntMethod) = False Then vntMethod = vntArrMethod
    If IsMissing(vntDelFlg) = False Then vntDelFlg = vntArrDelFlg
    If IsMissing(vntItemNo) = False Then vntItemNo = vntArrItemNo
    If IsMissing(vntSecondLineDivCd) = False Then vntSecondLineDivCd = vntArrSecondLineDivCd
    If IsMissing(vntSecondLineDivName) = False Then vntSecondLineDivName = vntArrSecondLineDivName

    SelectDmdDetailItmList = lngCount

    Set objOraDyna = Nothing

    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing

    'トランザクションをコミット
    mobjContext.SetComplete
    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Demand.SelectDmdDetailItmList"
    WriteErrorLog "ErrNo:" & Err.Number & ":" & Err.Description & ":" & Err.Source

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
'## 2004.05.24 Add End


'## 2004.06.01 Add Str Orb)T.Yaguchi 請求明細内訳の追加
'
' 機能　　 : 検索条件を満たす請求明細内訳情報を集計する
'
' 引数　　 : (In)   vntIn_BillNo            請求書番号
' 　　　　 : (In)   vntIn_LineNo            明細No
' 　　　　 : (Out)  vntSumPrice             金額合計
' 　　　　 : (Out)  vntSumEditPrice         調整金額合計
' 　　　　 : (Out)  vntSumTaxPrice          税額合計
' 　　　　 : (Out)  vntSumEditTax           調整税額合計
' 　　　　 : (Out)  vntSumPriceTotal        総合計
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
Public Function SelectSumDetailItems(ByVal vntIn_BillNo As Variant, _
                                            Optional ByVal vntIn_LineNo As Variant, _
                                            Optional ByRef vntSumPrice As Variant, Optional ByRef vntSumEditPrice As Variant, _
                                            Optional ByRef vntSumTaxPrice As Variant, Optional ByRef vntSumEditTax As Variant, _
                                            Optional ByRef vntSumPriceTotal As Variant) As Long
    
    Dim objOraParam                 As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna                  As OraDynaset       'ダイナセット
    Dim strStmt                     As String           'SQLステートメント
    
    Dim objFields                   As OraFields        'フィールドオブジェクト
    
    Dim objSumPrice                 As OraField         '金額合計
    Dim objSumEditPrice             As OraField         '調整金額合計
    Dim objSumTaxPrice              As OraField         '税額合計
    Dim objSumEditTax               As OraField         '調整税額合計
    Dim objSumPriceTotal            As OraField         '総合計

    Dim lngCount                    As Long             'レコード数

    Dim vntArrSumPrice()            As Variant          '金額合計
    Dim vntArrSumEditPrice()        As Variant          '調整金額合計
    Dim vntArrSumTaxPrice()         As Variant          '税額合計
    Dim vntArrSumEditTax()          As Variant          '調整税額合計
    Dim vntArrSumPriceTotal()       As Variant          '総合計

    Dim strCloseDate            As String           '締め日
    Dim lngBillSeq              As Long             '請求書Seq
    Dim lngBranchNo             As Long             '請求書枝番

    Dim blnIsBillNo                 As Boolean          'パラメタに請求書番号が指定されている
    Dim blnIsLineNo                 As Boolean          'パラメタに明細NOが指定されている

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    SelectSumDetailItems = False
    lngCount = 0
    blnIsBillNo = False
    blnIsLineNo = False

    If IsMissing(vntSumPrice) = False Then vntSumPrice = Empty
    If IsMissing(vntSumEditPrice) = False Then vntSumEditPrice = Empty
    If IsMissing(vntSumTaxPrice) = False Then vntSumTaxPrice = Empty
    If IsMissing(vntSumEditTax) = False Then vntSumEditTax = Empty
    If IsMissing(vntSumPriceTotal) = False Then vntSumPriceTotal = Empty

    '請求書番号の妥当性チェック
    If IsMissing(vntIn_BillNo) = False Then
        vntIn_BillNo = Trim(vntIn_BillNo)

        If IsNumeric(vntIn_BillNo) = True Then
            If CDbl(vntIn_BillNo) > 0 Then
                If (Len(vntIn_BillNo) = LENGTH_BILLNO) Then
                    '請求書番号を分解
                    strCloseDate = Mid(vntIn_BillNo, 1, 4) & "/" & Mid(vntIn_BillNo, 5, 2) & "/" & Mid(vntIn_BillNo, 7, 2)
                    lngBillSeq = CLng(Mid(vntIn_BillNo, 9, 5))
                    lngBranchNo = CLng(Mid(vntIn_BillNo, 14, 1))
                    If IsDate(strCloseDate) Then
                        blnIsBillNo = True
                    End If
                End If
            End If
        End If
    End If

    '請求書番号が正しく指定されていない場合はエラー
    If blnIsBillNo = False Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters

    '請求書番号が指定されている
    If blnIsBillNo = True Then
        objOraParam.Add "CLOSEDATE", CDate(strCloseDate), ORAPARM_INPUT, ORATYPE_DATE
        objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    End If

'    明細Noが指定されている
    If IsMissing(vntIn_LineNo) = False Then
        If IsNumeric(vntIn_LineNo) Then
            objOraParam.Add "LINENO", vntIn_LineNo, ORAPARM_INPUT, ORATYPE_NUMBER
            blnIsLineNo = True
        End If
    End If

    '基本部分SELECT句
    strStmt = vbNullString
    strStmt = strStmt & "SELECT  " & vbLf & _
                        "BILLDETAIL_ITEMS.CLOSEDATE, " & vbLf & _
                        "BILLDETAIL_ITEMS.BILLSEQ, " & vbLf & _
                        "BILLDETAIL_ITEMS.BRANCHNO,  " & vbLf
'    明細Noが指定されている
    If blnIsLineNo Then
        strStmt = strStmt & "BILLDETAIL_ITEMS.LINENO, " & vbLf
    End If
    strStmt = strStmt & "SUM(BILLDETAIL_ITEMS.PRICE) AS SUMPRICE, SUM(BILLDETAIL_ITEMS.EDITPRICE) AS SUMEDITPRICE, " & vbLf & _
                        "SUM(BILLDETAIL_ITEMS.TAXPRICE) AS SUMTAXPRICE, SUM(BILLDETAIL_ITEMS.EDITTAX) AS SUMEDITTAX, " & vbLf & _
                        "SUM(BILLDETAIL_ITEMS.PRICE + BILLDETAIL_ITEMS.EDITPRICE + BILLDETAIL_ITEMS.TAXPRICE + BILLDETAIL_ITEMS.EDITTAX) AS SUMPRICETOTAL " & vbLf & _
                        "FROM  BILLDETAIL_ITEMS" & vbLf

    '基本部分WHERE句
    strStmt = strStmt & "WHERE  " & vbLf & _
                        "BILLDETAIL_ITEMS.CLOSEDATE = :CLOSEDATE " & vbLf & _
                        "AND BILLDETAIL_ITEMS.BILLSEQ = :BILLSEQ " & vbLf & _
                        "AND BILLDETAIL_ITEMS.BRANCHNO = :BRANCHNO " & vbLf

    '明細No指定
    If blnIsLineNo = True Then
        strStmt = strStmt & "AND BILLDETAIL_ITEMS.LINENO = :LINENO " & vbLf
    End If

    strStmt = strStmt & "GROUP BY " & vbLf & _
                        "BILLDETAIL_ITEMS.CLOSEDATE, " & vbLf & _
                        "BILLDETAIL_ITEMS.BILLSEQ, " & vbLf & _
                        "BILLDETAIL_ITEMS.BRANCHNO " & vbLf
    '明細No指定
    If blnIsLineNo = True Then
        strStmt = strStmt & ",BILLDETAIL_ITEMS.LINENO " & vbLf
    End If

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        
        Set objSumPrice = objFields("SUMPRICE")
        Set objSumEditPrice = objFields("SUMEDITPRICE")
        Set objSumTaxPrice = objFields("SUMTAXPRICE")
        Set objSumEditTax = objFields("SUMEDITTAX")
        Set objSumPriceTotal = objFields("SUMPRICETOTAL")

        '配列形式で格納する
        Do Until objOraDyna.EOF
            ReDim Preserve vntArrSumPrice(lngCount)
            ReDim Preserve vntArrSumEditPrice(lngCount)
            ReDim Preserve vntArrSumTaxPrice(lngCount)
            ReDim Preserve vntArrSumEditTax(lngCount)
            ReDim Preserve vntArrSumPriceTotal(lngCount)

            vntArrSumPrice(lngCount) = objSumPrice.Value & ""
            vntArrSumEditPrice(lngCount) = objSumEditPrice.Value & ""
            vntArrSumTaxPrice(lngCount) = objSumTaxPrice.Value & ""
            vntArrSumEditTax(lngCount) = objSumEditTax.Value & ""
            vntArrSumPriceTotal(lngCount) = objSumPriceTotal.Value & ""

            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop

        '戻り値の設定
        If IsMissing(vntSumPrice) = False Then vntSumPrice = vntArrSumPrice
        If IsMissing(vntSumEditPrice) = False Then vntSumEditPrice = vntArrSumEditPrice
        If IsMissing(vntSumTaxPrice) = False Then vntSumTaxPrice = vntArrSumTaxPrice
        If IsMissing(vntSumEditTax) = False Then vntSumEditTax = vntArrSumEditTax
        If IsMissing(vntSumPriceTotal) = False Then vntSumPriceTotal = vntArrSumPriceTotal

    End If

    SelectSumDetailItems = lngCount

    Set objOraDyna = Nothing

    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing

    'トランザクションをコミット
    mobjContext.SetComplete
    Exit Function

ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Demand.SelectSumDetailItems"
    WriteErrorLog "ErrNo:" & Err.Number & ":" & Err.Description & ":" & Err.Source

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
'## 2004.06.01 Add End

'## 2004.1.15 Modified Function by Shiramizu@CS 聖路加病院殿向けにメソッドを新規作成
'
' 機能　　 : 検索条件を満たす発送日の一覧を取得する（請求書基本情報）
'
' 引数　　 : (In)   vntIn_BillNo            請求書コード
' 　　　　 : (In)   vntStartPos             SELECT開始位置
' 　　　　 : (In)   vntGetCount             取得件数
' 　　　　 : (Out)  vntBillNo               請求書番号
' 　　　　 : (Out)  vntCloseDate            締め日
' 　　　　 : (Out)  vntBillSeq              請求書Seq
' 　　　　 : (Out)  vntBranchno             請求書枝番
' 　　　　 : (Out)  vntOrgCd1               団体コード１
' 　　　　 : (Out)  vntOrgCd2               団体コード２
' 　　　　 : (Out)  vntOrgName              団体名
' 　　　　 : (Out)  vntOrgKName             団体カナ名
' 　　　　 : (Out)  vntPrtDate              請求書出力日
' 　　　　 : (Out)  vntSumPriceTotal        合計
' 　　　　 : (Out)  vntSumTaxTotal          税額合計
' 　　　　 : (Out)  vntSeq                  Seq
' 　　　　 : (Out)  vntDispatchDate         発送日
' 　　　　 : (Out)  vntUpdUser              更新者ID
' 　　　　 : (Out)  vntUserName             更新者名
' 　　　　 : (Out)  vntUserDate             更新日
' 　　　　 : (Out)  vntDelFlg               取消伝票フラグ
' ### 2004/11/11 Add by Gouda@FSIT 団体請求コメントの追加
'          : (Out)  vntBillComment          請求書コメント
' ### 2004/11/11 Add End
'
' 戻り値　 : 検索条件を満たすレコード件数
'
' 備考　　 :
'
' ### 2004/11/11 Add by Gouda@FSIT 団体請求コメントの追加
'Public Function SelectDmdBurdenDispatch(Optional ByVal vntIn_BillNo As Variant,
'                                    Optional ByVal vntStartPos As Variant, Optional ByVal vntGetCount As Variant,
'                                    Optional ByRef vntBillNo As Variant, Optional ByRef vntCloseDate As Variant,
'                                    Optional ByRef vntBillSeq As Variant, Optional ByRef vntBranchNo As Variant,
'                                    Optional ByRef vntOrgCd1 As Variant, Optional ByRef vntOrgCd2 As Variant,
'                                    Optional ByRef vntOrgName As Variant, Optional ByRef vntOrgKName As Variant,
'                                    Optional ByRef vntPrtDate As Variant,
'                                    Optional ByRef vntSumPriceTotal As Variant, Optional ByRef vntSumTaxTotal As Variant,
'                                    Optional ByRef vntSeq As Variant, Optional ByRef vntDispatchDate As Variant,
'                                    Optional ByRef vntUpdUser As Variant, Optional ByRef vntUserName As Variant,
'                                    Optional ByRef vntUpdDate As Variant, Optional ByRef vntDelFlg As Variant) As Long

Public Function SelectDmdBurdenDispatch(Optional ByVal vntIn_BillNo As Variant, _
                                    Optional ByVal vntStartPos As Variant, Optional ByVal vntGetCount As Variant, _
                                    Optional ByRef vntBillNo As Variant, Optional ByRef vntCloseDate As Variant, _
                                    Optional ByRef vntBillSeq As Variant, Optional ByRef vntBranchNo As Variant, _
                                    Optional ByRef vntOrgCd1 As Variant, Optional ByRef vntOrgCd2 As Variant, _
                                    Optional ByRef vntOrgName As Variant, Optional ByRef vntOrgKName As Variant, _
                                    Optional ByRef vntPrtDate As Variant, _
                                    Optional ByRef vntSumPriceTotal As Variant, Optional ByRef vntSumTaxTotal As Variant, _
                                    Optional ByRef vntSeq As Variant, Optional ByRef vntDispatchDate As Variant, _
                                    Optional ByRef vntUpdUser As Variant, Optional ByRef vntUserName As Variant, _
                                    Optional ByRef vntUpdDate As Variant, Optional ByRef vntDelFlg As Variant, _
                                    Optional ByRef vntBillComment As Variant) As Long
' ### 2004/11/11 Add End

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objBillNo               As OraField         '請求書番号
    Dim objCloseDate            As OraField         '締め日
    Dim objBillSeq              As OraField         '請求書Seq
    Dim objBranchNo             As OraField         '請求書枝番
    Dim objOrgCd1               As OraField         '団体コード１
    Dim objOrgCd2               As OraField         '団体コード２
    Dim objOrgName              As OraField         '団体名
    Dim objOrgKName             As OraField         '団体カナ名
    Dim objPrtDate              As OraField         '請求書出力日
    Dim objSumPriceTotal        As OraField         '入金額合計
    Dim objSumTaxTotal          As OraField         '税額合計
    Dim objSeq                  As OraField         'Seq
    Dim objDispatchDate         As OraField         '発送日
    Dim objUpdUser              As OraField         '更新者ID
    Dim objUserName             As OraField         '更新者名
    Dim objUpdDate              As OraField         '更新日
    Dim objDelFlg               As OraField         '取消伝票フラグ
' ### 2004/11/11 Add by Gouda@FSIT 団体請求コメントの追加
    Dim objBillComment          As OraField         '請求書コメント
' ### 2004/11/11 Add End

    Dim vntArrBillNo()          As Variant          '請求書番号
    Dim vntArrCloseDate()       As Variant          '締め日
    Dim vntArrBillSeq()         As Variant          '請求書Seq
    Dim vntArrBranchNo()        As Variant          '請求書枝番
    Dim vntArrOrgCd1()          As Variant          '団体コード１
    Dim vntArrOrgCd2()          As Variant          '団体コード２
    Dim vntArrOrgName()         As Variant          '団体名
    Dim vntArrOrgKName()        As Variant          '団体カナ名
    Dim vntArrPrtDate()         As Variant          '請求書出力日
    Dim vntArrSumPriceTotal()   As Variant          '入金額合計
    Dim vntArrSumTaxTotal()     As Variant          '税額合計
    Dim vntArrSeq()             As Variant          'Seq
    Dim vntArrDispatchDate()    As Variant          '発送日
    Dim vntArrUpdUser()         As Variant          '更新者ID（発送）
    Dim vntArrUserName()        As Variant          '更新者名（発送）
    Dim vntArrUpdDate()         As Variant          '更新日（発送）
    Dim vntArrDelFlg()          As Variant          '取消伝票フラグ
' ### 2004/11/11 Add by Gouda@FSIT 団体請求コメントの追加
    Dim vntArrBillComment()     As Variant          '請求書コメント
' ### 2004/11/11 Add End

    Dim lngCount                As Long             'レコード数
    Dim blnIsBillNo             As Boolean          'TRUE:請求書番号が指定されている
    
    Dim strCloseDate            As String           '締め日
    Dim lngBillSeq              As Long             '請求書Seq
    Dim lngBranchNo             As Long             '請求書枝番

    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    lngCount = 0
    SelectDmdBurdenDispatch = 0
    blnIsBillNo = False


    '請求書番号の妥当性チェック
    If IsMissing(vntIn_BillNo) = False Then
        vntIn_BillNo = Trim(vntIn_BillNo)
        
        If IsNumeric(vntIn_BillNo) = True Then
            If CDbl(vntIn_BillNo) > 0 Then
                If (Len(vntIn_BillNo) = LENGTH_BILLNO) Then
                    '請求書番号を分解
                    strCloseDate = Mid(vntIn_BillNo, 1, 4) & "/" & Mid(vntIn_BillNo, 5, 2) & "/" & Mid(vntIn_BillNo, 7, 2)
                    lngBillSeq = CLng(Mid(vntIn_BillNo, 9, 5))
                    lngBranchNo = CLng(Mid(vntIn_BillNo, 14, 1))
                    If IsDate(strCloseDate) Then
                        blnIsBillNo = True
                    End If
                End If
            End If
        End If
    End If
    
    '請求書番号が正しく指定されていない場合はエラー
    If blnIsBillNo = False Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    
    '請求書番号が指定されている
    If blnIsBillNo = True Then
        objOraParam.Add "CLOSEDATE", CDate(strCloseDate), ORAPARM_INPUT, ORATYPE_DATE
        objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    End If

'    '取得件数と開始位置が設定されている場合
'    If IsNumeric(vntStartPos) And IsNumeric(vntGetCount) Then
'        objOraParam.Add "SEQ_F", CLng(vntStartPos), ORAPARM_INPUT, ORATYPE_NUMBER
'        objOraParam.Add "SEQ_T", (CLng(vntStartPos) + CLng(vntGetCount) - 1), ORAPARM_INPUT, ORATYPE_NUMBER
'    End If
    
' ### 2004/11/11 Add by Gouda@FSIT 団体請求コメントの追加
    '基本部分
'    strStmt = "SELECT " & vbLf & _
'                        "TO_CHAR(BILL.CLOSEDATE,'YYYY/MM/DD') AS CLOSEDATE, " & vbLf & _
'                        "BILL.BILLSEQ, " & vbLf & _
'                        "BILL.BRANCHNO, " & vbLf & _
'                        "TO_CHAR(BILL.CLOSEDATE,'YYYYMMDD') || " & vbLf & _
'                        "TRIM(TO_CHAR(BILL.BILLSEQ,'00000')) || " & vbLf & _
'                        "TO_CHAR(BILL.BRANCHNO) AS BILLNO, " & vbLf & _
'                        "ORG.ORGCD1, " & vbLf & _
'                        "ORG.ORGCD2, " & vbLf & _
'                        "ORG.ORGNAME, " & vbLf & _
'                        "ORG.ORGKNAME, " & vbLf & _
'                        "TO_CHAR(BILL.PRTDATE,'YYYY/MM/DD') AS PRTDATE, " & vbLf & _
'                        "SUM_BILLDETAIL.SUM_PRICETOTAL, " & vbLf & _
'                        "SUM_BILLDETAIL.SUM_TAXTOTAL, " & vbLf & _
'                        "DISPATCH_VIEW.SEQ, " & vbLf & _
'                        "TO_CHAR(DISPATCH_VIEW.DISPATCHDATE,'YYYY/MM/DD') AS DISPATCHDATE, " & vbLf & _
'                        "TO_CHAR(DISPATCH_VIEW.UPDDATE,'YYYY/MM/DD') AS UPDDATE, " & vbLf & _
'                        "DISPATCH_VIEW.UPDUSER, " & vbLf & _
'                        "DISPATCH_VIEW.USERNAME, " & vbLf & _
'                        "BILL.DELFLG " & vbLf & _
'                         "FROM " & vbLf
   '基本部分
    strStmt = "SELECT " & vbLf & _
                        "TO_CHAR(BILL.CLOSEDATE,'YYYY/MM/DD') AS CLOSEDATE, " & vbLf & _
                        "BILL.BILLSEQ, " & vbLf & _
                        "BILL.BRANCHNO, " & vbLf & _
                        "TO_CHAR(BILL.CLOSEDATE,'YYYYMMDD') || " & vbLf & _
                        "TRIM(TO_CHAR(BILL.BILLSEQ,'00000')) || " & vbLf & _
                        "TO_CHAR(BILL.BRANCHNO) AS BILLNO, " & vbLf & _
                        "ORG.ORGCD1, " & vbLf & _
                        "ORG.ORGCD2, " & vbLf & _
                        "ORG.ORGNAME, " & vbLf & _
                        "ORG.ORGKNAME, " & vbLf & _
                        "TO_CHAR(BILL.PRTDATE,'YYYY/MM/DD') AS PRTDATE, " & vbLf & _
                        "SUM_BILLDETAIL.SUM_PRICETOTAL, " & vbLf & _
                        "SUM_BILLDETAIL.SUM_TAXTOTAL, " & vbLf & _
                        "DISPATCH_VIEW.SEQ, " & vbLf & _
                        "TO_CHAR(DISPATCH_VIEW.DISPATCHDATE,'YYYY/MM/DD') AS DISPATCHDATE, " & vbLf & _
                        "TO_CHAR(DISPATCH_VIEW.UPDDATE,'YYYY/MM/DD') AS UPDDATE, " & vbLf & _
                        "DISPATCH_VIEW.UPDUSER, " & vbLf & _
                        "DISPATCH_VIEW.USERNAME, " & vbLf & _
                        "BILL.DELFLG, " & vbLf & _
                        "BILL.BILLCOMMENT " & vbLf & _
                        "FROM " & vbLf
' ### 2004/11/11 Add End


    '請求書明細サマリ部分
    strStmt = strStmt & "( " & vbLf & _
                        "SELECT " & vbLf & _
                        "BILLDETAIL.CLOSEDATE, " & vbLf & _
                        "BILLDETAIL.BILLSEQ, " & vbLf & _
                        "BILLDETAIL.BRANCHNO, " & vbLf & _
                        "SUM(BILLDETAIL.PRICE + BILLDETAIL.EDITPRICE) AS SUM_PRICETOTAL, " & vbLf & _
                        "SUM(BILLDETAIL.TAXPRICE + BILLDETAIL.EDITTAX) AS SUM_TAXTOTAL " & vbLf & _
                        "FROM " & vbLf & _
                        "BILLDETAIL " & vbLf

    If blnIsBillNo = True Then
        strStmt = strStmt & "WHERE " & vbLf & _
                            "BILLDETAIL.CLOSEDATE = :CLOSEDATE " & vbLf & _
                            "AND BILLDETAIL.BILLSEQ = :BILLSEQ " & vbLf & _
                            "AND BILLDETAIL.BRANCHNO = :BRANCHNO " & vbLf
    End If

    strStmt = strStmt & "GROUP BY " & vbLf & _
                        "BILLDETAIL.CLOSEDATE, " & vbLf & _
                        "BILLDETAIL.BILLSEQ, " & vbLf & _
                        "BILLDETAIL.BRANCHNO " & vbLf & _
                        ") SUM_BILLDETAIL, " & vbLf

    '発送部分
    strStmt = strStmt & "( " & vbLf & _
                        "SELECT " & vbLf & _
                        "DISPATCH.CLOSEDATE, " & vbLf & _
                        "DISPATCH.BILLSEQ, " & vbLf & _
                        "DISPATCH.BRANCHNO, " & vbLf & _
                        "DISPATCH.SEQ, " & vbLf & _
                        "DISPATCH.DISPATCHDATE, " & vbLf & _
                        "DISPATCH.UPDDATE, " & vbLf & _
                        "DISPATCH.UPDUSER, " & vbLf & _
                        "HAINSUSER.USERNAME " & vbLf & _
                        "FROM " & vbLf & _
                        "DISPATCH, " & vbLf & _
                        "HAINSUSER " & vbLf
    
    If blnIsBillNo = True Then
        strStmt = strStmt & "WHERE " & vbLf & _
                            "DISPATCH.CLOSEDATE= :CLOSEDATE " & vbLf & _
                            "AND DISPATCH.BILLSEQ = :BILLSEQ " & vbLf & _
                            "AND DISPATCH.BRANCHNO = :BRANCHNO " & vbLf & _
                            "AND DISPATCH.UPDUSER=HAINSUSER.USERID " & vbLf
    End If
    strStmt = strStmt & ") DISPATCH_VIEW, " & vbLf

    strStmt = strStmt & "ORG, " & vbLf & _
                        "BILL " & vbLf

    '基本部分WHERE句
    If blnIsBillNo = True Then
        strStmt = strStmt & "WHERE " & vbLf & _
                            "BILL.CLOSEDATE= :CLOSEDATE " & vbLf & _
                            "AND BILL.BILLSEQ = :BILLSEQ " & vbLf & _
                            "AND BILL.BRANCHNO = :BRANCHNO " & vbLf
    End If
    strStmt = strStmt & "AND SUM_BILLDETAIL.CLOSEDATE(+)=BILL.CLOSEDATE " & vbLf & _
                        "AND SUM_BILLDETAIL.BILLSEQ(+)=BILL.BILLSEQ " & vbLf & _
                        "AND SUM_BILLDETAIL.BRANCHNO(+)=BILL.BRANCHNO " & vbLf & _
                        "AND DISPATCH_VIEW.CLOSEDATE(+)=BILL.CLOSEDATE " & vbLf & _
                        "AND DISPATCH_VIEW.BILLSEQ(+)=BILL.BILLSEQ " & vbLf & _
                        "AND DISPATCH_VIEW.BRANCHNO(+)=BILL.BRANCHNO " & vbLf & _
                        "AND BILL.ORGCD1=ORG.ORGCD1 " & vbLf & _
                        "AND BILL.ORGCD2=ORG.ORGCD2 " & vbLf
    
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
    
    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objBillNo = objFields("BILLNO")
        Set objCloseDate = objFields("CLOSEDATE")
        Set objBillSeq = objFields("BILLSEQ")
        Set objBranchNo = objFields("BRANCHNO")
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objOrgName = objFields("ORGNAME")
        Set objOrgKName = objFields("ORGKNAME")
        Set objPrtDate = objFields("PRTDATE")
        Set objSumPriceTotal = objFields("SUM_PRICETOTAL")
        Set objSumTaxTotal = objFields("SUM_TAXTOTAL")
        Set objSeq = objFields("SEQ")
        Set objDispatchDate = objFields("DISPATCHDATE")
        Set objUpdUser = objFields("UPDUSER")
        Set objUserName = objFields("USERNAME")
        Set objUpdDate = objFields("UPDDATE")
        Set objDelFlg = objFields("DELFLG")
' ### 2004/11/11 Add by Gouda@FSIT 団体請求コメントの追加
        Set objBillComment = objFields("BILLCOMMENT")
' ### 2004/11/11 Add End

    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            
            '通常モードの場合、引数に応じた結果を返す
            ReDim Preserve vntArrBillNo(lngCount)
            ReDim Preserve vntArrCloseDate(lngCount)
            ReDim Preserve vntArrBillSeq(lngCount)
            ReDim Preserve vntArrBranchNo(lngCount)
            ReDim Preserve vntArrOrgCd1(lngCount)
            ReDim Preserve vntArrOrgCd2(lngCount)
            ReDim Preserve vntArrOrgName(lngCount)
            ReDim Preserve vntArrOrgKName(lngCount)
            ReDim Preserve vntArrPrtDate(lngCount)
            ReDim Preserve vntArrSumPriceTotal(lngCount)
            ReDim Preserve vntArrSumTaxTotal(lngCount)
            ReDim Preserve vntArrSeq(lngCount)
            ReDim Preserve vntArrDispatchDate(lngCount)
            ReDim Preserve vntArrUpdUser(lngCount)
            ReDim Preserve vntArrUserName(lngCount)
            ReDim Preserve vntArrUpdDate(lngCount)
            ReDim Preserve vntArrDelFlg(lngCount)
' ### 2004/11/11 Add by Gouda@FSIT 団体請求コメントの追加
            ReDim Preserve vntArrBillComment(lngCount)
' ### 2004/11/11 Add End

            vntArrBillNo(lngCount) = objBillNo.Value & ""
            vntArrCloseDate(lngCount) = objCloseDate.Value & ""
            vntArrBillSeq(lngCount) = objBillSeq.Value & ""
            vntArrBranchNo(lngCount) = objBranchNo.Value & ""
            vntArrOrgCd1(lngCount) = objOrgCd1.Value & ""
            vntArrOrgCd2(lngCount) = objOrgCd2.Value & ""
            vntArrOrgName(lngCount) = objOrgName.Value & ""
            vntArrOrgKName(lngCount) = objOrgKName.Value & ""
            vntArrPrtDate(lngCount) = objPrtDate.Value & ""
            vntArrSumPriceTotal(lngCount) = objSumPriceTotal.Value & ""
            vntArrSumTaxTotal(lngCount) = objSumTaxTotal.Value & ""
            vntArrSeq(lngCount) = objSeq.Value & ""
            vntArrDispatchDate(lngCount) = objDispatchDate.Value & ""
            vntArrUpdUser(lngCount) = objUpdUser.Value & ""
            vntArrUserName(lngCount) = objUserName.Value & ""
            vntArrUpdDate(lngCount) = objUpdDate.Value & ""
            vntArrDelFlg(lngCount) = objDelFlg.Value & ""
' ### 2004/11/11 Add by Gouda@FSIT 団体請求コメントの追加
            vntArrBillComment(lngCount) = objBillComment.Value & ""
' ### 2004/11/11 Add End

            lngCount = lngCount + 1
            objOraDyna.MoveNext
        Loop
    
    End If
    
    '戻り値の設定
    If IsMissing(vntBillNo) = False Then vntBillNo = vntArrBillNo
    If IsMissing(vntCloseDate) = False Then vntCloseDate = vntArrCloseDate
    If IsMissing(vntBillSeq) = False Then vntBillSeq = vntArrBillSeq
    If IsMissing(vntBranchNo) = False Then vntBranchNo = vntArrBranchNo
    If IsMissing(vntOrgCd1) = False Then vntOrgCd1 = vntArrOrgCd1
    If IsMissing(vntOrgCd2) = False Then vntOrgCd2 = vntArrOrgCd2
    If IsMissing(vntOrgName) = False Then vntOrgName = vntArrOrgName
    If IsMissing(vntPrtDate) = False Then vntPrtDate = vntArrPrtDate
    If IsMissing(vntOrgKName) = False Then vntOrgKName = vntArrOrgKName
    If IsMissing(vntSumPriceTotal) = False Then vntSumPriceTotal = vntArrSumPriceTotal
    If IsMissing(vntSumTaxTotal) = False Then vntSumTaxTotal = vntArrSumTaxTotal
    If IsMissing(vntSeq) = False Then vntSeq = vntArrSeq
    If IsMissing(vntDispatchDate) = False Then vntDispatchDate = vntArrDispatchDate
    If IsMissing(vntUpdUser) = False Then vntUpdUser = vntArrUpdUser
    If IsMissing(vntUserName) = False Then vntUserName = vntArrUserName
    If IsMissing(vntUpdDate) = False Then vntUpdDate = vntArrUpdDate
    If IsMissing(vntDelFlg) = False Then vntDelFlg = vntArrDelFlg
' ### 2004/11/11 Add by Gouda@FSIT 団体請求コメントの追加
    If IsMissing(vntBillComment) = False Then vntBillComment = vntArrBillComment
' ### 2004/11/11 Add End
    
    SelectDmdBurdenDispatch = lngCount
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraDyna = Nothing
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    Exit Function
    
ErrorHandle:
    'イベントログ書き込み
    WriteErrorLog "Demand.SelectDmdBurdenDispatch"
    
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

'## 2003.01.03 Modified Function by ishihara@FSIT 東急殿向け締め処理に合致するよう、メソッドそのものを完全再作成
'
' 機能　　 : 請求書基本情報更新時の妥当性チェックを行う
'
' 引数　　 : (In)       lngBillNo               請求書番号
' 　　　　 : (In/Out)   vntSeq                  ＳＥＱ
' 　　　　 : (In/Out)   vntCsSeq                コースＳＥＱ
' 　　　　 : (In)       strCsOrgCd1             団体コード１
' 　　　　 : (In)       strCsOrgCd2             団体コード２
' 　　　　 : (In)       strIsrSign              健保記号
' 　　　　 : (In)       strCsCd                 コースコード
' 　　　　 : (In)       lngStrYear              開始受診日（年）
' 　　　　 : (In)       lngStrMonth             開始受診日（月）
' 　　　　 : (In)       lngStrDay               開始受診日（日）
' 　　　　 : (In)       lngEndYear              終了受診日（年）
' 　　　　 : (In)       lngEndMonth             終了受診日（月）
' 　　　　 : (In)       lngEndDay               終了受診日（日）
' 　　　　 : (Out)      vntStrDate              開始受診日
' 　　　　 : (Out)      vntEndDate              終了受診日
' 　　　　 : (In)       strCslCnt               受診人数
' 　　　　 : (In)       vntDmdLineClassCd       請求明細分類コード
' 　　　　 : (In)       vntNoPrint              請求書未出力フラグ
' 　　　　 : (In)       vntDetailName           名称
' 　　　　 : (In)       vntAgeDiv               年齢区分
' 　　　　 : (In)       vntExistsIsr            健保有無区分
' 　　　　 : (In)       vntPrice                負担元単価
' 　　　　 : (In)       vntTotalCnt             合計人数
' 　　　　 : (In)       vntSubTotal             金額
' 　　　　 : (In)       vntTax                  消費税
' 　　　　 : (In)       vntDiscount             値引き
' 　　　　 : (In)       vntTotal                合計
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
Public Function CheckValueDmdBurdenModify(ByVal lngBillNo As Long, ByRef vntSeq As Variant, ByRef vntCsSeq As Variant, _
                                          ByVal strCslOrgCd1 As String, ByVal strCslOrgCd2 As String, ByVal strIsrSign As String, _
                                          ByVal strCsCd As String, _
                                          ByVal lngStrYear As Long, ByVal lngStrMonth As Long, ByVal lngStrDay As Long, _
                                          ByVal lngEndYear As Long, ByVal lngEndMonth As Long, ByVal lngEndDay As Long, _
                                          ByRef vntStrDate As Variant, ByRef vntEndDate As Variant, ByVal strCslCnt As String, _
                                          ByVal vntDmdLineClassCd As Variant, _
                                          ByVal vntNoPrint As Variant, _
                                          ByVal vntDetailName As Variant, _
                                          ByVal vntAgeDiv As Variant, _
                                          ByVal vntExistsIsr As Variant, _
                                          ByVal vntPrice As Variant, _
                                          ByVal vntTotalCnt As Variant, _
                                          ByVal vntSubTotal As Variant, _
                                          ByVal vntTax As Variant, _
                                          ByVal vntDiscount As Variant, _
                                          ByVal vntTotal As Variant) As Variant
    
    Dim objCommon               As Common           '共通クラス
    
    Dim vntArrDetailName()      As Variant          '名称の配列
    Dim vntArrPrice()           As Variant          '単価の配列
    Dim vntArrCslMaleCnt1()     As Variant          '男性本人人数の配列
    Dim vntArrCslMaleCnt2()     As Variant          '男性扶養人数の配列
    Dim vntArrCslFemaleCnt1()   As Variant          '女性本人人数の配列
    Dim vntArrCslFemaleCnt2()   As Variant          '女性扶養人数の配列
    Dim vntArrTotalCnt()        As Variant          '人数合計の配列
    Dim vntArrSubTotal()        As Variant          '小計の配列
    Dim vntArrTax()             As Variant          '消費税の配列
    Dim vntArrDiscount()        As Variant          '値引きの配列
    Dim vntArrTotal()           As Variant          '合計の配列
    Dim vntArrNoPrint()         As Variant          '請求書出力の配列
    
    Dim blnArrChecked()         As Boolean          '入力チェック対象フラグの配列
    
    Dim lngArraySize            As Long             '配列のサイズ
    Dim lngInputCount           As Long             '入力行数
    
    Dim vntArrMessage           As Variant          'エラーメッセージの集合
    Dim i                       As Long             'インデックス
    
    Dim strCheckDate            As String
    
    
    '初期処理
    CheckValueDmdBurdenModify = Empty
    vntArrMessage = Empty
    
    '共通クラスのインスタンス作成
    Set objCommon = mobjContext.CreateInstance("HainsCommon.Common")
    
    Do
        '各値チェック処理
        With objCommon
    
            '受診団体チェック
            If strCslOrgCd1 = "" Or strCslOrgCd2 = "" Then
                .AppendArray vntArrMessage, "受診団体を指定してください"
            End If
    
            '開始受診日のチェック
            If (lngStrYear > 0) Or (lngStrMonth > 0) Or (lngStrDay > 0) Then
                strCheckDate = lngStrYear & "/" & lngStrMonth & "/" & lngStrDay
                If IsDate(strCheckDate) Then
                    vntStrDate = CDate(strCheckDate)
                Else
                    .AppendArray vntArrMessage, "開始受診日の日付設定が誤っています。"
                End If
            Else
                vntStrDate = ""
            End If
            
            '終了受診日のチェック
            If (lngEndYear > 0) Or (lngEndMonth > 0) Or (lngEndDay > 0) Then
                strCheckDate = lngEndYear & "/" & lngEndMonth & "/" & lngEndDay
                If IsDate(strCheckDate) Then
                    vntEndDate = CDate(strCheckDate)
                Else
                    .AppendArray vntArrMessage, "終了受診日の日付設定が誤っています。"
                End If
            Else
                vntEndDate = ""
            End If
            
            '開始のみセットなら終了日にも同じものをセットする。
            If vntStrDate <> "" And vntEndDate = "" Then
                vntEndDate = vntStrDate
            End If
            
            '終了のみセットなら開始日にも同じものをセットする。
            If vntStrDate = "" And vntEndDate <> "" Then
                vntStrDate = vntEndDate
            End If
            
            '終了受診日が開始受診日よりも小さいなら逆返し
            If vntStrDate <> "" Then
                If DateDiff("d", CDate(vntStrDate), CDate(vntEndDate)) < 0 Then
                    strCheckDate = vntEndDate
                    vntEndDate = vntStrDate
                    vntStrDate = CDate(strCheckDate)
                End If
            End If
            
            '受診人数の数値チェック
            .AppendArray vntArrMessage, .CheckNumeric("受診人数", strCslCnt, LENGTH_BILLDETAIL_TOTALCNT)

'            '受診コースチェック
'            If strCsCd = "" Then
'                .AppendArray vntArrMessage, "受診コースを指定してください"
'            End If
                        
            'チェック対象判定（どれかが入力されている行をチェックする
            lngInputCount = 0
            ReDim Preserve blnArrChecked(UBound(vntDetailName))
            For i = 0 To UBound(vntDetailName)
                
                If vntDmdLineClassCd(i) <> "" Or vntNoPrint(i) = "1" Or vntDetailName(i) <> "" Or _
                   vntAgeDiv(i) <> "" Or vntExistsIsr(i) <> "" Or vntPrice(i) <> "" Or _
                   vntTotalCnt(i) <> "" Or vntSubTotal(i) <> "" Or vntTax(i) <> "" Or _
                   vntDiscount(i) <> "" Or vntTotal(i) <> "" Then
                
                    lngInputCount = lngInputCount + 1
                
                    '名称チェック
                    .AppendArray vntArrMessage, .CheckLength(CStr(i + 1) & "行目:受診項目明細", vntDetailName(i), LENGTH_BILLDETAIL_DETAILNAME, CHECK_NECESSARY)
                    
                    '受診人数チェック
                    .AppendArray vntArrMessage, .CheckNumeric(CStr(i + 1) & "行目:受診人数", vntTotalCnt(i), LENGTH_BILLDETAIL_TOTALCNT)
                
                    '単価チェック
                    .AppendArray vntArrMessage, .CheckNumericWithSign(CStr(i + 1) & "行目:単価", vntPrice(i), LENGTH_BILLDETAIL_PRICE)
                
                    '小計チェック
                    .AppendArray vntArrMessage, .CheckNumericWithSign(CStr(i + 1) & "行目:小計", vntSubTotal(i), LENGTH_BILLDETAIL_SUBTOTAL)
                
                    '消費税チェック
                    .AppendArray vntArrMessage, .CheckNumericWithSign(CStr(i + 1) & "行目:消費税", vntTax(i), LENGTH_BILLDETAIL_TAX)
                
                    '値引きチェック
                    .AppendArray vntArrMessage, .CheckNumericWithSign(CStr(i + 1) & "行目:値引き", vntDiscount(i), LENGTH_BILLDETAIL_DISCOUNT)
                
                    '合計チェック
                    .AppendArray vntArrMessage, .CheckNumericWithSign(CStr(i + 1) & "行目:合計", vntTotal(i), LENGTH_BILLDETAIL_TOTAL)
                
                End If
            Next
            
            '請求明細行未入力チェック
            If lngInputCount = 0 Then
                .AppendArray vntArrMessage, "明細を１件以上を入力してください"
            End If
            
        End With
    
        Exit Do
    Loop
    
    '戻り値の編集
    If IsArray(vntArrMessage) Then
        CheckValueDmdBurdenModify = vntArrMessage
    End If
    
    Set objCommon = Nothing
    
End Function

'## 2003.01.03 Modified Function by ishihara@FSIT 東急殿向け締め処理に合致するよう、メソッドそのものを完全再作成
'
' 機能　　 : 請求書を更新する
'
' 引数　　 : (In)       lngBillNo               請求書番号
' 　　　　 : (In/Out)   vntSeq                  ＳＥＱ
' 　　　　 : (In/Out)   vntCsSeq                コースＳＥＱ
' 　　　　 : (In)       strCsOrgCd1             団体コード１
' 　　　　 : (In)       strCsOrgCd2             団体コード２
' 　　　　 : (In)       strIsrSign              健保記号
' 　　　　 : (In)       strCsCd                 コースコード
' 　　　　 : (In)       strStrDate              開始受診日
' 　　　　 : (In)       strEndDate              終了受診日
' 　　　　 : (In)       strCslCnt               受診人数
' 　　　　 : (In)       vntDmdLineClassCd       請求明細分類コード
' 　　　　 : (In)       vntNoPrint              請求書未出力フラグ
' 　　　　 : (In)       vntDetailName           名称
' 　　　　 : (In)       vntAgeDiv               年齢区分
' 　　　　 : (In)       vntExistsIsr            健保有無区分
' 　　　　 : (In)       vntPrice                負担元単価
' 　　　　 : (In)       vntTotalCnt             合計人数
' 　　　　 : (In)       vntSubTotal             金額
' 　　　　 : (In)       vntTax                  消費税
' 　　　　 : (In)       vntDiscount             値引き
' 　　　　 : (In)       vntTotal                合計
'
' 戻り値　 : TRUE   正常終了
' 　　　　 : FALSE  異常終了
'
' 備考　　 :
'
'Public Function UpdateDmdBurdenModify(ByVal lngBillNo As Long, _
'                                      ByRef vntSeq As Variant, _
'                                      ByRef vntCsSeq As Variant, _
'                                      ByVal strCslOrgCd1 As String, _
'                                      ByVal strCslOrgCd2 As String, _
'                                      ByVal strIsrSign As String, _
'                                      ByVal strCsCd As String, _
'                                      ByVal strStrDate As String, _
'                                      ByVal strEndDate As String, _
'                                      ByVal strCslCnt As String, _
'                                      ByVal vntDmdLineClassCd As Variant, _
'                                      ByVal vntNoPrint As Variant, _
'                                      ByVal vntDetailName As Variant, _
'                                      ByVal vntAgeDiv As Variant, _
'                                      ByVal vntExistsIsr As Variant, _
'                                      ByVal vntPrice As Variant, _
'                                      ByVal vntTotalCnt As Variant, _
'                                      ByVal vntSubTotal As Variant, _
'                                      ByVal vntTax As Variant, _
'                                      ByVal vntDiscount As Variant, _
'                                      ByVal vntTotal As Variant) As Boolean
'
'    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
'    Dim strStmt                 As String           'SQLステートメント
'
'    Dim lngRet                  As Long             '関数戻り値
'    Dim blnRet                  As Boolean          '関数戻り値
'    Dim strSeq                  As String           'SEQ
'    Dim strCsSeq                As String           'コースSEQ
'
'    'エラーハンドラの設定
'    On Error GoTo ErrorHandle
'
'    '初期処理
'    UpdateDmdBurdenModify = False
'
'    '検索条件が設定されていない場合はエラー
'    If lngBillNo = 0 Then
'        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
'        Exit Function
'    End If
'
'    strSeq = vntSeq
'    strCsSeq = vntCsSeq
'
'    Do
'
'        lngRet = INSERT_ERROR
'
'        '請求団体管理テーブル更新
'        If vntSeq = "" Then
'
'            '請求団体管理テーブル挿入
'            blnRet = InsertBillOrg(lngBillNo, strSeq, strCslOrgCd1, strCslOrgCd2, strIsrSign)
'            If Not blnRet Then Exit Do
'
'        End If
'
'        '請求書団体別コース管理
'        blnRet = RegistBill_Course(lngBillNo, _
'                                   CLng(strSeq), _
'                                   strCsSeq, _
'                                   strCsCd, _
'                                   strStrDate, _
'                                   strEndDate, _
'                                   strCslCnt)
'
'
'        If Not blnRet Then Exit Do
'
'        '請求明細テーブル更新
'        blnRet = UpdateBillDetail(lngBillNo, _
'                                  CLng(strSeq), _
'                                  CLng(strCsSeq), _
'                                  vntDmdLineClassCd, _
'                                  vntNoPrint, _
'                                  vntDetailName, _
'                                  vntAgeDiv, _
'                                  vntExistsIsr, _
'                                  vntPrice, _
'                                  vntTotalCnt, _
'                                  vntSubTotal, _
'                                  vntTax, _
'                                  vntDiscount, _
'                                  vntTotal)
'
'        If Not blnRet Then Exit Do
'
'        lngRet = INSERT_NORMAL
'
'        Exit Do
'    Loop
'
'    If lngRet = INSERT_NORMAL Then
'        mobjContext.SetComplete
'        vntSeq = CLng(strSeq)
'        vntCsSeq = CLng(strCsSeq)
'        '全て正常終了したならSEQ値をセット
'        UpdateDmdBurdenModify = True
'    Else
'        '異常終了ならRollBack
'        mobjContext.SetAbort
'    End If
'
'    Exit Function
'
'ErrorHandle:
'
'    'イベントログ書き込み
'    WriteErrorLog "Demand.UpdateDmdBurdenModify"
'
'    'エラー発生時はトランザクションをアボートに設定
'    mobjContext.SetAbort
'
'    'エラーをもう一回引き起こす
'    Err.Raise Err.Number, Err.Source, Err.Description
'
'    'エラー発生時はトランザクションをアボートに設定
'    mobjContext.SetAbort
'
'End Function

'## 2003.01.03 Modified Function by ishihara@FSIT 東急殿向け締め処理に合致するよう、メソッドそのものを完全再作成
'
' 機能　　 : 請求団体管理情報を更新する
'
' 引数　　 : (In)   lngBillNo        請求書番号
' 　　　　 : (Out)  vntSeq           SEQ(採番)
' 　　　　 : (In)   strCslOrgCd1     受診団体コード１
' 　　　　 : (In)   strCslOrgCd2     受診団体コード２
' 　　　　 : (In)   strIsrSign       健保記号
'
' 戻り値　 : TRUE   正常終了
' 　　　　 : FALSE  異常終了
'
' 備考　　 :
'
Private Function InsertBillOrg(ByVal lngBillNo As Long, _
                               ByRef vntSeq As Variant, _
                               ByVal strCslOrgCd1 As String, _
                               ByVal strCslOrgCd2 As String, _
                               ByVal strIsrSign As String) As Boolean
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim objFields               As OraFields        'OraParametersオブジェクト
    Dim objSeq                  As OraField         'SEQ
    
    Dim strStmt                 As String           'SQLステートメント
    Dim lngSeq                  As Long             'SEQ
    Dim blnDataExists           As Boolean          'TRUE：データ存在、FALSE:データなし
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    InsertBillOrg = False

    '検索条件が設定されていない場合はエラー
    If lngBillNo = 0 Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    '請求書SEQ取得
    blnDataExists = True
    
    Do
        
        'キー値の設定
        Set objOraParam = mobjOraDb.Parameters
        objOraParam.Add "BILLNO", lngBillNo, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "CSLORGCD1", Trim(strCslOrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "CSLORGCD2", Trim(strCslOrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
        objOraParam.Add "ISRSIGN", Trim(strIsrSign), ORAPARM_INPUT, ORATYPE_VARCHAR2
        
        '指定された団体コード、健保記号で同一SEQがないか検索する。
        strStmt = "SELECT SEQ                    " & vbLf & _
                  "  FROM BILL_ORG               " & vbLf & _
                  " WHERE BILLNO    = :BILLNO    " & vbLf & _
                  "   AND CSLORGCD1 = :CSLORGCD1 " & vbLf & _
                  "   AND CSLORGCD2 = :CSLORGCD2 " & vbLf
        
        If Trim(strIsrSign) = "" Then
            strStmt = strStmt & _
                      "   AND ISRSIGN   IS NULL"
        Else
            strStmt = strStmt & _
                      "   AND ISRSIGN   = :ISRSIGN"
        End If
        
        Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
        If objOraDyna.EOF Then
            
            blnDataExists = False
            
            '指定された団体コード、健保記号でSEQが存在しない場合、最大SEQを取得
            Set objOraDyna = Nothing
            strStmt = "SELECT NVL(MAX(SEQ), 0) + 1 SEQ " & vbLf & _
                      "  FROM BILL_ORG                  " & vbLf & _
                      " WHERE BILLNO =  :BILLNO         "
            Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
        End If
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objSeq = objFields("SEQ")
    
        '戻り値の設定
        lngSeq = CLng(objSeq.Value)
        
        '同一団体、健保記号でデータ存在するならここで処理終了
        If blnDataExists = True Then
            InsertBillOrg = True
            Exit Do
        End If
        
        '存在しないなら処理するSEQをパラメタセット
        objOraParam.Add "SEQ", lngSeq, ORAPARM_INPUT, ORATYPE_NUMBER
        
        '請求団体管理を挿入
        strStmt = "INSERT INTO BILL_ORG " & vbLf & _
                  "            (  BILLNO,  SEQ,  CSLORGCD1,  CSLORGCD2,  ISRSIGN )" & vbLf & _
                  "     VALUES ( :BILLNO, :SEQ, :CSLORGCD1, :CSLORGCD2, :ISRSIGN )"
        
        mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
        
        InsertBillOrg = True
        Exit Do
    
    Loop
    
    'SEQは戻り値として設定
    vntSeq = lngSeq
    
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraParam = Nothing
    Set objOraDyna = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.InsertBillOrg"
    
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
    
    'エラー発生時はトランザクションをアボートに設定
    mobjContext.SetAbort

End Function

'## 2003.01.03 Modified Function by ishihara@FSIT 東急殿向け締め処理に合致するよう、メソッドそのものを完全再作成
'
' 機能　　 : 請求書団体別コース管理テーブルを更新する
'
' 引数　　 : (In)       lngBillNo           請求書番号
' 　　　　 : (In)       lngSeq              SEQ
' 　　　　 : (In/Out)   strCsSeq            コースSEQ
' 　　　　 : (In)       strCsCd             コースコード
' 　　　　 : (In)       strStrDate          開始受診日
' 　　　　 : (In)       strEndDate          終了受診日
' 　　　　 : (In)       strCslCnt           受診人数
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Private Function RegistBill_Course(ByVal lngBillNo As Long, _
                                   ByVal lngSeq As Long, _
                                   ByRef strCsSeq As String, _
                                   ByVal strCsCd As String, _
                                   ByVal strStrDate As String, _
                                   ByVal strEndDate As String, _
                                   ByVal strCslCnt As String _
                                   ) As Boolean
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim objFields               As OraFields        'OraParametersオブジェクト
    Dim objCsSeq                As OraField         'コースSEQ
    
    Dim strStmt                 As String           'SQLステートメント
    Dim lngCsSeq                As Long             'CSSEQ
    Dim blnModeInsert           As Boolean          'TRUE:挿入モード、FALSE:更新モード
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    RegistBill_Course = False
    
    '検索条件が設定されていない場合はエラー
    If lngBillNo = 0 Or lngSeq = 0 Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    '更新モードチェック
    blnModeInsert = True
    
    'コースSEQが正しい数値として指定されているなら、更新モード
    If Trim(strCsSeq) <> "" Then
        If IsNumeric(strCsSeq) = True Then
            If CLng(strCsSeq) > 0 Then
                lngCsSeq = CLng(strCsSeq)
                blnModeInsert = False
            End If
        End If
    End If
    
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "BILLNO", lngBillNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "SEQ", lngSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "CSCD", strCsCd, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    'コースSEQが指定されていないなら、取得する必要あり
    If blnModeInsert = True Then
        
        Do
            'コースコードが指定されているなら、指定コースコードで検索する。
            If Trim(strCsCd) <> "" Then
                
                
                '指定された団体コード、健保記号で同一SEQがないか検索する。
                strStmt = "SELECT CSSEQ                  " & vbLf & _
                          "  FROM BILL_COURSE            " & vbLf & _
                          " WHERE BILLNO    = :BILLNO    " & vbLf & _
                          "   AND SEQ       = :SEQ       " & vbLf & _
                          "   AND CSCD      = :CSCD      "
                Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
                If Not objOraDyna.EOF Then
                    
                    'データが存在したなら、そのCSSEQを使用して更新モードにする
                    blnModeInsert = False
                    Exit Do
                End If
            
            End If
    
            '現在の最大SEQを取得する。
            Set objOraDyna = Nothing
            strStmt = "SELECT NVL(MAX(CSSEQ), 0) + 1 CSSEQ " & vbLf & _
                      "  FROM BILL_COURSE                  " & vbLf & _
                      " WHERE BILLNO = :BILLNO             " & vbLf & _
                      "   AND SEQ    = :SEQ                "
            Set objOraDyna = mobjOraDb.CreateDynaset(strStmt, ORADYN_READONLY + ORADYN_NOCACHE)
    
            Exit Do
        
        Loop
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objCsSeq = objFields("CSSEQ")
    
        '戻り値の設定
        lngCsSeq = CLng(objCsSeq.Value)
    
    End If
    
    'ここまできてCSSEQに値がセットされていないとおかしい
    If lngCsSeq < 1 Then
        App.LogEvent vbCrLf & _
                     "webHains Application Error: " & "Logic" & vbCrLf & _
                     "Demand.RegistBill_Course" & " 実行時ｴﾗｰ:'-1' " & "CSSEQの取得に失敗しました。(BILLNO=" & lngBillNo & ",SEQ=" & lngSeq & ",CSCD=" & strCsCd, vbLogEventTypeError
        Exit Function
    End If
    
    'キー値の設定
    objOraParam.Add "CSSEQ", lngCsSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "STRDATE", strStrDate, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "ENDDATE", strEndDate, ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "CSLCNT", strCslCnt, ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    If blnModeInsert = True Then
        strStmt = "INSERT INTO BILL_COURSE " & vbLf & _
                  "            (  BILLNO,  SEQ,  CSSEQ,  CSCD,  STRDATE,  ENDDATE,  CSLCNT )" & vbLf & _
                  "     VALUES ( :BILLNO, :SEQ, :CSSEQ, :CSCD, :STRDATE, :ENDDATE, :CSLCNT )"
    Else
        strStmt = "UPDATE BILL_COURSE                " & vbLf & _
                  "   SET CSCD          = :CSCD,     " & vbLf & _
                  "       STRDATE       = :STRDATE,  " & vbLf & _
                  "       ENDDATE       = :ENDDATE,  " & vbLf & _
                  "       CSLCNT        = :CSLCNT    " & vbLf & _
                  " WHERE BILLNO        = :BILLNO    " & vbLf & _
                  "   AND SEQ           = :SEQ       " & vbLf & _
                  "   AND CSSEQ         = :CSSEQ     "
    End If
    
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    '正常終了ならCSSEQを戻す
    strCsSeq = lngCsSeq
    
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraParam = Nothing
    
    '戻り値の設定
    RegistBill_Course = True
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.RegistBill_Course"
    
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

'## 2004.01.17 Modified Function by Shiramizu@CS 聖路加病院殿向けに、メソッドそのものを完全再作成
'
' 機能　　 : 請求明細を更新する
'
' 引数　　 : (In)   vntBillNo               請求書番号
' 　　　　 : (In)   vntLineNo               明細No.
' 　　　　 : (In)   vntCslDate              受診日
' 　　　　 : (In)   vntDetailName           名称
' 　　　　 : (In)   vntPerId                個人ID
' 　　　　 : (In)   vntPrice                金額
' 　　　　 : (In)   vntEditPrice            調整金額
' 　　　　 : (In)   vntTaxPrice             税額
' 　　　　 : (In)   vntEditTax              調整税額
' 　　　　 : (In)   vntRsvNo                予約番号
' 　　　　 : (In)   vntDayId                当日ID
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function UpdateBillDetail(ByVal vntBillNo As Variant, _
                                  ByVal vntLineNo As Variant, _
                                  ByVal vntCslDate As Variant, _
                                  ByVal vntDetailName As Variant, _
                                  ByVal vntPerId As Variant, _
                                  ByVal vntPrice As Variant, _
                                  ByVal vntEditPrice As Variant, _
                                  ByVal vntTaxPrice As Variant, _
                                  ByVal vntEditTax As Variant, _
                                  ByVal vntRsvNo As Variant, _
                                  ByVal vntDayId As Variant) As Boolean
    
    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    
    Dim blnPerId                As Boolean          'TRUE:個人ID入力
    
    Dim strCloseDate            As String           '締め日
    Dim lngBillSeq              As Long             '請求書Seq
    Dim lngBranchNo             As Long             '請求書枝番
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
 
    '初期処理
    UpdateBillDetail = False
    blnPerId = False
    
    '検索条件が設定されていない場合はエラー
    If Not IsNumeric(vntBillNo) Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    If IsMissing(vntPerId) = False Then
        If Not IsNull(vntPerId) And vntPerId <> "" Then
            blnPerId = True
        End If
    End If
    
    '請求書番号の妥当性チェック
    If IsMissing(vntBillNo) = False Then
        vntBillNo = Trim(vntBillNo)
        If IsNumeric(vntBillNo) = True Then
            If CDbl(vntBillNo) > 0 Then
                If (Len(vntBillNo) = LENGTH_BILLNO) Then
                    '請求書番号を分解
                    strCloseDate = Mid(vntBillNo, 1, 4) & "/" & Mid(vntBillNo, 5, 2) & "/" & Mid(vntBillNo, 7, 2)
                    lngBillSeq = CLng(Mid(vntBillNo, 9, 5))
                    lngBranchNo = CLng(Mid(vntBillNo, 14, 1))
                End If
            End If
        End If
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    
    objOraParam.Add "CSLDATE", CDate(vntCslDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "DETAILNAME", Trim(vntDetailName), ORAPARM_INPUT, ORATYPE_VARCHAR2
    If blnPerId = True Then
        objOraParam.Add "PERID", CStr(vntPerId), ORAPARM_INPUT, ORATYPE_VARCHAR2
    End If
    objOraParam.Add "PRICE", vntPrice, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "EDITPRICE", vntEditPrice, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TAXPRICE", vntTaxPrice, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "EDITTAX", vntEditTax, ORAPARM_INPUT, ORATYPE_NUMBER
    
    objOraParam.Add "CLOSEDATE", CDate(strCloseDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "LINENO", vntLineNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "RSVNO", vntRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "DAYID", vntDayId, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '該当キーの請求書を更新
    If blnPerId = True Then
        strStmt = "UPDATE BILLDETAIL SET ( " & vbLf & _
                  "DETAILNAME, PRICE, " & vbLf & _
                  "EDITPRICE,  TAXPRICE, " & vbLf & _
                  "EDITTAX,    CSLDATE, PERID, LASTNAME, " & vbLf & _
                  "FIRSTNAME,  LASTKNAME, " & vbLf & _
                  "FIRSTKNAME " & vbLf & ")= " & vbLf
        
        strStmt = strStmt & "(SELECT " & vbLf & _
                            ":DETAILNAME ,:PRICE , " & vbLf & _
                            ":EDITPRICE  ,:TAXPRICE , " & vbLf & _
                            ":EDITTAX    ,:CSLDATE , " & vbLf & _
                            "PERSON.PERID, " & vbLf & _
                            "PERSON.LASTNAME, " & vbLf & _
                            "PERSON.FIRSTNAME, " & vbLf & _
                            "PERSON.LASTKNAME, " & vbLf & _
                            "PERSON.FIRSTKNAME " & vbLf & _
                            "FROM " & vbLf & _
                            "PERSON " & vbLf & _
                            "WHERE " & vbLf & _
                            "PERID = :PERID " & vbLf & _
                            "), " & vbLf
        strStmt = strStmt & "RSVNO= " & vbLf & _
                            "CASE WHEN METHOD='0' THEN TO_NUMBER(:RSVNO) " & vbLf & _
                            "WHEN METHOD='1' THEN RSVNO " & vbLf & _
                            "END, " & vbLf & _
                            "DAYID= " & vbLf & _
                            "CASE WHEN METHOD='0' THEN TO_NUMBER(:DAYID) " & vbLf & _
                            "WHEN METHOD='1' THEN DAYID " & vbLf & _
                            "END " & vbLf & _
                            "WHERE " & vbLf & _
                            "CLOSEDATE = :CLOSEDATE " & vbLf & _
                            "AND BILLSEQ = :BILLSEQ " & vbLf & _
                            "AND BRANCHNO = :BRANCHNO " & vbLf & _
                            "AND LINENO = :LINENO " & vbLf
    Else
        strStmt = "UPDATE BILLDETAIL SET " & vbLf & _
                  "DETAILNAME = :DETAILNAME, PRICE = :PRICE, " & vbLf & _
                  "EDITPRICE = :EDITPRICE,   TAXPRICE = :TAXPRICE, " & vbLf & _
                  "EDITTAX = :EDITTAX,       CSLDATE = :CSLDATE, " & vbLf & _
                  "PERID = '', LASTNAME = '', FIRSTNAME = '', " & vbLf & _
                  "LASTKNAME = '', FIRSTKNAME = '', " & vbLf & _
                  "RSVNO = CASE WHEN METHOD=0 THEN TO_NUMBER(:RSVNO) " & vbLf & _
                  "             WHEN METHOD=1 THEN RSVNO " & vbLf & _
                  "        END, " & vbLf & _
                  "DAYID = CASE WHEN METHOD=0 THEN TO_NUMBER(:DAYID) " & vbLf & _
                  "             WHEN METHOD=1 THEN DAYID " & vbLf & _
                  "        END " & vbLf

        strStmt = strStmt & "WHERE " & vbLf & _
                            "CLOSEDATE = :CLOSEDATE " & vbLf & _
                            "AND BILLSEQ = :BILLSEQ " & vbLf & _
                            "AND BRANCHNO = :BRANCHNO " & vbLf & _
                            "AND LINENO = :LINENO " & vbLf
    End If
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)
    
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing
    
    '戻り値の設定
    UpdateBillDetail = True
    
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
    
    'キー重複時はRaise文を使用せず、戻り値を設定して正常終了させる
    If mobjOraDb.LastServerErr = 1 Then
        UpdateBillDetail = INSERT_DUPLICATE
        Exit Function
    End If
        
    UpdateBillDetail = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Demand.UpdateBillDetail"
    
    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function

'## 2004.05.24 Add Str Orb)T.Yaguchi 請求明細内訳の追加
'
' 機能　　 : 請求明細内訳を更新する
'
' 引数　　 : (In)   vntBillNo               請求書番号
' 　　　　 : (In)   vntLineNo               明細No.
' 　　　　 : (In)   vntItemNo               内訳No.
' 　　　　 : (In)   vntSecondLineDicCd      ２次請求明細コード
' 　　　　 : (In)   vntPrice                金額
' 　　　　 : (In)   vntEditPrice            調整金額
' 　　　　 : (In)   vntTaxPrice             税額
' 　　　　 : (In)   vntEditTax              調整税額
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function UpdateBillDetail_Items(ByVal vntBillNo As Variant, _
                                      ByVal vntLineNo As Variant, _
                                      ByVal vntItemNo As Variant, _
                                      ByVal vntSecondLineDivCd As Variant, _
                                      ByVal vntPrice As Variant, _
                                      ByVal vntEditPrice As Variant, _
                                      ByVal vntTaxPrice As Variant, _
                                      ByVal vntEditTax As Variant) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント

    Dim strCloseDate            As String           '締め日
    Dim lngBillSeq              As Long             '請求書Seq
    Dim lngBranchNo             As Long             '請求書枝番

    'エラーハンドラの設定
    On Error GoTo ErrorHandle

    '初期処理
    UpdateBillDetail_Items = False

    '検索条件が設定されていない場合はエラー
    If Not IsNumeric(vntBillNo) Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    If IsNull(vntLineNo) Or vntLineNo = "" Or _
       IsNull(vntItemNo) Or vntItemNo = "" Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If

    '請求書番号の妥当性チェック
    If IsMissing(vntBillNo) = False Then
        vntBillNo = Trim(vntBillNo)
        If IsNumeric(vntBillNo) = True Then
            If CDbl(vntBillNo) > 0 Then
                If (Len(vntBillNo) = LENGTH_BILLNO) Then
                    '請求書番号を分解
                    strCloseDate = Mid(vntBillNo, 1, 4) & "/" & Mid(vntBillNo, 5, 2) & "/" & Mid(vntBillNo, 7, 2)
                    lngBillSeq = CLng(Mid(vntBillNo, 9, 5))
                    lngBranchNo = CLng(Mid(vntBillNo, 14, 1))
                End If
            End If
        End If
    End If

    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters

    objOraParam.Add "SECONDLINEDIVCD", Trim(vntSecondLineDivCd), ORAPARM_INPUT, ORATYPE_VARCHAR2
    objOraParam.Add "PRICE", vntPrice, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "EDITPRICE", vntEditPrice, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "TAXPRICE", vntTaxPrice, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "EDITTAX", vntEditTax, ORAPARM_INPUT, ORATYPE_NUMBER

    objOraParam.Add "CLOSEDATE", CDate(strCloseDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "LINENO", vntLineNo, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "ITEMNO", vntItemNo, ORAPARM_INPUT, ORATYPE_NUMBER

    '該当キーの請求書を更新
    strStmt = "UPDATE BILLDETAIL_ITEMS SET " & vbLf & _
              "SECONDLINEDIVCD = :SECONDLINEDIVCD, PRICE = :PRICE, " & vbLf & _
              "EDITPRICE = :EDITPRICE,   TAXPRICE = :TAXPRICE, " & vbLf & _
              "EDITTAX = :EDITTAX " & vbLf

    strStmt = strStmt & "WHERE " & vbLf & _
                        "CLOSEDATE = :CLOSEDATE " & vbLf & _
                        "AND BILLSEQ = :BILLSEQ " & vbLf & _
                        "AND BRANCHNO = :BRANCHNO " & vbLf & _
                        "AND LINENO = :LINENO " & vbLf & _
                        "AND ITEMNO = :ITEMNO " & vbLf
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    Set objOraParam = Nothing

    '戻り値の設定
    UpdateBillDetail_Items = True

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

    'キー重複時はRaise文を使用せず、戻り値を設定して正常終了させる
    If mobjOraDb.LastServerErr = 1 Then
        UpdateBillDetail_Items = INSERT_DUPLICATE
        Exit Function
    End If

    UpdateBillDetail_Items = INSERT_ERROR

    'イベントログ書き込み
    WriteErrorLog "Demand.UpdateBillDetail_Items"

    'エラーをもう一回引き起こす
    Err.Raise Err.Number, Err.Source, Err.Description

End Function


'## 2004.1.9 Modified Function by Shiramizu@CS 聖路加病院殿向けにメソッドそのものを完全再作成
'
' 機能　　 : 検索条件を満たす受診者の一覧を取得する（請求書検索）
'
' 引数　　 : (In)   vntMode                 取得モード(NULL:通常取得、"CNT":検索条件での請求書数を数える）
' 　　　　 : (In)   vntIn_StrDate           開始締め日
' 　　　　 : (In)   vntIn_EndDate           終了締め日
' 　　　　 : (In)   vntIn_BillNo            請求書コード
' 　　　　 : (In)   vntIn_OrgCd1            団体コード１
' 　　　　 : (In)   vntIn_OrgCd2            団体コード２
' 　　　　 : (In)   vntIn_IsDispatch        請求書発送状態（1:発送済みのみ、2:未発送のみ）
' 　　　　 : (In)   vntIn_IsPayment         入金状態（1:入金済みのみ、2:未収のみ）
' 　　　　 : (In)   vntIn_IsCancel          取消伝票表示（1:表示）
' 　　　　 : (In)   vntStartPos             SELECT開始位置
' 　　　　 : (In)   vntGetCount             取得件数
' 　　　　 : (In)   vntSortName             ソート項目名
' 　　　　 : (In)   vntSortType             ソート順（1:昇順、2:降順）
' 　　　　 : (Out)  vntBillNo               請求書番号
' 　　　　 : (Out)  vntCloseDate            締め日
' 　　　　 : (Out)  vntBillSeq              請求書Seq
' 　　　　 : (Out)  vntBranchno             請求書枝番
' 　　　　 : (Out)  vntOrgCd1               団体コード１
' 　　　　 : (Out)  vntOrgCd2               団体コード２
' 　　　　 : (Out)  vntOrgName              団体名
' 　　　　 : (Out)  vntOrgKName             団体カナ名
' 　　　　 : (Out)  vntMethod               請求書作成方法
' 　　　　 : (Out)  vntPrtDate              請求書出力日
' 　　　　 : (Out)  vntDispatchDate         発送日
' 　　　　 : (Out)  vntPaymentDate          入金日
' 　　　　 : (Out)  vntPriceTotal           小計
' 　　　　 : (Out)  vntTaxTotal             税額
' 　　　　 : (Out)  vntBillTotal            請求金額
' 　　　　 : (Out)  vntPaymentPrice         入金額
' 　　　　 : (Out)  vntSumPaymentPrice      入金額合計
' 　　　　 : (Out)  vntUpdUser              更新者ID（入金）
' 　　　　 : (Out)  vntUserName             更新者名（入金）
' 　　　　 : (Out)  vntSeq                  Seq（入金）
' 　　　　 : (Out)  vntDelFlg               取消伝票フラグ
' ### 2004/11/11 Add by Gouda@FSIT 団体請求コメントの追加
'          : (Out)  vntBillComment          請求書コメント
' ### 2004/11/11 Add End

'
' 戻り値　 : 検索条件を満たすレコード件数（モードがCNTの場合、請求書枚数ベース、通常の場合レコード件数ベース）
'
' 備考　　 :
'
'Public Function SelectDmdBurdenList(ByVal vntMode As Variant,
'                                    Optional ByVal vntIn_StrDate As Variant, Optional ByVal vntIn_EndDate As Variant, Optional ByVal vntIn_BillNo As Variant,
'                                    Optional ByVal vntIn_OrgCd1 As Variant, Optional ByVal vntIn_OrgCd2 As Variant,
'                                    Optional ByVal vntIn_IsDispatch As Variant, Optional ByVal vntIn_IsPayment As Variant, Optional ByVal vntIn_IsCancel As Variant,
'                                    Optional ByVal vntStartPos As Variant, Optional ByVal vntGetCount As Variant,
'                                    Optional ByVal vntSortName As Variant, Optional ByVal vntSortType As Variant,
'                                    Optional ByRef vntBillNo As Variant, Optional ByRef vntCloseDate As Variant,
'                                    Optional ByRef vntBillSeq As Variant, Optional ByRef vntBranchNo As Variant,
'                                    Optional ByRef vntOrgCd1 As Variant, Optional ByRef vntOrgCd2 As Variant,
'                                    Optional ByRef vntOrgName As Variant, Optional ByRef vntOrgKName As Variant,
'                                    Optional ByRef vntMethod As Variant, Optional ByRef vntPrtDate As Variant,
'                                    Optional ByRef vntDispatchDate As Variant, Optional ByRef vntPaymentDate As Variant,
'                                    Optional ByRef vntPriceTotal As Variant, Optional ByRef vntTaxTotal As Variant,
'                                    Optional ByRef vntBillTotal As Variant, Optional ByRef vntPaymentPrice As Variant, Optional ByRef vntSumPaymentPrice As Variant,
'                                    Optional ByRef vntUpdUser As Variant, Optional ByRef vntUserName As Variant,
'                                    Optional ByRef vntSeq As Variant, Optional ByRef vntDelFlg As Variant) As Long

Public Function SelectDmdBurdenList(ByVal vntMode As Variant, _
                                    Optional ByVal vntIn_StrDate As Variant, Optional ByVal vntIn_EndDate As Variant, Optional ByVal vntIn_BillNo As Variant, _
                                    Optional ByVal vntIn_OrgCd1 As Variant, Optional ByVal vntIn_OrgCd2 As Variant, _
                                    Optional ByVal vntIn_IsDispatch As Variant, Optional ByVal vntIn_IsPayment As Variant, Optional ByVal vntIn_IsCancel As Variant, _
                                    Optional ByVal vntStartPos As Variant, Optional ByVal vntGetCount As Variant, _
                                    Optional ByVal vntSortName As Variant, Optional ByVal vntSortType As Variant, _
                                    Optional ByRef vntBillNo As Variant, Optional ByRef vntCloseDate As Variant, _
                                    Optional ByRef vntBillSeq As Variant, Optional ByRef vntBranchNo As Variant, _
                                    Optional ByRef vntOrgCd1 As Variant, Optional ByRef vntOrgCd2 As Variant, _
                                    Optional ByRef vntOrgName As Variant, Optional ByRef vntOrgKName As Variant, _
                                    Optional ByRef vntMethod As Variant, Optional ByRef vntPrtDate As Variant, _
                                    Optional ByRef vntDispatchDate As Variant, Optional ByRef vntPaymentDate As Variant, _
                                    Optional ByRef vntPriceTotal As Variant, Optional ByRef vntTaxTotal As Variant, _
                                    Optional ByRef vntBillTotal As Variant, Optional ByRef vntPaymentPrice As Variant, Optional ByRef vntSumPaymentPrice As Variant, _
                                    Optional ByRef vntUpdUser As Variant, Optional ByRef vntUserName As Variant, _
                                    Optional ByRef vntSeq As Variant, Optional ByRef vntDelFlg As Variant, _
                                    Optional ByRef vntBillComment As Variant) As Long

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna              As OraDynaset       'ダイナセット
    Dim strStmt                 As String           'SQLステートメント
    
    Dim objFields               As OraFields        'フィールドオブジェクト
    Dim objBillNo               As OraField         '請求書番号
    Dim objRowSeq               As OraField         '取得番号（１請求書で１）
    Dim objCloseDate            As OraField         '締め日
    Dim objBillSeq              As OraField         '請求書Seq
    Dim objBranchNo             As OraField         '請求書枝番
    Dim objOrgCd1               As OraField         '団体コード１
    Dim objOrgCd2               As OraField         '団体コード２
    Dim objOrgName              As OraField         '団体名
    Dim objOrgKName             As OraField         '団体カナ名
    Dim objMethod               As OraField         '請求書作成方法
    Dim objPrtDate              As OraField         '請求書出力日
    Dim objDispatchDate         As OraField         '発送日
    Dim objPaymentDate          As OraField         '入金日
    Dim objPriceTotal           As OraField         '小計
    Dim objTaxTotal             As OraField         '税額
    Dim objBillTotal            As OraField         '請求金額
    Dim objPaymentPrice         As OraField         '入金額
    Dim objSumPaymentPrice      As OraField         '入金額合計
    Dim objUpdUser              As OraField         '更新者ID（入金）
    Dim objUserName             As OraField         '更新者名（入金）
    Dim objSeq                  As OraField         'Seq（入金）
    Dim objDelFlg               As OraField         '取消伝票フラグ
' ### 2004/11/11 Add by Gouda@FSIT 団体請求コメントの追加
    Dim objBillComment          As OraField         '請求書コメント
' ### 2004/11/11 Add End
    
    Dim vntArrBillNo()          As Variant          '請求書番号
    Dim vntArrRowSeq()          As Variant          '取得番号（１請求書で１）
    Dim vntArrCloseDate()       As Variant          '締め日
    Dim vntArrBillSeq()         As Variant          '請求書Seq
    Dim vntArrBranchNo()        As Variant          '請求書枝番
    Dim vntArrOrgCd1()          As Variant          '団体コード１
    Dim vntArrOrgCd2()          As Variant          '団体コード２
    Dim vntArrOrgName()         As Variant          '団体名
    Dim vntArrOrgKName()        As Variant          '団体カナ名
    Dim vntArrMethod()          As Variant          '請求書作成方法
    Dim vntArrPrtDate()         As Variant          '請求書出力日
    Dim vntArrDispatchDate()    As Variant          '発送日
    Dim vntArrPaymentDate()     As Variant          '入金日
    Dim vntArrPriceTotal()      As Variant          '小計
    Dim vntArrTaxTotal()        As Variant          '税額
    Dim vntArrBillTotal()       As Variant          '請求金額
    Dim vntArrPaymentPrice()    As Variant          '入金額
    Dim vntArrSumPaymentPrice() As Variant          '入金額合計
    Dim vntArrUpdUser()         As Variant          '更新者ID（入金）
    Dim vntArrUserName()        As Variant          '更新者名（入金）
    Dim vntArrSeq()             As Variant          'Seq（入金）
    Dim vntArrDelFlg()          As Variant          '取消伝票フラグ
' ### 2004/11/11 Add by Gouda@FSIT 団体請求コメントの追加
    Dim vntArrBillComment()     As Variant          '請求書コメント
' ### 2004/11/11 Add End

    Dim lngCount                As Long             'レコード数
    Dim blnIsCloseDate          As Boolean          'TRUE:締め日範囲が指定されている
    Dim blnIsBillNo             As Boolean          'TRUE:請求書番号が指定されている
    Dim blnIsOrgCd              As Boolean          'TRUE:請求先団体が指定されている
    Dim blnIsPayment            As Boolean          'TRUE:未収「入金済みのみ」が指定されている
    Dim blnIsNoPayment          As Boolean          'TRUE:未収「未収のみ」が指定されている
    Dim blnIsDispatch           As Boolean          'TRUE:発送状態「発送済みのみ」が指定されている
    Dim blnIsNoDispatch         As Boolean          'TRUE:発送状態「未発送のみ」が指定されている
    Dim blnIsCancel             As Boolean          'TRUE:取消伝票も表示
    Dim blnIsWhere              As Boolean          'TRUE:WHERE句出力済み'
    
    Dim strCloseDate            As String           '締め日
    Dim lngBillSeq              As Long             '請求書Seq
    Dim lngBranchNo             As Long             '請求書枝番
    Dim strOrderPaymentDate     As String           'ソート用の入金日
    
'### 2004/3/17 Added by Ishihara@FSIT ご要望によりソート条件追加(--;)
    Dim strDescAsc              As String
'### 2004/3/17 Added End
    
    If vntMode <> "CNT" Then
        If vntSortType = "2" Then
            strOrderPaymentDate = "1000/01/01"
        Else
            strOrderPaymentDate = "9999/01/01"
        End If
    End If
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    lngCount = 0
    SelectDmdBurdenList = 0
    blnIsCloseDate = False
    blnIsBillNo = False
    blnIsOrgCd = False
    blnIsPayment = False
    blnIsNoPayment = False
    blnIsDispatch = False
    blnIsNoDispatch = False
    blnIsCancel = False

    '締め日範囲の妥当性チェック
    If (IsMissing(vntIn_StrDate) = False) And (IsMissing(vntIn_EndDate) = False) Then
        vntIn_StrDate = Trim(vntIn_StrDate)
        vntIn_EndDate = Trim(vntIn_EndDate)
        If (IsDate(vntIn_StrDate) = True) And (IsDate(vntIn_EndDate) = True) Then
            blnIsCloseDate = True
        End If
    End If
       
    '請求書番号の妥当性チェック
    If IsMissing(vntIn_BillNo) = False Then
        vntIn_BillNo = Trim(vntIn_BillNo)
        
        If IsNumeric(vntIn_BillNo) = True Then
            If CDbl(vntIn_BillNo) > 0 Then
            '2004/01/13 Shiramizu Modified Start
                If (Len(vntIn_BillNo) = LENGTH_BILLNO) Then
                    '請求書番号を分解
                    strCloseDate = Mid(vntIn_BillNo, 1, 4) & "/" & Mid(vntIn_BillNo, 5, 2) & "/" & Mid(vntIn_BillNo, 7, 2)
                    lngBillSeq = CLng(Mid(vntIn_BillNo, 9, 5))
                    lngBranchNo = CLng(Mid(vntIn_BillNo, 14, 1))
                    If IsDate(strCloseDate) Then
                        blnIsBillNo = True
                    End If
                End If
            '2004/01/13 Shiramizu Modified End
            End If
        End If
    End If
    
    '締め日範囲も請求書番号も正しく指定されていない場合はエラー
    If blnIsCloseDate = False And blnIsBillNo = False Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    
    '請求書番号が指定されている
    If blnIsBillNo = True Then
        objOraParam.Add "CLOSEDATE", CDate(strCloseDate), ORAPARM_INPUT, ORATYPE_DATE
        objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    
    '締め日範囲が設定されている（請求書番号がない場合のみ）
    If (blnIsCloseDate = True) And (blnIsBillNo = False) Then
        objOraParam.Add "STRDATE", CDate(vntIn_StrDate), ORAPARM_INPUT, ORATYPE_DATE
        objOraParam.Add "ENDDATE", CDate(vntIn_EndDate), ORAPARM_INPUT, ORATYPE_DATE
    End If
    
    '負担元が設定されている
    If (IsMissing(vntIn_OrgCd1) = False) And (IsMissing(vntIn_OrgCd2) = False) Then
        If (Trim(vntIn_OrgCd1) <> "") And (Trim(vntIn_OrgCd2) <> "") Then
            objOraParam.Add "ORGCD1", Trim(vntIn_OrgCd1), ORAPARM_INPUT, ORATYPE_VARCHAR2
            objOraParam.Add "ORGCD2", Trim(vntIn_OrgCd2), ORAPARM_INPUT, ORATYPE_VARCHAR2
            blnIsOrgCd = True
        End If
    End If
    
    '請求書発送状態が設定されている。
    If IsMissing(vntIn_IsDispatch) = False Then
        If Trim(vntIn_IsDispatch) = "1" Then
            blnIsDispatch = True
        End If
        If Trim(vntIn_IsDispatch) = "2" Then
            blnIsNoDispatch = True
        End If
    End If

    '入金状態が設定されている。
    If IsMissing(vntIn_IsPayment) = False Then
        If Trim(vntIn_IsPayment) = "1" Then
            blnIsPayment = True
        End If
        If Trim(vntIn_IsPayment) = "2" Then
            blnIsNoPayment = True
        End If
    End If

    '取消伝票表示
    If IsMissing(vntIn_IsCancel) = False Then
        If Trim(vntIn_IsCancel) = "1" Then
            blnIsCancel = True
        End If
    End If
    
    '取得件数と開始位置が設定されている場合
    If IsNumeric(vntStartPos) And IsNumeric(vntGetCount) Then
        objOraParam.Add "SEQ_F", CLng(vntStartPos), ORAPARM_INPUT, ORATYPE_NUMBER
        objOraParam.Add "SEQ_T", (CLng(vntStartPos) + CLng(vntGetCount) - 1), ORAPARM_INPUT, ORATYPE_NUMBER
    End If
    
    
    'Rownumで範囲指定するため、結果セットを丸ごとViewにする
    strStmt = "SELECT " & vbLf & _
              "BASE_VIEW.* " & vbLf & _
              "FROM " & vbLf & _
              "(" & vbLf & _
              "SELECT " & vbLf & _
              "MAIN_VIEW.*, " & vbLf & _
              "ROWNUM As ROWSEQ " & vbLf & _
              "FROM " & vbLf & _
              "("

' ### 2004/11/11 Add by Gouda@FSIT 団体請求コメントの追加
    '基本部分SELECT句
'    strStmt = strStmt & "SELECT  " & vbLf & _
'              "BILL.CLOSEDATE, BILL.BILLSEQ, " & vbLf & _
'              "BILL.BRANCHNO, " & vbLf & _
'              "TO_CHAR(BILL.CLOSEDATE,'YYYYMMDD') || " & vbLf & _
'              "TRIM(TO_CHAR(BILL.BILLSEQ,'00000')) || " & vbLf & _
'              "TO_CHAR(BILL.BRANCHNO) AS BILLNO, " & vbLf & _
'              "PAYMENT_VIEW.SEQ AS PAYMENTSEQ, " & vbLf & _
'              "BILL.ORGCD1, BILL.ORGCD2, " & vbLf & _
'              "BILL.PRTDATE, BILL.METHOD, " & vbLf & _
'              "ORG.ORGNAME, ORG.ORGKNAME, " & vbLf & _
'              "SUM_BILLDETAIL.PRICETOTAL, SUM_BILLDETAIL.TAXTOTAL, " & vbLf & _
'              "SUM_BILLDETAIL.PRICETOTAL + SUM_BILLDETAIL.TAXTOTAL AS BILLTOTAL, " & vbLf & _
'              "LAST_DISPATCH.DISPATCHDATE, " & vbLf & _
'              "SUM_PAYMENT.SUM_PAYMENTPRICE, " & vbLf & _
'              "PAYMENT_VIEW.SEQ, " & vbLf & _
'              "PAYMENT_VIEW.PAYMENTPRICE, " & vbLf & _
'              "PAYMENT_VIEW.PAYMENTDATE, " & vbLf & _
'              "PAYMENT_VIEW.UPDUSER, " & vbLf & _
'              "PAYMENT_VIEW.USERNAME, " & vbLf & _
'              "NVL(PAYMENT_VIEW.PAYMENTDATE,'" & strOrderPaymentDate & "') AS ORDER_PAYMENTDATE, " & vbLf & _
'              "BILL.DELFLG " & vbLf & _
'              "FROM " & vbLf & _
'              "BILL, " & vbLf & _
'              "ORG, " & vbLf

    strStmt = strStmt & "SELECT  " & vbLf & _
              "BILL.CLOSEDATE, BILL.BILLSEQ, " & vbLf & _
              "BILL.BRANCHNO, " & vbLf & _
              "TO_CHAR(BILL.CLOSEDATE,'YYYYMMDD') || " & vbLf & _
              "TRIM(TO_CHAR(BILL.BILLSEQ,'00000')) || " & vbLf & _
              "TO_CHAR(BILL.BRANCHNO) AS BILLNO, " & vbLf & _
              "PAYMENT_VIEW.SEQ AS PAYMENTSEQ, " & vbLf & _
              "BILL.ORGCD1, BILL.ORGCD2, " & vbLf & _
              "BILL.PRTDATE, BILL.METHOD, " & vbLf & _
              "ORG.ORGNAME, ORG.ORGKNAME, " & vbLf & _
              "SUM_BILLDETAIL.PRICETOTAL, SUM_BILLDETAIL.TAXTOTAL, " & vbLf & _
              "SUM_BILLDETAIL.PRICETOTAL + SUM_BILLDETAIL.TAXTOTAL AS BILLTOTAL, " & vbLf & _
              "LAST_DISPATCH.DISPATCHDATE, " & vbLf & _
              "SUM_PAYMENT.SUM_PAYMENTPRICE, " & vbLf & _
              "PAYMENT_VIEW.SEQ, " & vbLf & _
              "PAYMENT_VIEW.PAYMENTPRICE, " & vbLf & _
              "PAYMENT_VIEW.PAYMENTDATE, " & vbLf & _
              "PAYMENT_VIEW.UPDUSER, " & vbLf & _
              "PAYMENT_VIEW.USERNAME, " & vbLf & _
              "NVL(PAYMENT_VIEW.PAYMENTDATE,'" & strOrderPaymentDate & "') AS ORDER_PAYMENTDATE, " & vbLf & _
              "BILL.DELFLG, " & vbLf & _
              "BILL.BILLCOMMENT " & vbLf & _
              "FROM " & vbLf & _
              "BILL, " & vbLf & _
              "ORG, " & vbLf
' ### 2004/11/11 Add End
    
    '請求書明細サマリ部分
    strStmt = strStmt & "( " & vbLf & _
              "SELECT " & vbLf & _
              "BILLDETAIL.CLOSEDATE, " & vbLf & _
              "BILLDETAIL.BILLSEQ, " & vbLf & _
              "BILLDETAIL.BRANCHNO, " & vbLf & _
              "SUM(BILLDETAIL.PRICE) AS PRICE, " & vbLf & _
              "SUM(BILLDETAIL.EDITPRICE) AS EDITPRICE, " & vbLf & _
              "SUM(BILLDETAIL.PRICE) + SUM(BILLDETAIL.EDITPRICE) AS PRICETOTAL, " & vbLf & _
              "SUM(BILLDETAIL.TAXPRICE) AS TAXPRICE, " & vbLf & _
              "SUM(BILLDETAIL.EDITTAX) AS EDITTAX, " & vbLf & _
              "SUM(BILLDETAIL.TAXPRICE) + SUM(BILLDETAIL.EDITTAX) AS TAXTOTAL " & vbLf & _
              "FROM " & vbLf & _
              "BILLDETAIL " & vbLf

    '請求書番号が指定されている
    If blnIsBillNo = True Then
        strStmt = strStmt & _
              "WHERE BILLDETAIL.CLOSEDATE = :CLOSEDATE " & vbLf & _
              "AND BILLDETAIL.BILLSEQ = :BILLSEQ " & vbLf & _
              "AND BILLDETAIL.BRANCHNO = :BRANCHNO " & vbLf
    End If
    
    '締め日範囲が設定されている（請求書番号がない場合のみ）
    If (blnIsCloseDate = True) And (blnIsBillNo = False) Then
        strStmt = strStmt & _
              "          WHERE BILLDETAIL.CLOSEDATE BETWEEN :STRDATE AND :ENDDATE" & vbLf
    End If
    
    
    strStmt = strStmt & "GROUP BY " & vbLf & _
              "BILLDETAIL.CLOSEDATE, " & vbLf & _
              "BILLDETAIL.BILLSEQ, " & vbLf & _
              "BILLDETAIL.BRANCHNO" & vbLf & _
              ") SUM_BILLDETAIL, " & vbLf

'## 2004.07.08 ADD STR ORB)T.YAGUCHI ２次金額追加
    '２次請求書明細サマリ部分
    strStmt = strStmt & "( " & vbLf & _
              "SELECT " & vbLf & _
              "BILLDETAIL_ITEMS.CLOSEDATE, " & vbLf & _
              "BILLDETAIL_ITEMS.BILLSEQ, " & vbLf & _
              "BILLDETAIL_ITEMS.BRANCHNO, " & vbLf & _
              "SUM(BILLDETAIL_ITEMS.PRICE) AS PRICE, " & vbLf & _
              "SUM(BILLDETAIL_ITEMS.EDITPRICE) AS EDITPRICE, " & vbLf & _
              "SUM(BILLDETAIL_ITEMS.PRICE) + SUM(BILLDETAIL_ITEMS.EDITPRICE) AS PRICETOTAL, " & vbLf & _
              "SUM(BILLDETAIL_ITEMS.TAXPRICE) AS TAXPRICE, " & vbLf & _
              "SUM(BILLDETAIL_ITEMS.EDITTAX) AS EDITTAX, " & vbLf & _
              "SUM(BILLDETAIL_ITEMS.TAXPRICE) + SUM(BILLDETAIL_ITEMS.EDITTAX) AS TAXTOTAL " & vbLf & _
              "FROM " & vbLf & _
              "BILLDETAIL_ITEMS " & vbLf

    '請求書番号が指定されている
    If blnIsBillNo = True Then
        strStmt = strStmt & _
              "WHERE BILLDETAIL_ITEMS.CLOSEDATE = :CLOSEDATE " & vbLf & _
              "AND BILLDETAIL_ITEMS.BILLSEQ = :BILLSEQ " & vbLf & _
              "AND BILLDETAIL_ITEMS.BRANCHNO = :BRANCHNO " & vbLf
    End If
    
    '締め日範囲が設定されている（請求書番号がない場合のみ）
    If (blnIsCloseDate = True) And (blnIsBillNo = False) Then
        strStmt = strStmt & _
              "          WHERE BILLDETAIL_ITEMS.CLOSEDATE BETWEEN :STRDATE AND :ENDDATE" & vbLf
    End If
    
    
    strStmt = strStmt & "GROUP BY " & vbLf & _
              "BILLDETAIL_ITEMS.CLOSEDATE, " & vbLf & _
              "BILLDETAIL_ITEMS.BILLSEQ, " & vbLf & _
              "BILLDETAIL_ITEMS.BRANCHNO" & vbLf & _
              ") SUM_BILLDETAIL_ITEMS, " & vbLf
'## 2004.07.08 ADD END

    '入金情報サマリ部分
    strStmt = strStmt & "(SELECT " & vbLf & _
              "PAYMENT.CLOSEDATE, " & vbLf & _
              "PAYMENT.BILLSEQ, " & vbLf & _
              "PAYMENT.BRANCHNO, " & vbLf & _
              "SUM(PAYMENT.PAYMENTPRICE) AS SUM_PAYMENTPRICE " & vbLf & _
              "FROM PAYMENT " & vbLf

    '請求書番号が指定されている
    If blnIsBillNo = True Then
        strStmt = strStmt & _
              "WHERE PAYMENT.CLOSEDATE = :CLOSEDATE " & vbLf & _
              "AND PAYMENT.BILLSEQ = :BILLSEQ " & vbLf & _
              "AND PAYMENT.BRANCHNO = :BRANCHNO " & vbLf
    End If
    
    '締め日範囲が設定されている（請求書番号がない場合のみ）
    If (blnIsCloseDate = True) And (blnIsBillNo = False) Then
        strStmt = strStmt & _
              "WHERE PAYMENT.CLOSEDATE BETWEEN :STRDATE AND :ENDDATE " & vbLf
    End If

    strStmt = strStmt & "GROUP BY  " & vbLf & _
              "PAYMENT.CLOSEDATE, " & vbLf & _
              "PAYMENT.BILLSEQ, " & vbLf & _
              "PAYMENT.BRANCHNO " & vbLf & _
              ") SUM_PAYMENT, " & vbLf
    
    '入金管理部分
    strStmt = strStmt & "(" & vbLf & _
              "SELECT" & vbLf & _
              "PAYMENT.CLOSEDATE, " & vbLf & _
              "PAYMENT.BILLSEQ, " & vbLf & _
              "PAYMENT.BRANCHNO, " & vbLf & _
              "PAYMENT.SEQ," & vbLf & _
              "PAYMENT.PAYMENTPRICE, " & vbLf & _
              "PAYMENT.PAYMENTDATE, " & vbLf & _
              "PAYMENT.UPDUSER," & vbLf & _
              "HAINSUSER.USERNAME " & vbLf & _
              "FROM " & vbLf & _
              "PAYMENT, " & vbLf & _
              "HAINSUSER " & vbLf & _
              "WHERE " & vbLf & _
              "PAYMENT.UPDUSER=HAINSUSER.USERID " & vbLf
    
    '請求書番号が指定されている
    If blnIsBillNo = True Then
        strStmt = strStmt & _
              "AND PAYMENT.CLOSEDATE = :CLOSEDATE " & vbLf & _
              "AND PAYMENT.BILLSEQ = :BILLSEQ " & vbLf & _
              "AND PAYMENT.BRANCHNO = :BRANCHNO " & vbLf
    End If
    
    '締め日範囲が設定されている（請求書番号がない場合のみ）
    If (blnIsCloseDate = True) And (blnIsBillNo = False) Then
        strStmt = strStmt & _
              "AND PAYMENT.CLOSEDATE BETWEEN :STRDATE AND :ENDDATE " & vbLf
    End If
        strStmt = strStmt & _
              ") PAYMENT_VIEW, " & vbLf
    
    
    '発送日最終レコード取得部分
    strStmt = strStmt & "( " & vbLf & _
              "SELECT " & vbLf & _
              "DISPATCH.CLOSEDATE, " & vbLf & _
              "DISPATCH.BILLSEQ, " & vbLf & _
              "DISPATCH.BRANCHNO, " & vbLf & _
              "TO_CHAR(DISPATCH.DISPATCHDATE,'YYYY/MM/DD') AS DISPATCHDATE " & vbLf & _
              "FROM " & vbLf & _
              "DISPATCH " & vbLf & _
              "WHERE " & vbLf & _
              "(CLOSEDATE,BILLSEQ,BRANCHNO,SEQ) IN( " & vbLf & _
              "SELECT " & vbLf & _
              "DISPATCH.CLOSEDATE, " & vbLf & _
              "DISPATCH.BILLSEQ, " & vbLf & _
              "DISPATCH.BRANCHNO, " & vbLf & _
              "MAX(DISPATCH.SEQ) AS SUM_PAYMENTPRICE " & vbLf & _
              "FROM DISPATCH " & vbLf
    
    '請求書番号が指定されている
    If blnIsBillNo = True Then
        strStmt = strStmt & _
              "WHERE DISPATCH.CLOSEDATE = :CLOSEDATE " & vbLf & _
              "AND DISPATCH.BILLSEQ = :BILLSEQ " & vbLf & _
              "AND DISPATCH.BRANCHNO = :BRANCHNO " & vbLf
    End If
    
    '締め日範囲が設定されている（請求書番号がない場合のみ）
    If (blnIsCloseDate = True) And (blnIsBillNo = False) Then
        strStmt = strStmt & _
              "WHERE DISPATCH.CLOSEDATE BETWEEN :STRDATE AND :ENDDATE " & vbLf
    End If
    
    strStmt = strStmt & "GROUP BY  " & vbLf & _
              "DISPATCH.CLOSEDATE, " & vbLf & _
              "DISPATCH.BILLSEQ, " & vbLf & _
              "DISPATCH.BRANCHNO " & vbLf & _
              ") " & vbLf & _
              ") LAST_DISPATCH " & vbLf

    '基本部分WHERE句
    strStmt = strStmt & "WHERE " & vbLf & _
              "SUM_PAYMENT.CLOSEDATE(+)=BILL.CLOSEDATE " & vbLf & _
              "AND SUM_PAYMENT.BILLSEQ(+)=BILL.BILLSEQ " & vbLf & _
              "AND SUM_PAYMENT.BRANCHNO(+)=BILL.BRANCHNO " & vbLf & _
              "AND LAST_DISPATCH.CLOSEDATE(+)=BILL.CLOSEDATE " & vbLf & _
              "AND LAST_DISPATCH.BILLSEQ(+)=BILL.BILLSEQ " & vbLf & _
              "AND LAST_DISPATCH.BRANCHNO(+)=BILL.BRANCHNO " & vbLf & _
              "AND PAYMENT_VIEW.CLOSEDATE(+)=BILL.CLOSEDATE " & vbLf & _
              "AND PAYMENT_VIEW.BILLSEQ(+)=BILL.BILLSEQ " & vbLf & _
              "AND PAYMENT_VIEW.BRANCHNO(+)=BILL.BRANCHNO " & vbLf & _
              "AND SUM_BILLDETAIL.CLOSEDATE(+)=BILL.CLOSEDATE " & vbLf & _
              "AND SUM_BILLDETAIL.BILLSEQ(+)=BILL.BILLSEQ " & vbLf & _
              "AND SUM_BILLDETAIL.BRANCHNO(+)=BILL.BRANCHNO " & vbLf & _
              "AND BILL.ORGCD1=ORG.ORGCD1 " & vbLf & _
              "AND BILL.ORGCD2=ORG.ORGCD2 " & vbLf

'## 2004.07.08 ADD STR ORB)T.YAGUCHI ２次金額追加
        strStmt = strStmt & _
              "AND SUM_BILLDETAIL_ITEMS.CLOSEDATE(+)=BILL.CLOSEDATE " & vbLf & _
              "AND SUM_BILLDETAIL_ITEMS.BILLSEQ(+)=BILL.BILLSEQ " & vbLf & _
              "AND SUM_BILLDETAIL_ITEMS.BRANCHNO(+)=BILL.BRANCHNO " & vbLf
'## 2004.07.08 ADD END

    '請求書番号が指定されている
    If blnIsBillNo = True Then
        strStmt = strStmt & _
              "AND BILL.CLOSEDATE = :CLOSEDATE " & vbLf & _
              "AND BILL.BILLSEQ = :BILLSEQ " & vbLf & _
              "AND BILL.BRANCHNO = :BRANCHNO " & vbLf
    End If
    
    '締め日範囲が設定されている（請求書番号がない場合のみ）
    If (blnIsCloseDate = True) And (blnIsBillNo = False) Then
        strStmt = strStmt & _
              "AND BILL.CLOSEDATE BETWEEN :STRDATE AND :ENDDATE " & vbLf
    End If
    
    '団体が設定されている
    If blnIsOrgCd = True Then
        strStmt = strStmt & _
              "AND BILL.ORGCD1 = :ORGCD1 " & vbLf & _
              "AND BILL.ORGCD2 = :ORGCD2 " & vbLf
    End If
    
    '発送済みのみが設定されている
    If blnIsDispatch = True Then
        strStmt = strStmt & _
              "AND LAST_DISPATCH.DISPATCHDATE IS NOT NULL " & vbLf
    End If
    
    '未発送のみが設定されている
    If blnIsNoDispatch = True Then
        strStmt = strStmt & _
              "AND LAST_DISPATCH.DISPATCHDATE IS NULL " & vbLf
    End If
    
'## 2004.07.08 MOD STR ORB)T.YAGUCHI ２次金額追加
'    '入金済みのみが設定されている
'    If blnIsPayment = True Then
'        strStmt = strStmt & _
'              "AND NVL(SUM_BILLDETAIL.PRICETOTAL + SUM_BILLDETAIL.TAXTOTAL - SUM_PAYMENT.SUM_PAYMENTPRICE, " & _
'              "SUM_BILLDETAIL.PRICETOTAL + SUM_BILLDETAIL.TAXTOTAL)=0 " & vbLf
'    End If
'
'    '未収のみが設定されている
'    If blnIsNoPayment = True Then
'        strStmt = strStmt & _
'              "AND NVL(SUM_BILLDETAIL.PRICETOTAL + SUM_BILLDETAIL.TAXTOTAL - SUM_PAYMENT.SUM_PAYMENTPRICE, " & _
'              "SUM_BILLDETAIL.PRICETOTAL + SUM_BILLDETAIL.TAXTOTAL)<>0 " & vbLf
'    End If
    '入金済みのみが設定されている
    If blnIsPayment = True Then
        strStmt = strStmt & _
              "AND NVL(SUM_BILLDETAIL.PRICETOTAL + SUM_BILLDETAIL.TAXTOTAL + NVL(SUM_BILLDETAIL_ITEMS.PRICETOTAL + SUM_BILLDETAIL_ITEMS.TAXTOTAL,0) - SUM_PAYMENT.SUM_PAYMENTPRICE, " & _
              "SUM_BILLDETAIL.PRICETOTAL + SUM_BILLDETAIL.TAXTOTAL + NVL(SUM_BILLDETAIL_ITEMS.PRICETOTAL + SUM_BILLDETAIL_ITEMS.TAXTOTAL,0))=0 " & vbLf
    End If
    
    '未収のみが設定されている
    If blnIsNoPayment = True Then
        strStmt = strStmt & _
              "AND NVL(SUM_BILLDETAIL.PRICETOTAL + SUM_BILLDETAIL.TAXTOTAL + NVL(SUM_BILLDETAIL_ITEMS.PRICETOTAL + SUM_BILLDETAIL_ITEMS.TAXTOTAL,0) - SUM_PAYMENT.SUM_PAYMENTPRICE, " & _
              "SUM_BILLDETAIL.PRICETOTAL + SUM_BILLDETAIL.TAXTOTAL + NVL(SUM_BILLDETAIL_ITEMS.PRICETOTAL + SUM_BILLDETAIL_ITEMS.TAXTOTAL,0))<>0 " & vbLf
    End If
'## 2004.07.08 MOD END

    '取消伝票も表示するが設定されていない
    If blnIsCancel = False Then
        strStmt = strStmt & _
              "AND BILL.DELFLG='0' " & vbLf
'    Else
'        strStmt = strStmt & _
'              "AND ((BILL.DELFLG='0' AND BILL.BRANCHNO=0) " & vbLf & _
'              "OR (BILL.DELFLG='1' AND BILL.BRANCHNO=1)) " & vbLf
    End If

    '基本部分ORDER BY句
    If vntMode <> "CNT" Then
        
'### 2004/3/17 Added by Ishihara@FSIT ご要望によりソート条件追加(--;)
        If vntSortType = "2" Then
            strDescAsc = " DESC "
        Else
            strDescAsc = " ASC "
        End If
'### 2004/3/17 Added End
        
        strStmt = strStmt & "ORDER BY " & vbLf
        Select Case vntSortName
        Case "1"
'### 2004/3/17 Updated by Ishihara@FSIT ご要望によりソート条件追加(--;)
'            strStmt = strStmt & "BILL.CLOSEDATE " & vbLf
            strStmt = strStmt & "BILL.CLOSEDATE " & strDescAsc & ", ORG.ORGKNAME " & strDescAsc & vbLf
'### 2004/3/17 Updated End
        Case "2"
            strStmt = strStmt & "ORG.ORGNAME " & vbLf
        Case "3"
'### 2004/3/17 Updated by Ishihara@FSIT ご要望によりソート条件追加(--;)
'            strStmt = strStmt & "ORG.ORGKNAME " & vbLf
            strStmt = strStmt & "ORG.ORGKNAME " & strDescAsc & ", BILL.CLOSEDATE " & strDescAsc & vbLf
'### 2004/3/17 Updated End
        Case "4"
'### 2004/3/17 Updated by Ishihara@FSIT ご要望によりソート条件追加(--;)
'            strStmt = strStmt & "ORDER_PAYMENTDATE " & vbLf
            strStmt = strStmt & "ORDER_PAYMENTDATE " & strDescAsc & " , ORG.ORGKNAME " & strDescAsc & ", BILL.CLOSEDATE " & strDescAsc & vbLf
'### 2004/3/17 Updated End
        Case Else
            strStmt = strStmt & "BILLNO " & strDescAsc & vbLf
        End Select
        
'### 2004/3/17 Deleted by Ishihara@FSIT ご要望によりソート条件追加(--;)
'        If vntSortType = "2" Then
'            strStmt = strStmt & "DESC " & vbLf
'        Else
'            strStmt = strStmt & "ASC " & vbLf
'        End If
'### 2004/3/17 Deleted End
    
    End If
    
    strStmt = strStmt & ") MAIN_VIEW " & vbLf & _
              ") BASE_VIEW " & vbLf

    
    '取得件数と開始位置が設定されている場合
    If (IsMissing(vntStartPos) = False) And (IsMissing(vntGetCount) = False) Then
        If IsNumeric(vntStartPos) And IsNumeric(vntGetCount) And _
           Trim(vntStartPos) <> "" And Trim(vntGetCount) <> "" Then
                strStmt = strStmt & vbLf & _
                          " WHERE BASE_VIEW.ROWSEQ BETWEEN :SEQ_F AND :SEQ_T" & vbLf
        End If
    End If

'    strStmt = strStmt & _
'              " ORDER BY BASEBILL.ROWSEQ, BASEBILL.BILLNO, BILL_ORG.SEQ, BILL_COURSE.CSSEQ"

    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)

    '検索レコードが存在する場合
    If Not objOraDyna.EOF Then
    
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objRowSeq = objFields("ROWSEQ")
        Set objBillNo = objFields("BILLNO")
        Set objCloseDate = objFields("CLOSEDATE")
        Set objBillSeq = objFields("BILLSEQ")
        Set objBranchNo = objFields("BRANCHNO")
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objOrgName = objFields("ORGNAME")
        Set objOrgKName = objFields("ORGKNAME")
        Set objMethod = objFields("METHOD")
        Set objPrtDate = objFields("PRTDATE")
        Set objDispatchDate = objFields("DISPATCHDATE")
        Set objPaymentDate = objFields("PAYMENTDATE")
        Set objPriceTotal = objFields("PRICETOTAL")
        Set objTaxTotal = objFields("TAXTOTAL")
        Set objBillTotal = objFields("BILLTOTAL")
        Set objPaymentPrice = objFields("PAYMENTPRICE")
        Set objSumPaymentPrice = objFields("SUM_PAYMENTPRICE")
        Set objUpdUser = objFields("UPDUSER")
        Set objUserName = objFields("USERNAME")
        Set objSeq = objFields("SEQ")
        Set objDelFlg = objFields("DELFLG")
' ### 2004/11/11 Add by Gouda@FSIT 団体請求コメントの追加
        Set objBillComment = objFields("BILLCOMMENT")
' ### 2004/11/11 Add End
    
        '配列形式で格納する
        Do Until objOraDyna.EOF
            
            If (vntMode = "CNT") Then
                
                '件数取得モード、かつ受診団体指定モードでない場合、請求書の枚数を返す
                If CLng(objRowSeq.Value & "") >= lngCount Then
                    lngCount = CLng(objRowSeq.Value & "")
                End If
            Else
                '通常モードの場合、引数に応じた結果を返す
                ReDim Preserve vntArrBillNo(lngCount)
                ReDim Preserve vntArrCloseDate(lngCount)
                ReDim Preserve vntArrBillSeq(lngCount)
                ReDim Preserve vntArrBranchNo(lngCount)
                ReDim Preserve vntArrOrgCd1(lngCount)
                ReDim Preserve vntArrOrgCd2(lngCount)
                ReDim Preserve vntArrOrgName(lngCount)
                ReDim Preserve vntArrOrgKName(lngCount)
                ReDim Preserve vntArrMethod(lngCount)
                ReDim Preserve vntArrPrtDate(lngCount)
                ReDim Preserve vntArrDispatchDate(lngCount)
                ReDim Preserve vntArrPaymentDate(lngCount)
                ReDim Preserve vntArrPriceTotal(lngCount)
                ReDim Preserve vntArrTaxTotal(lngCount)
                ReDim Preserve vntArrBillTotal(lngCount)
                ReDim Preserve vntArrPaymentPrice(lngCount)
                ReDim Preserve vntArrSumPaymentPrice(lngCount)
                ReDim Preserve vntArrUpdUser(lngCount)
                ReDim Preserve vntArrUserName(lngCount)
                ReDim Preserve vntArrSeq(lngCount)
                ReDim Preserve vntArrDelFlg(lngCount)
' ### 2004/11/11 Add by Gouda@FSIT 団体請求コメントの追加
                ReDim Preserve vntArrBillComment(lngCount)
' ### 2004/11/11 Add End
                
                vntArrBillNo(lngCount) = objBillNo.Value & ""
                vntArrCloseDate(lngCount) = objCloseDate.Value & ""
                vntArrBillSeq(lngCount) = objBillSeq.Value & ""
                vntArrBranchNo(lngCount) = objBranchNo.Value & ""
                vntArrOrgCd1(lngCount) = objOrgCd1.Value & ""
                vntArrOrgCd2(lngCount) = objOrgCd2.Value & ""
                vntArrOrgName(lngCount) = objOrgName.Value & ""
                vntArrOrgKName(lngCount) = objOrgKName.Value & ""
                vntArrMethod(lngCount) = objMethod.Value & ""
                vntArrPrtDate(lngCount) = objPrtDate.Value & ""
                vntArrDispatchDate(lngCount) = objDispatchDate.Value & ""
                vntArrPaymentDate(lngCount) = objPaymentDate.Value & ""
                vntArrPriceTotal(lngCount) = objPriceTotal.Value & ""
                vntArrTaxTotal(lngCount) = objTaxTotal.Value & ""
                vntArrBillTotal(lngCount) = objBillTotal.Value & ""
                vntArrPaymentPrice(lngCount) = objPaymentPrice.Value & ""
                vntArrSumPaymentPrice(lngCount) = objSumPaymentPrice.Value & ""
                vntArrUpdUser(lngCount) = objUpdUser.Value & ""
                vntArrUserName(lngCount) = objUserName.Value & ""
                vntArrSeq(lngCount) = objSeq.Value & ""
                vntArrDelFlg(lngCount) = objDelFlg.Value & ""
' ### 2004/11/11 Add by Gouda@FSIT 団体請求コメントの追加
                vntArrBillComment(lngCount) = objBillComment.Value & ""
' ### 2004/11/11 Add End
                
                lngCount = lngCount + 1
            End If
            objOraDyna.MoveNext
        Loop
    
    End If
    
    '戻り値の設定
    If vntMode <> "CNT" Then
        If IsMissing(vntBillNo) = False Then vntBillNo = vntArrBillNo
        If IsMissing(vntCloseDate) = False Then vntCloseDate = vntArrCloseDate
        If IsMissing(vntBillSeq) = False Then vntBillSeq = vntArrBillSeq
        If IsMissing(vntBranchNo) = False Then vntBranchNo = vntArrBranchNo
        If IsMissing(vntOrgCd1) = False Then vntOrgCd1 = vntArrOrgCd1
        If IsMissing(vntOrgCd2) = False Then vntOrgCd2 = vntArrOrgCd2
        If IsMissing(vntOrgName) = False Then vntOrgName = vntArrOrgName
        If IsMissing(vntOrgKName) = False Then vntOrgKName = vntArrOrgKName
        If IsMissing(vntMethod) = False Then vntMethod = vntArrMethod
        If IsMissing(vntPrtDate) = False Then vntPrtDate = vntArrPrtDate
        If IsMissing(vntDispatchDate) = False Then vntDispatchDate = vntArrDispatchDate
        If IsMissing(vntPaymentDate) = False Then vntPaymentDate = vntArrPaymentDate
        If IsMissing(vntPriceTotal) = False Then vntPriceTotal = vntArrPriceTotal
        If IsMissing(vntTaxTotal) = False Then vntTaxTotal = vntArrTaxTotal
        If IsMissing(vntBillTotal) = False Then vntBillTotal = vntArrBillTotal
        If IsMissing(vntPaymentPrice) = False Then vntPaymentPrice = vntArrPaymentPrice
        If IsMissing(vntSumPaymentPrice) = False Then vntSumPaymentPrice = vntArrSumPaymentPrice
        If IsMissing(vntUpdUser) = False Then vntUpdUser = vntArrUpdUser
        If IsMissing(vntUserName) = False Then vntUserName = vntArrUserName
        If IsMissing(vntSeq) = False Then vntSeq = vntArrSeq
        If IsMissing(vntDelFlg) = False Then vntDelFlg = vntArrDelFlg
' ### 2004/11/11 Add by Gouda@FSIT 団体請求コメントの追加
        If IsMissing(vntBillComment) = False Then vntBillComment = vntArrBillComment
' ### 2004/11/11 Add End
    End If
    
    SelectDmdBurdenList = lngCount
    
    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Set objOraDyna = Nothing
    Set objOraParam = Nothing
    
    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:
    
    'イベントログ書き込み
    WriteErrorLog "Demand.SelectDmdBurdenList"
    
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
' 機能　　 : 個人受診金額情報の読み込み
'
' 引数　　 : (In)     lngRsvNo              予約番号
' 　　　　   (Out)    vntORGCD1             団体コード１
' 　　　　   (Out)    vntORGCD2             団体コード２
' 　　　　   (Out)    vntORGNAME            団体名
' 　　　　   (Out)    vntORGDIV             団体種別
' 　　　　   (Out)    vntCSCD               コースコード
' 　　　　   (Out)    vntCSNAME             コース名
' 　　　　   (Out)    vntDMDLINECLASSCD     請求明細分類コード
' 　　　　   (Out)    vntDMDLINECLASSNAME   請求明細分類名
' 　　　　   (Out)    vntSUMDETAILS         健診基本料集計区分
' 　　　　   (Out)    vntAGEDIV             年齢区分
' 　　　　   (Out)    vntPRICE              金額
' 　　　　   (Out)    vntEDITPRICE          調整金額
' 　　　　   (Out)    vntPRICESEQ           ＳＥＱ
' 　　　　   (In)     vntSort               ソート順
' 　　　　   (In)     vntExistsZeroData     1:\0データも取得する。
' 　　　　   (Out)    vntTaxPrice           税額
' 　　　　   (Out)    vntEditTax            調整税額
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectConsult_mList(ByVal lngRsvNo As Long, _
                                    Optional ByRef vntOrgCd1 As Variant, _
                                    Optional ByRef vntOrgCd2 As Variant, _
                                    Optional ByRef vntOrgName As Variant, _
                                    Optional ByRef vntOrgDiv As Variant, _
                                    Optional ByRef vntCsCd As Variant, _
                                    Optional ByRef vntCsName As Variant, _
                                    Optional ByRef vntDmdLineClassCd As Variant, _
                                    Optional ByRef vntDmdLineClassName As Variant, _
                                    Optional ByRef vntSUMDETAILS As Variant, _
                                    Optional ByRef vntAgeDiv As Variant, _
                                    Optional ByRef vntPrice As Variant, _
                                    Optional ByRef vntEditPrice As Variant, _
                                    Optional ByRef vntPriceSeq As Variant, _
                                    Optional ByVal vntSort As Variant, _
                                    Optional ByVal vntExistsZeroData As Variant, _
                                    Optional ByRef vntTaxPrice As Variant, _
                                    Optional ByRef vntEditTax As Variant) As Long

    Dim objOraParam                 As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna                  As OraDynaset       'ダイナセット
    Dim strStmt                     As String           'SQLステートメント
    Dim lngCount                    As Long
    
    Dim objFields                   As OraFields        'フィールドオブジェクト
    Dim objOrgCd1                   As OraField         '団体コード１
    Dim objOrgCd2                   As OraField         '団体コード２
    Dim objOrgName                  As OraField         '団体名
    Dim objOrgDiv                   As OraField         '団体種別
    Dim objCsCd                     As OraField         'コースコード
    Dim objCsName                   As OraField         'コース名
    Dim objDmdLineClassCd           As OraField         '請求明細分類コード
    Dim objDmdLineClassName         As OraField         '請求明細分類名
    Dim objSumDetails               As OraField         '健診基本料集計区分
    Dim objAgeDiv                   As OraField         '年齢区分
    Dim objPrice                    As OraField         '金額
    Dim objEditPrice                As OraField         '調整金額
    Dim objPriceSeq                 As OraField         'ＳＥＱ
    Dim objTaxPrice                 As OraField         '税額
    Dim objEditTax                  As OraField         '調整税額
    
    Dim vntArrOrgCd1()              As Variant          '団体コード１
    Dim vntArrOrgCd2()              As Variant          '団体コード２
    Dim vntArrOrgName()             As Variant          '団体名
    Dim vntArrOrgDiv()              As Variant          '団体種別
    Dim vntArrCsCd()                As Variant          'コースコード
    Dim vntArrCsName()              As Variant          'コース名
    Dim vntArrDmdLineClassCd()      As Variant          '請求明細分類コード
    Dim vntArrDmdLineClassName()    As Variant          '請求明細分類名
    Dim vntArrSumDetails()          As Variant          '健診基本料集計区分
    Dim vntArrAgeDiv()              As Variant          '年齢区分
    Dim vntArrPrice()               As Variant          '金額
    Dim vntArrEditPrice()           As Variant          '調整金額
    Dim vntArrPriceSeq()            As Variant          'ＳＥＱ
    Dim vntArrTaxPrice()            As Variant          '税額
    Dim vntArrEditTax()             As Variant          '調整税額
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    SelectConsult_mList = -1
    
    'SORTキーオプションがないなら空白セット
    If IsMissing(vntSort) Then vntSort = ""
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '指定された予約番号の受診金額情報を取得
    strStmt = "SELECT CONSULT_M.ORGCD1,     CONSULT_M.ORGCD2, ORG.ORGNAME,ORG.ORGDIV," & vbLf & _
              "       CONSULT_M.CSCD,       COURSE_P.CSNAME, CONSULT_M.DMDLINECLASSCD,DMDLINECLASS.DMDLINECLASSNAME," & vbLf & _
              "       CONSULT_M.SUMDETAILS, CONSULT_M.AGEDIV, " & vbLf & _
              "       CONSULT_M.PRICE,      CONSULT_M.EDITPRICE, CONSULT_M.PRICESEQ," & vbLf & _
              "       CONSULT_M.TAXPRICE,   CONSULT_M.EDITTAX" & vbLf & _
              "  FROM DMDLINECLASS, COURSE_P, ORG, CONSULT_M" & vbLf & _
              " WHERE CONSULT_M.RSVNO = :RSVNO " & vbLf & _
              "   AND ORG.ORGCD1      = CONSULT_M.ORGCD1" & vbLf & _
              "   AND ORG.ORGCD2      = CONSULT_M.ORGCD2" & vbLf & _
              "   AND COURSE_P.CSCD   = CONSULT_M.CSCD" & vbLf & _
              "   AND DMDLINECLASS.DMDLINECLASSCD = CONSULT_M.DMDLINECLASSCD" & vbLf
        
    '\0データの判断（デフォルトは取得しない）
    If vntExistsZeroData <> "1" Then
        strStmt = strStmt & " AND ( CONSULT_M.PRICE != 0 OR CONSULT_M.EDITPRICE != 0 )" & vbLf
    End If
        
    'SORT順指定を設定
    Select Case vntSort
        Case "2"
            '2の場合、コース、負担元、請求明細分類でSort
            strStmt = strStmt & _
                      "ORDER BY CONSULT_M.CSCD, ORG.ORGDIV DESC, CONSULT_M.ORGCD1, CONSULT_M.ORGCD2, CONSULT_M.DMDLINECLASSCD"
        Case "3"
            '3の場合、請求明細分類、負担元、コースでSort
            strStmt = strStmt & _
                      "ORDER BY CONSULT_M.DMDLINECLASSCD, ORG.ORGDIV DESC, CONSULT_M.ORGCD1, CONSULT_M.ORGCD2, CONSULT_M.CSCD"
        Case Else
            '1、もしくは負担元指定の場合、負担元、コース、請求明細分類でSort
            strStmt = strStmt & _
                      "ORDER BY ORG.ORGDIV DESC, CONSULT_M.ORGCD1, CONSULT_M.ORGCD2, CONSULT_M.CSCD, CONSULT_M.DMDLINECLASSCD"
    End Select

    'SQL実行
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objOrgName = objFields("ORGNAME")
        Set objOrgDiv = objFields("ORGDIV")
        Set objCsCd = objFields("CSCD")
        Set objCsName = objFields("CSNAME")
        Set objDmdLineClassCd = objFields("DMDLINECLASSCD")
        Set objDmdLineClassName = objFields("DMDLINECLASSNAME")
        Set objSumDetails = objFields("SUMDETAILS")
        Set objAgeDiv = objFields("AGEDIV")
        Set objPrice = objFields("PRICE")
        Set objEditPrice = objFields("EDITPRICE")
        Set objPriceSeq = objFields("PRICESEQ")
        Set objTaxPrice = objFields("TAXPRICE")
        Set objEditTax = objFields("EDITTAX")
        
        lngCount = 0
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrOrgCd1(lngCount)
            ReDim Preserve vntArrOrgCd2(lngCount)
            ReDim Preserve vntArrOrgName(lngCount)
            ReDim Preserve vntArrOrgDiv(lngCount)
            ReDim Preserve vntArrCsCd(lngCount)
            ReDim Preserve vntArrCsName(lngCount)
            ReDim Preserve vntArrDmdLineClassCd(lngCount)
            ReDim Preserve vntArrDmdLineClassName(lngCount)
            ReDim Preserve vntArrSumDetails(lngCount)
            ReDim Preserve vntArrAgeDiv(lngCount)
            ReDim Preserve vntArrPrice(lngCount)
            ReDim Preserve vntArrEditPrice(lngCount)
            ReDim Preserve vntArrPriceSeq(lngCount)
            ReDim Preserve vntArrTaxPrice(lngCount)
            ReDim Preserve vntArrEditTax(lngCount)
            
            vntArrOrgCd1(lngCount) = objOrgCd1.Value & ""
            vntArrOrgCd2(lngCount) = objOrgCd2.Value & ""
            vntArrOrgName(lngCount) = objOrgName.Value & ""
            vntArrOrgDiv(lngCount) = objOrgDiv.Value & ""
            vntArrCsCd(lngCount) = objCsCd.Value & ""
            vntArrCsName(lngCount) = objCsName.Value & ""
            vntArrDmdLineClassCd(lngCount) = objDmdLineClassCd.Value & ""
            vntArrDmdLineClassName(lngCount) = objDmdLineClassName.Value & ""
            vntArrSumDetails(lngCount) = objSumDetails.Value & ""
            vntArrAgeDiv(lngCount) = objAgeDiv.Value & ""
            vntArrPrice(lngCount) = objPrice.Value & ""
            vntArrEditPrice(lngCount) = objEditPrice.Value & ""
            vntArrPriceSeq(lngCount) = objPriceSeq.Value & ""
            vntArrTaxPrice(lngCount) = objTaxPrice.Value & ""
            vntArrEditTax(lngCount) = objEditTax.Value & ""
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        
        Loop
        
        '戻り値の設定
        If IsMissing(vntOrgCd1) = False Then vntOrgCd1 = vntArrOrgCd1
        If IsMissing(vntOrgCd2) = False Then vntOrgCd2 = vntArrOrgCd2
        If IsMissing(vntOrgName) = False Then vntOrgName = vntArrOrgName
        If IsMissing(vntOrgDiv) = False Then vntOrgDiv = vntArrOrgDiv
        If IsMissing(vntCsCd) = False Then vntCsCd = vntArrCsCd
        If IsMissing(vntCsName) = False Then vntCsName = vntArrCsName
        If IsMissing(vntDmdLineClassCd) = False Then vntDmdLineClassCd = vntArrDmdLineClassCd
        If IsMissing(vntDmdLineClassName) = False Then vntDmdLineClassName = vntArrDmdLineClassName
        If IsMissing(vntSUMDETAILS) = False Then vntSUMDETAILS = vntArrSumDetails
        If IsMissing(vntAgeDiv) = False Then vntAgeDiv = vntArrAgeDiv
        If IsMissing(vntPrice) = False Then vntPrice = vntArrPrice
        If IsMissing(vntEditPrice) = False Then vntEditPrice = vntArrEditPrice
        If IsMissing(vntPriceSeq) = False Then vntPriceSeq = vntArrPriceSeq
        If IsMissing(vntTaxPrice) = False Then vntTaxPrice = vntArrTaxPrice
        If IsMissing(vntEditTax) = False Then vntEditTax = vntArrEditTax
        
        SelectConsult_mList = lngCount
        
    Else
        SelectConsult_mList = 0 '件数なし
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
    WriteErrorLog "Demand.SelectConsult_mList"
    
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
' 機能　　 : 個人受診金額情報の読み込み
'
' 引数　　 : (In)     lngRsvNo              予約番号
' 　　　　   (Out)    vntOrgCd1             団体コード１
' 　　　　   (Out)    vntOrgCd2             団体コード２
' 　　　　   (Out)    vntOrgSeq             契約パターンＳＥＱ
' 　　　　   (Out)    vntOrgName            団体名
' 　　　　   (Out)    vntPrice              金額
' 　　　　   (Out)    vntEditPrice          調整金額
' 　　　　   (Out)    vntTaxPrice           税額
' 　　　　   (Out)    vntEditTax            調整税額
' 　　　　   (Out)    vntLineTotal          金額小計
' 　　　　   (Out)    vntPriceSeq           受診金額ＳＥＱ
' 　　　　   (Out)    vntCtrPtCd            契約パターンコード
' 　　　　   (Out)    vntOpt                オプション番号
' 　　　　   (Out)    vntOptBranchNo        オプション枝番
' 　　　　   (Out)    vntOptName            オプション名称
' 　　　　   (Out)    vntOtherLineDivCd     セット外明細区分
' 　　　　   (Out)    vntLineName           請求明細名称
' 　　　　   (Out)    vntDmdDate            請求日
' 　　　　   (Out)    vntBillSeq            請求書Ｓｅｑ
' 　　　　   (Out)    vntBranchNo           請求書枝番
' 　　　　   (Out)    vntBillLineNo         請求書明細行Ｎｏ
' 　　　　   (Out)    vntPaymentDate        入金日
' 　　　　   (Out)    vntPaymentSeq         入金Ｓｅｑ
' 　　　　   (Out)    vntOmitTaxFlg         消費税免除フラグ
' 　　　　   (Out)    vntPrintDate          領収書印刷日
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectConsult_mInfo(ByVal lngRsvNo As Long, _
                                    Optional ByRef vntOrgCd1 As Variant, _
                                    Optional ByRef vntOrgCd2 As Variant, _
                                    Optional ByRef vntOrgSeq As Variant, _
                                    Optional ByRef vntOrgName As Variant, _
                                    Optional ByRef vntPrice As Variant, _
                                    Optional ByRef vntEditPrice As Variant, _
                                    Optional ByRef vntTaxPrice As Variant, _
                                    Optional ByRef vntEditTax As Variant, _
                                    Optional ByRef vntLineTotal As Variant, _
                                    Optional ByRef vntPriceSeq As Variant, _
                                    Optional ByRef vntCrtPtCd As Variant, _
                                    Optional ByRef vntOpt As Variant, _
                                    Optional ByRef vntOptBranchNo As Variant, _
                                    Optional ByRef vntOptName As Variant, _
                                    Optional ByRef vntOtherLineDivCd As Variant, _
                                    Optional ByRef vntLineName As Variant, _
                                    Optional ByRef vntDmdDate As Variant, _
                                    Optional ByRef vntBillSeq As Variant, _
                                    Optional ByRef vntBranchNo As Variant, _
                                    Optional ByRef vntBillLineNo As Variant, _
                                    Optional ByRef vntPaymentDate As Variant, _
                                    Optional ByRef vntPaymentSeq As Variant, _
                                    Optional ByRef vntOmitTaxFlg As Variant, _
                                    Optional ByRef vntPrintDate As Variant) As Long


    Dim objOraParam                 As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna                  As OraDynaset       'ダイナセット
    Dim strStmt                     As String           'SQLステートメント
    Dim lngCount                    As Long
    
    Dim objFields                   As OraFields        'フィールドオブジェクト
    Dim objOrgCd1                   As OraField         '団体コード１
    Dim objOrgCd2                   As OraField         '団体コード２
    Dim objOrgSeq                   As OraField         '契約パターンＳＥＱ
    Dim objOrgName                  As OraField         '団体名
    Dim objPrice                    As OraField         '金額
    Dim objEditPrice                As OraField         '調整金額
    Dim objTaxPrice                 As OraField         '税額
    Dim objEditTax                  As OraField         '調整税額
    Dim objLineTotal                As OraField         '金額小計
    Dim objPriceSeq                 As OraField         '受診金額ＳＥＱ
    Dim objCrtPtCd                  As OraField         '契約パターンコード
    Dim objOpt                      As OraField         'オプション番号
    Dim objOptBranchNo              As OraField         'オプション枝番
    Dim objOptName                  As OraField         'オプション名称
    Dim objOtherLineDivCd           As OraField         'セット外明細区分
    Dim objLineName                 As OraField         '請求明細名称
    Dim objDmdDate                  As OraField         '請求日
    Dim objBillSeq                  As OraField         '請求書Ｓｅｑ
    Dim objBranchNo                 As OraField         '請求書枝番
    Dim objBillLineNo               As OraField         '請求書明細行Ｎｏ
    Dim objPaymentDate              As OraField         '入金日
    Dim objPaymentSeq               As OraField         '入金Ｓｅｑ
    Dim objOmitTaxFlg               As OraField         '消費税免除フラグ
    Dim objPrintDate                As OraField         '領収書印刷日

    Dim vntArrOrgCd1()              As Variant          '団体コード１
    Dim vntArrOrgCd2()              As Variant          '団体コード２
    Dim vntArrOrgSeq()              As Variant          '契約パターンＳＥＱ
    Dim vntArrOrgName()             As Variant          '団体名
    Dim vntArrPrice()               As Variant          '金額
    Dim vntArrEditPrice()           As Variant          '調整金額
    Dim vntArrTaxPrice()            As Variant          '税額
    Dim vntArrEditTax()             As Variant          '調整税額
    Dim vntArrLineTotal()           As Variant          '金額小計
    Dim vntArrPriceSeq()            As Variant          '受診金額ＳＥＱ
    Dim vntArrCrtPtCd()             As Variant          '契約パターンコード
    Dim vntArrOpt()                 As Variant          'オプション番号
    Dim vntArrOptBranchNo()         As Variant          'オプション枝番
    Dim vntArrOptName()             As Variant          'オプション名称
    Dim vntArrOtherLineDivCd()      As Variant          'セット外明細区分
    Dim vntArrLineName()            As Variant          '請求明細名称
    Dim vntArrDmdDate()             As Variant          '請求日
    Dim vntArrBillSeq()             As Variant          '請求書Seq
    Dim vntArrBranchNo()            As Variant          '請求書枝番
    Dim vntArrBillLineNo()          As Variant          '請求書明細行Ｎｏ
    Dim vntArrPaymentDate()         As Variant          '入金日
    Dim vntArrPaymentSeq()          As Variant          '入金Ｓｅｑ
    Dim vntArrOmitTaxFlg()          As Variant          '消費税免除フラグ
    Dim vntArrPrintDate()           As Variant          '領収書印刷日

    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    SelectConsult_mInfo = -1
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER

    '指定された予約番号の受診金額情報を取得

    strStmt = "SELECT MAIN.ORGCD1,                      " & vbLf & _
              "       MAIN.ORGCD2,                      " & vbLf & _
              "       MAIN.ORGSEQ,                      " & vbLf & _
              "       MAIN.ORGNAME,                     " & vbLf & _
              "       MAIN.PRICE,                       " & vbLf & _
              "       MAIN.EDITPRICE,                   " & vbLf & _
              "       MAIN.TAXPRICE,                    " & vbLf & _
              "       MAIN.EDITTAX,                     " & vbLf & _
              "       MAIN.LINETOTAL,                   " & vbLf & _
              "       MAIN.PRICESEQ,                    " & vbLf & _
              "       MAIN.CTRPTCD,                     " & vbLf & _
              "       MAIN.OPTCD,                       " & vbLf & _
              "       MAIN.OPTBRANCHNO,                 " & vbLf & _
              "       MAIN.CTRPT_OPTNAME,               " & vbLf & _
              "       MAIN.OTHERLINEDIVCD,              " & vbLf & _
              "       MAIN.LINENAME,                    " & vbLf & _
              "       MAIN.DMDDATE,                     " & vbLf & _
              "       MAIN.BILLSEQ,                     " & vbLf & _
              "       MAIN.BRANCHNO,                    " & vbLf & _
              "       MAIN.BILLLINENO,                  " & vbLf & _
              "       MAIN.OMITTAXFLG,                  " & vbLf & _
              "       PERBILL.PAYMENTDATE,              " & vbLf & _
              "       PERBILL.PAYMENTSEQ,               " & vbLf & _
              "       PERBILL.PRINTDATE                 " & vbLf

    strStmt = strStmt & _
              "  FROM PERBILL,                          " & vbLf & _
              "       ( SELECT MAINVIEW.ORGCD1,         " & vbLf & _
              "                MAINVIEW.ORGCD2,         " & vbLf & _
              "                MAINVIEW.ORGSEQ,         " & vbLf & _
              "                MAINVIEW.ORGNAME,        " & vbLf & _
              "                MAINVIEW.PRICE,          " & vbLf & _
              "                MAINVIEW.EDITPRICE,      " & vbLf & _
              "                MAINVIEW.TAXPRICE,       " & vbLf & _
              "                MAINVIEW.EDITTAX,        " & vbLf & _
              "                MAINVIEW.LINETOTAL,      " & vbLf & _
              "                MAINVIEW.PRICESEQ,       " & vbLf & _
              "                MAINVIEW.CTRPTCD,        " & vbLf & _
              "                MAINVIEW.OPTCD,          " & vbLf & _
              "                MAINVIEW.OPTBRANCHNO,    " & vbLf & _
              "                MAINVIEW.CTRPT_OPTNAME,  " & vbLf & _
              "                MAINVIEW.OTHERLINEDIVCD, " & vbLf & _
              "                MAINVIEW.DMDDATE,        " & vbLf & _
              "                MAINVIEW.BILLSEQ,        " & vbLf & _
              "                MAINVIEW.BRANCHNO,       " & vbLf & _
              "                MAINVIEW.BILLLINENO,     " & vbLf & _
              "                MAINVIEW.OMITTAXFLG,     " & vbLf

    strStmt = strStmt & _
              "                CASE                                                                           " & vbLf & _
              "                    WHEN MAINVIEW.LINENAME         IS NOT NULL  THEN MAINVIEW.LINENAME         " & vbLf & _
              "                    WHEN CTRPT_PRICE.BILLPRINTNAME IS NOT NULL  THEN CTRPT_PRICE.BILLPRINTNAME " & vbLf & _
              "                    ELSE MAINVIEW.OPTNAME                                                      " & vbLf & _
              "                END LINENAME                                                                   " & vbLf

    strStmt = strStmt & _
              "           FROM CTRPT_PRICE,                                                                                        " & vbLf & _
              "                ( SELECT CONSULT_M.ORGCD1,                                                                          " & vbLf & _
              "                         CONSULT_M.ORGCD2,                                                                          " & vbLf & _
              "                         ORGSEQVIEW.ORGSEQ,                                                                         " & vbLf & _
              "                         ORG.ORGNAME,                                                                               " & vbLf & _
              "                         CONSULT_M.PRICE,                                                                           " & vbLf & _
              "                         CONSULT_M.EDITPRICE,                                                                       " & vbLf & _
              "                         CONSULT_M.TAXPRICE,                                                                        " & vbLf & _
              "                         CONSULT_M.EDITTAX,                                                                         " & vbLf & _
              "                         (CONSULT_M.PRICE + CONSULT_M.EDITPRICE + CONSULT_M.TAXPRICE + CONSULT_M.EDITTAX) LINETOTAL," & vbLf & _
              "                         CONSULT_M.PRICESEQ,                                                                        " & vbLf & _
              "                         CONSULT_M.CTRPTCD,                                                                         " & vbLf & _
              "                         CONSULT_M.OPTCD,                                                                           " & vbLf & _
              "                         CONSULT_M.OPTBRANCHNO,                                                                     " & vbLf & _
              "                         CTRPT_OPT.OPTNAME CTRPT_OPTNAME,                                                           " & vbLf & _
              "                         CONSULT_M.OTHERLINEDIVCD,                                                                  " & vbLf & _
              "                         CONSULT_M.DMDDATE,                                                                         " & vbLf & _
              "                         CONSULT_M.BILLSEQ,                                                                         " & vbLf & _
              "                         CONSULT_M.BRANCHNO,                                                                        " & vbLf & _
              "                         CONSULT_M.BILLLINENO,                                                                      " & vbLf & _
              "                         CONSULT_M.OMITTAXFLG,                                                                      " & vbLf & _
              "                         NVL(CTRPT_OPT.OPTNAME, OTHERLINEDIV.OTHERLINEDIVNAME) OPTNAME,                             " & vbLf & _
              "                         CONSULT_M.LINENAME                                                                         " & vbLf

    strStmt = strStmt & _
              "                    FROM OTHERLINEDIV,                                                                              " & vbLf & _
              "                         ( SELECT CTRPT_ORG.SEQ ORGSEQ,                                                             " & vbLf & _
              "                                  NVL(CTRPT_ORG.ORGCD1, CONSULT.ORGCD1) ORGCD1,                                     " & vbLf & _
              "                                  NVL(CTRPT_ORG.ORGCD2, CONSULT.ORGCD2) ORGCD2                                      " & vbLf & _
              "                             FROM CTRPT_ORG, CONSULT                                                                " & vbLf & _
              "                            WHERE CONSULT.RSVNO     = :RSVNO                                                        " & vbLf & _
              "                              AND CTRPT_ORG.CTRPTCD = CONSULT.CTRPTCD                                               " & vbLf & _
              "                         ) ORGSEQVIEW,                                                                              " & vbLf & _
              "                         CTRPT_OPT, ORG, CONSULT_M                                                                  " & vbLf & _
              "                   WHERE CONSULT_M.RSVNO = :RSVNO                                                                   " & vbLf & _
              "                     AND ORG.ORGCD1               = CONSULT_M.ORGCD1                                                " & vbLf & _
              "                     AND ORG.ORGCD2               = CONSULT_M.ORGCD2                                                " & vbLf & _
              "                     AND CONSULT_M.CTRPTCD        = CTRPT_OPT.CTRPTCD     (+)                                       " & vbLf & _
              "                     AND CONSULT_M.OPTCD          = CTRPT_OPT.OPTCD       (+)                                       " & vbLf & _
              "                     AND CONSULT_M.OPTBRANCHNO    = CTRPT_OPT.OPTBRANCHNO (+)                                       " & vbLf & _
              "                     AND ORGSEQVIEW.ORGCD1        = CONSULT_M.ORGCD1                                                " & vbLf & _
              "                     AND ORGSEQVIEW.ORGCD2        = CONSULT_M.ORGCD2                                                " & vbLf & _
              "                     AND CONSULT_M.OTHERLINEDIVCD = OTHERLINEDIV.OTHERLINEDIVCD (+)                                 " & vbLf & _
              "                ) MAINVIEW                                                                                          " & vbLf

    strStmt = strStmt & _
              "          WHERE MAINVIEW.CTRPTCD     = CTRPT_PRICE.CTRPTCD     (+)                                                  " & vbLf & _
              "            AND MAINVIEW.OPTCD       = CTRPT_PRICE.OPTCD       (+)                                                  " & vbLf & _
              "            AND MAINVIEW.OPTBRANCHNO = CTRPT_PRICE.OPTBRANCHNO (+)                                                  " & vbLf & _
              "            AND MAINVIEW.ORGSEQ      = CTRPT_PRICE.SEQ         (+)                                                  " & vbLf & _
              "          ORDER BY MAINVIEW.ORGSEQ, MAINVIEW.PRICESEQ                                                               " & vbLf & _
              "       ) MAIN                                                                                                       " & vbLf & _
              " WHERE MAIN.DMDDATE   =  PERBILL.DMDDATE (+)                                                                        " & vbLf & _
              "   AND MAIN.BILLSEQ   =  PERBILL.BILLSEQ (+)                                                                        " & vbLf & _
              "   AND MAIN.BRANCHNO  =  PERBILL.BRANCHNO (+)                                                                       "

    'SQL実行
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objOrgSeq = objFields("ORGSEQ")
        Set objOrgName = objFields("ORGNAME")
        Set objPrice = objFields("PRICE")
        Set objEditPrice = objFields("EDITPRICE")
        Set objTaxPrice = objFields("TAXPRICE")
        Set objEditTax = objFields("EDITTAX")
        Set objLineTotal = objFields("LINETOTAL")
        Set objPriceSeq = objFields("PRICESEQ")
        Set objCrtPtCd = objFields("CTRPTCD")
        Set objOpt = objFields("OPTCD")
        Set objOptBranchNo = objFields("OPTBRANCHNO")
        Set objOptName = objFields("CTRPT_OPTNAME")
        Set objOtherLineDivCd = objFields("OTHERLINEDIVCD")
        Set objLineName = objFields("LINENAME")
        Set objDmdDate = objFields("DMDDATE")
        Set objBillSeq = objFields("BILLSEQ")
        Set objBranchNo = objFields("BRANCHNO")
        Set objBillLineNo = objFields("BILLLINENO")
        Set objPaymentDate = objFields("PAYMENTDATE")
        Set objPaymentSeq = objFields("PAYMENTSEQ")
        Set objOmitTaxFlg = objFields("OMITTAXFLG")
        Set objPrintDate = objFields("PRINTDATE")

        lngCount = 0
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrOrgCd1(lngCount)
            ReDim Preserve vntArrOrgCd2(lngCount)
            ReDim Preserve vntArrOrgSeq(lngCount)
            ReDim Preserve vntArrOrgName(lngCount)
            ReDim Preserve vntArrPrice(lngCount)
            ReDim Preserve vntArrEditPrice(lngCount)
            ReDim Preserve vntArrTaxPrice(lngCount)
            ReDim Preserve vntArrEditTax(lngCount)
            ReDim Preserve vntArrLineTotal(lngCount)
            ReDim Preserve vntArrPriceSeq(lngCount)
            ReDim Preserve vntArrCrtPtCd(lngCount)
            ReDim Preserve vntArrOpt(lngCount)
            ReDim Preserve vntArrOptBranchNo(lngCount)
            ReDim Preserve vntArrOptName(lngCount)
            ReDim Preserve vntArrOtherLineDivCd(lngCount)
            ReDim Preserve vntArrLineName(lngCount)
            ReDim Preserve vntArrDmdDate(lngCount)
            ReDim Preserve vntArrBillSeq(lngCount)
            ReDim Preserve vntArrBranchNo(lngCount)
            ReDim Preserve vntArrBillLineNo(lngCount)
            ReDim Preserve vntArrPaymentDate(lngCount)
            ReDim Preserve vntArrPaymentSeq(lngCount)
            ReDim Preserve vntArrOmitTaxFlg(lngCount)
            ReDim Preserve vntArrPrintDate(lngCount)

            vntArrOrgCd1(lngCount) = objOrgCd1.Value & ""
            vntArrOrgCd2(lngCount) = objOrgCd2.Value & ""
            vntArrOrgSeq(lngCount) = objOrgSeq.Value & ""
            vntArrOrgName(lngCount) = objOrgName.Value & ""
            vntArrPrice(lngCount) = objPrice.Value & ""
            vntArrEditPrice(lngCount) = objEditPrice.Value & ""
            vntArrTaxPrice(lngCount) = objTaxPrice.Value & ""
            vntArrEditTax(lngCount) = objEditTax.Value & ""
            vntArrLineTotal(lngCount) = objLineTotal.Value & ""
            vntArrPriceSeq(lngCount) = objPriceSeq.Value & ""
            vntArrCrtPtCd(lngCount) = objCrtPtCd.Value & ""
            vntArrOpt(lngCount) = objOpt.Value & ""
            vntArrOptBranchNo(lngCount) = objOptBranchNo.Value & ""
            vntArrOptName(lngCount) = objOptName.Value & ""
            vntArrOtherLineDivCd(lngCount) = objOtherLineDivCd.Value & ""
            vntArrLineName(lngCount) = objLineName.Value & ""
            vntArrDmdDate(lngCount) = objDmdDate.Value & ""
            vntArrBillSeq(lngCount) = objBillSeq.Value & ""
            vntArrBranchNo(lngCount) = objBranchNo.Value & ""
            vntArrBillLineNo(lngCount) = objBillLineNo.Value & ""
            vntArrPaymentDate(lngCount) = objPaymentDate.Value & ""
            vntArrPaymentSeq(lngCount) = objPaymentSeq.Value & ""
            vntArrOmitTaxFlg(lngCount) = objOmitTaxFlg.Value & ""
            vntArrPrintDate(lngCount) = objPrintDate.Value & ""

            lngCount = lngCount + 1
            objOraDyna.MoveNext
        
        Loop

        '戻り値の設定
        If IsMissing(vntOrgCd1) = False Then vntOrgCd1 = vntArrOrgCd1
        If IsMissing(vntOrgCd2) = False Then vntOrgCd2 = vntArrOrgCd2
        If IsMissing(vntOrgSeq) = False Then vntOrgSeq = vntArrOrgSeq
        If IsMissing(vntOrgName) = False Then vntOrgName = vntArrOrgName
        If IsMissing(vntPrice) = False Then vntPrice = vntArrPrice
        If IsMissing(vntEditPrice) = False Then vntEditPrice = vntArrEditPrice
        If IsMissing(vntTaxPrice) = False Then vntTaxPrice = vntArrTaxPrice
        If IsMissing(vntEditTax) = False Then vntEditTax = vntArrEditTax
        If IsMissing(vntLineTotal) = False Then vntLineTotal = vntArrLineTotal
        If IsMissing(vntPriceSeq) = False Then vntPriceSeq = vntArrPriceSeq
        If IsMissing(vntCrtPtCd) = False Then vntCrtPtCd = vntArrCrtPtCd
        If IsMissing(vntOpt) = False Then vntOpt = vntArrOpt
        If IsMissing(vntOptBranchNo) = False Then vntOptBranchNo = vntArrOptBranchNo
        If IsMissing(vntOptName) = False Then vntOptName = vntArrOptName
        If IsMissing(vntOtherLineDivCd) = False Then vntOtherLineDivCd = vntArrOtherLineDivCd
        If IsMissing(vntLineName) = False Then vntLineName = vntArrLineName
        If IsMissing(vntDmdDate) = False Then vntDmdDate = vntArrDmdDate
        If IsMissing(vntBillSeq) = False Then vntBillSeq = vntArrBillSeq
        If IsMissing(vntBranchNo) = False Then vntBranchNo = vntArrBranchNo
        If IsMissing(vntBillLineNo) = False Then vntBillLineNo = vntArrBillLineNo
        If IsMissing(vntPaymentDate) = False Then vntPaymentDate = vntArrPaymentDate
        If IsMissing(vntPaymentSeq) = False Then vntPaymentSeq = vntArrPaymentSeq
        If IsMissing(vntOmitTaxFlg) = False Then vntOmitTaxFlg = vntArrOmitTaxFlg
        If IsMissing(vntPrintDate) = False Then vntPrintDate = vntArrPrintDate

        SelectConsult_mInfo = lngCount
        
    Else
        SelectConsult_mInfo = 0 '件数なし
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
    WriteErrorLog "Demand.SelectConsult_mInfo"
    
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
' 機能　　 : 個人受診金額小計の読み込み
'
' 引数　　 : (In)     lngRsvNo              予約番号
' 　　　　   (Out)    vntORGCD1             団体コード１
' 　　　　   (Out)    vntORGCD2             団体コード２
' 　　　　   (Out)    vntSubPrice           金額小計
' 　　　　   (Out)    vntSubEditPrice       調整金額小計
' 　　　　   (Out)    vntSubTaxPrice        税額小計
' 　　　　   (Out)    vntSubEditTax         調整税額小計
' 　　　　   (Out)    vntSubLineTotal       小計（金額＋調整金額＋税額＋調整税額）

'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectConsult_mTotal(ByVal lngRsvNo As Long, _
                                    Optional ByRef vntOrgCd1 As Variant, _
                                    Optional ByRef vntOrgCd2 As Variant, _
                                    Optional ByRef vntSubPrice As Variant, _
                                    Optional ByRef vntSubEditPrice As Variant, _
                                    Optional ByRef vntSubTaxPrice As Variant, _
                                    Optional ByRef vntSubEditTax As Variant, _
                                    Optional ByRef vntSubLineTotal As Variant) As Long

    Dim objOraParam                 As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna                  As OraDynaset       'ダイナセット
    Dim strStmt                     As String           'SQLステートメント
    Dim lngCount                    As Long
    
    Dim objFields                   As OraFields        'フィールドオブジェクト
    Dim objOrgCd1                   As OraField         '団体コード１
    Dim objOrgCd2                   As OraField         '団体コード２
    Dim objPrice                    As OraField         '金額
    Dim objEditPrice                As OraField         '調整金額
    Dim objTaxPrice                 As OraField         '税額
    Dim objEditTax                  As OraField         '調整税額
    
    Dim vntArrOrgCd1()              As Variant          '団体コード１
    Dim vntArrOrgCd2()              As Variant          '団体コード２
    Dim vntArrSubPrice()            As Variant          '金額小計
    Dim vntArrSubEditPrice()        As Variant          '調整金額小計
    Dim vntArrSubTaxPrice()         As Variant          '税額小計
    Dim vntArrSubEditTax()          As Variant          '調整税額小計
    Dim vntArrSubLineTotal()        As Variant          '小計
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    SelectConsult_mTotal = -1
        
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '指定された予約番号の受診金額小計を取得
    strStmt = "SELECT CONSULT_M.ORGCD1,                      " & vbLf & _
              "       CONSULT_M.ORGCD2,                      " & vbLf & _
              "       SUM(CONSULT_M.PRICE) SUBPRICE,         " & vbLf & _
              "       SUM(CONSULT_M.EDITPRICE) SUBEDITPRICE, " & vbLf & _
              "       SUM(CONSULT_M.TAXPRICE) SUBTAXPRICE,   " & vbLf & _
              "       SUM(CONSULT_M.EDITTAX) SUBEDITTAX      " & vbLf & _
              "  FROM CONSULT_M                              " & vbLf & _
              " WHERE CONSULT_M.RSVNO = :RSVNO               " & vbLf & _
              " GROUP BY CONSULT_M.ORGCD1, CONSULT_M.ORGCD2  "
    'SQL実行
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objPrice = objFields("SUBPRICE")
        Set objEditPrice = objFields("SUBEDITPRICE")
        Set objTaxPrice = objFields("SUBTAXPRICE")
        Set objEditTax = objFields("SUBEDITTAX")
        
        lngCount = 0
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrOrgCd1(lngCount)
            ReDim Preserve vntArrOrgCd2(lngCount)
            ReDim Preserve vntArrSubPrice(lngCount)
            ReDim Preserve vntArrSubEditPrice(lngCount)
            ReDim Preserve vntArrSubTaxPrice(lngCount)
            ReDim Preserve vntArrSubEditTax(lngCount)
            ReDim Preserve vntArrSubLineTotal(lngCount)
            
            vntArrOrgCd1(lngCount) = objOrgCd1.Value & ""
            vntArrOrgCd2(lngCount) = objOrgCd2.Value & ""
            vntArrSubPrice(lngCount) = objPrice.Value & ""
            vntArrSubEditPrice(lngCount) = objEditPrice.Value & ""
            vntArrSubTaxPrice(lngCount) = objTaxPrice.Value & ""
            vntArrSubEditTax(lngCount) = objEditTax.Value & ""
            vntArrSubLineTotal(lngCount) = CLng(objPrice.Value) + CLng(objEditPrice.Value) + _
                                           CLng(objTaxPrice.Value) + CLng(objEditTax.Value)
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        
        Loop
        
        '戻り値の設定
        If IsMissing(vntOrgCd1) = False Then vntOrgCd1 = vntArrOrgCd1
        If IsMissing(vntOrgCd2) = False Then vntOrgCd2 = vntArrOrgCd2
        If IsMissing(vntSubPrice) = False Then vntSubPrice = vntArrSubPrice
        If IsMissing(vntSubEditPrice) = False Then vntSubEditPrice = vntArrSubEditPrice
        If IsMissing(vntSubTaxPrice) = False Then vntSubTaxPrice = vntArrSubTaxPrice
        If IsMissing(vntSubEditTax) = False Then vntSubEditTax = vntArrSubEditTax
        If IsMissing(vntSubLineTotal) = False Then vntSubLineTotal = vntArrSubLineTotal
        
        SelectConsult_mTotal = lngCount
        
    Else
        SelectConsult_mTotal = 0 '件数なし
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
    WriteErrorLog "Demand.SelectConsult_mTotal"
    
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

'## 2004.02.02 Modified Function by ishihara@FSIT メソッドそのものを完全再作成
'
' 機能　　 : 個人毎の締め処理状態の読み込み
'
' 引数　　 : (In)     lngRsvNo          予約番号
' 　　　　   (Out)    vntORGCD1         団体コード１
' 　　　　   (Out)    vntORGCD2         団体コード２
' 　　　　   (Out)    vntORGNAME        団体名
' 　　　　   (Out)    vntCloseDate      締め日
' 　　　　   (Out)    vntBillSeq        SEQ
' 　　　　   (Out)    vntBranchNo       枝番
'
' 戻り値　 : >=0  レコード件数
' 　　　　   <0   異常終了
'
' 備考　　 :
'
Public Function SelectPersonalCloseMngInfo(ByVal lngRsvNo As Long, _
                                           Optional ByRef vntOrgCd1 As Variant, _
                                           Optional ByRef vntOrgCd2 As Variant, _
                                           Optional ByRef vntOrgName As Variant, _
                                           Optional ByRef vntCloseDate As Variant, _
                                           Optional ByRef vntBillSeq As Variant, _
                                           Optional ByRef vntBranchNo As Variant) As Long


    Dim objOraParam                 As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna                  As OraDynaset       'ダイナセット
    Dim strStmt                     As String           'SQLステートメント
    Dim lngCount                    As Long
    
    Dim objFields                   As OraFields        'フィールドオブジェクト
    Dim objOrgCd1                   As OraField         '団体コード１
    Dim objOrgCd2                   As OraField         '団体コード２
    Dim objOrgName                  As OraField         '団体名
    Dim objCloseDate                As OraField         '締め日
    Dim objBillSeq                  As OraField         'SEQ
    Dim objBranchNo                 As OraField         '枝番
    
    Dim vntArrOrgCd1()              As Variant          '団体コード１
    Dim vntArrOrgCd2()              As Variant          '団体コード２
    Dim vntArrOrgName()             As Variant          '団体名
    Dim vntArrCloseDate()           As Variant          '締め日
    Dim vntArrBillSeq()             As Variant          'SEQ
    Dim vntArrBranchNo()            As Variant          '枝番variant
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    SelectPersonalCloseMngInfo = -1
    
    'キー値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "RSVNO", lngRsvNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    '指定された予約番号の締め管理情報を取得（個人負担分は除外）
'### 2004/03/07 Updated by Ishihara@FSIT 過去データには契約がないため、考慮しないと表示されない。
'    strStmt = "SELECT BASEINFO.ORGCD1, BASEINFO.ORGCD2, ORG.ORGNAME,            " & vbLf & _
              "       CLOSEMNG.CLOSEDATE, CLOSEMNG.BILLSEQ, CLOSEMNG.BRANCHNO   " & vbLf & _
              "  FROM ORG, CLOSEMNG,                                            " & vbLf & _
              "       ( SELECT DISTINCT CONSULT_M.ORGCD1,                       " & vbLf & _
              "                CONSULT_M.ORGCD2, CONSULT_M.CSCD                 " & vbLf & _
              "           FROM CONSULT_M                                        " & vbLf & _
              "          WHERE CONSULT_M.RSVNO   = :RSVNO                       " & vbLf & _
              "            AND CONSULT_M.ORGCD1 != 'XXXXX'                      " & vbLf & _
              "            AND CONSULT_M.ORGCD2 != 'XXXXX') BASEINFO            " & vbLf & _
              " WHERE :RSVNO          = CLOSEMNG.RSVNO(+)                       " & vbLf & _
              "   AND BASEINFO.ORGCD1 = CLOSEMNG.ORGCD1(+)                      " & vbLf & _
              "   AND BASEINFO.ORGCD2 = CLOSEMNG.ORGCD2(+)                      " & vbLf & _
              "   AND ORG.ORGCD1      = BASEINFO.ORGCD1                         " & vbLf & _
              "   AND ORG.ORGCD2      = BASEINFO.ORGCD2                         " & vbLf & _
              " ORDER BY BASEINFO.ORGCD1, BASEINFO.ORGCD2                       "
    strStmt = "SELECT BASEINFO.ORGCD1, BASEINFO.ORGCD2, ORG.ORGNAME,            " & vbLf & _
              "       CLOSEMNG.CLOSEDATE, CLOSEMNG.BILLSEQ, CLOSEMNG.BRANCHNO   " & vbLf & _
              "  FROM ORG, CLOSEMNG,                                            " & vbLf & _
              "       ( SELECT DISTINCT CONSULT_M.ORGCD1,                       " & vbLf & _
              "                CONSULT_M.ORGCD2                                 " & vbLf & _
              "           FROM CONSULT_M                                        " & vbLf & _
              "          WHERE CONSULT_M.RSVNO   = :RSVNO                       " & vbLf & _
              "            AND CONSULT_M.ORGCD1 != 'XXXXX'                      " & vbLf & _
              "            AND CONSULT_M.ORGCD2 != 'XXXXX'                      " & vbLf & _
              "        UNION                                                    " & vbLf & _
              "         SELECT DISTINCT CLOSEMNG.ORGCD1,                        " & vbLf & _
              "                CLOSEMNG.ORGCD2                                  " & vbLf & _
              "           FROM CLOSEMNG                                         " & vbLf & _
              "          WHERE CLOSEMNG.RSVNO    = :RSVNO                       " & vbLf & _
              "            AND CLOSEMNG.ORGCD1 != 'XXXXX'                       " & vbLf & _
              "            AND CLOSEMNG.ORGCD2 != 'XXXXX') BASEINFO             " & vbLf & _
              " WHERE :RSVNO          = CLOSEMNG.RSVNO(+)                       " & vbLf & _
              "   AND BASEINFO.ORGCD1 = CLOSEMNG.ORGCD1(+)                      " & vbLf & _
              "   AND BASEINFO.ORGCD2 = CLOSEMNG.ORGCD2(+)                      " & vbLf & _
              "   AND ORG.ORGCD1      = BASEINFO.ORGCD1                         " & vbLf & _
              "   AND ORG.ORGCD2      = BASEINFO.ORGCD2                         " & vbLf & _
              " ORDER BY BASEINFO.ORGCD1, BASEINFO.ORGCD2                       "
'### 2004/03/07 Updated End
        
    'SQL実行
    Set objOraDyna = mobjOraDb.CreateDynaset(OmitCharSpc(strStmt), ORADYN_READONLY + ORADYN_NOCACHE)
        
    'レコードが存在する場合
    If Not objOraDyna.EOF Then
        
        'オブジェクトの参照設定
        Set objFields = objOraDyna.Fields
        Set objOrgCd1 = objFields("ORGCD1")
        Set objOrgCd2 = objFields("ORGCD2")
        Set objOrgName = objFields("ORGNAME")
        Set objCloseDate = objFields("CLOSEDATE")
        Set objBillSeq = objFields("BILLSEQ")
        Set objBranchNo = objFields("BRANCHNO")
        
        lngCount = 0
        
        '配列形式で格納する
        Do Until objOraDyna.EOF
            
            ReDim Preserve vntArrOrgCd1(lngCount)
            ReDim Preserve vntArrOrgCd2(lngCount)
            ReDim Preserve vntArrOrgName(lngCount)
            ReDim Preserve vntArrCloseDate(lngCount)
            ReDim Preserve vntArrBillSeq(lngCount)
            ReDim Preserve vntArrBranchNo(lngCount)
            
            vntArrOrgCd1(lngCount) = objOrgCd1.Value & ""
            vntArrOrgCd2(lngCount) = objOrgCd2.Value & ""
            vntArrOrgName(lngCount) = objOrgName.Value & ""
            vntArrCloseDate(lngCount) = objCloseDate.Value & ""
            vntArrBillSeq(lngCount) = objBillSeq.Value & ""
            vntArrBranchNo(lngCount) = objBranchNo.Value & ""
            
            lngCount = lngCount + 1
            objOraDyna.MoveNext
        
        Loop
        
        '戻り値の設定
        If IsMissing(vntOrgCd1) = False Then vntOrgCd1 = vntArrOrgCd1
        If IsMissing(vntOrgCd2) = False Then vntOrgCd2 = vntArrOrgCd2
        If IsMissing(vntOrgName) = False Then vntOrgName = vntArrOrgName
        If IsMissing(vntCloseDate) = False Then vntCloseDate = vntArrCloseDate
        If IsMissing(vntBillSeq) = False Then vntBillSeq = vntArrBillSeq
        If IsMissing(vntBranchNo) = False Then vntBranchNo = vntArrBranchNo
        
        SelectPersonalCloseMngInfo = lngCount
        
    Else
        SelectPersonalCloseMngInfo = 0 '件数なし
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
    WriteErrorLog "Demand.SelectPersonalCloseMngInfo"
    
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
' 機能　　 : 個人受診金額の調整金額を更新する。
'
' 引数　　 : (In)    lngRsvNo              予約番号
' 　　　　   (In)    vntPriceSeq           ＳＥＱ
' 　　　　   (In)    vntEditPrice          調整金額
' 　　　　   (In)    vntEditTax            調整金額
'
' 戻り値　 : INSERT_NORMAL     正常終了
' 　　　　   INSERT_ERROR      異常終了
'
' 備考　　 :
'
Public Function RegistConsult_mEditPrice(ByVal lngRsvNo As Long, _
                                         ByVal vntPriceSeq As Variant, _
                                         ByVal vntEditPrice As Variant, _
                                         ByVal vntEditTax As Variant) As Long
                               
    Dim objOraParam         As OraParameters    'OraParametersオブジェクト
    Dim objOraDyna          As OraDynaset       'ダイナセット
    Dim strStmt             As String           'SQLステートメント

    Dim objRsvNo            As OraParamArray    '予約番号
    Dim objPriceSeq         As OraParamArray    'SEQ
    Dim objEditPrice        As OraParamArray    '調整金額
    Dim objEditTax          As OraParamArray    '調整税額

    Dim i                   As Integer
    Dim Ret                 As Long             '関数戻り値
    Dim lngItemCount        As Long
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    Ret = INSERT_ERROR
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    
    If IsArray(vntPriceSeq) Then
        lngItemCount = UBound(vntPriceSeq) + 1
    End If
    
    'キー及び更新値の設定再割り当て
    objOraParam.AddTable "RSVNO", ORAPARM_INPUT, ORATYPE_NUMBER, lngItemCount
    objOraParam.AddTable "PRICESEQ", ORAPARM_INPUT, ORATYPE_NUMBER, lngItemCount
    objOraParam.AddTable "EDITPRICE", ORAPARM_INPUT, ORATYPE_NUMBER, lngItemCount
    objOraParam.AddTable "EDITTAX", ORAPARM_INPUT, ORATYPE_NUMBER, lngItemCount
    
    'OraParameterオブジェクトの参照設定
    Set objRsvNo = objOraParam("RSVNO")
    Set objPriceSeq = objOraParam("PRICESEQ")
    Set objEditPrice = objOraParam("EDITPRICE")
    Set objEditTax = objOraParam("EDITTAX")
    
    'OraParameterオブジェクトの値設定
    For i = 0 To lngItemCount - 1
        objRsvNo(i) = lngRsvNo
        objPriceSeq(i) = vntPriceSeq(i)
        objEditPrice(i) = IIf(Trim(vntEditPrice(i)) = "", 0, Trim(vntEditPrice(i)))
        objEditTax(i) = IIf(Trim(vntEditTax(i)) = "", 0, Trim(vntEditTax(i)))
    Next i
    
    '更新
    strStmt = ""
    strStmt = strStmt & "UPDATE CONSULT_M SET EDITPRICE = :EDITPRICE, EDITTAX = :EDITTAX WHERE RSVNO = :RSVNO AND PRICESEQ = :PRICESEQ"
    mobjOraDb.ExecuteSQL strStmt
    
    'キー及び更新値の設定解除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    Ret = UPDATE_NORMAL
    
    '戻り値の設定
    RegistConsult_mEditPrice = Ret

    'トランザクションをコミット
    mobjContext.SetComplete

    Exit Function
    
ErrorHandle:

    'その他の戻り値設定
    RegistConsult_mEditPrice = UPDATE_ERROR

    'イベントログ書き込み
    WriteErrorLog "RoundClass.RegistConsult_mEditPrice"
    
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

' ### 2004/11/11 Add by Gouda@FSIT 団体請求コメントの追加
'
' 機能　　 : 請求書Ｎｏをキーに請求書コメントを更新する
'
' 引数　　 : (In)     vntIn_BillNo             請求書番号
' 　　　　   (In)     vntBillcomment        請求書コメント
'
' 戻り値　 : True   正常終了
' 　　　　 : False  異常終了
'
' 備考　　 :
'
Public Function UpdateDmdBill_comment(ByVal vntIn_BillNo As String, _
                                      ByVal vntBillComment As Variant) As Boolean

    Dim objOraParam             As OraParameters    'OraParametersオブジェクト
    Dim strStmt                 As String           'SQLステートメント
    
    Dim strCloseDate            As String           '締め日
    Dim lngBillSeq              As Long             '請求書Seq
    Dim lngBranchNo             As Long             '請求書枝番
    
    Dim blnIsBillNo             As Boolean          'TRUE:請求書番号が指定されている
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    '初期処理
    UpdateDmdBill_comment = False
    blnIsBillNo = False

    '請求書番号の妥当性チェック
    If IsMissing(vntIn_BillNo) = False Then
        vntIn_BillNo = Trim(vntIn_BillNo)
        
        If IsNumeric(vntIn_BillNo) = True Then
            If CDbl(vntIn_BillNo) > 0 Then
                If (Len(vntIn_BillNo) = LENGTH_BILLNO) Then
                    '請求書番号を分解
                    strCloseDate = Mid(vntIn_BillNo, 1, 4) & "/" & Mid(vntIn_BillNo, 5, 2) & "/" & Mid(vntIn_BillNo, 7, 2)
                    lngBillSeq = CLng(Mid(vntIn_BillNo, 9, 5))
                    lngBranchNo = CLng(Mid(vntIn_BillNo, 14, 1))
                    If IsDate(strCloseDate) Then
                        blnIsBillNo = True
                    End If
                End If
            End If
        End If
    End If
    
    '請求書番号が正しく指定されていない場合はエラー
    If blnIsBillNo = False Then
        Err.Raise 5     '「プロシージャの呼び出し、または引数が不正です。」
        Exit Function
    End If
    
    'エラーハンドラの設定
    On Error GoTo ErrorHandle
    
    'キー及び更新値の設定
    Set objOraParam = mobjOraDb.Parameters
    objOraParam.Add "CLOSEDATE", Trim(strCloseDate), ORAPARM_INPUT, ORATYPE_DATE
    objOraParam.Add "BILLSEQ", lngBillSeq, ORAPARM_INPUT, ORATYPE_NUMBER
    objOraParam.Add "BRANCHNO", lngBranchNo, ORAPARM_INPUT, ORATYPE_NUMBER
    
    objOraParam.Add "BILLCOMMENT", Trim(vntBillComment), ORAPARM_INPUT, ORATYPE_VARCHAR2
    
    
    '請求書テーブル　請求書コメントの更新
    strStmt = "UPDATE BILL                          " & vbLf & _
              "   SET BILLCOMMENT    = :BILLCOMMENT "
    
    strStmt = strStmt & vbLf & _
              " WHERE BILL.CLOSEDATE = :CLOSEDATE   " & vbLf & _
              "   AND BILL.BILLSEQ   = :BILLSEQ     " & vbLf & _
              "   AND BILL.BRANCHNO  = :BRANCHNO    "
     
    mobjOraDb.ExecuteSQL OmitCharSpc(strStmt)

    'バインド変数の削除
    Do Until objOraParam.Count <= 0
        objOraParam.Remove (objOraParam.Count - 1)
    Loop
    
    '戻り値の設定
    UpdateDmdBill_comment = True

    'トランザクションをコミット
    mobjContext.SetComplete
    
    Exit Function
    
ErrorHandle:

    'イベントログ書き込み
    WriteErrorLog "Demand.UpdateDmdBill_comment"
    
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

'### 2004/11/11 Add End
