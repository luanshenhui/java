<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'       団体情報メンテナンス(メイン画面) (Ver0.0.1)
'       AUTHER  : H.Kamata@FFCS
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/EditEraYearList.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/EditPrefList.inc"   -->
<!-- #include virtual = "/webHains/includes/EditIsrDivList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objFree         '汎用情報アクセス用
Dim objOrganization '団体情報アクセス用

Dim strMode         '処理モード(挿入:"insert"、更新:"update")
Dim strAction       '処理状態(保存ボタン押下時:"save"、保存完了後:"saveend")
Dim strTarget       'ターゲット先のURL
Dim strOrgCd1       '団体コード1
Dim strOrgCd2       '団体コード2
Dim strDelFlg       '使用中状態
Dim strOrgKName     '団体カナ名
Dim strOrgName      '団体名
Dim strOrgEName     '団体名英語
Dim strOrgSName     '団体略称

CONST strKeyOrgDivCd = "ORGDIV"
Dim strOrgDivCd     '団体種別コード
Dim strArrOrgDivCd  '団体種別コード（配列）
Dim strArrOrgDivCdName '団体種別名（配列）

Dim strAddrDiv      '住所区分
Dim strZipCd        '郵便番号
Dim strZipCd1       '郵便番号1
Dim strZipCd2       '郵便番号2
Dim strPrefCd       '都道府県コード
Dim strPrefName     '都道府県名
Dim strCityName     '市区町村名
Dim strAddress1     '住所1
Dim strAddress2     '住所2
Dim strTel          '電話番号代表
Dim strDirectTel    '電話番号直通
Dim strExtension    '内線
Dim strFax          'ＦＡＸ
Dim strEMail        'E-Mailアドレス
Dim strUrl          'ＵＲＬ
Dim strChargeName   '担当者氏名
Dim strChargeKName  '担当者カナ名
Dim strChargeEmail  '担当者E-Mailアドレス
Dim strChargePost   '担当者部署名
Dim strChargeOrgName '団体名
Dim strBank         '銀行名
Dim strBranch       '支店名
Dim strAccountKind  '口座種別
Dim strAccountNo    '口座番号
Dim strNumEmp       '社員数
Dim strAvgAge       '平均年齢
Dim strVisitDate    '定期訪問予定日
Dim strPresents     '年始・中元・歳暮
Dim strDM           'ＤＭ
Dim strSendMethod   '送信方法

Dim strPostCard         '確認はがき有無
Dim strArrPostCard()    '確認はがき有無（配列）
Dim strArrPostCardName()'確認はがき有無名（配列）
Const postCardCount = 2 '確認はがき有無数

Dim strSendGuid         '一括送付案内
Dim strArrSendGuid()    '一括送付案内（配列）
Dim strArrSendGuidName()'一括送付案内名（配列）
Const sendGuidCount = 2 '一括送付案内数

Dim strTicket           '利用券
Dim strArrTicket()      '利用券（配列）
Dim strArrTicketName()  '利用券名（配列）
Const ticketCount = 2   '利用券数
Dim strNoPrintLetter    '1年目はがき出力
Dim strInsCheck     '保険証予約時確認
Dim strInsBring     '保険証当日持参
Dim strInsReport    '保険証成績書出力
Dim strBillAddress  '請求書適用住所
Dim strBillCslDiv   '請求書本人家族区分出力
Dim strBillIns      '請求書保険証情報出力
Dim strBillEmpNo    '請求書社員番号出力
Dim strBillReport   '請求書成績所添付
Dim strBillFD       '請求書FD発送
'## 2008.03.19 張 請求書特定健診レポート項目追加 Start ##
Dim strBillSpecial  '請求書特定健診レポート
'## 2008.03.19 張 請求書特定健診レポート項目追加 End   ##

'## 2009.05.20 張 請求書備考欄に年齢表記の為追加 Start ##
Dim strBillAge       '請求書年齢
'## 2009.05.20 張 請求書備考欄に年齢表記の為追加 End   ##

Dim strSendComment  '送付案内コメント
Dim strSendEComment '英語送付案内コメント
Dim strSpare(2)     '予備
Dim strNotes        '特記事項
Dim strDmdComment   '請求関連コメント
Dim strUpdDate      '更新日時
Dim strUpdUser      '更新者
Dim strSelectedDate '年月日
Dim strDateStart    '開始年

Dim strTicketDiv    '利用券区分
Dim strTicketAddBill    '利用券請求書添付
Dim strTicketCenterCall '利用券センターより連絡
Dim strTicketperCall    '利用券本人より連絡
Dim strCtrptDate        '契約日付
Dim strCtrptYear        '契約日付（年）
Dim strCtrptMonth       '契約日付（月）
Dim strCtrptDay         '契約日付（日）

Dim strUserName     '更新者名
Dim strRoundNoTaxFlg    'まるめ金消費税非計算フラグ
Dim strIsrGetName   '健保名称索引対象
Dim blnOpAnchor     '操作用アンカー制御
Dim strSpareName(2) '予備の表示名称
Dim strFreeName     '汎用名
Dim strArrMessage   'エラーメッセージ
Dim Ret             '関数戻り値
Dim i               'インデックス
Dim objOrgBillClass     '団体請求書分類アクセス用
Dim strOrgBillName      '請求書用名称
Dim strArrBillClassCd   '請求書分類（表示用）
Dim strArrBillClassName '請求書名（表示用）
Dim strArrOrgCd         '団体コード（表示用）

Dim strWkNum            '番号全角編集用ワーク

'## 2004.01.29 Add By T.Takagi@FSIT 項目追加
Dim strReptCslDiv   '成績書本人家族区分出力
'## 2004.01.29 Add End
'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objFree         = Server.CreateObject("HainsFree.Free")
Set objOrganization = Server.CreateObject("HainsOrganization.Organization")
Set objOrgBillClass = Server.CreateObject("HainsOrgBillClass.OrgBillClass")

'引数値の取得
strMode        = Request("mode")
strAction      = Request("act")
strTarget      = Request("target")
strOrgCd1      = Request("orgCd1")
strOrgCd2      = Request("orgCd2")
strDelFlg      = Request("delFlg")
strOrgKName    = Request("orgKName")
strOrgEName    = Request("orgEName")
strOrgName     = Request("orgName")
strOrgSName    = Request("orgSName")
strZipCd       = ConvIStringToArray(Request("zipCd"))
strZipCd1      = Request("zipCd1")
strZipCd2      = Request("zipCd2")
strPrefCd      = ConvIStringToArray(Request("prefCd"))
strCityName    = ConvIStringToArray(Request("cityName"))
strAddress1    = ConvIStringToArray(Request("address1"))
strAddress2    = ConvIStringToArray(Request("address2"))
strTel         = ConvIStringToArray(Request("tel"))
strDirectTel   = ConvIStringToArray(Request("directTel"))
strExtension   = ConvIStringToArray(Request("extension"))
strFax         = ConvIStringToArray(Request("fax"))
strEMail       = ConvIStringToArray(Request("eMail"))
strUrl	       = ConvIStringToArray(Request("url"))
strChargeName  = ConvIStringToArray(Request("chargeName"))
strChargeKName = ConvIStringToArray(Request("chargeKName"))
strChargeEmail = ConvIStringToArray(Request("chargeEmail"))
strChargePost  = ConvIStringToArray(Request("chargePost"))
strChargeOrgName = ConvIStringToArray(Request("chargeOrgName"))
strBank        = Request("bank")
strBranch      = Request("branch")
strAccountKind = Request("accountKind")
strAccountNo   = Request("accountNo")
strNumEmp      = Request("numEmp")
strAvgAge      = Request("avgAge")
strVisitDate   = Request("visitDate")
strPresents    = Request("presents")
strDM          = Request("dm")
strSendMethod  = Request("sendMethod")
strPostCard    = Request("postcard")
strSendGuid    = Request("sendguid")
strTicket      = Request("ticket")
strNoPrintLetter = Request("noPrintLetter")
'## 2008.03.19 張 請求書特定健診レポート項目追加 Start ##
strBillSpecial = Request("billSpecial")
'## 2008.03.19 張 請求書特定健診レポート項目追加 End   ##
strInsCheck    = Request("insCheck")
strInsBring    = Request("insBring")
strInsReport   = Request("insReport")
strBillAddress = Request("billAddress")
strBillCslDiv  = Request("billCslDiv")
strBillIns     = Request("billIns")
strBillEmpNo   = Request("billEmpNo")
strBillReport  = Request("billReport")
strBillFD      = Request("billFD")
'## 2009.05.20 張 請求書備考欄に年齢表記の為追加 Start ##
strBillAge     = Request("billAge")
'## 2009.05.20 張 請求書備考欄に年齢表記の為追加 End   ##
strSendComment = Request("sendComment")
strSendEComment= Request("sendEComment")
strSpare(0)    = Request("spare1")
strSpare(1)    = Request("spare2")
strSpare(2)    = Request("spare3")
strNotes       = Request("notes")
strDmdComment  = Request("dmdComment")
strUpdDate     = Request("updDate")
strUpdUser     = Request("updUser")
strTicketDiv        = Request("ticketDiv")
strTicketAddBill    = Request("ticketAddBill")
strTicketCenterCall = Request("ticketCenterCall")
strTicketperCall    = Request("ticketperCall")
strCtrptYear   = Request("ctrptYear")
strCtrptMonth  = Request("ctrptMonth")
strCtrptDay    = Request("ctrptDay")



strUserName    = Request("userName")
strRoundNoTaxFlg = Request("RoundNoTaxFlg")
strIsrGetName  = Request("isrGetName")

strOrgBillName = Request("orgBillName")
strOrgDivCd      = Request("orgDivCd")

'## 2004.01.29 Add By T.Takagi@FSIT 項目追加
strReptCslDiv = Request("reptCslDiv")
'## 2004.01.29 Add End

'予備の表示名称取得
For i = 0 To UBound(strSpare)

    '汎用名読み込み
    objFree.SelectFree 0, "ORGSPARE" & (i + 1), , strFreeName

    '名称が設定されている場合はその内容を保持
    strSpareName(i) = IIf(strFreeName <> "", strFreeName, "汎用キー(" & (i + 1) & ")")

Next

'確認はがき有無に何も設定されない場合は「0（無)」をデフォルトとする。
If( strPostCard = "" ) Then
    strPostCard = "0"
End If

'確認はがき有無の配列作成
Call CreatePostCardInfo()

'一括送付案内に何も設定されない場合は「0（無)」をデフォルトとする。
If( strSendGuid = "" ) Then
    strSendGuid = "0"
End If

'一括送付案内の配列作成
Call CreateSendGuidInfo()

'利用券に何も設定されない場合は「0（利用しない)」をデフォルトとする。
If( strTicket = "" ) Then
    strTicket = "0"
End If

'利用券の配列作成
Call CreateTicketInfo()


'チェック・更新・読み込み処理の制御
Do

'err.raise 1000,,strAction
    '削除ボタン押下時
    If strAction = "delete" Then

        Ret = objOrganization.DeleteOrg(strOrgCd1, strOrgCd2)
        Select Case Ret
            Case  1
            Case  0
                strArrMessage = ("参照整合性制約の為に削除できません。")
            Case Else
                strArrMessage = ("その他のエラーが発生しました（エラーコード＝" & Ret & "）。")
        End Select

        If Ret <> 1 Then
            Exit Do
        End If

        Response.Redirect Request.ServerVariables("SCRIPT_NAME") & "?mode=insert&act=deleteend"

    End If

    '保存ボタン押下時
    If strAction = "save" Then

        '入力チェック
        strArrMessage = CheckValue()
        If Not IsEmpty(strArrMessage) Then
            Exit Do
        End If

        '保存処理
        If strMode = "update" Then

            ''' 担当者情報は「団体住所情報テーブル」へ　2003.11.14
            '団体テーブルレコード更新
'## 2004.01.29 Mod By T.Takagi@FSIT 項目追加
'           objOrganization.UpdateOrg strOrgCd1,      strOrgCd2,       strDelFlg, _
'                                     strOrgKName,    strOrgName,      strOrgEName,    strOrgSName, _
'                                     strOrgDivCd,    strOrgBillName, _
'                                     strBank,        strBranch,       strAccountKind, strAccountNo, _
'                                     strNumEmp,      strAvgAge,  _
'                                     strDM,           strSendMethod,  strPostCard,    strSendGuid, _
'                                     strTicket,      strInsCheck,     strInsBring,    strInsReport, _
'                                     strBillAddress, strBillCslDiv,   strBillIns,     strBillEmpNo,   strBillReport, _
'                                     strSendComment, strSendEComment, strSpare(0),    strSpare(1),    strSpare(2), _
'                                     strNotes,       strDmdComment,   Session("userid"), _
'                                     Iif( strNoPrintLetter="0", "", strNoPrintLetter), _
'                                     strVisitDate,   strPresents, _
'                                     strTicketDiv,   strTicketAddBill, strTicketCenterCall, _
'                                     strTicketperCall, strCtrptDate
    '## FD発送項目追加 Start 2005.05.05 張 
'           objOrganization.UpdateOrg strOrgCd1,      strOrgCd2,       strDelFlg, _
'                                     strOrgKName,    strOrgName,      strOrgEName,    strOrgSName, _
'                                     strOrgDivCd,    strOrgBillName, _
'                                     strBank,        strBranch,       strAccountKind, strAccountNo, _
'                                     strNumEmp,      strAvgAge,  _
'                                     strDM,           strSendMethod,  strPostCard,    strSendGuid, _
'                                     strTicket,      strInsCheck,     strInsBring,    strInsReport, _
'                                     strBillAddress, strBillCslDiv,   strBillIns,     strBillEmpNo,   strBillReport, _
'                                     strSendComment, strSendEComment, strSpare(0),    strSpare(1),    strSpare(2), _
'                                     strNotes,       strDmdComment,   Session("userid"), _
'                                     Iif( strNoPrintLetter="0", "", strNoPrintLetter), _
'                                     strVisitDate,   strPresents, _
'                                     strTicketDiv,   strTicketAddBill, strTicketCenterCall, _
'                                     strTicketperCall, strCtrptDate, strReptCslDiv

        '## 2008.03.19 張 請求書特定健診レポート項目追加
'            objOrganization.UpdateOrg strOrgCd1,      strOrgCd2,       strDelFlg, _
'                                      strOrgKName,    strOrgName,      strOrgEName,    strOrgSName, _
'                                      strOrgDivCd,    strOrgBillName, _
'                                      strBank,        strBranch,       strAccountKind, strAccountNo, _
'                                      strNumEmp,      strAvgAge,  _
'                                      strDM,           strSendMethod,  strPostCard,    strSendGuid, _
'                                      strTicket,      strInsCheck,     strInsBring,    strInsReport, _
'                                      strBillAddress, strBillCslDiv,   strBillIns,     strBillEmpNo,   strBillReport, _
'                                      strBillFD, strSendComment, strSendEComment, strSpare(0),    strSpare(1), _
'                                      strSpare(2), strNotes,       strDmdComment,   Session("userid"), _
'                                      Iif( strNoPrintLetter="0", "", strNoPrintLetter), _
'                                      strVisitDate,   strPresents, _
'                                      strTicketDiv,   strTicketAddBill, strTicketCenterCall, _
'                                      strTicketperCall, strCtrptDate, strReptCslDiv

'            objOrganization.UpdateOrg strOrgCd1,      strOrgCd2,       strDelFlg, _
'                                      strOrgKName,    strOrgName,      strOrgEName,    strOrgSName, _
'                                      strOrgDivCd,    strOrgBillName, _
'                                      strBank,        strBranch,       strAccountKind, strAccountNo, _
'                                      strNumEmp,      strAvgAge,  _
'                                      strDM,           strSendMethod,  strPostCard,    strSendGuid, _
'                                      strTicket,      strInsCheck,     strInsBring,    strInsReport, _
'                                      strBillAddress, strBillCslDiv,   strBillIns,     strBillEmpNo,   strBillReport, _
'                                      strBillFD, strSendComment, strSendEComment, strSpare(0),    strSpare(1), _
'                                      strSpare(2), strNotes,       strDmdComment,   Session("userid"), _
'                                      Iif( strNoPrintLetter="0", "", strNoPrintLetter), _
'                                      strVisitDate,   strPresents, _
'                                      strTicketDiv,   strTicketAddBill, strTicketCenterCall, _
'                                      strTicketperCall, strCtrptDate, strReptCslDiv, strBillSpecial

            '## 2009.05.20 張 請求書備考欄に年齢表記の為追加 Start ##
            objOrganization.UpdateOrg strOrgCd1,      strOrgCd2,       strDelFlg, _
                                      strOrgKName,    strOrgName,      strOrgEName,    strOrgSName, _
                                      strOrgDivCd,    strOrgBillName, _
                                      strBank,        strBranch,       strAccountKind, strAccountNo, _
                                      strNumEmp,      strAvgAge,  _
                                      strDM,           strSendMethod,  strPostCard,    strSendGuid, _
                                      strTicket,      strInsCheck,     strInsBring,    strInsReport, _
                                      strBillAddress, strBillCslDiv,   strBillIns,     strBillEmpNo,   strBillReport, _
                                      strBillFD, strSendComment, strSendEComment, strSpare(0),    strSpare(1), _
                                      strSpare(2), strNotes,       strDmdComment,   Session("userid"), _
                                      Iif( strNoPrintLetter="0", "", strNoPrintLetter), _
                                      strVisitDate,   strPresents, _
                                      strTicketDiv,   strTicketAddBill, strTicketCenterCall, _
                                      strTicketperCall, strCtrptDate, strReptCslDiv, strBillSpecial, strBillAge
            '## 2009.05.20 張 請求書備考欄に年齢表記の為追加 End   ##

        '## 2008.03.19 張 請求書特定健診レポート項目追加

    '## FD発送項目追加 End   2005.05.05 張 
'## 2004.01.29 Mod End

            '団体住所情報テーブルレコード更新
            objOrganization.UpdateOrgAddr strOrgCd1,    strOrgCd2, _
                                          strZipCd,     strPrefCd,     strCityName, _
                                          strAddress1,  strAddress2, _
                                          strDirectTel, strTel,        strExtension, _
                                          strFax,       strEMail,      strUrl, _
                                          strChargeName,strChargeKName,strChargeEmail, _
                                          strChargePost,strChargeOrgName 

        Else

            ''' 担当者情報は「団体住所情報テーブル」へ　2003.11.14
            '団体テーブルレコード挿入
'## 2004.01.29 Mod By T.Takagi@FSIT 項目追加
'           Ret = objOrganization.InsertOrg(strOrgCd1,      strOrgCd2,       strDelFlg, _
'                                           strOrgKName,    strOrgName,      strOrgEName,    strOrgSName, _
'                                           strOrgDivCd,    strOrgBillName, _
'                                           strBank,        strBranch,       strAccountKind, strAccountNo, _
'                                           strNumEmp,      strAvgAge, _
'                                           strDM,           strSendMethod,  strPostCard,    strSendGuid, _
'                                           strTicket,      strInsCheck,     strInsBring,    strInsReport, _
'                                           strBillAddress, strBillCslDiv,   strBillIns,     strBillEmpNo,   strBillReport, _
'                                           strSendComment, strSendEComment, strSpare(0),    strSpare(1),    strSpare(2), _
'                                           strNotes,       strDmdComment,   Session("userid"), _
'                                           strNoPrintLetter, strVisitDate,  strPresents, _
'                                           strTicketDiv,   strTicketAddBill, strTicketCenterCall, _
'                                           strTicketperCall, strCtrptDate _
'                                          )
    '## FD発送項目追加 Start 2005.05.05 張 
'           Ret = objOrganization.InsertOrg(strOrgCd1,      strOrgCd2,       strDelFlg, _
'                                           strOrgKName,    strOrgName,      strOrgEName,    strOrgSName, _
'                                           strOrgDivCd,    strOrgBillName, _
'                                           strBank,        strBranch,       strAccountKind, strAccountNo, _
'                                           strNumEmp,      strAvgAge, _
'                                           strDM,           strSendMethod,  strPostCard,    strSendGuid, _
'                                           strTicket,      strInsCheck,     strInsBring,    strInsReport, _
'                                           strBillAddress, strBillCslDiv,   strBillIns,     strBillEmpNo,   strBillReport, _
'                                           strSendComment, strSendEComment, strSpare(0),    strSpare(1),    strSpare(2), _
'                                           strNotes,       strDmdComment,   Session("userid"), _
'                                           strNoPrintLetter, strVisitDate,  strPresents, _
'                                           strTicketDiv,   strTicketAddBill, strTicketCenterCall, _
'                                           strTicketperCall, strCtrptDate,  strReptCslDiv _
'                                          )
        '## 2008.03.19 張 請求書特定健診レポート項目追加
'            Ret = objOrganization.InsertOrg(strOrgCd1,      strOrgCd2,       strDelFlg, _
'                                            strOrgKName,    strOrgName,      strOrgEName,    strOrgSName, _
'                                            strOrgDivCd,    strOrgBillName, _
'                                            strBank,        strBranch,       strAccountKind, strAccountNo, _
'                                            strNumEmp,      strAvgAge, _
'                                            strDM,           strSendMethod,  strPostCard,    strSendGuid, _
'                                            strTicket,      strInsCheck,     strInsBring,    strInsReport, _
'                                            strBillAddress, strBillCslDiv,   strBillIns,     strBillEmpNo,   strBillReport, strBillFD, _
'                                            strSendComment, strSendEComment, strSpare(0),    strSpare(1),    strSpare(2), _
'                                            strNotes,       strDmdComment,   Session("userid"), _
'                                            strNoPrintLetter, strVisitDate,  strPresents, _
'                                            strTicketDiv,   strTicketAddBill, strTicketCenterCall, _
'                                            strTicketperCall, strCtrptDate,  strReptCslDiv, _
'                                           )

            '## 2009.05.20 張 請求書備考欄に年齢表記の為追加 Start ##
'            Ret = objOrganization.InsertOrg(strOrgCd1,      strOrgCd2,       strDelFlg, _
'                                            strOrgKName,    strOrgName,      strOrgEName,    strOrgSName, _
'                                            strOrgDivCd,    strOrgBillName, _
'                                            strBank,        strBranch,       strAccountKind, strAccountNo, _
'                                            strNumEmp,      strAvgAge, _
'                                            strDM,           strSendMethod,  strPostCard,    strSendGuid, _
'                                            strTicket,      strInsCheck,     strInsBring,    strInsReport, _
'                                            strBillAddress, strBillCslDiv,   strBillIns,     strBillEmpNo,   strBillReport, strBillFD, _
'                                            strSendComment, strSendEComment, strSpare(0),    strSpare(1),    strSpare(2), _
'                                            strNotes,       strDmdComment,   Session("userid"), _
'                                            strNoPrintLetter, strVisitDate,  strPresents, _
'                                            strTicketDiv,   strTicketAddBill, strTicketCenterCall, _
'                                            strTicketperCall, strCtrptDate,  strReptCslDiv,  strBillSpecial _
'                                           )
            Ret = objOrganization.InsertOrg(strOrgCd1,      strOrgCd2,       strDelFlg, _
                                            strOrgKName,    strOrgName,      strOrgEName,    strOrgSName, _
                                            strOrgDivCd,    strOrgBillName, _
                                            strBank,        strBranch,       strAccountKind, strAccountNo, _
                                            strNumEmp,      strAvgAge, _
                                            strDM,           strSendMethod,  strPostCard,    strSendGuid, _
                                            strTicket,      strInsCheck,     strInsBring,    strInsReport, _
                                            strBillAddress, strBillCslDiv,   strBillIns,     strBillEmpNo,   strBillReport, strBillFD, _
                                            strSendComment, strSendEComment, strSpare(0),    strSpare(1),    strSpare(2), _
                                            strNotes,       strDmdComment,   Session("userid"), _
                                            strNoPrintLetter, strVisitDate,  strPresents, _
                                            strTicketDiv,   strTicketAddBill, strTicketCenterCall, _
                                            strTicketperCall, strCtrptDate,  strReptCslDiv,  strBillSpecial,  strBillAge _
                                           )
            '## 2009.05.20 張 請求書備考欄に年齢表記の為追加 End   ##

        '## 2008.03.19 張 請求書特定健診レポート項目追加

    '## FD発送項目追加 End   2005.05.05 張 
'## 2004.01.29 Mod End

            'キー重複時はエラーメッセージを編集する
            If Ret = INSERT_DUPLICATE Then
                strArrMessage = Array("同一団体コードの団体情報がすでに存在します。")
                Exit Do
            End If


            '団体住所情報テーブルレコード挿入
            Ret = objOrganization.InsertOrgAddr( strOrgCd1,    strOrgCd2, _
                                                 strZipCd,     strPrefCd,     strCityName, _
                                                 strAddress1,  strAddress2, _
                                                 strDirectTel, strTel,        strExtension, _
                                                 strFax,       strEMail,      strUrl, _
                                                 strChargeName,strChargeKName,strChargeEmail, _
                                                 strChargePost,strChargeOrgName _
                                               )

            'キー重複時はエラーメッセージを編集する
            If Ret = INSERT_DUPLICATE Then
                strArrMessage = Array("同一団体コードの団体住所情報がすでに存在します。")
                Exit Do
            End If

'## 2003.11.18 Del by T.Takagi@FSIT 不要項目削除
'           '団体管理請求分類テーブルレコード挿入
'           Ret = objOrgBillClass.NewInsrtOrgBillClass( strOrgCd1, strOrgCd2 )
'           If( Ret <> 1 )Then
'               strArrMessage = Array("団体管理請求分類テーブルの追加に失敗しました。")
'               Exit Do
'           End If
'## 2003.11.18 Del End

        End If

        '保存に成功した場合、ターゲット指定時は指定先のURLへジャンプし、未指定時は更新モードでリダイレクト
        If strTarget <> "" Then
            Response.Redirect strTarget & "?orgCd1=" & strOrgCd1 & "&orgCd2=" & strOrgCd2
        Else
            Response.Redirect Request.ServerVariables("SCRIPT_NAME") & "?mode=update&act=saveend&orgcd1=" & strOrgCd1 & "&orgcd2=" & strOrgCd2
        End If
        Response.End

    End If



    '新規モードの場合は読み込みを行わない
    If strMode = "insert" Then

        '配列宣言を行う。
        strAddrDiv   = Array()
        strCityName  = Array()
        strZipCd     = Array()
        strPrefCd    = Array()
        strAddress1  = Array()
        strAddress2  = Array()
        strDirectTel = Array()
        strTel       = Array()
        strExtension = Array()
        strFax       = Array()
        strEMail     = Array()
        strUrl       = Array()
        strChargeName   = Array()
        strChargeKName  = Array()
        strChargeEmail  = Array()
        strChargePost   = Array()
        strChargeOrgName= Array()

        ReDim Preserve strAddrDiv(2)
        ReDim Preserve strCityName(2)
        ReDim Preserve strZipCd(2)
        ReDim Preserve strPrefCd(2)
        ReDim Preserve strAddress1(2)
        ReDim Preserve strAddress2(2)
        ReDim Preserve strDirectTel(2)
        ReDim Preserve strTel(2)
        ReDim Preserve strExtension(2)
        ReDim Preserve strFax(2)
        ReDim Preserve strEMail(2)
        ReDim Preserve strUrl(2)
        ReDim Preserve strChargeName(2)
        ReDim Preserve strChargeKName(2)
        ReDim Preserve strChargeEmail(2)
        ReDim Preserve strChargePost(2)
        ReDim Preserve strChargeOrgName(2)

        Exit Do
    End If

    ''' 担当者情報は「団体住所情報テーブル」から取得　2003.11.14
    '団体テーブルレコード読み込み
'## 2004.01.29 Mod By T.Takagi@FSIT 項目追加
'   objOrganization.SelectOrg_Lukes strOrgCd1,      strOrgCd2,       strDelFlg, _
'                                   strOrgKName,    strOrgName,      strOrgEName,    strOrgSName, _
'                                   strOrgDivCd,    strOrgBillName, _
'                                    ,   ,   ,   , _
'                                   strBank,        strBranch,       strAccountKind, strAccountNo, _
'                                   strNumEmp,      strAvgAge, _
'                                   strDM,          strSendMethod,   strPostCard,    strSendGuid, _
'                                   strTicket,      strInsCheck,     strInsBring,    strInsReport, _
'                                   strBillAddress, strBillCslDiv,   strBillIns,     strBillEmpNo,   strBillReport, _
'                                   strSendComment, strSendEComment, strSpare(0),    strSpare(1),    strSpare(2), _
'                                   strNotes,       strDmdComment,   strUpdDate,     strUpdUser,     strUserName, _
'                                   strNoPrintLetter, strVisitDate,  strPresents, _
'                                   strTicketDiv,   strTicketAddBill, strTicketCenterCall, _
'                                   strTicketperCall, strCtrptDate

    '## FD発送項目追加 Start 2005.05.05 張 
'   objOrganization.SelectOrg_Lukes strOrgCd1,      strOrgCd2,       strDelFlg, _
'                                   strOrgKName,    strOrgName,      strOrgEName,    strOrgSName, _
'                                   strOrgDivCd,    strOrgBillName, _
'                                    ,   ,   ,   , _
'                                   strBank,        strBranch,       strAccountKind, strAccountNo, _
'                                   strNumEmp,      strAvgAge, _
'                                   strDM,          strSendMethod,   strPostCard,    strSendGuid, _
'                                   strTicket,      strInsCheck,     strInsBring,    strInsReport, _
'                                   strBillAddress, strBillCslDiv,   strBillIns,     strBillEmpNo,   strBillReport, _
'                                   strSendComment, strSendEComment, strSpare(0),    strSpare(1),    strSpare(2), _
'                                   strNotes,       strDmdComment,   strUpdDate,     strUpdUser,     strUserName, _
'                                   strNoPrintLetter, strVisitDate,  strPresents, _
'                                   strTicketDiv,   strTicketAddBill, strTicketCenterCall, _
'                                   strTicketperCall, strCtrptDate, strReptCslDiv

        '## 2008.03.19 張 請求書特定健診レポート項目追加
'    objOrganization.SelectOrg_Lukes strOrgCd1,      strOrgCd2,       strDelFlg, _
'                                    strOrgKName,    strOrgName,      strOrgEName,    strOrgSName, _
'                                    strOrgDivCd,    strOrgBillName, _
'                                     ,   ,   ,   , _
'                                    strBank,        strBranch,       strAccountKind, strAccountNo, _
'                                    strNumEmp,      strAvgAge, _
'                                    strDM,          strSendMethod,   strPostCard,    strSendGuid, _
'                                    strTicket,      strInsCheck,     strInsBring,    strInsReport, _
'                                    strBillAddress, strBillCslDiv,   strBillIns,     strBillEmpNo,   strBillReport, strBillFD, _
'                                    strSendComment, strSendEComment, strSpare(0),    strSpare(1),    strSpare(2), _
'                                    strNotes,       strDmdComment,   strUpdDate,     strUpdUser,     strUserName, _
'                                    strNoPrintLetter, strVisitDate,  strPresents, _
'                                    strTicketDiv,   strTicketAddBill, strTicketCenterCall, _
'                                    strTicketperCall, strCtrptDate, strReptCslDiv

'    objOrganization.SelectOrg_Lukes strOrgCd1,      strOrgCd2,       strDelFlg, _
'                                    strOrgKName,    strOrgName,      strOrgEName,    strOrgSName, _
'                                    strOrgDivCd,    strOrgBillName, _
'                                     ,   ,   ,   , _
'                                    strBank,        strBranch,       strAccountKind, strAccountNo, _
'                                    strNumEmp,      strAvgAge, _
'                                    strDM,          strSendMethod,   strPostCard,    strSendGuid, _
'                                    strTicket,      strInsCheck,     strInsBring,    strInsReport, _
'                                    strBillAddress, strBillCslDiv,   strBillIns,     strBillEmpNo,   strBillReport, strBillFD, _
'                                    strSendComment, strSendEComment, strSpare(0),    strSpare(1),    strSpare(2), _
'                                    strNotes,       strDmdComment,   strUpdDate,     strUpdUser,     strUserName, _
'                                    strNoPrintLetter, strVisitDate,  strPresents, _
'                                    strTicketDiv,   strTicketAddBill, strTicketCenterCall, _
'                                    strTicketperCall, strCtrptDate, strReptCslDiv,  strBillSpecial

            '## 2009.05.20 張 請求書備考欄に年齢表記の為追加 Start ##
    objOrganization.SelectOrg_Lukes strOrgCd1,      strOrgCd2,       strDelFlg, _
                                    strOrgKName,    strOrgName,      strOrgEName,    strOrgSName, _
                                    strOrgDivCd,    strOrgBillName, _
                                     ,   ,   ,   , _
                                    strBank,        strBranch,       strAccountKind, strAccountNo, _
                                    strNumEmp,      strAvgAge, _
                                    strDM,          strSendMethod,   strPostCard,    strSendGuid, _
                                    strTicket,      strInsCheck,     strInsBring,    strInsReport, _
                                    strBillAddress, strBillCslDiv,   strBillIns,     strBillEmpNo,   strBillReport, strBillFD, _
                                    strSendComment, strSendEComment, strSpare(0),    strSpare(1),    strSpare(2), _
                                    strNotes,       strDmdComment,   strUpdDate,     strUpdUser,     strUserName, _
                                    strNoPrintLetter, strVisitDate,  strPresents, _
                                    strTicketDiv,   strTicketAddBill, strTicketCenterCall, _
                                    strTicketperCall, strCtrptDate, strReptCslDiv,  strBillSpecial,  strBillAge

            '## 2009.05.20 張 請求書備考欄に年齢表記の為追加 End   ##

        '## 2008.03.19 張 請求書特定健診レポート項目追加

    '## FD発送項目追加 End   2005.05.05 張 
'## 2004.01.29 Mod End

    If strCtrptDate <> "" Then
        strCtrptYear = Year(strCtrptDate)
        strCtrptMonth = Month(strCtrptDate)
        strCtrptDay = Day(strCtrptDate)
    End If

    '団体住所情報テーブルレコード読み込み
    objOrganization.SelectOrgAddrList strOrgCd1,    strOrgCd2,      strAddrDiv, _
                                      strZipCd,     strPrefCd,      strCityName, _
                                      strAddress1,  strAddress2, _
                                      strDirectTel, strTel,         strExtension, _
                                      strFax,       strEMail,       strUrl, _
                                      strChargeName,strChargeKName, strChargeEmail, _
                                      strChargePost,strChargeOrgName 

    Exit Do
Loop


'-------------------------------------------------------------------------------
'
' 機能　　 : 戻り先URL編集
'
' 引数　　 : 
'
' 戻り値　 : 戻り先のURL
'
' 備考　　 : 各業務ごとに戻り先(検索画面)のURLが異なるため、それを制御
'
'-------------------------------------------------------------------------------
Function EditURLForReturning()

    Dim strURL	'戻り先URL

    Do
        'ターゲット先URLが存在しない場合
        If strTarget = "" Then

            '通常のメンテナンス業務とみなし、同一仮想フォルダの検索画面へ
            strURL = "mntSearchOrg.asp"
            Exit Do

        End If

        'ターゲット先が契約情報の場合
        If InStr(1, strTarget, "contract") > 0 Then

            'ターゲット先URLと同一仮想フォルダの検索画面へ
            strURL = Left(strTarget, InStrRev(strTarget, "/")) & "ctrSearchOrg.asp"
            Exit Do

        End If

        Exit Do
    Loop

    EditURLForReturning = strURL

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 団体情報各値の妥当性チェックを行う
'
' 引数　　 :
'
' 戻り値　 : エラー値がある場合、エラーメッセージの配列を返す
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CheckValue()

    Dim objCommon       '共通クラス

    Dim strIsrOrgCd1    '団体コード１
    Dim strIsrOrgCd2    '団体コード２
    Dim strIsrOrgSName  '団体略称

    Dim vntArrMessage   'エラーメッセージの集合
    Dim strMessage      'エラーメッセージ
    Dim i               'インデックス

    '共通クラスのインスタンス作成
    Set objCommon = Server.CreateObject("HainsCommon.Common")

    '各値チェック処理
    With objCommon

        '団体コード
        .AppendArray vntArrMessage, .CheckAlphabetAndNumeric("団体コード１", strOrgCd1, LENGTH_ORG_ORGCD1, CHECK_NECESSARY)
        .AppendArray vntArrMessage, .CheckAlphabetAndNumeric("団体コード２", strOrgCd2, LENGTH_ORG_ORGCD2, CHECK_NECESSARY)

'       '団体種別
'       .AppendArray vntArrMessage, .CheckWideValue("団体種別", strOrgDivCd, 12, CHECK_NECESSARY)

        '各種名称
'## 2003.12.17 Mod By T.Takagi@FSIT チェック方法変更
'       .AppendArray vntArrMessage, .CheckWideValue("団体カナ名称", strOrgKName, LENGTH_ORG_ORGKNAME, CHECK_NECESSARY)
'       .AppendArray vntArrMessage, .CheckWideValue("団体名称",     strOrgName,  LENGTH_ORG_ORGNAME,  CHECK_NECESSARY)
'       .AppendArray vntArrMessage, .CheckNarrowValue("団体名称（英語）",     strOrgEName,  50)
'       .AppendArray vntArrMessage, .CheckWideValue("団体略称",     strOrgSName, LENGTH_ORG_ORGSNAME, CHECK_NECESSARY)
        If strOrgKName = "" Then
            .AppendArray vntArrMessage, "団体カナ名称を入力してください。"
        End If
        If strOrgName = "" Then
            .AppendArray vntArrMessage, "団体名称を入力してください。"
        End If
        If strOrgSName = "" Then
            .AppendArray vntArrMessage, "団体略称を入力してください。"
        End If
'## 2003.12.17 Mod End

'## 2003.12.17 Del By T.Takagi@FSIT チェック方法変更
'       '住所１
'       .AppendArray vntArrMessage, .CheckWideValue("住所１：市区町村", strCityName(0), LENGTH_CITYNAME)
'       .AppendArray vntArrMessage, .CheckWideValue("住所１：住所（１）",   strAddress1(0), LENGTH_ADDRESS)
'       .AppendArray vntArrMessage, .CheckWideValue("住所１：住所（２）",   strAddress2(0), LENGTH_ADDRESS)
'       .AppendArray vntArrMessage, .CheckNarrowValue("住所１：電話番号直通", strDirectTel(0), 12)
'       .AppendArray vntArrMessage, .CheckNarrowValue("住所１：電話番号代表", strTel(0), 12)
'       .AppendArray vntArrMessage, .CheckNarrowValue("住所１：内線", strExtension(0), LENGTH_ORG_EXTENSION)
'       .AppendArray vntArrMessage, .CheckNarrowValue("住所１：ＦＡＸ番号", strFax(0), 12)
'       strMessage = .CheckNarrowValue("住所１：E-Mailアドレス", strEMail(0), LENGTH_EMAIL)
'       If strMessage = "" Then
'           strMessage = .CheckEMail("住所１：E-Mailアドレス", strEMail(0))
'       End If
'       .AppendArray vntArrMessage, strMessage
'
'       strMessage = .CheckNarrowValue("住所１：ＵＲＬアドレス", strUrl(0), 50)
'       .AppendArray vntArrMessage, strMessage
'
'       '担当名
'       .AppendArray vntArrMessage, .CheckWideValue("住所１：担当者カナ名", strChargeKName(0), LENGTH_ORG_CHARGEKNAME)
'       .AppendArray vntArrMessage, .CheckWideValue("住所１：担当者名",     strChargeName(0),  LENGTH_ORG_CHARGENAME)
'
'       '担当者E-Mail
'       strMessage = .CheckNarrowValue("住所１：担当者E-Mailアドレス", strChargeEmail(0), LENGTH_EMAIL)
'       If strMessage = "" Then
'           strMessage = .CheckEMail("住所１：担当者E-Mailアドレス", strChargeEmail(0))
'       End If
'       .AppendArray vntArrMessage, strMessage
'
'       '担当部署
'       .AppendArray vntArrMessage, .CheckWideValue("住所１：担当部署名", strChargePost(0), LENGTH_ORG_CHARGEPOST)
'       '宛先会社名
'       .AppendArray vntArrMessage, .CheckWideValue("住所１：宛先会社名", strChargeOrgName(0), LENGTH_ORG_ORGNAME)
'
'
'       '住所２
'       .AppendArray vntArrMessage, .CheckWideValue("住所２：市区町村", strCityName(1), LENGTH_CITYNAME)
'       .AppendArray vntArrMessage, .CheckWideValue("住所２：住所（１）",   strAddress1(1), LENGTH_ADDRESS)
'       .AppendArray vntArrMessage, .CheckWideValue("住所２：住所（２）",   strAddress2(1), LENGTH_ADDRESS)
'       .AppendArray vntArrMessage, .CheckNarrowValue("住所２：電話番号直通", strDirectTel(1), 12)
'       .AppendArray vntArrMessage, .CheckNarrowValue("住所２：電話番号代表", strTel(1), 12)
'       .AppendArray vntArrMessage, .CheckNarrowValue("住所２：内線", strExtension(1), LENGTH_ORG_EXTENSION)
'       .AppendArray vntArrMessage, .CheckNarrowValue("住所２：ＦＡＸ番号", strFax(1), 12)
'       strMessage = .CheckNarrowValue("住所２：E-Mailアドレス", strEMail(1), LENGTH_EMAIL)
'       If strMessage = "" Then
'       strMessage = .CheckEMail("住所２：E-Mailアドレス", strEMail(1))
'       End If
'       .AppendArray vntArrMessage, strMessage
'
'       strMessage = .CheckNarrowValue("住所２：ＵＲＬアドレス", strUrl(1), 50)
'       .AppendArray vntArrMessage, strMessage
'
'       '担当名
'       .AppendArray vntArrMessage, .CheckWideValue("住所１：担当者カナ名", strChargeKName(1), LENGTH_ORG_CHARGEKNAME)
'       .AppendArray vntArrMessage, .CheckWideValue("住所１：担当者名",     strChargeName(1),  LENGTH_ORG_CHARGENAME)
'
'       '担当者E-Mail
'       strMessage = .CheckNarrowValue("住所１：担当者E-Mailアドレス", strChargeEmail(1), LENGTH_EMAIL)
'       If strMessage = "" Then
'           strMessage = .CheckEMail("住所１：担当者E-Mailアドレス", strChargeEmail(1))
'       End If
'       .AppendArray vntArrMessage, strMessage
'
'       '担当部署
'       .AppendArray vntArrMessage, .CheckWideValue("住所１：担当部署名", strChargePost(1), LENGTH_ORG_CHARGEPOST)
'       '宛先会社名
'       .AppendArray vntArrMessage, .CheckWideValue("住所１：宛先会社名", strChargeOrgName(1), LENGTH_ORG_ORGNAME)
'
'
'       '住所３
'       .AppendArray vntArrMessage, .CheckWideValue("住所３：市区町村", strCityName(2), LENGTH_CITYNAME)
'       .AppendArray vntArrMessage, .CheckWideValue("住所３：（住所１）",   strAddress1(2), LENGTH_ADDRESS)
'       .AppendArray vntArrMessage, .CheckWideValue("住所３：（住所２）",   strAddress2(2), LENGTH_ADDRESS)
'       .AppendArray vntArrMessage, .CheckNarrowValue("住所３：電話番号直通", strDirectTel(2), 12)
'       .AppendArray vntArrMessage, .CheckNarrowValue("住所３：電話番号代表", strTel(2), 12)
'       .AppendArray vntArrMessage, .CheckNarrowValue("住所３：内線", strExtension(2), LENGTH_ORG_EXTENSION)
'       .AppendArray vntArrMessage, .CheckNarrowValue("住所３：ＦＡＸ番号", strFax(2), 12)
'       strMessage = .CheckNarrowValue("住所３：E-Mailアドレス", strEMail(2), LENGTH_EMAIL)
'       If strMessage = "" Then
'           strMessage = .CheckEMail("住所３：E-Mailアドレス", strEMail(2))
'       End If
'       .AppendArray vntArrMessage, strMessage
'
'       strMessage = .CheckNarrowValue("住所３：ＵＲＬアドレス", strUrl(2), 50)
'       .AppendArray vntArrMessage, strMessage
'       '担当名
'       .AppendArray vntArrMessage, .CheckWideValue("住所１：担当者カナ名", strChargeKName(2), LENGTH_ORG_CHARGEKNAME)
'       .AppendArray vntArrMessage, .CheckWideValue("住所１：担当者名",     strChargeName(2),  LENGTH_ORG_CHARGENAME)
'
'       '担当者E-Mail
'       strMessage = .CheckNarrowValue("住所１：担当者E-Mailアドレス", strChargeEmail(2), LENGTH_EMAIL)
'       If strMessage = "" Then
'           strMessage = .CheckEMail("住所１：担当者E-Mailアドレス", strChargeEmail(2))
'       End If
'       .AppendArray vntArrMessage, strMessage
'
'       '担当部署
'       .AppendArray vntArrMessage, .CheckWideValue("住所１：担当部署名", strChargePost(2), LENGTH_ORG_CHARGEPOST)
'       '宛先会社名
'       .AppendArray vntArrMessage, .CheckWideValue("住所１：宛先会社名", strChargeOrgName(2), LENGTH_ORG_ORGNAME)
'## 2003.12.17 Del End

        '口座番号
        .AppendArray vntArrMessage, .CheckNumeric("口座番号", strAccountNo, 10)

        '社員数
        .AppendArray vntArrMessage, .CheckNumeric("社員数", strNumEmp, 6)

        '平均年齢
        .AppendArray vntArrMessage, .CheckNumeric("平均年齢", strAvgAge, 3)

        '定期訪問予定日
        .AppendArray vntArrMessage, .CheckNumeric("定期訪問予定日", strVisitDate, 2)
'       .AppendArray vntArrMessage, .CheckDate("定期訪問予定日", strVisitYear, strVisitMonth, strVisitDay, strVisitDate)

        '契約日付
        .AppendArray vntArrMessage, .CheckDate("契約日付", strCtrptYear, strCtrptMonth, strCtrptDay, strCtrptDate)

        '送付案内コメント(改行文字も1字として含む旨を通達)
        strMessage = .CheckWideValue("送付案内コメント（日本文）", strSendComment, LENGTH_ORG_NOTES)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "（改行文字も含みます）"
        End If

        '送付案内コメント英語(改行文字も1字として含む旨を通達)
        strMessage = .CheckNarrowValue("送付案内コメント（英文）", strSendEComment, 400)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "（改行文字も含みます）"
        End If

        '汎用キー
        For i = 0 To UBound(strSpare)

            '文字列長チェック
            .AppendArray vntArrMessage, .CheckLength(strSpareName(i), strSpare(i), LENGTH_ORG_SPARE)

        Next

        '特記事項(改行文字も1字として含む旨を通達)
        strMessage = .CheckWideValue("特記事項", strNotes, LENGTH_ORG_NOTES)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "（改行文字も含みます）"
        End If

        '請求関連コメント(改行文字も1字として含む旨を通達)
        strMessage = .CheckWideValue("送付案内コメント", strDmdComment, LENGTH_ORG_NOTES)
        If strMessage <> "" Then
            .AppendArray vntArrMessage, strMessage & "（改行文字も含みます）"
        End If


    End With

    '戻り値の編集
    If IsArray(vntArrMessage) Then
        CheckValue = vntArrMessage
    End If

End Function


'-------------------------------------------------------------------------------
'
' 機能　　 : 使用中状態のドロップダウンリスト編集
'
' 引数　　 : 
'
' 戻り値　 : HTML文字列
'
' 備考　　 : 
'
'-------------------------------------------------------------------------------
Function DelFlgList()

    Dim strArrDelFlgID(3)       '使用中状態
    Dim strArrDelFlgName(3)     '使用中状態名

    '### 使用状態区分の変更により修正 2005.04.02 張
    '固定値の編集
    strArrDelFlgID(0) = "0":    strArrDelFlgName(0) = "使用中①"
    strArrDelFlgID(1) = "2":    strArrDelFlgName(1) = "使用中②"
    strArrDelFlgID(2) = "3":    strArrDelFlgName(2) = "長期未使用"
    strArrDelFlgID(3) = "1":    strArrDelFlgName(3) = "未使用"

    'strArrDelFlgID(0) = "0":    strArrDelFlgName(0) = "使用中"
    'strArrDelFlgID(1) = "2":    strArrDelFlgName(1) = "契約手続中"
    'strArrDelFlgID(2) = "3":    strArrDelFlgName(2) = "長期未使用"
    'strArrDelFlgID(3) = "1":    strArrDelFlgName(3) = "未使用"

    DelFlgList = EditDropDownListFromArray("delFlg", strArrDelFlgID, strArrDelFlgName, IIf(strDelFlg = "" , "2", strDelFlg), NON_SELECTED_DEL)

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 口座種別・名称のドロップダウンリスト編集
'
' 引数　　 : 
'
' 戻り値　 : HTML文字列
'
' 備考　　 : 
'
'-------------------------------------------------------------------------------
Function AccountList()

    Dim strArrAccountKind(1)    '口座種別
    Dim strArrAccountName(1)    '口座種別名

    '固定値の編集
    strArrAccountKind(0) = "1" : strArrAccountName(0) = "普通"
    strArrAccountKind(1) = "2" : strArrAccountName(1) = "当座"

    AccountList = EditDropDownListFromArray("accountkind", strArrAccountKind, strArrAccountName, strAccountKind, NON_SELECTED_ADD)

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 年始・中元・歳暮のドロップダウンリスト編集
'
' 引数　　 : 
'
' 戻り値　 : HTML文字列
'
' 備考　　 : 
'
'-------------------------------------------------------------------------------
Function PresentsList()

    Dim strArrPresentsID(1)         '出力種別
    Dim strArrPresentsName(1)       '出力名

    '固定値の編集
    strArrPresentsID(0) = "1" : strArrPresentsName(0) = "出力する"
    strArrPresentsID(1) = "0" : strArrPresentsName(1) = "出力しない"

    PresentsList = EditDropDownListFromArray("presents", strArrPresentsID, strArrPresentsName, strPresents, NON_SELECTED_ADD)

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : ＤＭのドロップダウンリスト編集
'
' 引数　　 : 
'
' 戻り値　 : HTML文字列
'
' 備考　　 : 
'
'-------------------------------------------------------------------------------
Function DmList()

    Dim strArrDmID(3)       '出力種別
    Dim strArrDmName(3)     '出力名

    ''##　営業からの依頼によって修正　2005.02.17　張 ##
    ''##　住所種類に合わせてＤＭ区分セッティング     ##
    ''固定値の編集
    'strArrDmID(0) = "1" : strArrDmName(0) = "出力する"
    'strArrDmID(1) = "0" : strArrDmName(1) = "出力しない"
    strArrDmID(0) = "1" : strArrDmName(0) = "住所１"
    strArrDmID(1) = "2" : strArrDmName(1) = "住所２"
    strArrDmID(2) = "3" : strArrDmName(2) = "住所３"
    strArrDmID(3) = "0" : strArrDmName(3) = "出力しない"

    DmList = EditDropDownListFromArray("dm", strArrDmID, strArrDmName, strDm, NON_SELECTED_ADD)

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 送付方法のドロップダウンリスト編集
'
' 引数　　 : 
'
' 戻り値　 : HTML文字列
'
' 備考　　 : 
'
'-------------------------------------------------------------------------------
Function SendMethodList()

    Dim strArrSendID(1)     '送信方法
    Dim strArrSendName(1)   '送信名

    '固定値の編集
'## 2003.11.18 Mod by T.Takagi@FSIT チェック制約が異なる
'	strArrSendID(0) = "1" : strArrSendName(0) = "個別"
'	strArrSendID(1) = "2" : strArrSendName(1) = "一括"
    strArrSendID(0) = "0" : strArrSendName(0) = "個別"
    strArrSendID(1) = "1" : strArrSendName(1) = "一括"
'## 2003.11.18 Mod End

    SendMethodList = EditDropDownListFromArray("sendMethod", strArrSendID, strArrSendName, strSendMethod, NON_SELECTED_ADD)

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 請求書適用住所のドロップダウンリスト編集
'
' 引数　　 : 
'
' 戻り値　 : HTML文字列
'
' 備考　　 : 
'
'-------------------------------------------------------------------------------
Function BillAddressList()

    Dim strArrBillAddID(2)      '住所番号
    Dim strArrBillAddName(2)    '住所名

    '固定値の編集
    strArrBillAddID(0) = "1" : strArrBillAddName(0) = "住所１"
    strArrBillAddID(1) = "2" : strArrBillAddName(1) = "住所２"
    strArrBillAddID(2) = "3" : strArrBillAddName(2) = "住所３"

    BillAddressList = EditDropDownListFromArray("billAddress", strArrBillAddID, strArrBillAddName, strBillAddress, NON_SELECTED_ADD)

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : 利用券区分のドロップダウンリスト編集
'
' 引数　　 : 
'
' 戻り値　 : HTML文字列
'
' 備考　　 : 
'
'-------------------------------------------------------------------------------
Function TicketDivList()

    Dim strArrTicketDivID(3)        '利用券区分
    Dim strArrTicketDivName(3)      '利用券区分名

    '固定値の編集
    strArrTicketDivID(0) = "1" : strArrTicketDivName(0) = "貴社専用フォーム"
    strArrTicketDivID(1) = "2" : strArrTicketDivName(1) = "健保組合フォーム"
    strArrTicketDivID(2) = "3" : strArrTicketDivName(2) = "健保連フォーム"
    strArrTicketDivID(3) = "4" : strArrTicketDivName(3) = "聖路加フォーム"

    TicketDivList = EditDropDownListFromArray("ticketDiv", strArrTicketDivID, strArrTicketDivName, strTicketDiv, NON_SELECTED_ADD)

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 :確認はがき有無の配列作成
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub CreatePostCardInfo()

    Redim Preserve strArrPostCard( postCardCount - 1 )
    Redim Preserve strArrPostCardName( postCardCount - 1)

    strArrPostCard(0) = "1":strArrPostCardName(0) = "有"
    strArrPostCard(1) = "0":strArrPostCardName(1) = "無"

End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 :一括送付案内有無の配列作成
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub CreateSendGuidInfo()

    Redim Preserve strArrSendGuid( sendGuidCount - 1 )
    Redim Preserve strArrSendGuidName( sendGuidCount - 1)

    strArrSendGuid(0) = "1":strArrSendGuidName(0) = "有"
    strArrSendGuid(1) = "0":strArrSendGuidName(1) = "無"

End Sub

'-------------------------------------------------------------------------------
'
' 機能　　 :利用券の配列作成
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub CreateTicketInfo()

    Redim Preserve strArrTicket( ticketCount - 1 )
    Redim Preserve strArrTicketName( ticketCount - 1)

    strArrTicket(0) = "1":strArrTicketName(0) = "利用する"
    strArrTicket(1) = "0":strArrTicketName(1) = "利用しない"

End Sub



%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>団体情報メンテナンス</TITLE>
<!-- #include virtual = "/webHains/includes/zipGuide.inc"     -->
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<!-- #include virtual = "/webHains/includes/noteGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--

var winRptOpt;

// 郵便番号ガイド呼び出し
function callZipGuide(keyPrefCd, zipCd, prefCd, cityName, address1) {

    var objForm = document.entryForm;   // 自画面のフォームエレメント

    zipGuide_showGuideZip( keyPrefCd, zipCd, prefCd, cityName, address1 );

}

// 郵便番号のクリア
function clearZipInfo(zipCd) {

    var objForm = document.entryForm;    // 自画面のフォームエレメント

    zipGuide_clearZipInfo( zipCd, zipCd );

}

var winGuideCal;
// 日付ガイド呼び出し
function callCalGuide(year, month, day) {


    // 日付ガイド表示
    calGuide_showGuideCalendar( year, month, day, '' );

}

// 保存
function saveData() {

    /** 団体情報の保存処理を行う時ワーニングメッセージを表示して再確認するように修正 Start 2005.06.18 張 **/
    if ( !confirm( '団体情報を変更します。よろしいですか？' ) ) {
        return;
    }
    /** 団体情報の保存処理を行う時ワーニングメッセージを表示して再確認するように修正 End   2005.06.18 張 **/

    document.entryForm.submit();

}

function deleteData() {

    if ( !confirm( 'この団体情報を削除します。よろしいですか？' ) ) {
        return;
    }

    // モードを指定してsubmit
    document.entryForm.act.value = 'delete';
    document.entryForm.submit();

}

function windowClose() {
    zipGuide_closeGuideZip();
    
    // 日付ガイドを閉じる
    calGuide_closeGuideCalendar();
}

/** 請求書に添付する成績書に関するチェックボックスコントロール  **/
/** 2005.5.06 追加 張                                       **/
function changeBillReport(cnt,cnt2)
{
    with(document.entryForm){
        //eval('billReport'+cnt).checked = true;
        eval('billReport'+cnt2).checked = false;
        if(eval('billReport'+cnt).checked == true){
            billReport.value = eval('billReport'+cnt).value;
        } else {
            billReport.value = "";
        }
    }
}

/** ３連成績書のオプション検査結果印刷管理画面表示 **/
/** 2005.5.06 追加 張                                       **/
function callReportOption(orgCd1, orgCd2)
{
    var opened = false; // 画面が開かれているか
    var url;            // 成績書オプション管理画面のURL

    // すでにガイドが開かれているかチェック
    if ( winRptOpt != null ) {
        if ( !winRptOpt.closed ) {
            opened = true;
        }
    }

    // 成績書オプション管理画面のURL編集
    url = 'rptSetOption.asp?orgCd1=' + orgCd1 + '&orgCd2=' + orgCd2;

    // 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
    if ( opened ) {
        winRptOpt.focus();
        winRptOpt.location.replace( url );
    } else {
        winRptOpt = window.open( url, '', 'width=550,height=550,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
    }

}

//-->
</SCRIPT>
<STYLE TYPE="text/css">
td.mnttab { background-color:#FFFFFF }
</STYLE>
</HEAD>
<BODY ONUNLOAD="javascript:zipGuide_closeGuideZip()">

<!-- #include virtual = "/webHains/includes/navibar.inc" -->
<FORM NAME="entryForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<BLOCKQUOTE>
<INPUT TYPE="hidden"    NAME="mode"         VALUE="<%= strMode %>">
<INPUT TYPE="hidden"    NAME="act"          VALUE="save">
<INPUT TYPE="hidden"    NAME="target"       VALUE="<%= strTarget %>">
<INPUT TYPE="hidden"    NAME="billReport"   VALUE="<%=strBillReport%>">
<!-- 表題 -->
<TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="650">
    <TR><TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="maintenance">■</SPAN><FONT COLOR="#000000">団体情報メンテナンス</FONT></B></TD></TR>
</TABLE>
<!-- 操作ボタン -->
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0" WIDTH="650">
    <TR>
        <TD HEIGHT="5"></TD>
    </TR>
    <TR>
        <TD>
<%
            '操作用アンカー制御設定
            blnOpAnchor = ( strMode = "update" ) And Not ( strOrgCd1 ="XXXXX" AND strOrgCd2 ="XXXXX" ) And Not ( strOrgCd1 ="WWWWW" AND strOrgCd2 ="WWWWW" )
%>
            <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%">
                <TR>
                    <TD WIDTH="100%"></TD>
                    <TD><A HREF="<%= EditURLForReturning() %>"><IMG SRC="/webhains/images/back.gif" WIDTH="77" HEIGHT="24" ALT="検索画面に戻ります"></A></TD>
                    <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="7" HEIGHT="5"></TD>
<%
                    If blnOpAnchor Then
%>
                    <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="12" HEIGHT="5"></TD>

                        <TD>
                        <% '2005.08.22 権限管理 Add by 李　--- START %>
                        <%  if Session("PAGEGRANT") = "3" or Session("PAGEGRANT") = "4" then   %>
                            <A HREF="javascript:deleteData()"><IMG SRC="/webhains/images/delete.gif" WIDTH="77" HEIGHT="24" ALT="この団体情報を削除します"></A>
                        <%  else    %>
                             &nbsp;
                        <%  end if  %>
                        <% '2005.08.22 権限管理 Add by 李　--- END %>
                        </TD>

                        <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="25" HEIGHT="5"></TD>
<%
                    End If
%>
<%
                    If strMode = "update" Then
%>
                        <TD NOWRAP><A HREF="/webHains/contents/contract/ctrCourseList.asp?orgCd1=<%= strOrgCd1 %>&orgCd2=<%= strOrgCd2 %>"><IMG SRC="/webHains/images/prevcont_b.gif" HEIGHT="24" WIDTH="77" ALT="契約を参照します"></A></TD>
                        <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="7" HEIGHT="5"></TD>
                        <TD><A HREF="javascript:noteGuide_showGuideNote('5', '0,0,1,0', '', '', '<%= strOrgCd1 %>', '<%= strOrgCd2 %>')"><IMG SRC="/webHains/images/comment.gif" HEIGHT="24" WIDTH="77" ALT="コメントを登録します"></A></TD>
<%
                    End If
%>
                    <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="12" HEIGHT="5"></TD>

                    <TD>
                    <% '2005.08.22 権限管理 Add by 李　--- START %>
                        <%  if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then   %>
                        <A HREF="javascript:saveData()"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="入力したデータを保存します"></A>
                    <%  else    %>
                         &nbsp;
                    <%  end if  %>
                    <% '2005.08.22 権限管理 Add by 李　--- END %>
                    </TD>


                </TR>
            </TABLE>
        </TD>
    </TR>
    <TR>
        <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="1" HEIGHT="15"></TD>
    </TR>
</TABLE>
<%
'メッセージの編集
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
<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="1">
    <TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">団体コード</TD>
        <TD WIDTH="5"></TD>
        <TD>
<%
            '挿入モードの場合はテキスト表示を行い、更新モードの場合はhiddenでコードを保持
            If strMode = "insert" Then
%>
                <INPUT TYPE="text" NAME="orgCd1" SIZE="5" MAXLENGTH="5" VALUE="<%= strOrgCd1 %>" STYLE="ime-mode:disabled;">-<INPUT TYPE="text" NAME="orgCd2" SIZE="5" MAXLENGTH="5" VALUE="<%= strOrgCd2 %>" STYLE="ime-mode:disabled;">
<%
            Else
%>
                <INPUT TYPE="hidden" NAME="orgCd1" VALUE="<%= strOrgCd1 %>"><INPUT TYPE="hidden" NAME="orgCd2" VALUE="<%= strOrgCd2 %>"><%= strOrgCd1 %>-<%= strOrgCd2 %>
<%
            End If
%>
        </TD>
    </TR>
    <TR>
        <TD HEIGHT="6"></TD>
    </TR>
    <TR HEIGHT="26">
        <TD HEIGHT="26" BGCOLOR="#eeeeee" ALIGN="right">使用状態</TD>
        <TD HEIGHT="26"></TD>
        <TD HEIGHT="26"><%= DelFlgList() %></TD>
    </TR>
    <TR height="26">
        <TD HEIGHT="26" BGCOLOR="#eeeeee" ALIGN="right">団体カナ名称</TD>
        <TD height="26"></TD>
        <TD height="26"><INPUT TYPE="text" NAME="orgKName" SIZE="100" MAXLENGTH="40" VALUE="<%= strOrgKName %>" STYLE="ime-mode:active;"></TD>
    </TR>
    <TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">団体名称</TD>
        <TD></TD>
        <TD><INPUT TYPE="text" NAME="orgName" SIZE="70" MAXLENGTH="50" VALUE="<%= strOrgName %>" STYLE="ime-mode:activate;"></TD>
    </TR>
    <TR>
        <TD height="25" bgcolor="#eeeeee" align="right">団体名称（英語）</TD>
        <TD></TD>
        <TD><INPUT TYPE="text" NAME="orgEName" SIZE="70" MAXLENGTH="50" VALUE="<%= strOrgEName %>" STYLE="ime-mode:disabled;"></TD>
    </TR>
    <TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">団体略称</TD>
        <TD></TD>
        <TD><INPUT TYPE="text" NAME="orgSName" SIZE="27" MAXLENGTH="20" VALUE="<%= strOrgSName %>" STYLE="ime-mode:activate;"></TD>
    </TR>
    <TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">団体種別</TD>
        <TD></TD>
<%
            '団体種別
            objFree.SelectFree 1, strKeyOrgDivCd, strArrOrgDivCd, , , strArrOrgDivCdName
%>
        <TD><%= EditDropDownListFromArray("orgDivCd", strArrOrgDivCd, strArrOrgDivCdName, strOrgDivCd, NON_SELECTED_ADD) %></TD>
    </TR>
    <TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">請求書用名称</TD>
        <TD></TD>
        <TD><INPUT TYPE="text" NAME="orgBillName" SIZE="83" MAXLENGTH="60" VALUE="<%= strOrgBillName %>" STYLE="ime-mode:activate;"></TD>
    </TR>
    <TR>
        <TD HEIGHT="8" ALIGN="left"></TD>
        <TD HEIGHT="8"></TD>
        <TD HEIGHT="8"></TD>
    </TR>
<%
    For i = 0 To 2
        Select Case i
            Case 0
                strWkNum = "１"
            Case 1
                strWkNum = "２"
            Case 2
                strWkNum = "３"
        End Select
%>      
        <TR>
            <TD HEIGHT="25" ALIGN="left">住所<%= strWkNum %></TD>
            <TD></TD>
            <TD></TD>
        </TR>
        <TR>
            <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">宛先会社名</TD>
            <TD></TD>
            <TD><INPUT TYPE="text" NAME="chargeOrgName" SIZE="70" MAXLENGTH="50" VALUE="<%= strChargeOrgName(i) %>" STYLE="ime-mode:active;"></TD>
        </TR>
        <TR>
            <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">郵便番号</TD>
            <TD></TD>
            <TD>
                <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                    <TR>
                        <TD><A HREF="javascript:callZipGuide(document.entryForm.prefCd[<%= i %>].value, document.entryForm.zipCd[<%= i %>], document.entryForm.prefCd[<%= i %>], document.entryForm.cityName[<%= i %>], document.entryForm.address1[<%= i %>] )"><IMG SRC="../../../images/question.gif" WIDTH="21" HEIGHT="21" ALT="郵便番号ガイド表示" border="0"  ></A>
                        <TD>&nbsp;</TD>
                        <TD><A HREF="javascript:clearZipInfo(document.entryForm.zipCd[<%= i %>])"><IMG SRC="../../../images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="郵便番号を削除します" border="0"></A></TD>
                        <TD>&nbsp;</TD>
                        <TD><INPUT TYPE="text" NAME="zipCd" VALUE="<%= strZipCd(i) %>" SIZE="8" MAXLENGTH="7" STYLE="ime-mode:disabled;"></TD>
                        <TD>　都道府県：</TD>
                        <TD><%= EditPrefList("prefCd", strPrefcd(i)) %></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">市区町村</TD>
            <TD></TD>
            <TD><INPUT TYPE="text" NAME="cityName" SIZE="70" MAXLENGTH="50" VALUE="<%= strCityName(i) %>" STYLE="ime-mode:active;"></TD>
        </TR>
        <TR>
            <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">住所(1)</TD>
            <TD></TD>
            <TD><INPUT TYPE="text" NAME="address1" SIZE="83" MAXLENGTH="60" VALUE="<%= strAddress1(i) %>" STYLE="ime-mode:active;"></TD>
        </TR>
        <TR>
            <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">住所(2)</TD>
            <TD></TD>
            <TD><INPUT TYPE="text" NAME="address2" SIZE="83" MAXLENGTH="60" VALUE="<%= strAddress2(i) %>" STYLE="ime-mode:active;"></TD>
        </TR>
        <TR>
            <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">電話番号直通</TD>
            <TD></TD>
            <TD><INPUT TYPE="text" NAME="directTel" SIZE="15" MAXLENGTH="12" VALUE="<%= strDirectTel(i) %>" STYLE="ime-mode:disabled;"></TD>
        </TR>
        <TR>
            <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">電話番号代表</TD>
            <TD></TD>
            <TD>
                <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                <TR>
                    <TD><INPUT TYPE="text" NAME="tel" SIZE="15" MAXLENGTH="12" VALUE="<%= strTel(i) %>" STYLE="ime-mode:disabled;"></TD>
                    <TD>内線</TD>
                    <TD>：&nbsp;</TD>
                    <TD><INPUT TYPE="text" NAME="extension" SIZE="15" MAXLENGTH="10" VALUE="<%= strExtension(i) %>" STYLE="ime-mode:disabled;"></TD>
                </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">FAX番号</TD>
            <TD></TD>
            <TD><INPUT TYPE="text" NAME="fax" SIZE="15" MAXLENGTH="12" VALUE="<%= strFax(i) %>" STYLE="ime-mode:disabled;"></TD>
        </TR>
        <TR>
            <TD height="25" bgcolor="#eeeeee" ALIGN="right">E-mail</TD>
           <TD height="25"></TD>
            <TD height="25"><INPUT TYPE="text" NAME="eMail" SIZE="52" MAXLENGTH="40" VALUE="<%= strEMail(i) %>" STYLE="ime-mode:disabled;"></TD>
        </TR>
        <TR>
            <TD height="25" bgcolor="#eeeeee" ALIGN="right">URL</TD>
            <TD></TD>
            <TD><INPUT TYPE="text" NAME="url" SIZE="52" MAXLENGTH="40" VALUE="<%= strUrl(i) %>" STYLE="ime-mode:disabled;"></TD>
        </TR>
        <TR>
            <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">担当者カナ名</TD>
            <TD></TD>
            <TD><INPUT TYPE="text" NAME="chargeKName" SIZE="40" MAXLENGTH="30" VALUE="<%= strChargeKName(i) %>" STYLE="ime-mode:active;"></TD>
        </TR>
        <TR>
            <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">担当者名</TD>
            <TD></TD>
            <TD><INPUT TYPE="text" NAME="chargeName" SIZE="27" MAXLENGTH="20" VALUE="<%= strChargeName(i) %>" STYLE="ime-mode:active;"></TD>
        </TR>
        <TR>
            <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">担当者E-Mailアドレス</TD>
            <TD></TD>
            <TD><INPUT TYPE="text" NAME="chargeEmail" SIZE="52" MAXLENGTH="40" VALUE="<%= strChargeEmail(i) %>" STYLE="ime-mode:disabled;"></TD>
        </TR>
        <TR>
            <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">担当部署名</TD>
            <TD></TD>
            <TD><INPUT TYPE="text" NAME="chargePost" SIZE="70" MAXLENGTH="50" VALUE="<%= strChargePost(i) %>" STYLE="ime-mode:active;"></TD>
        </TR>
<%
    Next
%>

    <TR HEIGHT="6">
        <TD HEIGHT="6" ALIGN="right"></TD>
        <TD HEIGHT="6"></TD>
        <TD HEIGHT="6"></TD>
    </TR>
    <TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">銀行名</TD>
        <TD></TD>
        <TD><INPUT TYPE="text" NAME="bank" SIZE="26" MAXLENGTH="10" VALUE="<%= strBank %>" STYLE="ime-mode:active;"></TD>
    </TR>
    <TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">支店名</TD>
        <TD></TD>
        <TD><INPUT TYPE="text" NAME="branch" SIZE="26" MAXLENGTH="10" VALUE="<%= strBranch %>" STYLE="ime-mode:active;"></TD>
    </TR>
    <TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">口座</TD>
        <TD></TD>
        <TD>
            <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                <TD>種別：</TD>
                <TD><%= AccountList() %></TD>
                <TD>番号：</TD>
                <TD><INPUT TYPE="text" NAME="accountNo" SIZE="13" MAXLENGTH="10" VALUE="<%= strAccountNo %>" STYLE="ime-mode:disabled;"></TD>
            </TABLE>
        </TD>
    </TR>
    <TR>
        <TD HEIGHT="6"></TD>
    </TR>
    <TR>
        <TD bgcolor="#eeeeee" ALIGN="right" height="25">社員数</TD>
        <TD height="25"></TD>
        <TD height="25"><INPUT TYPE="text" NAME="numEmp" SIZE="6" MAXLENGTH="6" VALUE="<%= strNumEmp %>" STYLE="ime-mode:disabled;"></TD>
    </TR>
    <TR>
        <TD bgcolor="#eeeeee" ALIGN="right" height="25">平均年齢</TD>
        <TD height="25"></TD>
        <TD height="25"><INPUT TYPE="text" NAME="avgAge" SIZE="6" MAXLENGTH="3" VALUE="<%= strAvgAge %>" STYLE="ime-mode:disabled;"></TD>
    </TR>
    <TR>
        <TD bgcolor="#eeeeee" ALIGN="right" height="25">定期訪問予定日</TD>
        <TD></TD>
        <TD>
            <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                <TR>
                    <TD>毎月&nbsp;<%= EditSelectNumberList("visitDate",   1, 31, CLng("0" & strVisitDate )) %></TD>
                    <TD>&nbsp;日</TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
    <TR>
        <TD bgcolor="#eeeeee" ALIGN="right" height="25">年始・中元・歳暮</TD>
        <TD height="25"></TD>
        <TD><%= PresentsList() %></TD>
    </TR>
    <TR>
        <TD bgcolor="#eeeeee" ALIGN="right" height="25">ＤＭ</TD>
        <TD height="25"></TD>
        <TD><%= DmList() %></TD>
    </TR>
    <TR>
        <TD bgcolor="#eeeeee" ALIGN="right" height="25">送付方法</TD>
        <TD height="25"></TD>
        <TD><%= SendMethodList() %></TD>
    </TR>
    <TR>
        <TD HEIGHT="8"></TD>
    </TR>
    <TD bgcolor="#eeeeee" align="right" height="25">確認はがき</TD>
    <TD></TD>
    <TD>
<%
        For i = 0 To postCardCount - 1
%>
            <INPUT TYPE="radio" NAME="postcard" VALUE="<%= strArrPostCard(i) %>" <%= IIf( strArrPostCard(i) = strPostCard , "CHECKED", "") %>><%= strArrPostCardName(i) %>
<%
        Next
%>
    </TD>
    <TD valign="top"></TD>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right" HEIGHT="25">一括送付案内</TD>
        <TD></TD>
        <TD>
<%
        For i = 0 To sendGuidCount - 1
%>
            <INPUT TYPE="radio" NAME="sendguid" VALUE="<%= strArrSendGuid(i) %>" <%= IIf( strArrSendGuid(i) = strSendGuid , "CHECKED", "") %>><%= strArrSendGuidName(i) %>
<%
        Next
%>
        </TD>
        <TD VALIGN="top"></TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right" HEIGHT="25">利用券</TD>
        <TD></TD>
        <TD NOWRAP>
<%
        For i = 0 To ticketCount - 1
%>
            <INPUT TYPE="radio" NAME="ticket" VALUE="<%= strArrTicket(i) %>" <%= IIf( strArrTicket(i) = strTicket , "CHECKED", "") %>><%= strArrTicketName(i) %>
<%
        Next
%>
        </TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right" HEIGHT="25">利用券区分</TD>
        <TD></TD>
        <TD><%= TicketDivList() %></TD>

    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right" HEIGHT="25">利用券請求書添付</TD>
        <TD></TD>
        <TD NOWRAP>
            <INPUT TYPE="checkbox" NAME="ticketAddBill" VALUE="1" <%= IIf( strTicketAddBill = "1", "CHECKED", "") %>>要添付　</TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right" HEIGHT="25">利用券事前回収</TD>
        <TD></TD>
        <TD NOWRAP>
            <INPUT TYPE="checkbox" NAME="ticketCenterCall" VALUE="1" <%= IIf( strTicketCenterCall = "1", "CHECKED", "") %>>有</TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right" HEIGHT="25">利用券本人当日回収</TD>
        <TD></TD>
        <TD NOWRAP>
            <INPUT TYPE="checkbox" NAME="ticketperCall" VALUE="1" <%= IIf( strTicketperCall = "1", "CHECKED", "") %>>有</TD>
    </TR>
    <TR>
        <TD bgcolor="#eeeeee" ALIGN="right" height="25">契約日付</TD>
        <TD></TD>
<%
        '年月日の形式を作成する
        strSelectedDate = strCtrptYear & "/" & strCtrptMonth & "/" & strCtrptDay

        '日付認識不能時は元号をそのまま関数に渡す
        If Not IsDate(strSelectedDate) Then
            strSelectedDate = strCtrptYear
        End If
%>
        <TD>
            <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                <TR>
                    <TD><A HREF="javascript:callCalGuide('ctrptYear', 'ctrptMonth', 'ctrptDay' )"><IMG SRC="/webHains/images/question.gif" ALT="日付ガイドを表示" HEIGHT="21" WIDTH="21" BORDER="0"></A></TD>
                    <TD><A HREF="javascript:calGuide_clearDate('ctrptYear', 'ctrptMonth', 'ctrptDay')"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="日付を削除します" border="0"></A></TD>					<TD><%= EditSelectNumberList("ctrptYear", YEARRANGE_MIN, YEARRANGE_MAX, CLng("0" & strCtrptYear)) %></TD>
                    <TD>&nbsp;年&nbsp;</TD>
                    <TD><%= EditSelectNumberList("ctrptMonth", 1, 12, CLng("0" & strCtrptMonth)) %></TD>
                    <TD>&nbsp;月&nbsp;</TD>
                    <TD><%= EditSelectNumberList("ctrptDay",   1, 31, CLng("0" & strCtrptDay  )) %></TD>
                    <TD>&nbsp;日</TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right" HEIGHT="25">１年目はがき</TD>
        <TD></TD>
        <TD NOWRAP>
            <INPUT TYPE="checkbox" NAME="noPrintLetter" VALUE="1" <%= IIf( strNoPrintLetter = "1", "CHECKED", "") %>>出力しない　
        </TD>
    </TR>
    <TR>
        <TD HEIGHT="8"></TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right" HEIGHT="25">保険証</TD>
        <TD></TD>
        <TD NOWRAP>
            <INPUT TYPE="checkbox" NAME="insCheck" VALUE="1" <%= IIf( strInsCheck = "1", "CHECKED", "") %>>予約時に確認する　
            <INPUT TYPE="checkbox" NAME="insBring" VALUE="1" <%= IIf( strInsBring = "1", "CHECKED", "") %>>当日持参して頂く　
            <INPUT TYPE="checkbox" NAME="insReport" VALUE="1" <%= IIf( strInsReport = "1", "CHECKED", "") %>>成績表に保険証記号、番号を出力　</TD>
    </TR>
    <TR>
        <TD HEIGHT="8"></TD>
    </TR>
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right" HEIGHT="25">請求書</TD>
        <TD></TD>
        <!-- ## 2008.03.19 Add By 張 請求書特定健診レポート項目追加 Start -->
        <TD>適用住所：<%= BillAddressList() %>&nbsp;&nbsp;<br>
            <INPUT TYPE="checkbox" NAME="billCslDiv"    VALUE="1" <%= IIf( strBillCslDiv = "1", "CHECKED", "") %>>本人、家族区分を出力
            <INPUT TYPE="checkbox" NAME="billIns"       VALUE="1" <%= IIf( strBillIns = "1", "CHECKED", "") %>>保険証記号、番号を出力
            <INPUT TYPE="checkbox" NAME="billEmpNo"     VALUE="1" <%= IIf( strBillEmpNo = "1", "CHECKED", "") %>>社員番号を出力
            <INPUT TYPE="checkbox" NAME="billAge"       VALUE="1" <%= IIf( strBillAge = "1", "CHECKED", "") %>>年齢を出力<br>
            <INPUT TYPE="checkbox" NAME="billReport1"   VALUE="1" <%= IIf( strBillReport = "1", "CHECKED", "") %> onclick="javascript:changeBillReport(1,2);">３連成績書を添付
            <INPUT TYPE="checkbox" NAME="billReport2"   VALUE="2" <%= IIf( strBillReport = "2", "CHECKED", "") %> onclick="javascript:changeBillReport(2,1);">法定項目成績書を添付
            <INPUT TYPE="checkbox" NAME="billSpecial"   VALUE="1" <%= IIf( strBillSpecial = "1", "CHECKED", "") %>>特定健診成績書を添付
            <INPUT TYPE="checkbox" NAME="billFD"        VALUE="1" <%= IIf( strBillFD = "1", "CHECKED", "") %>>FD発送
        </TD>
    </TR>
    <TR>
        <TD HEIGHT="8"></TD>
    </TR>
<!-- ## 2004.01.29 Add By T.Takagi@FSIT 項目追加 -->
    <TR>
        <TD BGCOLOR="#eeeeee" ALIGN="right" HEIGHT="25">成績書</TD>
        <TD></TD>
        <TD><INPUT TYPE="checkbox" NAME="reptCslDiv" VALUE="1" <%= IIf(strReptCslDiv = "1", "CHECKED", "") %>>本人、家族区分を出力&nbsp;&nbsp;&nbsp;&nbsp;
        <!-- ## 2005.05.09 Add By 張 新規追加 Start -->
        <%
            'オプションコードが存在する場合のみ保存ボタンを用意する
            If strOrgCd1 <> "" Then
        %>
            <A HREF="javascript:callReportOption('<%=strOrgCd1%>','<%=strOrgCd2%>')">成績書オプション管理</A>
        <%
            End If
        %>
        <!-- ## 2005.05.09 Add By 張 新規追加 End   -->
        </TD>
    </TR>
<!-- ## 2004.01.29 Add End -->
    <TR>
        <TD HEIGHT="8"></TD>
    </TR>
    <TR>
        <TD bgcolor="#eeeeee" ALIGN="right" height="25">送付案内コメント（日本文）</TD>
        <TD height="25"></TD>
        <TD height="25"><TEXTAREA NAME="sendComment" COLS="46" ROWS="4" STYLE="ime-mode:active;"><%= strSendComment %></TEXTAREA></TD>
    </TR>
    <TR>
        <TD bgcolor="#eeeeee" ALIGN="right" height="25">送付案内コメント（英文）</TD>
        <TD height="25"></TD>
        <TD height="25"><TEXTAREA NAME="sendEComment" COLS="46" ROWS="4" STYLE="ime-mode:disabled;"><%= strSendEComment %></TEXTAREA></TD>
    </TR>
    <TR height="6">
        <TD ALIGN="right" height="6"></TD>
        <TD height="6"></TD>
        <TD height="6"></TD>
    </TR>
    <TR>
        <TD HEIGHT="6"></TD>
    </TR>
    <TR>
        <TD height="25" bgcolor="#eeeeee" ALIGN="right">汎用項目その１</TD>
        <TD></TD>
        <TD><INPUT TYPE="text" NAME="spare1" SIZE="15" MAXLENGTH="12" VALUE="<%= strSpare(0) %>">&nbsp;※保険者番号</TD>
    </TR>
    <TR height="24">
        <TD height="24" bgcolor="#eeeeee" ALIGN="right">汎用項目その２</TD>
        <TD height="24"></TD>
        <TD height="24"><INPUT TYPE="text" NAME="spare2" SIZE="15" MAXLENGTH="12" VALUE="<%= strSpare(1) %>">&nbsp;※組合番号</TD>
    </TR>
    <TR height="24">
        <TD height="24" bgcolor="#eeeeee" ALIGN="right">汎用項目その３</TD>
        <TD height="24"></TD>
        <TD height="24"><INPUT TYPE="text" NAME="spare3" SIZE="15" MAXLENGTH="12" VALUE="<%= strSpare(2) %>"></TD>
    </TR>
<!-- 2004/01/22 Updated by Ishihara@FSIT コメントはコメントに統一
    <TR height="24">
        <TD height="24" bgcolor="#eeeeee" ALIGN="right">団体に関する通常コメント</TD>
        <TD height="24"></TD>
        <TD height="24"><TEXTAREA NAME="notes" COLS="60" ROWS="4" STYLE="ime-mode:active;"><%= strNotes %></TEXTAREA></TD>
    </TR>
-->
    <TR height="24">
        <TD></TD>
        <TD></TD>
        <TD><FONT COLOR="RED"><B>2004/1/22更新:<BR>コメントはコメント情報として登録場所をまとめました。<BR>このページの最上部コメントボタンから登録してください。<BR>
        （請求関連コメントも最上部コメントボタンにまとめる予定です）
        <INPUT TYPE="HIDDEN" NAME="notes"><%= strNotes %></INPUT>
        </B></FONT>
        </TD>
    </TR>
    <TR height="24">
        <TD height="24" bgcolor="#eeeeee" align="right">請求関連コメント</TD>
        <TD height="24"></TD>
        <TD height="24"><TEXTAREA NAME="dmdComment" COLS="60" ROWS="4" STYLE="ime-mode:active;"><%= strDmdComment %></TEXTAREA></TD>
        <TD></TD>
    </TR>
    <TR height="7">
        <TD height="7" ALIGN="right"></TD>
        <TD height="7"></TD>
        <TD height="7"></TD>
    </TR>
    <TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">更新日時</TD>
        <TD></TD>
        <TD><INPUT TYPE="hidden" NAME="updDate" VALUE="<%= strUpdDate %>"><%= strUpdDate %></TD>
    </TR>
    <INPUT TYPE="hidden" NAME="updUser"  VALUE="<%= strUpdUser  %>">
    <INPUT TYPE="hidden" NAME="userName" VALUE="<%= strUserName %>">
    <TR>
        <TD HEIGHT="25" BGCOLOR="#eeeeee" ALIGN="right">オペレータＩＤ</TD>
        <TD></TD>
        <TD><%= strUserName %></TD>
    </TR>
</TABLE>
</BLOCKQUOTE>
</FORM>
<DIV ALIGN="right"><FONT COLOR="#ffffff">.</FONT></DIV>
</BODY>
</HTML>
