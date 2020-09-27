<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      個人返金情報 (Ver0.0.1)
'      AUTHER  : keiko fujii@ffcs.co.jp
'             2004.01.19 入金情報と同じように入金方法を選べる必要があるので
'                        入金情報画面をコピーして再作成
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc" -->
<!-- #include virtual = "/webHains/includes/InterviewEditDropDown.inc" -->
<!-- '### 2004/11/30 Add by gouda@FSIT 計上日を追加する -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/GetCalcDate.inc" -->
<!-- '### 2004/11/30 End -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_DEMAND, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon           '共通クラス
Dim objFree             '汎用情報アクセス用
Dim objPerBill          '会計情報アクセス用
Dim objHainsUser        'ユーザ情報アクセス用
Dim objConsult          '受診情報アクセス用
Dim objPerson           '個人情報アクセス用
'### 2004/11/30 Add by gouda@FSIT 計上日を追加する
Dim objSchedule         'スケジュールアクセス用COMオブジェクト
'### 2004/11/30 Add End

Dim strMode             '処理モード(挿入:"insert"、更新:"update")
Dim strAction           '処理状態(保存ボタン押下時:"save"、保存完了後:"saveend")
Dim strTarget           'ターゲット先のURL

Dim strPerID            '個人ＩＤ
Dim strLastName         '姓
Dim strFirstName        '名
Dim strLastKName        'カナ姓
Dim strFirstKName       'カナ名
Dim strCslDate          '受信日
Dim lngRsvNo            '予約番号
Dim strCtrPtCd          '契約パターンコード（受診コース）
Dim strCsName           '受信コース名
Dim strBirth            '生年月日
Dim strBirthYear        '生年月日(年)
Dim strBirthMonth       '生年月日(月)
Dim strBirthDay         '生年月日(日)
Dim strGender           '性別

Dim lngDayId            '当日ＩＤ（受付済みチェック用）
Dim strComeDate         '来院日時（受付済みチェック用）
Dim strWrtOkFlg         '書き込みＯＫフラグ

'受診情報用変数
Dim strCsCd             'コースコード
Dim strAge              '年齢
Dim strGenderName       '性別名称
Dim strKeyDayId         '当日ID

Dim strKeyDate          '元の返金日
Dim lngKeySeq           '元の返金Ｓｅｑ

Dim strOriginalDate     '入金日
Dim strOriginalYear     '入金日（年）
Dim strOriginalMonth    '入金日（月）
Dim strOriginalDay      '入金日（日）
Dim lngOriginalSeq      '入金Ｓｅｑ

Dim strMaxDmdDate       '一番新しい請求日

Dim strPaymentDate      '返金日
Dim strPaymentYear      '返金日（年）
Dim strPaymentMonth     '返金日（月）
Dim strPaymentDay       '返金日（日）
Dim lngPaymentSeq       '返金Ｓｅｑ
Dim strBillNo           '請求書Ｎｏ
Dim strDmdDate          '請求日
Dim lngBillSeq          '請求書Ｓｅｑ
Dim lngDelflg           '取消伝票フラグ
Dim lngBranchNo         '請求書枝番
Dim lngPriceTotal       '請求金額合計
Dim lngRegisterno       'レジ番号
Dim lngCredit           '現金預かり金
Dim lngHappy_ticket     'ハッピー買物券
Dim lngCard             'カード
Dim strCardKind         'カード種別
Dim strCardName         'カード名
Dim lngCreditslipno     '伝票No
Dim lngJdebit           'Ｊデビット
Dim strBankCode         '金融機関コード
Dim strBankName         '金融機関名称
Dim lngCheque           '小切手
Dim lngTransfer         '振込み     2003.12.25 add
Dim strUpdDate          '更新日付
Dim strUpdUser          '更新者
Dim strPrintDate        '領収書印刷日
'### 2004/11/30 Add by gouda@FSIT 計上日を追加する
Dim strCalcDate         '計上日
Dim strCalcDateYear     '計上日（年）
Dim strCalcDateMonth    '計上日（月）
Dim strCalcDateDay      '計上日（日）
Dim strCloseDate        '締め日
Const strKey = "DAILYCLS"   '汎用テーブルのキー
'### 2004/11/30 Add End

Dim lngChangePrice      'おつり

Dim strUserName         'ユーザ名

Dim lngBillNoCnt        '請求書数

Dim vntDmdDate          '請求日 配列
Dim vntBillSeq          '請求書Ｓｅｑ 配列
Dim vntBranchNo         '請求書枝番 配列

Dim vntNullLastName     '姓
Dim vntNullFirstName    '名
Dim vntWkLastName       '姓
Dim vntWkFirstName      '名
Dim vntLastName         '姓　配列
Dim vntFirstName        '名　配列

Dim lngPriceWork        '請求金額
Dim strReqDmdDate       '請求日 Request
Dim strReqBillSeq       '請求書Ｓｅｑ Request
Dim strReqBranchNo      '請求書枝番 Request

Dim i                   'カウンタ

Dim strCheckCredit      '現金チェックボックス
Dim strCheckHappy       'ハッピー買物券チェックボックス
Dim strCheckCard        'カードチェックボックス
Dim strCheckJdebit      'Ｊデビットチェックボックス
Dim strCheckCheque      '小切手チェックボックス
Dim strCheckTransfer    '振込みチェックボックス      2003.12.25

Dim strArrMessage       'エラーメッセージ
Dim Ret                 '関数戻り値

Dim strArrRegisterno()      'レジ番号
Dim strArrRegisternoName()  'レジ番号名称

Dim strArrCardKind      'カード種別
Dim strArrCardName      'カード名称

Dim strArrBankCode      '銀行コード
Dim strArrBankName      '銀行名称

Dim strHTML             '呼び出し元ＨＴＭＬ
'## 2003.12.20 Add By T.Takagi@FSIT 領収書印刷対応
Dim strURL              'URL文字列
'## 2003.12.20 Add End
'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objFree         = Server.CreateObject("HainsFree.Free")
Set objHainsUser    = Server.CreateObject("HainsHainsUser.HainsUser")
Set objPerBill      = Server.CreateObject("HainsPerBill.PerBill")
Set objConsult      = Server.CreateObject("HainsConsult.Consult")
Set objPerson       = Server.CreateObject("HainsPerson.Person")

'引数値の取得
strMode             = Request("mode")
strAction           = Request("act")
strTarget           = Request("target")
lngRsvNo            = Request("rsvno")
strDmdDate          = Request("dmddate")
lngBillSeq          = Request("billseq")
lngBranchNo         = Request("branchno")

strReqDmdDate       = Request("reqdmddate")
strReqBillSeq       = Request("reqbillseq")
strReqBranchNo      = Request("reqbranchno")

lngBillNoCnt        = Request("billNoCnt")
vntDmdDate          = ConvIStringToArray(Request("arrdmddate"))
vntBillSeq          = ConvIStringToArray(Request("arrbillseq"))
vntBranchNo         = ConvIStringToArray(Request("arrbranchno"))
vntLastName         = ConvIStringToArray(Request("arrlastname"))
vntFirstName        = ConvIStringToArray(Request("arrfirstname"))

strKeyDate          = Request("keyDate")
lngKeySeq           = Request("keySeq")
strOriginalDate     = Request("originalDate")
lngOriginalSeq      = Request("originalSeq")

strMaxDmdDate       = Request("maxDmdDate")

strPerId            = Request("perId")
strBirth            = Request("Birth")
strGender           = Request("gender")
strPaymentDate      = Request("paymentDate")
strPaymentYear      = Request("pYear")
strPaymentMonth     = Request("pMonth")
strPaymentDay       = Request("pDay")
lngPaymentSeq       = Request("paymentSeq")
lngPriceTotal       = Request("priceTotal")
lngRegisterno       = Request("registernoval")
lngCredit           = Request("credit")
lngHappy_ticket     = Request("happy_ticket")
lngCard             = Request("card")
strCardKind         = Request("cardKind")
lngCreditslipno     = Request("creditslipno")
lngJdebit           = Request("jdebit")
strBankCode         = Request("bankCode")
lngCheque           = Request("cheque")
'## 振込み　追加 2003.12.25
lngTransfer         = Request("transfer")
strUpdDate          = Request("updDate")
strUpdUser          = Session.Contents("userId")
lngChangePrice      = Request("changeprice")
'### 2004/11/30 Add by gouda@FSIT 計上日を追加する
strCalcDate         = Request("calcDate")
strCalcDateYear     = Request("cYear")
strCalcDateMonth    = Request("cMonth")
strCalcDateDay      = Request("cDay")
'### 2004/11/30 Add End

strCheckCredit      = Request("checkCredit")
strCheckHappy       = Request("checkHappy")
strCheckCard        = Request("checkCard")
strCheckJdebit      = Request("checkJdebit")
strCheckCheque      = Request("checkCheque")
strCheckTransfer    = Request("checkTransfer")

'レジ番号・名称の配列作成
Call CreateRegisternoInfo()

'パラメタのデフォルト値設定
lngRsvNo   = IIf(IsNumeric(lngRsvNo) = False, 0,  lngRsvNo )

'未返金の場合、システム年月日を適用する
If strPaymentYear = "" Then
    strPaymentYear  = CStr(Year(Now))
    strPaymentMonth = CStr(Month(Now))
    strPaymentDay   = CStr(Day(Now))
End If

'### 2004/11/30 Add by gouda@FSIT 計上日を追加する
'締め日の取得
objFree.SelectFree 0, strKey, , , strCloseDate

'計上日の取得
Call GetCalcDate(strPaymentYear, strPaymentMonth,  strPaymentDay,  _
                strCalcDateYear, strCalcDateMonth, strCalcDateDay, _
                strCloseDate)
'### 2004/11/30 Update End

'2004.01.10 add
lngRegisterno = IIF( IsNumeric(lngRegisterno)=False, 1, lngRegisterno )


'チェック・更新・読み込み処理の制御
Do

    strWrtOkFlg = ""
    '予約番号がある場合
    If lngRsvNo <> 0 Then

        ''' 受付状況、来院状況が必要なため、来院情報取得処理に変更
        '受診情報検索
'		Ret = objConsult.SelectRslConsult(lngRsvNo,      _
'						  strPerId,      _
'						  strCslDate,    _
'						  strCsCd,       _
'						  strCsName,     _
'						  strLastName,   _
'						  strFirstName,  _
'						  strLastKName,  _
'						  strFirstKName, _
'						  strBirth,      _
'						  strAge,        _
'						  strGender,     _
'						  strGenderName, _
'						  strKeyDayId)

        '来院情報検索
        Ret = objConsult.SelectWelComeInfo(lngRsvNo,        _
                                        ,                   _
                                        strCslDate,         _
                                        strPerId,           _
                                        strCsCd,            _
                                        ,   ,   ,   ,       _
                                        strAge,             _
                                        ,   ,   ,   ,   ,   _
                                        ,   ,   ,   ,   ,   _
                                        lngDayId,           _
                                        strComeDate,        _
                                        ,   ,   ,           _
                                        strBirth,           _
                                        strGender,          _
                                        strLastName,        _
                                        strFirstName,       _
                                        strLastKName,       _
                                        strFirstKName,      _
                                        ,   ,   ,   ,   ,   _
                                        strCsName           _
                                    )

        '受診情報が存在しない場合はエラーとする
        If Ret = False Then
            Err.Raise 1000, , "受診情報が存在しません。（予約番号= " & lngRsvNo & " )"
        End If

        '受付済み　＆　来院済み
        If lngDayId <> "" And strComeDate <> "" Then
            strWrtOkFlg = "1"
        End If

    Else
        '個人ＩＤがある場合
        If strPerId <> "" Then
            '個人ＩＤ情報を取得する
            Ret = objPerson.SelectPerson_lukes(strPerId, _
                            strLastName, _
                            strFirstName, _
                            strLastKName, _
                            strFirstKName, _
                            ,  _
                            strBirth, _
                            strGender )
            '個人情報が存在しない場合
            If Ret = False Then
                Err.Raise 1000, , "個人情報が取得できません。（個人ＩＤ　= " & strPerId &" ）"
            End If
            strGenderName = IIf( strGender="1", "男性", "女性" )

            strAge = objFree.CalcAge(strBirth)
            
            '無条件に受付済状態
            strWrtOkFlg = "1"
        End If
    End If


    '削除ボタン押下時
    If strAction = "delete" Then

        Ret = objPerBill.DeletePerPayment ( _
                        strKeyDate, _
                        lngKeySeq ) 
        
'		Response.Redirect Request.ServerVariables("SCRIPT_NAME") & "?mode=insert&act=deleteend&rsvno=" & lngRsvNo & "&dmddate=" & strDmdDate  & "&billseq=" & lngBillSeq & "&branchno=" & lngBranchNo
        'エラーがなければ呼び元画面を再表示して自身を閉じる
        strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
        strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
        strHTML = strHTML & "</BODY>"
        strHTML = strHTML & "</HTML>"
        Response.Write strHTML
        Response.End
        Exit Do

    End If

    '保存ボタン押下時
    If strAction = "save" Then
        IF lngPriceTotal >= 0 Then
            lngChangePrice = - CLng(lngPriceTotal)
        End if

        '金額:数値入力チェック
        lngCredit = IIf( lngCredit = "", 0, lngCredit )

        '### 2005/09/30 張 (-)返金発生の為、修正 Start ###
        'strArrMessage = objCommon.CheckNumeric("現金", lngCredit, 8)
        'If strArrMessage <> "" Then
        '        Err.Raise 1000, , "現金エラー。 " 
        '    Exit Do
        'End If

        strArrMessage = objCommon.CheckNumericSign("現金", lngCredit, 8)
        If strArrMessage <> "" Then
                Err.Raise 1000, , "現金エラー。 " 
            Exit Do
        End If
        '### 2005/09/30 張 (-)返金発生の為、修正 End   ###

        
        lngHappy_ticket = IIf( lngHappy_ticket = "", 0, lngHappy_ticket )
        strArrMessage = objPerBill.CheckNumeric("ハッピー買物券", lngHappy_ticket, 8)
        If strArrMessage <> "" Then
                Err.Raise 1000, , "ハッピー買物券エラー。 " 
            Exit Do
        End If
        lngCard = IIf( lngCard = "", 0, lngCard )
        strArrMessage = objPerBill.CheckNumeric("カード", lngCard, 8)
        If strArrMessage <> "" Then
                Err.Raise 1000, , "カードエラー。 " 
            Exit Do
        End If
        lngJdebit = IIf( lngJdebit = "", 0, lngJdebit )
        strArrMessage = objPerBill.CheckNumeric("Ｊデビット", lngJdebit, 8)
        If strArrMessage <> "" Then
                Err.Raise 1000, , "Ｊデビットエラー。 " 
            Exit Do
        End If
        lngCheque = IIf( lngCheque = "", 0, lngCheque )
        strArrMessage = objPerBill.CheckNumeric("小切手", lngCheque, 8)
        If strArrMessage <> "" Then
                Err.Raise 1000, , "小切手エラー。 " 
            Exit Do
        End If
        lngTransfer = IIf( lngTransfer = "", 0, lngTransfer )
        strArrMessage = objPerBill.CheckNumeric("振込み", lngTransfer, 8)
        If strArrMessage <> "" Then
                Err.Raise 1000, , "振込みエラー。 " 
            Exit Do
        End If

        lngChangePrice = (CLng(lngCredit) + CLng(lngHappy_Ticket) + CLng(lngCard) + CLng(lngJdebit) + CLng(lngCheque) + CLng(lngTransfer)) - CLng(lngPriceTotal)

        '伝票No.:数値入力チェック
        lngCreditslipno = IIf( lngCreditslipno = "", 0, lngCreditslipno )
        strArrMessage = objPerBill.CheckNumeric("伝票No.", lngCreditslipno, 5)
        If strArrMessage <> "" Then
            Exit Do
        End If

        '返金日の編集
' ### 2004/11/30 Update by gouda@FSIT 返金日のチェックを追加する
'       strPaymentDate = CDate(strPaymentYear & "/" & strPaymentMonth & "/" & strPaymentDay)
        strPaymentDate = strPaymentYear & "/" & strPaymentMonth & "/" & strPaymentDay
' ### 2004/11/30 Update

' ### 2004/11/30 Add by gouda@FSIT 計上日を追加する
        '計上日の編集
        strCalcDate = strCalcDateYear & "/" & strCalcDateMonth & "/" & strCalcDateDay
' ### 2004/11/30 Add End

        '入力チェック
        strArrMessage = CheckValue()
        If Not IsEmpty(strArrMessage) Then
            Exit Do
        End If

' ### 2004/11/30 Update by gouda@FSIT 返金日のチェックを追加する
        strPaymentDate = CDate(strPaymentYear & "/" & strPaymentMonth & "/" & strPaymentDay)
' ### 2004/11/30 Update End

' ### 2004/11/30 Add by gouda@FSIT 計上日を追加する
        strCalcDate = CDate(strCalcDateYear & "/" & strCalcDateMonth & "/" & strCalcDateDay)
' ### 2004/11/30 Add End


''###2005/10/17 by 李　####################################
'		If lngPriceTotal > 0 Then
'			lngPriceTotal = -1 * lngPriceTotal
'		End If
'		If lngCredit > 0 Then
'			lngCredit = -1 * lngCredit
'		End If
'		If lngHappy_ticket > 0 Then
'			lngHappy_ticket = -1 * lngHappy_ticket
'		End If
'		If lngCard > 0 Then
'			lngCard = -1 * lngCard
'		End If
'		If lngJdebit > 0 Then
'			lngJdebit = -1 * lngJdebit
'		End If
'		If lngCheque > 0 Then
'			lngCheque = -1 * lngCheque
'		End If
'		If lngTransfer > 0 Then
'			lngTransfer = -1 * lngTransfer
'		End If

        lngPriceTotal = -1 * lngPriceTotal
        lngCredit = -1 * lngCredit
        lngHappy_ticket = -1 * lngHappy_ticket
        lngCard = -1 * lngCard
        lngJdebit = -1 * lngJdebit
        lngCheque = -1 * lngCheque
        lngTransfer = -1 * lngTransfer


        '### 2004.01.19以前は保存時に引数１番目＝２とし、ＣＯＭ＋で返金処理として
        '　　元の入金金額に－１をかけて登録していたが返金時も任意に返金方法を選べるように
        '    なったので、入金処理と同じ保存方法となった
        '保存処理
        If strMode = "insert" Then
'### 2004/11/25 Updated by Ishihara@FSIT とりあえず応急措置
'			strArrMessage = objPerBill.InsertPerPayment( _
'                                                        1, _
'							strPaymentDate, lngPaymentSeq, _
'                                                        "", "", _
'    							vntDmdDate, vntBillSeq, _
'							vntBranchNo, _
'							lngRegisterno, _
'							strUpdUser, lngPriceTotal, _
'							lngCredit, lngHappy_ticket, lngCard, _
'							strCardKind, lngCreditslipno, _
'							lngJdebit,     strBankCode, _
'							lngCheque,     lngTransfer _
'						)
' ### 2004/11/30 Add by gouda@FSIT 計上日を追加する
'			strArrMessage = objPerBill.InsertPerPayment( _
'                                                        1, _
'							strPaymentDate, lngPaymentSeq, _
'                                                        "", "", _
'    							vntDmdDate, vntBillSeq, _
'							vntBranchNo, _
'							lngRegisterno, _
'							strUpdUser, lngPriceTotal, _
'							lngCredit, lngHappy_ticket, lngCard, _
'							strCardKind, lngCreditslipno, _
'							lngJdebit,     strBankCode, _
'							lngCheque,     lngTransfer, cDate(Now) _
'						)
'### 2004/11/25 Updated End
'		Else
'			strArrMessage = objPerBill.UpdatePerPayment( _
'							1, strKeyDate, lngKeySeq, _
'							strPaymentDate, lngPaymentSeq, _
'    							vntDmdDate, vntBillSeq, _
'							vntBranchNo, _
'							lngPriceTotal, lngRegisterno, _
'							strUpdUser, _
'							lngCredit, lngHappy_ticket, lngCard, _
'							strCardKind, lngCreditslipno, _
'							lngJdebit, strBankCode, _
'							lngCheque,     lngTransfer _
'						)
'		End IF

            strArrMessage = objPerBill.InsertPerPayment( _
                                                        1, _
                            strPaymentDate, lngPaymentSeq, _
                                                        "", "", _
                                vntDmdDate, vntBillSeq, _
                            vntBranchNo, _
                            lngRegisterno, _
                            strUpdUser, lngPriceTotal, _
                            lngCredit, lngHappy_ticket, lngCard, _
                            strCardKind, lngCreditslipno, _
                            lngJdebit,     strBankCode, _
                            lngCheque,     lngTransfer, strCalcDate _
                        )
        
        Else

            
            strArrMessage = objPerBill.UpdatePerPayment( _
                            1, strKeyDate, lngKeySeq, _
                            strPaymentDate, lngPaymentSeq, _
                                vntDmdDate, vntBillSeq, _
                            vntBranchNo, _
                            lngPriceTotal, lngRegisterno, _
                            strUpdUser, _
                            lngCredit, lngHappy_ticket, lngCard, _
                            strCardKind, lngCreditslipno, _
                            lngJdebit, strBankCode, _
                            lngCheque,     lngTransfer, strCalcDate _
                        )
        End IF
' ### 2004/11/30 Add End

        '更新エラー時は処理を抜ける
        If Not IsEmpty(strArrMessage) Then
'               Err.Raise 1000, , "保存エラー。 " 
            Exit Do
        End If

        'エラーがなければ呼び元画面を再表示して自身を閉じる
        strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
        strHTML = strHTML & "<BODY ONLOAD=""javascript:if ( opener != null ) opener.location.reload(); close()"">"
        strHTML = strHTML & "</BODY>"
        strHTML = strHTML & "</HTML>"
        Response.Write strHTML
        Response.End
        Exit Do

    End If


    '請求書Ｎｏから個人請求書管理情報を取得する
    objPerbill.SelectPerBill_BillNo strDmdDate, _
                           lngBillSeq, _
                           lngBranchNo, _
                           lngDelflg, _
                           , _
                           , _
                           , _
                           , _
                           strPaymentDate, _
                           lngPaymentSeq, _
                           , _
                           , _
                           , _
                           , _
                           lngPriceTotal, _
                           , _
                           strPrintDate


    '未返金？
    If IsNull(strPaymentDate) = True Then
        strMode = "insert"
        '元の請求書情報取得
        objPerbill.SelectPerBill_BillNo strDmdDate, _
                           lngBillSeq, _
                           "0", _
                           lngDelflg, _
                           , _
                           , _
                           , _
                           , _
                           strOriginalDate, _
                           lngOriginalSeq, _
                           , _
                           , _
                           , _
                           , _
                           lngPriceTotal


        '返金年月日の編集
        strOriginalDate = CDate(strOriginalDate)
        strOriginalYear  = CStr(Year(strOriginalDate))
        strOriginalMonth = CStr(Month(strOriginalDate))
        strOriginalDay   = CStr(Day(strOriginalDate))

        strPaymentDate = strOriginalDate
        lngPaymentSeq  = lngOriginalSeq

        '同一返金の請求書Ｎｏ取得
''' 名前も取得する　2003.12.19 
'		lngBillNoCnt = objPerBill.SelectBillNo_Payment ( _
'						strOriginalDate, _
'						lngOriginalSeq, _
'						vntDmdDate, _
'						vntBillSeq, _
'						vntBranchNo )
        lngBillNoCnt = objPerBill.SelectBillNo_Payment ( _
                        strOriginalDate, _
                        lngOriginalSeq, _
                        vntDmdDate, _
                        vntBillSeq, _
                        vntBranchNo, _
                        vntLastName, vntFirstName )

        If lngBillNoCnt <= 0 Then
            Exit Do
        End If

    Else
        strMode = "update"
        '返金年月日の編集
        strPaymentDate = CDate(strPaymentDate)
        strPaymentYear  = CStr(Year(strPaymentDate))
        strPaymentMonth = CStr(Month(strPaymentDate))
        strPaymentDay   = CStr(Day(strPaymentDate))

        strKeyDate = strPaymentDate
        lngKeySeq  = lngPaymentSeq

''' 名前も取得する　2003.12.18 
'		lngBillNoCnt = objPerBill.SelectBillNo_Payment ( _
'						strPaymentDate, _
'						lngPaymentSeq, _
'						vntDmdDate, _
'						vntBillSeq, _
'						vntBranchNo )
        lngBillNoCnt = objPerBill.SelectBillNo_Payment ( _
                        strPaymentDate, _
                        lngPaymentSeq, _
                        vntDmdDate, _
                        vntBillSeq, _
                        vntBranchNo, _
                        vntLastName, vntFirstName )
        If lngBillNoCnt <= 0 Then
            Exit Do
        End If

    End If

    For i = 0 To UBound(vntBranchNo)
        vntBranchNo(i) = 1
    Next 
    For i = 0 To UBound(vntDmdDate)
        If strMaxDmdDate < vntDmdDate(i) Then
            strMaxDmdDate = vntDmdDate(i)
        End If
    Next

    '新規モードの場合は読み込みを行わない
'	If strMode = "insert" Then
'		lngChangePrice = -1
'
'		Exit Do
'	End If

    '### 2004/11/30 Add by gouda@FSIT 計上日を追加する
    '### 振込み(TRANSFER)を追加 2003.12.25
'	objPerBill.SelectPerPayment _
'    						strPaymentDate, lngPaymentSeq, _
'    						lngPriceTotal, lngCredit, _
'    						lngHappy_ticket, lngCard, _
'						strCardKind, strCardName, _
'    						lngCreditslipno, _
'						lngJdebit, strBankCode, _
'						strBankName, lngCheque, _
'						lngRegisterno, strUpdDate, _
'    						strUpdUser, strUserName, _
'							lngTransfer 
    objPerBill.SelectPerPayment _
                            strPaymentDate, lngPaymentSeq, _
                            lngPriceTotal, lngCredit, _
                            lngHappy_ticket, lngCard, _
                        strCardKind, strCardName, _
                            lngCreditslipno, _
                        lngJdebit, strBankCode, _
                        strBankName, lngCheque, _
                        lngRegisterno, strUpdDate, _
                            strUpdUser, strUserName, _
                            lngTransfer, strCalcDate 
    '### 2004/11/30 Add End

    '新規モードの場合は更新日付クリア
    If strMode = "insert" Then
        strUpdDate = ""
'### 2004/02/12 Added by Ishihara@FSIT オペレータもクリアしてください。
        strUpdUser = ""
        strUserName = ""
'### 2004/02/12 Added End
    
    Else
'' 2005/10/17 Edit by 李　###################################
'    	If lngPriceTotal < 0 Then
'	    	lngPriceTotal = -1 * lngPriceTotal
'      	End If
'        If lngCredit < 0 Then
'		    lngCredit = -1 * lngCredit
'    	End If
'	    If lngHappy_ticket < 0 Then
'		    lngHappy_ticket = -1 * lngHappy_ticket
 '   	End If
'	    If lngCard < 0 Then
'		    lngCard = -1 * lngCard
 '   	End If
'	    If lngJdebit < 0 Then
'		    lngJdebit = -1 * lngJdebit
 '   	End If
'	    If lngCheque < 0 Then
'		    lngCheque = -1 * lngCheque
 '   	End If
'	    If lngTransfer < 0 Then
'		    lngTransfer = -1 * lngTransfer
 '   	End If

    lngPriceTotal = -1 * lngPriceTotal
    lngCredit = -1 * lngCredit
    lngHappy_ticket = -1 * lngHappy_ticket
    lngCard = -1 * lngCard
    lngJdebit = -1 * lngJdebit
    lngCheque = -1 * lngCheque
    lngTransfer = -1 * lngTransfer

'' 2005/10/17 Edit by 李　###################################    
    End If


'' 2005/10/17 Edit by 李　###################################
'	strCheckCredit   = IIf(CLng(lngCredit) > 0, "1",  "" )
    strCheckCredit   = IIf(CLng(lngCredit) > 0, "1",  "1" )
'' 2005/10/17 Edit by 李　###################################

    strCheckHappy    = IIf(CLng(lngHappy_ticket) > 0, "2",  "" )
    strCheckCard     = IIf(CLng(lngCard) > 0, "3",  "" )
    strCheckJdebit   = IIf(CLng(lngJdebit) > 0, "4",  "" )
    strCheckCheque   = IIf(CLng(lngCheque) > 0, "5",  "" )
    '### 振込み(TRANSFER)を追加 2003.12.25
    strCheckTransfer   = IIf(CLng(lngTransfer) > 0, "6",  "" )

    '### 振込み(TRANSFER)を追加 2003.12.25
'	lngChangePrice = (CLng(lngCredit) + CLng(lngHappy_Ticket) + CLng(lngCard) + CLng(lngJdebit) + CLng(lngCheque)) - CLng(lngPriceTotal)
    lngChangePrice = (CLng(lngCredit) + CLng(lngHappy_Ticket) + CLng(lngCard) + CLng(lngJdebit) + CLng(lngCheque) + CLng(lngTransfer)) - CLng(lngPriceTotal)

    '### 2004/11/30 Update by gouda@FSIT 計上日を追加する
    '新規モードの場合は表示しない
    If Not strMode = "insert" Then
        strCalcDateYear  = CStr(Year(strCalcDate))
        strCalcDateMonth = CStr(Month(strCalcDate))
        strCalcDateDay   = CStr(Day(strCalcDate))
    End If
    '### 2004/11/30 Update End

    Exit Do
Loop

'-------------------------------------------------------------------------------
'
' 機能　　 : レジ番号・名称の配列作成
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub CreateRegisternoInfo()

    Redim Preserve strArrRegisterno(2)
    Redim Preserve strArrRegisternoName(2)

    strArrRegisterno(0) = "1":strArrRegisternoName(0) = "1"
    strArrRegisterno(1) = "2":strArrRegisternoName(1) = "2"
    strArrRegisterno(2) = "3":strArrRegisternoName(2) = "3"

End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 : 返金情報の妥当性チェックを行う
'
' 引数　　 :
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckValue()
    Dim vntArrMessage   'エラーメッセージの集合
    Dim strMessage      'エラーメッセージ

    '各値チェック処理
    With objCommon
        ' ### 2004/11/30 Update by gouda@FSIT 返金日のチェックを追加する
'		If Trim(strMaxDmdDate) > Trim(strPaymentDate) Then
'			.AppendArray vntArrMessage, "返金日が請求日より過去です。"
'		End If

        If Not IsDate(Trim(strPaymentDate)) Then
            .AppendArray vntArrMessage, "返金日の入力形式が正しくありません。"
        Else
            If CDate(strMaxDmdDate) > CDate(strPaymentDate) Then
                .AppendArray vntArrMessage, "返金日は請求日よりも過去の日付に設定することはできません。"
            End If
        End If
        ' ### 2004/11/30 Update End
        
        ' ### 2004/11/30 Add by gouda@FSIT 計上日を追加する
        If Not IsDate(Trim(strCalcDate)) Then
            .AppendArray vntArrMessage, "計上日の入力形式が正しくありません。"
        Else
            If IsDate(Trim(strPaymentDate)) Then
                If CDate(strPaymentDate) > CDate(strCalcDate) Then
                    .AppendArray vntArrMessage, "計上日は返金日よりも過去の日付に設定することはできません。"
                End If
            End If
        End If
        ' ### 2004/11/30 Add End

        If lngCard <> 0 And _
                (strCardKind = "" Or lngCreditslipno = 0) Then
            .AppendArray vntArrMessage, "カード情報が入力されていません。"
        End If
        
        If lngJdebit <> 0 And strBankCode = "" Then
            .AppendArray vntArrMessage, "Ｊデビットの金融機関が指定されていません。"
        End If

'		if lngChangePrice < 0 Then
'			.AppendArray vntArrMessage, "返金金額が入金金額に達していないため保存できません。"
'		End If

    End With

    '戻り値の編集
    If IsArray(vntArrMessage) Then
        CheckValue = vntArrMessage
    End If

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>返金情報</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!-- #include virtual = "/webHains/includes/Date.inc" -->
<!-- #include virtual = "/webHains/includes/price.inc" -->
<!--
var winAllocate, winGuideOrg, winGuideCal;
var curYear, curMonth, curDay;	// 日付ガイド呼び出し直前の日付退避用変数

var varChangePrice, varCredit, varlngHappy_Ticket,varCard, varJdebit, varCheque, varPriceTotal;
// 2003.12.25 振込み　追加
var varTransfer;

// ### 2004/11/30 Add by gouda@FSIT 計上日を追加する
var curYear_Calc, curMonth_Calc, curDay_Calc;	// 計上日の日付ガイド呼び出し直前の日付退避用変数
// ### 2004/11/30 Add End

// 日付ガイド呼び出し
function callCalGuide() {

    // ガイド呼び出し直前の日付を退避
    curYear  = document.entryForm.pyear.value;
    curMonth = document.entryForm.pmonth.value;
    curDay   = document.entryForm.pday.value;

    // 日付ガイド表示
    calGuide_showGuideCalendar( 'pyear', 'pmonth', 'pday', checkDateChanged );

}

// 返金日変更チェック
function checkDateChanged() {

    // 退避していた日付と異なる場合、受診日変更時の処理を呼び出す
    with ( document.entryForm ) {
        if ( pyear.value != curYear || pmonth.value != curMonth || pday.value != curDay ) {
//			replaceOptionFrame();
        }
    }

}

// ### 2004/11/30 Add by gouda@FSIT 計上日を追加する
// 計上日の日付ガイド呼び出し
function callCalGuide_Calc() {

    // ガイド呼び出し直前の日付を退避
    curYear_Calc  = document.entryForm.cyear.value;
    curMonth_Calc = document.entryForm.cmonth.value;
    curDay_Calc   = document.entryForm.cday.value;

    // 日付ガイド表示
    calGuide_showGuideCalendar( 'cyear', 'cmonth', 'cday', checkDateChanged_Calc );

}

// 計上日変更チェック
function checkDateChanged_Calc() {

    // 退避していた日付と異なる場合、受診日変更時の処理を呼び出す
    with ( document.entryForm ) {
        if ( cyear.value != curYear_Calc || cmonth.value != curMonth_Calc || cday.value != curDay_Calc ) {
        }
    }

}
// ### 2004/11/30 Add End

function checkCreditAct() {

    with ( document.entryForm ) {
        checkCredit.value = (checkCredit.checked ? '1' : '');
        credit.value = (checkCredit.checked ? credit.value : '');
    }

    CalcChange();
}

function checkHappyAct() {

    with ( document.entryForm ) {
        checkHappy.value = (checkHappy.checked ? '2' : '');
        happy_ticket.value = (checkHappy.checked ? happy_ticket.value : '');
    }

    CalcChange();
}

function checkCardAct() {

    with ( document.entryForm ) {
        checkCard.value = (checkCard.checked ? '3' : '');
        card.value = (checkCard.checked ? card.value : '');
        creditslipno.value = (checkCard.checked ? creditslipno.value : '');
    }

    CalcChange();
}

function checkJdebitAct() {

    with ( document.entryForm ) {
        checkJdebit.value = (checkJdebit.checked ? '4' : '');
        jdebit.value = (checkJdebit.checked ? jdebit.value : '');
    }

    CalcChange();
}

function checkChequeAct() {

    with ( document.entryForm ) {
        checkCheque.value = (checkCheque.checked ? '5' : '');
        cheque.value = (checkCheque.checked ? cheque.value : '');
    }

    CalcChange();
}

// 2003.12.25 振込み　追加
function checkTransferAct() {

    with ( document.entryForm ) {
        checkTransfer.value = (checkTransfer.checked ? '6' : '');
        transfer.value = (checkTransfer.checked ? transfer.value : '');
    }

    CalcChange();
}

// エンターキー押下時の処理 2004.01.04
function keyPressFunc() {

    if ("13" == window.event.keyCode) {
        CalcChange();
    }

}

function CalcChange() {

    var dayid;
    var comedate;

    with ( document.entryForm ) {
        varCredit = credit.value - 0 ;
                varHappy_Ticket = happy_ticket.value - 0 ;
                varCard = card.value - 0 ;
                varJdebit = jdebit.value - 0 ;
                varCheque = cheque.value - 0 ;
                // 2003.12.25 振込み　追加
                varTransfer = transfer.value - 0 ;
                varPriceTotal = pricetotal.value - 0;

    }

    // 2003.12.25 振込み　追加
//	varChangePrice = (varCredit + varHappy_Ticket + varCard + varJdebit + varCheque) - varPriceTotal;
    varChangePrice = (varCredit + varHappy_Ticket + varCard + varJdebit + varCheque + varTransfer) - varPriceTotal;

    dayid = '<%= lngDayId %>';
    comedate = '<%= strComeDate %>';
    if( varChangePrice == 0 ){
        document.getElementById('changeprice').innerHTML = '返金額に達しました';
    } else if( varChangePrice > 0 ){
        document.getElementById('changeprice').innerHTML = formatCurrency(varChangePrice) + '　超過しています';
    } else {
        //未受付の場合
        if ( dayid == '' ){
            document.getElementById('changeprice').innerHTML = 'まだ受け付けていません';
        } else {
            //未来院の場合
            if ( comedate == '' ){
                document.getElementById('changeprice').innerHTML = 'まだ来院していません';
            } else {
                document.getElementById('changeprice').innerHTML = '返金額に達していません';
            }
        }
    }

}


//-->


<!--
// 削除確認メッセージ
function deleteData() {

    if ( !confirm( 'この返金情報を削除します。よろしいですか？' ) ) {
        return;
    }


    // モードを指定してsubmit
    document.entryForm.act.value = 'delete';
    document.entryForm.mode.value = 'delete';
    document.entryForm.submit();

}


// 次画面処理
function goNextPage() {

    with ( document.entryForm ) {
        varCredit = credit.value - 0 ;
                varHappy_Ticket = happy_ticket.value - 0 ;
                varCard = card.value - 0 ;
                varJdebit = jdebit.value - 0 ;
                varCheque = cheque.value - 0 ;
                // 2003.12.25 振込み　追加
                varTransfer = transfer.value - 0 ;
                varPriceTotal = pricetotal.value - 0;
        // 日付変換
        varPaymenDate = formatDate( pyear.value, pmonth.value, pday.value );
        // ### 2004/11/30 Add by gouda@FSIT 計上日を追加する
        varCalcDate = formatDate( cyear.value, cmonth.value, cday.value );
        // ### 2004/11/30 Add End

    }
    // おつり
//	varChangePrice = (varCredit + varHappy_Ticket + varCard + varJdebit + varCheque) - varPriceTotal;

    if (varCard == 0){
        document.entryForm.cardkind.value = '';
        document.entryForm.creditslipno.value = '';
    }
    if (varJdebit == 0){
        document.entryForm.bankcode.value = '';
    }

    // 自画面を送信
    document.entryForm.submit();

//	return false;
}

// レジNoが選択されたときの処理 2004.01.04 add
function selectRegiNo( val ) {

    var curDate = new Date();
    var previsit = curDate.toGMTString();

    curDate.setTime( curDate.getTime() + 30*365*24*60*60*1000 ); // 30年後

    var expire = curDate.toGMTString();

    document.cookie = 'regino=' + val + ';expires=' + expire;

    document.entryForm.registernoval.value = val;

}

// 親ウインドウへ戻る
function goBackPage() {

    // 連絡域に設定されてある親画面の関数呼び出し
    if ( opener.dmdPayment_CalledFunction != null ) {
        opener.dmdPayment_CalledFunction();
    }

    close();

    return false;
}
function windowClose() {

    //日付ガイドを閉じる
    calGuide_closeGuideCalendar();

}

// '### 2004/11/30 Add by gouda@FSIT 計上日を追加する -->
// 確定ボタン押下時の処理
// 締め日と計上日が同じ日付になっていないかチェック
function PreserveCheck() {

    var closedate;
    var calcdate;
    var calcdateyear;
    var calcdatemonth;
    var calcdateday;
    var msg;

    closedate = '<%= strCloseDate %>';

    calcdateyear = document.entryForm.cyear.value;
    calcdatemonth = document.entryForm.cmonth.value;
    calcdateday = document.entryForm.cday.value;

    if ( calcdatemonth.length == 1 ) {
        calcdatemonth = '0' + calcdatemonth
    }

    if ( calcdateday.length == 1 ) {
        calcdateday = '0' + calcdateday
    }

    calcdate = '';
    calcdate = calcdateyear + '/' + calcdatemonth + '/' + calcdateday;

    if ( calcdate == closedate ) {

        msg = '';
        msg = '日次締め処理が完了している日にちに対しての処理を実行しようとしています。よろしいですか？';
    
        if ( confirm(msg) ) {
            return true;
        } else {
            return false;
        }
    } else {
        return true;
    }
}
// '### 2004/11/30 Add

//-->
</SCRIPT>
<style type="text/css">
	body { margin: 20px 0 0 20px; }
</style>
</HEAD>
<BODY ONLOAD="JavaScript:document.entryForm.credit.focus()" ONUNLOAD="javascript:windowClose()">
    <FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><SPAN CLASS="demand">■</SPAN><B>返金情報</B></TD>
        </TR>
    </TABLE>
    <!-- 引数情報 -->
    <INPUT TYPE="hidden" NAME="act"         VALUE="save">
    <INPUT TYPE="hidden" NAME="mode"        VALUE="<%= strMode %>">
    <INPUT TYPE="hidden" NAME="rsvno"       VALUE="<%= lngRsvNo %>">
    <INPUT TYPE="hidden" NAME="dmddate"     VALUE="<%= strDmdDate %>">
    <INPUT TYPE="hidden" NAME="billseq"     VALUE="<%= lngBillSeq %>">
    <INPUT TYPE="hidden" NAME="branchno"    VALUE="<%= lngBranchNo %>">
    <INPUT TYPE="hidden" NAME="pricetotal"  VALUE="<%= lngPriceTotal %>"> 
    <INPUT TYPE="hidden" NAME="delflg"      VALUE="<%= lngDelflg %>"> 
    <INPUT TYPE="hidden" NAME="keyDate"     VALUE="<%= strKeyDate %>"> 
    <INPUT TYPE="hidden" NAME="keySeq"      VALUE="<%= lngKeySeq %>"> 
    <INPUT TYPE="hidden" NAME="paymentDate" VALUE="<%= strPaymentDate %>"> 
    <INPUT TYPE="hidden" NAME="maxDmdDate"  VALUE="<%= strMaxDmdDate %>"> 
    <INPUT TYPE="hidden" NAME="billNoCnt"   VALUE="<%= lngBillNoCnt %>"> 
    <INPUT TYPE="hidden" NAME="perid"       VALUE="<%= strPerId %>"> 
    <!--'### 2004/11/30 Add by gouda@FSIT 計上日を追加する -->
    <INPUT TYPE="hidden" NAME="calcDate"    VALUE="<%= strCalcDate %>"> 
    <!--'### 2004/11/30 Add End -->

    <INPUT TYPE="hidden" NAME="reqdmddate"  VALUE="<%= strReqDmdDate %>">
    <INPUT TYPE="hidden" NAME="reqbillseq"  VALUE="<%= strReqBillSeq %>">
    <INPUT TYPE="hidden" NAME="reqbranchno" VALUE="<%= strReqBranchNo %>">
<%
    For i = 0 To lngBillNoCnt - 1
%>
    <INPUT TYPE="hidden" NAME="arrdmddate"      VALUE="<%= vntDmdDate(i) %>">
    <INPUT TYPE="hidden" NAME="arrbillseq"      VALUE="<%= vntBillSeq(i) %>">
    <INPUT TYPE="hidden" NAME="arrbranchno"     VALUE="<%= vntBranchNo(i) %>">
    <INPUT TYPE="hidden" NAME="arrlastname"     VALUE="<%= vntLastName(i) %>">
    <INPUT TYPE="hidden" NAME="arrfirstname"    VALUE="<%= vntFirstName(i) %>">
<%
    Next
%>
<%
    'メッセージの編集
    If strAction <> "" Then

        Select Case strAction

            '保存完了時は「保存完了」の通知
            Case "saveend"
                Call EditMessage("保存が完了しました。", MESSAGETYPE_NORMAL)

            '削除完了時は「削除完了」の通知
            Case "deleteend"
                Call EditMessage("削除が完了しました。", MESSAGETYPE_NORMAL)

            'さもなくばエラーメッセージを編集
            Case Else
                Call EditMessage(strArrMessage, MESSAGETYPE_WARNING)

        End Select

    End If
%>
    <BR>
    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
        <TR>
            <TD>受診日</TD>
            <TD>：</TD>
            <TD><FONT COLOR="#ff6600"><B><%= strCslDate %>

            <TD>予約番号</TD>
            <TD>：</TD>
<%
            If lngRsvNo = 0 Then
%>
                <TD><FONT COLOR="#ff6600"><B></B></FONT></TD>
<%
            Else
%>
                <TD><FONT COLOR="#ff6600"><B><%= lngRsvNo %></B></FONT></TD>
<%
            End If
%>
        </TR>
        <TR>
            <TD>受診コース</TD>
            <TD>：</TD>
            <TD><FONT COLOR="#ff6600"><B><%= strCsName %></B></FONT></TD>
            <TD></TD>
            <TD></TD>
            <TD></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="0">
        <TR>
            <TD HEIGHT="10"></TD>
        </TR>
        <TR>
            <TD NOWRAP ROWSPAN="2" VALIGN="top"><%= strPerId %></TD>
            <TD WIDTH="16" ROWSPAN="2"></TD>
            <TD NOWRAP><B><%= strLastName & " " & strFirstName %></B> (<FONT SIZE="-1"><%= strLastKname & "　" & strFirstKName %></FONT>)</TD>
        </TR>
        <TR>
            <TD NOWRAP><%= FormatDateTime(strBirth, 1) %>生　<%= Int(strAge) %>歳　<%= IIf(strGender = "1", "男性", "女性") %></TD>
        </TR>
    </TABLE>
    <BR>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
        <TR>
            <TD COLSPAN="3" NOWRAP HEIGHT="25"><SPAN STYLE="color:#cc9999">●</SPAN>返金額を確認してください。</TD>
        </TR>
        <TR>
            <TD NOWRAP>対象請求書番号</td>
            <TD>：</TD>
            <TD>
<%
            For i = 0 To lngBillNoCnt - 1
%>
            <%= objCommon.FormatString(vntDmdDate(i), "yyyymmdd") %><%= objCommon.FormatString(vntBillSeq(i), "00000") %><%= vntBranchNo(i) %>（<%= vntLastName(i) %> <%= vntFirstName(i) %>）
<%
            Next
%>
            </TD>
        </TR>
        <TR>
            <TD>レジ番号</TD>
            <TD>：</TD>
<!---
            <td nowrap width="479"><select name="selectName" size="1">
                <option value="one">1</option>
                <option value="two">2</option>
                <option value="three">3</option>
            </select></td>
-->
            <INPUT TYPE="hidden" NAME="registernoval" VALUE="<%= lngRegisterno %>">
            <TD><SPAN ID="registerDrop"></SPAN></TD>
<!--
            <TD><%= EditDropDownListFromArray2("registerno", strArrRegisterno, strArrRegisternoName, lngRegisterno, NON_SELECTED_DEL, "javascript:selectRegiNo( document.entryForm.registerno.value )") %></TD>
-->
        </TR>
        <TR>
            <TD>返金日</TD>
            <TD>：</TD>
            <TD>
                <table border="0" cellspacing="0" cellpadding="1">
                    <tr>
                        <td><a href="javascript:callCalGuide()"><img src="/webHains/images/question.gif" alt="日付ガイドを表示" height="21" width="21" border="0"></a></td>
                        <TD><%= EditSelectNumberList("pyear", YEARRANGE_MIN, YEARRANGE_MAX, CLng(strPaymentYear)) %></TD>
                        <TD>&nbsp;年&nbsp;</TD>
                        <TD><%= EditSelectNumberList("pmonth", 1, 12, CLng("0" & strPaymentMonth)) %></TD>
                        <TD>&nbsp;月&nbsp;</TD>
                        <TD><%= EditSelectNumberList("pday",   1, 31, CLng("0" & strPaymentDay  )) %></TD>
                        <TD>&nbsp;日</TD>
                        <td></td>
                    </tr>
                </table>
            </td>
        </tr>
<!-- '### 2004/11/30 Add by gouda@FSIT 計上日を追加する -->
        <TR>
            <TD>計上日</TD>
            <TD>：</TD>
            <TD>
                <table border="0" cellspacing="0" cellpadding="1">
                    <tr>
                        <td><a href="javascript:callCalGuide_Calc()"><img src="/webHains/images/question.gif" alt="日付ガイドを表示" height="21" width="21" border="0"></a></td>
                        <TD><%= EditNumberList("cyear", YEARRANGE_MIN, YEARRANGE_MAX, CLng(strCalcDateYear), False) %></TD>
                        <TD>&nbsp;年&nbsp;</TD>
                        <TD><%= EditNumberList("cmonth", 1, 12, CLng("0" & strCalcDateMonth), False) %></TD>
                        <TD>&nbsp;月&nbsp;</TD>
                        <TD><%= EditNumberList("cday", 1, 31, CLng("0" & strCalcDateDay  ), False) %></TD>
                        <TD>&nbsp;日</TD>
                        <td></td>
                    </tr>
                </table>
            </td>
        </tr>
<!-- '### 2004/11/30 Add End -->
        <tr>
            <td width="114">返金額</td>
            <td>：</td>
            <td width="479"><font size="+3"><b><%= FormatCurrency(lngPriceTotal) %></b> </font></td>
        </tr>
        <tr height="15">
            <td width="114" height="15"></td>
            <td height="15"></td>
            <td width="479" height="15"></td>
        </tr>
        <tr>
            <td width="114"><input type="checkbox" name="checkCredit" value="1" <%= IIf(strCheckCredit <> "", " CHECKED", "") %>  ONCLICK="javascript:checkCreditAct()" border="0">現金</td>
            <td>：</td>
            <td width="479">
                <table border="0" cellspacing="0" cellpadding="1">
                    <tr>
                        <td>返金</td>
<!--
                        <td><input type="text" name="credit" size="10" maxlength="8" value="<%= IIf(strCheckCredit <> "",lngCredit, "") %>" ONBLUR="javascript:CalcChange()" ></td>
-->
                        <td><input type="text" name="credit" size="10" maxlength="8" value="<%= IIf(lngCredit <> "0",lngCredit, "") %>" ONBLUR="javascript:CalcChange()" ONKEYPRESS="javascript:keyPressFunc()" ></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td nowrap width="130"><input type="checkbox" name="checkHappy" value="2" <%= IIf(strCheckHappy <> "", " CHECKED", "") %>  ONCLICK="javascript:checkHappyAct()" border="0">ハッピー買物券</td>
            <td>：</td>
            <td width="479">
                <table border="0" cellspacing="0" cellpadding="1">
                    <tr>
                        <td>返金</td>
<!--
                        <td><input type="text" name="happy_ticket" size="10" maxlength="8" value="<%= IIf(strCheckHappy <> "",lngHappy_Ticket, "") %>" ONBLUR="javascript:CalcChange()" ></td>
-->
                        <td><input type="text" name="happy_ticket" size="10" maxlength="8" value="<%= IIf(lngHappy_Ticket <> "0",lngHappy_Ticket, "") %>" ONBLUR="javascript:CalcChange()" ONKEYPRESS="javascript:keyPressFunc()" ></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td width="114"><input type="checkbox" name="checkCard" value="3" <%= IIf(strCheckCard <> "", " CHECKED", "") %>  ONCLICK="javascript:checkCardAct()" border="0">カード</td>
            <td>：</td>
            <TD>
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
                    <TR>
                        <TD NOWRAP>返金</TD>
<!--
                        <td><input type="text" name="card" size="10" maxlength="8" value="<%= IIf(strCheckCard <> "", lngCard, "") %>" ONBLUR="javascript:CalcChange()" ></td>
-->
                        <td><input type="text" name="card" size="10" maxlength="8" value="<%= IIf(lngCard <> "0", lngCard, "") %>" ONBLUR="javascript:CalcChange()" ONKEYPRESS="javascript:keyPressFunc()" ></td>
                        <TD NOWRAP>カード種別</TD>
<%
                        'カード情報の読み込み
                        '#### 2008/08/13 張 基準日設定によって基準日別のリスト取得が出来るように変更 ####
                        'If objFree.SelectFree( 1, "CARD" , strArrCardKind, , , strArrCardName) > 0 Then
                        If objFree.SelectFreeDate( 3, "CARD" ,iif(strCslDate<>"",strCslDate,strDmdDate) , strArrCardKind, , , strArrCardName) > 0 Then
%>
                        <TD>
                        <%= EditDropDownListFromArray("cardkind", strArrCardKind, strArrCardName, strCardKind, NON_SELECTED_ADD) %>
                        </TD>
<%
                        End If
%>
                        <td width="10"></td>
                        <TD NOWRAP>伝票NO.</TD>
<!--
                        <td><input type="text" name="creditslipno" value="<%= IIf(strCheckCard <> "", lngCreditslipno, "") %>" size="7" maxlength="5" ></td>
-->
                        <td><input type="text" name="creditslipno" value="<%= IIf(lngCreditslipno <> "0", lngCreditslipno, "") %>" size="7" maxlength="5" ></td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td width="114"><input type="checkbox" name="checkJdebit" value="4" <%= IIf(strCheckJdebit <> "", " CHECKED", "") %>  ONCLICK="javascript:checkJdebitAct()" border="0">Ｊデビット</td>
            <td>：</td>
            <td width="479">
                <table border="0" cellspacing="0" cellpadding="1">
                    <tr>
                        <td>返金</td>
<!--
                        <td><input type="text" name="jdebit" size="10" maxlength="8" value="<%= IIf(strCheckJdebit <> "", lngJdebit, "") %>" ONBLUR="javascript:CalcChange()"></td>
-->
                        <td><input type="text" name="jdebit" size="10" maxlength="8" value="<%= IIf(lngJdebit <> "0", lngJdebit, "") %>" ONBLUR="javascript:CalcChange()" ONKEYPRESS="javascript:keyPressFunc()"></td>
<%
                        '銀行情報の読み込み
                        If objFree.SelectFree( 1, "BANK" , strArrBankCode, , , strArrBankName) > 0 Then
%>
                        <TD>
                        <%= EditDropDownListFromArray("bankcode", strArrBankCode, strArrBankName, strBankCode, NON_SELECTED_ADD) %>
                        </TD>
<%
                        End If
%>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td width="114"><input type="checkbox" name="checkCheque" value="5" <%= IIf(strCheckCheque <> "", " CHECKED", "") %>  ONCLICK="javascript:checkChequeAct()" border="0">小切手</td>
            <td>：</td>
            <td width="479">
                <table border="0" cellspacing="0" cellpadding="1">
                    <tr>
                        <td>返金</td>
                        <td><input type="text" name="cheque" size="10" maxlength="8" value="<%= IIf(lngCheque <> "0", lngCheque, "" ) %>" ONBLUR="javascript:CalcChange()" ONKEYPRESS="javascript:keyPressFunc()"></td>
                    </tr>
                </table>
            </td>
        </tr>
<!-- 振込み　追加 2003.12.25 -->
        <tr>
            <td width="114"><input type="checkbox" name="checkTransfer" value="6" <%= IIf(strCheckTransfer <> "", " CHECKED", "") %>  ONCLICK="javascript:checkTransferAct()" border="0">振込み</td>
            <td>：</td>
            <td width="479">
                <table border="0" cellspacing="0" cellpadding="1">
                    <tr>
                        <td>返金</td>
                        <td><input type="text" name="transfer" size="10" maxlength="8" value="<%= IIf(lngTransfer <> "0", lngTransfer, "" ) %>" ONBLUR="javascript:CalcChange()" ONKEYPRESS="javascript:keyPressFunc()"></td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <BR>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
        <TR>
<%
            If lngChangePrice >= 0 Then
                If lngChangePrice = 0 Then
%>
                    <TD WIDTH="409"><B><FONT SIZE="6" COLOR="#ff8c00"><SPAN ID="changeprice" >返金額に達しました</SPAN></FONT></B></TD>
<%
                Else
%>
                    <TD WIDTH="409"><B><FONT SIZE="6" COLOR="#ff8c00"><SPAN ID="changeprice" ><%= FormatCurrency(lngChangePrice) %>　超過しています</SPAN></FONT></B></TD>
<%
                End If
            Else
                '未受付の場合
                If strWrtOkFlg = "" AND lngDayId = "" Then
%>
                    <TD WIDTH="409"><B><FONT SIZE="6" COLOR="#ff8c00"><SPAN ID="changeprice">まだ受け付けていません</SPAN></FONT></B></TD>
<%
                Else
                    '未来院の場合
                    If strWrtOkFlg = "" AND strComeDate = "" Then
%>
                        <TD WIDTH="409"><B><FONT SIZE="6" COLOR="#ff8c00"><SPAN ID="changeprice">まだ来院していません</SPAN></FONT></B></TD>
<%
                    Else
%>
                        <TD WIDTH="409"><B><FONT SIZE="6" COLOR="#ff8c00"><SPAN ID="changeprice">返金額に達していません</SPAN></FONT></B></TD>
<%
                    End If
                End If
            End If
%>
        </TR>
    </TABLE>
    <BR>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
        <TR>
            <TD WIDTH="114">オペレータ</TD>
            <TD>：</TD>
            <TD>
                <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                    <TR>
                        <TD></TD>
<%
                        'ユーザ名読み込み
                        If strUpdUser <> "" Then
                            objHainsUser.SelectHainsUser strUpdUser, strUserName
                        End If
%>
                        <TD><%= strUserName %></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD WIDTH="114">更新日時</TD>
            <TD>：</TD>
            <TD><INPUT TYPE="hidden" NAME="upddate" VALUE="<%= strUpdDate %>"><%= strUpdDate %></TD>	
        </TR>
<!-- '### 2004/11/30 Add by gouda@FSIT 計上日を追加する -->
        <TR>
            <TD WIDTH="114">日次締め日</TD>
            <TD>：</TD>
            <TD><INPUT TYPE="hidden" NAME="closedate" VALUE="<%= strCloseDate %>"><%= strCloseDate %></TD>	
        </TR>
<!-- '### 2004/11/30 End -->
    </TABLE>
    <BR>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
        <!-- 修正時 -->
<%
            '未返金のとき削除ボタン不要
            '領収書印刷済のときも不要
            If strKeyDate = "" Or lngKeySeq = "" Or strPrintDate <> "" Then
%>
            <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="77" HEIGHT="24" border="0"></TD>
<%
            Else
                if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then 
%>
                <TD><A HREF="javascript:deleteData()"><IMG SRC="/webHains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="この返金情報を削除します" border="0"></A></TD>
<%
                End If
            End If
%>
            <TD WIDTH="252"></TD>

            <TD WIDTH="5"></TD>
<%
            '領収書印刷済のときは保存ボタン不要
            '未受付、未来院の場合も不要　2003.12.19
            If strPrintDate <> "" Or strWrtOkFlg = "" Then
%>
                <TD WIDTH="77"></TD>
<%
            Else
                if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then
%>
                <TD><A HREF="javascript:goNextPage()" ONCLICK="return PreserveCheck()"><IMG SRC="/webHains/images/save.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="この内容で保存"></A></TD>

<%
                End If
            End If
%>
            <TD WIDTH="5"></TD>
            <TD><A HREF="javascript:goBackPage()"><IMG SRC="/webHains/images/cancel.gif" BORDER="0" WIDTH="77" HEIGHT="24" ALT="キャンセルする"></A></TD>
        </TR>
    </TABLE>
    </FORM>
<SCRIPT TYPE="text/javascript">
<!--
    var i;

    // cookie値の取得
    var searchStr = 'regino=';
    var strCookie = document.cookie;
    if ( strCookie.length > 0 ){
        var startPos  = strCookie.indexOf(searchStr) + searchStr.length;
        var regino = strCookie.substring(startPos, startPos + 1);
        if (regino != '' ){
            document.entryForm.registernoval.value = regino;
            var html = '';
            html = html + '<TD>';
            html = html + '<SELECT NAME="registerno" ONCHANGE="javascript:selectRegiNo( document.entryForm.registerno.value )">';

<%
            '配列添字数分のリストを追加
            If Not IsEmpty(strArrRegisterno) Then
                For i = 0 To UBound(strArrRegisterno)
%>
                    html = html + '<OPTION VALUE="<%= strArrRegisterno(i) %>"'
                    if ( '<%= strArrRegisterno(i) %>' == regino ){
                        html = html + '  SELECTED';
                    }
                    html = html + '> <%= strArrRegisternoName(i) %>';
<%
                Next
            End If
%>

            html = html + '</SELECT>';
            html = html + '</TD>';
            document.getElementById('registerDrop').innerHTML = html;
        }
    }
//-->
</SCRIPT>
</BODY>
</HTML>
