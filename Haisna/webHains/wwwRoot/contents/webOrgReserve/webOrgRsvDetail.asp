<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      web団体予約情報登録(基本情報) (Ver1.0.0)
'      AUTHER  : 
'-----------------------------------------------------------------------------
'管理番号：SL-UI-Y0101-108
'修正日  ：2010.08.06（修正）
'担当者  ：TCS)菅原
'修正内容：web団体予約よりキャンセルの取込も可能とする。
'-------------------------
'管理番号：SL-SN-Y0101-612
'修正日　：2013.3.11
'担当者  ：T.Takagi@RD
'修正内容：web予約受診オプションの取得方法変更

Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/editCourseList.inc" -->
<!-- #include virtual = "/webHains/includes/EditMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<!-- #include virtual = "/webHains/includes/recentConsult.inc"  -->
<!-- #include virtual = "/webHains/includes/webRsv.inc"         -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const MODE_CANCEL        = "cancel"         '処理モード(予約キャンセル)
Const CANCEL_FIX         = 1                'キャンセル理由固定（暫定：院内都合）

Const FREECD_CANCEL      = "CANCEL"         '汎用コード(キャンセル理由)
Const FREECD_RSVINTERVAL = "RSVINTERVAL"    '汎用コード(はがきから送付案内への切り替えを行う日数)

Const PRTONSAVE_INDEXNONE = 0       '保存時印刷(なし)
Const PRTONSAVE_INDEXCARD = 1       '保存時印刷(はがき)
Const PRTONSAVE_INDEXFORM = 2       '保存時印刷(送付案内)

Const IGNORE_EXCEPT_NO_RSVFRA = "1" '予約枠無視権限(枠なしの日付を除く強制予約が可能)
Const IGNORE_ANY              = "2" '予約枠無視権限(あらゆる強制予約が可能)

'データベースアクセス用オブジェクト
Dim objCommon           '共通クラス

'引数値(web予約情報の主キー)
Dim dtmCslDate          '受診年月日
Dim lngWebNo            'webNo.
Dim lngCRsvNo           'web予約登録時マッチングされたHains予約情報の予約番号（キャンセル対象）

'引数値(処理用)
Dim blnSave             '保存の要否
Dim blnNext             '次予約情報表示の要否
Dim lngIgnoreFlg        '強制登録フラグ
Dim blnSaved            '保存完了フラグ

'引数値(次予約情報検索用)
Dim dtmStrCslDate       '開始受診年月日
Dim dtmEndCslDate       '終了受診年月日
Dim strKey              '検索キー
Dim dtmStrOpDate        '開始処理年月日
Dim dtmEndOpDate        '終了処理年月日
Dim lngOpMode           '処理モード(1:申込日で検索、2:予約処理日で検索)
Dim lngRegFlg           '本登録フラグ(0:指定なし、1:未登録者、2:編集済み受診者)
Dim lngOrder            '出力順(1:受診日順、2:個人ID順)
'#### 2010.10.28 SL-UI-Y0101-108 ADD START ####'
Dim lngMosFlg		'申込区分(0:指定なし、1:新規、2:キャンセル)
'#### 2010.10.28 SL-UI-Y0101-108 ADD END ####'

'引数値(web予約情報、受診情報共通)
Dim strCsCd             'コースコード
Dim strRsvGrpCd         '予約群コード
Dim strPerId            '個人ID
Dim strLastName         '姓
Dim strFirstName        '名
Dim strLastKName        'カナ姓
Dim strFirstKName       'カナ名
Dim strGender           '性別
Dim strBirth            '生年月日

'引数値(web予約情報)
Dim strOptionStomac     '胃検査(0:胃なし、1:胃X線、2:胃内視鏡)
Dim strOptionBreast     '乳房検査(0:乳房なし、1:乳房X線、2:乳房超音波、3:乳房X線＋乳房超音波)
'#### 2013.3.11 SL-SN-Y0101-612 ADD START ####
Dim strCslOptions		'受診オプション
'#### 2013.3.11 SL-SN-Y0101-612 ADD END   ####

'引数値(受診情報)
Dim strOrgCd1           '団体コード1
Dim strOrgCd2           '団体コード2
Dim strOrgName          '団体名称
Dim strAge              '受診時年齢
Dim strCslDivCd         '受診区分コード
Dim strCtrPtCd          '契約パターンコード

'引数値(個人情報)
Dim strRomeName         'ローマ字名
Dim strZipCd            '郵便番号
Dim strPrefCd           '都道府県コード
Dim strPrefName         '都道府県名
Dim strCityName         '市区町村名
Dim strAddress1         '住所１
Dim strAddress2         '住所２
Dim strTel1             '電話番号1
Dim strPhone            '携帯番号
Dim strTel2             '電話番号2
Dim strExtension        '内線
Dim strFax              'FAX
Dim strEMail            'e-Mail
Dim strNationCd         '国籍コード
Dim strNationName       '国籍名

'引数値(受診付属情報)
Dim strRsvStatus        '予約状況
Dim strPrtOnSave        '保存時印刷
Dim strCardAddrDiv      '確認はがき宛先
Dim strCardOutEng       '確認はがき英文出力
Dim strFormAddrDiv      '一式書式宛先
Dim strFormOutEng       '一式書式英文出力
Dim strReportAddrDiv    '成績書宛先
Dim strReportOutEng     '成績書英文出力
Dim strVolunteer        'ボランティア
Dim strVolunteerName    'ボランティア名
Dim strCollectTicket    '利用券回収
Dim strIssueCslTicket   '診察券発行
Dim strBillPrint        '請求書出力
Dim strIsrSign          '保険証記号
Dim strIsrNo            '保険証番号
Dim strIsrManNo         '保険者番号
Dim strEmpNo            '社員番号
Dim strIntroductor      '紹介者
Dim strLastCslDate      '前回受診日

'引数値(オプション)
Dim strOptCd            'オプションコード
Dim strOptBranchNo      'オプション枝番

'web予約情報(初期表示時のみしか使用しない項目)
Dim strRegFlg           '本登録フラグ(1:未登録者、2:編集済み受診者)
Dim strRsvNo            '予約番号

'受診情報(初期表示時のみしか使用しない項目)
Dim strCancelFlg        'キャンセルフラグ
Dim strCslDate          '受診年月日
Dim strCardPrintDate    '確認はがき出力日時
Dim strFormPrintDate    '一式書式出力日時

'web予約住所情報(新規申し込み者のデフォルト値となる)
Dim strDefZipNo         '郵便番号
Dim strDefAddress1      '住所1
Dim strDefAddress2      '住所2
Dim strDefAddress3      '住所3
Dim strDefTel           '電話番号
Dim strDefEMail         'e-mail
Dim strDefOfficeTel     '勤務先電話番号

Dim dtmNextCslDate      '次web予約情報の受診年月日
Dim lngNextWebNo        '次web予約情報のwebNo.
Dim strMessage          'メッセージ
Dim strMessage2         'メッセージ2
Dim Ret                 '関数戻り値
Dim i                   'インデックス

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得(web予約情報の主キー)
dtmCslDate      = CDate(Request("cslDate"))
lngWebNo        = CLng("0" & Request("webNo"))
lngCRsvNo       = CLng("0" & Request("cRsvNo"))

'引数値の取得(処理用)
blnSave         = (Request("save")  <> "")
blnNext         = (Request("next")  <> "")
lngIgnoreFlg    = CLng("0" & Request("ignore"))
blnSaved        = (Request("saved") <> "")

'引数値の取得(次予約情報検索用)
dtmStrCslDate   = Request("strCslDate")
dtmEndCslDate   = Request("endCslDate")
strKey          = Request("key")
dtmStrOpDate    = CDate("0" & Request("strOpDate"))
dtmEndOpDate    = CDate("0" & Request("endOpDate"))
lngOpMode       = CLng("0" & Request("opMode"))
lngRegFlg       = CLng("0" & Request("regFlg"))
lngOrder        = CLng("0" & Request("order"))
'#### 2010.10.28 SL-UI-Y0101-108 ADD START ####'
'申込区分の入力がなければ1:新規をデフォルトに
lngMosFlg      = IIf(Request("mousi") = "", 1, CLng("0" & Request("mousi")))
'#### 2010.10.28 SL-UI-Y0101-108 ADD END ####'

'引数値(web予約情報、受診情報共通)
strCsCd         = Request("csCd")
strRsvGrpCd     = Request("rsvGrpCd")
strPerId        = Request("perId")
strLastName     = Request("lastName")
strFirstName    = Request("firstName")
strLastKName    = Request("lastKName")
strFirstKName   = Request("firstKName")
strGender       = Request("gender")
strBirth        = Request("birth")

'引数値の取得(web予約情報)
strOptionStomac = Request("stomac")
strOptionBreast = Request("breast")
'#### 2013.3.11 SL-SN-Y0101-612 ADD START ####
strCslOptions = Request("csloptions")
'#### 2013.3.11 SL-SN-Y0101-612 ADD END   ####

'引数値の取得(受診情報)
strOrgCd1       = Request("orgCd1")
strOrgCd2       = Request("orgCd2")
strOrgName      = Request("orgName")
strAge          = Request("age")
strCslDivCd     = Request("cslDivCd")
strCtrPtCd      = Request("ctrPtCd")

'引数値(個人情報)
strRomeName     = Request("romeName")
strZipCd        = ConvIStringToArray(Request("zipCd"))
strPrefCd       = ConvIStringToArray(Request("prefCd"))
strPrefName     = ConvIStringToArray(Request("prefName"))
strCityName     = ConvIStringToArray(Request("cityName"))
strAddress1     = ConvIStringToArray(Request("address1"))
strAddress2     = ConvIStringToArray(Request("address2"))
strTel1         = ConvIStringToArray(Request("tel1"))
strPhone        = ConvIStringToArray(Request("phone"))
strTel2         = ConvIStringToArray(Request("tel2"))
strExtension    = ConvIStringToArray(Request("extension"))
strFax          = ConvIStringToArray(Request("fax"))
strEMail        = ConvIStringToArray(Request("eMail"))
strNationCd     = Request("nationCd")
strNationName   = Request("nationName")

'引数値の取得(受診付属情報)
strRsvStatus      = Request("rsvStatus")
strPrtOnSave      = Request("prtOnSave")
strCardAddrDiv    = Request("cardAddrDiv")
strCardOutEng     = Request("cardOutEng")
strFormAddrDiv    = Request("formAddrDiv")
strFormOutEng     = Request("formOutEng")
strReportAddrDiv  = Request("reportAddrDiv")
strReportOutEng   = Request("reportOutEng")
strVolunteer      = Request("volunteer")
strVolunteerName  = Request("volunteerName")
strCollectTicket  = Request("collectTicket")
strIssueCslTicket = Request("issueCslTicket")
strBillPrint      = Request("billPrint")
strIsrSign        = Request("isrSign")
strIsrNo          = Request("isrNo")
strIsrManNo       = Request("isrManNo")
strEmpNo          = Request("empNo")
strIntroductor    = Request("introductor")
strLastCslDate    = Request("lastCslDate")

'引数値の取得(オプション)
strOptCd        = Request("optCd")
strOptBranchNo  = Request("optBNo")

'チェック・更新・読み込み処理の制御
Do

    '何らかの処理を行う場合
     If blnSave Or blnNext Then

        '編集用の受診日はキー値のそれとする
        strCslDate = CStr(dtmCslDate)

        '次web予約情報のキー取得
        If blnNext Then
            SelectWebOrgRsvNext dtmCslDate, lngWebNo, dtmNextCslDate, lngNextWebNo
        Else
            dtmNextCslDate = dtmCslDate
            lngNextWebNo   = lngWebNo
        End If

        '保存を行う場合
        If blnSave Then

            '近い受診日で健診歴がある場合のワーニング対応
            If strPerId <> "" And lngIgnoreFlg = 0 Then
                strMessage = RecentConsult_CheckRecentConsult(strPerId, dtmCslDate, strCsCd, "")
                If strMessage <> "" Then
                    Exit Do
                End If
            End If

            'キャンセル対象予約情報存在有無をチェックし、キャンセル処理を先行
            Ret = Cancel()

            'web予約情報の登録
            Ret = Regist()
            If Ret <= 0 Then
                'web予約情報登録時、エラーが発生して正常に登録されなかった場合、
                'キャンセルした枠取り分の予約情報を復活する
                Ret = Restore()
                Exit Do
            End If

        End If

        'ページ遷移
        Response.Write CreateHTMLForControlAfterSaved(Ret, dtmNextCslDate, lngNextWebNo)
        Response.End

    End If

    'web予約情報読み込み
    SelectWebOrgRsv dtmCslDate, lngWebNo

    '未登録者、または編集済み受診者で予約番号を持たない場合
    If strRegFlg = REGFLG_UNREGIST Or (strRegFlg = REGFLG_REGIST And strRsvNo = "") Then

        '編集用の受診日はキー値のそれとする
        strCslDate = CStr(dtmCslDate)

        '受診付属情報のデフォルト値編集
        SetDefaultPersonalInfo dtmCslDate, strPerId

    '編集済みでかつ予約番号を持つ場合
    Else

        '受診情報読み込み
        SelectConsult CLng(strRsvNo)

    End If

    '個人住所情報格納域の初期化
    InitializePerAddr

    If strPerId = "" Then

        '個人IDが存在しない場合はweb予約情報の住所を個人住所情報のデフォルト値として適用する
        SetDefaultPerAddr

    Else

        '個人ID存在時は、個人情報の不足分(ローマ字名)と住所情報とを読む
        SelectPerson strPerId

    End If

    Exit Do
Loop

'-------------------------------------------------------------------------------
'
' 機能　　 : web予約情報に指定されているHains予約情報キャンセル
'
' 引数　　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function Cancel()

    Dim objConsult          '受診情報アクセス用
    Dim objWebOrgRsv        'web予約情報アクセス用
    Dim Ret                 '関数戻り値
    Dim RetBl               '関数戻り値

    'オブジェクトのインスタンス作成
    Set objConsult = Server.CreateObject("HainsConsult.Consult")
    Set objWebOrgRsv = Server.CreateObject("HainsWebOrgRsv.WebOrgRsv")

    'web予約情報編集時、キャンセル対象者予約情報有無チェック
    RetBl = objWebOrgRsv.SelectConsultCheck(lngCRsvNo, strOrgCd1, strOrgCd2)

    if RetBl = True Then
        'web予約時設定された予約情報キャンセル
        'キャンセル理由(固定）：院内都合(臨時）、問診結果が登録された場合、キャンセル処理をしない
        Ret = objConsult.CancelConsult(lngCRsvNo, Session("USERID"), CANCEL_FIX, strMessage, False)
    Else
        Ret = 0
    End If

    '戻り値の編集
    Cancel = Ret

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : キャンセルした枠取り予約情報を復元する
'
' 引数　　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function Restore()

    Dim objConsult          '受診情報アクセス用
    Dim objWebOrgRsv        'web予約情報アクセス用
    Dim Ret                 '関数戻り値

    'オブジェクトのインスタンス作成
    Set objConsult = Server.CreateObject("HainsConsult.Consult")

    '復元処理（予約枠を無視し強制復元）
    Ret = objConsult.RestoreConsult(lngCRsvNo, Session("USERID"), strMessage2, 2)
    If Ret <= 0 Then
'        strArrMessage = Array(strMessage2)
    End If

    '戻り値の編集
    Restore = Ret

End Function

'-------------------------------------------------------------------------------
'
' 機能　　 : web予約情報の登録
'
' 引数　　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function Regist()

    Dim objWebOrgRsv        'web予約情報アクセス用
    Dim strAddrDiv          '住所区分
    Dim strWkOptCd          'オプションコード
    Dim strWkOptBranchNo    'オプション枝番
    Dim Ret                 '関数戻り値

    'オブジェクトのインスタンス作成
    Set objWebOrgRsv = Server.CreateObject("HainsWebOrgRsv.WebOrgRsv")

    '住所区分の配列を作成
    strAddrDiv = Array("1", "2", "3")

    'オプションの配列化
    strWkOptCd       = Split(strOptCd,       ",")
    strWkOptBranchNo = Split(strOptBranchNo, ",")

    Ret = objWebOrgRsv.Regist(      _
              dtmCslDate,        _
              lngWebNo,          _
              Session("USERID"), _
              strCsCd,           _
              strRsvGrpCd,       _
              strPerId,          _
              strLastName,       _
              strFirstName,      _
              strLastKName,      _
              strFirstKName,     _
              strGender,         _
              strBirth,          _
              strOrgCd1,         _
              strOrgCd2,         _
              strAge,            _
              strCslDivCd,       _
              strCtrPtCd,        _
              strRomeName,       _
              strNationCd,       _
              strAddrDiv,        _
              strZipCd,          _
              strPrefCd,         _
              strCityName,       _
              strAddress1,       _
              strAddress2,       _
              strTel1,           _
              strPhone,          _
              strEMail,          _
              strRsvStatus,      _
              strPrtOnSave,      _
              strCardAddrDiv,    _
              strCardOutEng,     _
              strFormAddrDiv,    _
              strFormOutEng,     _
              strReportAddrDiv,  _
              strReportOutEng,   _
              strVolunteer,      _
              strVolunteerName,  _
              strCollectTicket,  _
              strIssueCslTicket, _
              strBillPrint,      _
              strIsrSign,        _
              strIsrNo,          _
              strIsrManNo,       _
              strEmpNo,          _
              strIntroductor,    _
              strWkOptCd,        _
              strWkOptBranchNo,  _
              lngIgnoreFlg,      _
              strMessage         _
          )

    '戻り値の編集
    Regist = Ret

End Function
'-------------------------------------------------------------------------------
'
' 機能　　 : web予約情報読み込み
'
' 引数　　 : (In)     dtmParaCslDate  受診年月日
' 　　　　   (In)     lngParaWebNo    webNo.
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub SelectWebOrgRsv(dtmParaCslDate, lngParaWebNo)

    Dim objWebOrgRsv    'web予約情報アクセス用
    Dim strFullName     '姓名
    Dim strKanaName     'カナ姓名

    'オブジェクトのインスタンス作成
    Set objWebOrgRsv = Server.CreateObject("HainsWebOrgRsv.WebOrgRsv")

    'web予約情報読み込み
'#### 2013.3.11 SL-SN-Y0101-612 UPD START ####
'	'#### 2010.08.06 SL-UI-Y0101-108 MOD START ####
'	'※CanDateの対応で、RsvNoの前にカンマ１つ追加
'	'objWebOrgRsv.SelectWebOrgRsv dtmParaCslDate,  _
'	'                             lngParaWebNo,    _
'	'                             strRegFlg,       _
'	'                             strCsCd,         _
'	'                             strRsvGrpCd,     _
'	'                             strPerId,        _
'	'                             strFullName,     _
'	'                             strKanaName,     _
'	'                             strRomeName,     _
'	'                             strLastName,     _
'	'                             strFirstName,    _
'	'                             strLastKName,    _
'	'                             strFirstKName,   _
'	'                             strGender,       _
'	'                             strBirth,        _
'	'                             strDefZipNo,     _
'	'                             strDefAddress1,  _
'	'                             strDefAddress2,  _
'	'                             strDefAddress3,  _
'	'                             strDefTel,       _
'	'                             strDefEMail,     _
'	'                             ,                _
'	'                             strDefOfficeTel, _
'	'                             strOrgCd1,       _
'	'                             strOrgCd2,       _
'	'                             strOrgName, ,    _
'	'                             strOptionStomac, _
'	'                             strOptionBreast, _
'	'                             , , ,            _
'	'                             strRsvNo,        _
'	'                             strIsrSign,      _
'	'                             strIsrNo,        _
'	'                             strVolunteer,    _
'	'                             strCardOutEng,   _
'	'                             strFormOutEng,   _
'	'                             strReportOutEng, _
'	'                             lngCRsvNo, _
'	'                             strNationName
'	objWebOrgRsv.SelectWebOrgRsv dtmParaCslDate,  _
'	                             lngParaWebNo,    _
'	                             strRegFlg,       _
'	                             strCsCd,         _
'	                             strRsvGrpCd,     _
'	                             strPerId,        _
'	                             strFullName,     _
'	                             strKanaName,     _
'	                             strRomeName,     _
'	                             strLastName,     _
'	                             strFirstName,    _
'	                             strLastKName,    _
'	                             strFirstKName,   _
'	                             strGender,       _
'	                             strBirth,        _
'	                             strDefZipNo,     _
'	                             strDefAddress1,  _
'	                             strDefAddress2,  _
'	                             strDefAddress3,  _
'	                             strDefTel,       _
'	                             strDefEMail,     _
'	                             ,                _
'	                             strDefOfficeTel, _
'	                             strOrgCd1,       _
'	                             strOrgCd2,       _
'	                             strOrgName, ,    _
'	                             strOptionStomac, _
'	                             strOptionBreast, _
'	                             , , , ,          _
'	                             strRsvNo,        _
'	                             strIsrSign,      _
'	                             strIsrNo,        _
'	                             strVolunteer,    _
'	                             strCardOutEng,   _
'	                             strFormOutEng,   _
'	                             strReportOutEng, _
'	                             lngCRsvNo, _
'	                             strNationName
'	'#### 2010.08.06 SL-UI-Y0101-108 MOD END ####
    objWebOrgRsv.SelectWebOrgRsv dtmParaCslDate,  _
                                 lngParaWebNo,    _
                                 strRegFlg,       _
                                 strCsCd,         _
                                 strRsvGrpCd,     _
                                 strPerId,        _
                                 strFullName,     _
                                 strKanaName,     _
                                 strRomeName,     _
                                 strLastName,     _
                                 strFirstName,    _
                                 strLastKName,    _
                                 strFirstKName,   _
                                 strGender,       _
                                 strBirth,        _
                                 strDefZipNo,     _
                                 strDefAddress1,  _
                                 strDefAddress2,  _
                                 strDefAddress3,  _
                                 strDefTel,       _
                                 strDefEMail,     _
                                 ,                _
                                 strDefOfficeTel, _
                                 strOrgCd1,       _
                                 strOrgCd2,       _
                                 strOrgName, ,    _
                                 strOptionStomac, _
                                 strOptionBreast, _
                                 , , , ,          _
                                 strRsvNo,        _
                                 strIsrSign,      _
                                 strIsrNo,        _
                                 strVolunteer,    _
                                 strCardOutEng,   _
                                 strFormOutEng,   _
                                 strReportOutEng, _
                                 lngCRsvNo,       _
                                 strNationName,   _
                                 strCslOptions
'#### 2013.3.11 SL-SN-Y0101-612 UPD END   ####

    '個人IDが存在する場合
    If strPerId <> "" Then

        If strLastName = "" And strFirstName = "" Then
            SplitName strFullName, strLastName,  strFirstName
        End If

        If strLastKName = "" And strFirstKName = "" Then
            SplitName strKanaName, strLastKName, strFirstKName
        End If

    '個人IDが存在しない場合
    Else

        SplitName strFullName, strLastName,  strFirstName
        SplitName strKanaName, strLastKName, strFirstKName

    End If

End Sub
'-------------------------------------------------------------------------------
'
' 機能　　 : 姓名分割
'
' 引数　　 : (In)     strParaName      姓名
' 　　　　   (Out)    strParaLastName  姓
' 　　　　   (Out)    strParaLastName  名
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub SplitName(strParaName, strParaLastName, strParaFirstName)

    Dim lngPos  '空白検索位置

    strParaLastName  = ""
    strParaFirstName = ""

    '最初の空白を検索
    lngPos = InStr(1, strParaName, "　")

    'あれば分割、なければ姓にセット
    If lngPos > 0 Then
        strParaLastName  = Trim(Left(strParaName, lngPos))
        strParaFirstName = Trim(Right(strParaName, Len(strParaName) - lngPos))
    Else
        strParaLastName = strParaName
    End If

End Sub
'-------------------------------------------------------------------------------
'
' 機能　　 : 受診情報読み込み
'
' 引数　　 : (In)     lngParaRsvNo  予約番号
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub SelectConsult(lngParaRsvNo)

    Dim objConsult          '受診情報アクセス用
    Dim strWkOptCd          'オプションコード
    Dim strWkOptBranchNo    'オプション枝番

    'オブジェクトのインスタンス作成
    Set objConsult = Server.CreateObject("HainsConsult.Consult")

    '受診情報読み込み
    objConsult.SelectConsult lngParaRsvNo, strCancelFlg, strCslDate, strPerId, strCsCd, , strOrgCd1, strOrgCd2, strOrgName, , , strAge, , , , , , , , , , , , , , , , , , , , , , , , , , , , , _
                             strCtrPtCd, , strLastName, strFirstName, strLastKName, strFirstKName, strBirth, strGender, , , , , strCslDivCd, strRsvGrpCd


    '受診付属情報読み込み
    objConsult.SelectConsultDetail lngParaRsvNo,      strRsvStatus,     strPrtOnSave,   _
                                   strCardAddrDiv,    strCardOutEng,    strFormAddrDiv, _
                                   strFormOutEng,     strReportAddrDiv, strReportOutEng, _
                                   strVolunteer,      strVolunteerName, strCollectTicket, _
                                   strIssueCslTicket, strBillPrint,     strIsrSign, _
                                   strIsrNo,          strIsrManNo,      strEmpNo, _
                                   strIntroductor, ,  strLastCslDate

    '印刷日の読み込み
    objConsult.SelectConsultPrintStatus lngParaRsvNo, strCardPrintDate, strFormPrintDate

    '受診オプションの読み込み
    objConsult.SelectConsult_O lngParaRsvNo, strWkOptCd, strWkOptBranchNo
    strOptCd       = Join(strWkOptCd, ",")
    strOptBranchNo = Join(strWkOptBranchNo, ",")

    '保存時印刷の制御
    strPrtOnSave = CStr(ControlPrtOnSave(CDate(strCslDate), False))

End Sub
'-------------------------------------------------------------------------------
'
' 機能　　 : 受診付属情報の初期値編集
'
' 引数　　 : (In)     dtmParaCslDate  受診年月日
' 　　　　   (In)     strParaPerId    個人ID
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub SetDefaultPersonalInfo(dtmParaCslDate, strParaPerId)

    '予約状況は個人IDが存在すれば確定、なければ保留(ない場合、保存時に仮IDで作成されるため)
    strRsvStatus = IIf(strParaPerId <> "", "0", "1")

    '保存時印刷の制御
    strPrtOnSave = CStr(ControlPrtOnSave(dtmParaCslDate, True))

    '郵送あて先は「住所(自宅)」をデフォルトで設定
    strCardAddrDiv    = "1"
    strFormAddrDiv    = "1"
    strReportAddrDiv  = "1"

    '診察券発行は個人IDが存在すれば既存、なければ新規(ない場合、保存時に仮IDで作成されるため)
    strIssueCslTicket = IIf(strParaPerId <> "", "2", "1")

End Sub
'-------------------------------------------------------------------------------
'
' 機能　　 : 個人情報の初期値編集
'
' 引数　　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub SetDefaultPerAddr()

    '自宅情報のデフォルト値編集
    strZipCd(0)    = strDefZipNo
    strCityName(0) = strDefAddress1
    strAddress1(0) = strDefAddress2
    strAddress2(0) = strDefAddress3
    strTel1(0)     = strDefTel
    strEMail(0)    = strDefEMail

    '勤務先情報のデフォルト値編集
    strTel1(1) = strDefOfficeTel

End Sub
'-------------------------------------------------------------------------------
'
' 機能　　 : 保存時印刷制御
'
' 引数　　 : (In)     dtmParaCslDate  受診年月日
' 　　　　   (In)     blnParaNew      新規フラグ(True:新規、False:登録済み)
'
' 戻り値　 : 保存時印刷の値
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function ControlPrtOnSave(dtmParaCslDate, blnParaNew)

    Dim objFree             '汎用情報アクセス用
    Dim strLastFormCslDate  '送付案内最新出力受診日
    Dim dtmLastFormCslDate  '送付案内最新出力受診日
    Dim Ret                 '関数戻り値

    'オブジェクトのインスタンス作成
    Set objFree = Server.CreateObject("HainsFree.Free")

    '送付案内最新出力受診日の読み込み
    objFree.SelectFree 0, FREECD_RSVINTERVAL, , , strLastFormCslDate

    '日付比較を行うため、Date型に変換
    dtmLastFormCslDate = CDate(strLastFormCslDate)

    Do

        '新規の場合、受診日が送付案内出力最新受診日より未来ならはがき出力、さもなくば送付案内を出力
        If blnParaNew Then
            Ret = IIf(dtmParaCslDate > dtmLastFormCslDate, PRTONSAVE_INDEXCARD, PRTONSAVE_INDEXFORM)
            Exit Do
        End If

        '更新時の制御ロジック

        '(1)はがき、送付案内共に未出力の場合、受診日の状態に関わらず新規の場合と同じ
        If strCardPrintDate = "" And strFormPrintDate = "" Then
            Ret = IIf(dtmParaCslDate > dtmLastFormCslDate, PRTONSAVE_INDEXCARD, PRTONSAVE_INDEXFORM)
            Exit Do
        End If

        '(2)はがきのみ出力済みの場合
        If strCardPrintDate <> "" And strFormPrintDate = "" Then

            '受診日が送付案内出力最新受診日より未来ならなし
            If dtmParaCslDate > dtmLastFormCslDate Then
                Ret = PRTONSAVE_INDEXNONE
                Exit Do
            End If

            'さもなくば送付案内
            Ret = PRTONSAVE_INDEXFORM

            Exit Do
        End If

        '(3)送付案内のみ出力済みの場合、または(4)両方とも出力済みの場合(即ち送付案内出力済みの場合)はなしとする
        Ret = PRTONSAVE_INDEXNONE
        Exit Do
    Loop

    '戻り値の設定
    ControlPrtOnSave = Ret

End Function
'-------------------------------------------------------------------------------
'
' 機能　　 : 次web予約情報のキー取得
'
' 引数　　 : (In)     dtmParaCslDate      受診年月日
' 　　　　   (In)     lngParaWebNo        webNo.
' 　　　　   (Out)    dtmParaNextCslDate  (次web予約情報の)受診年月日
' 　　　　   (Out)    lngParaNextWebNo    (次web予約情報の)webNo.
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub SelectWebOrgRsvNext(dtmParaCslDate, lngParaWebNo, dtmParaNextCslDate, lngParaNextWebNo)

    Dim objWebOrgRsv        'web予約情報アクセス用
    Dim strNextCslDate      '次web予約情報の受診年月日
    Dim strNextWebNo        '次web予約情報のwebNo.
    Dim Ret                 '関数戻り値

    '現web予約情報のキーを次web予約情報のデフォルトキーとして設定
    dtmParaNextCslDate = dtmParaCslDate
    lngParaNextWebNo   = lngParaWebNo

    'オブジェクトのインスタンス作成
    Set objWebOrgRsv = Server.CreateObject("HainsWebOrgRsv.WebOrgRsv")

    'web予約情報を読み、次キーを求める
'#### 2010.10.28 SL-UI-Y0101-107 MOD START ####'
    'Ret = objWebOrgRsv.SelectWebOrgRsvNext( _
    '          dtmStrCslDate,          _
    '          dtmEndCslDate,          _
    '          strKey,                 _
    '          dtmStrOpDate,           _
    '          dtmEndOpDate,           _
    '          strOrgCd1,              _
    '          strOrgCd2,              _
    '          lngOpMode,              _
    '          lngRegFlg,              _
    '          lngOrder,               _
    '          dtmParaCslDate,         _
    '          lngParaWebNo,           _
    '          strNextCslDate,         _
    '          strNextWebNo            _
    '      )
    Ret = objWebOrgRsv.SelectWebOrgRsvNext( _
              dtmStrCslDate,          _
              dtmEndCslDate,          _
              strKey,                 _
              dtmStrOpDate,           _
              dtmEndOpDate,           _
              strOrgCd1,              _
              strOrgCd2,              _
              lngOpMode,              _
              lngRegFlg,              _
              lngMosFlg,              _
              lngOrder,               _
              dtmParaCslDate,         _
              lngParaWebNo,           _
              strNextCslDate,         _
              strNextWebNo            _
          )
'#### 2010.10.28 SL-UI-Y0101-107 MOD END ####'

    'オブジェクトの解放
    Set objWebOrgRsv = Nothing

    '次キー存在時は値を更新
    If Ret = True Then
        dtmParaNextCslDate = CDate(strNextCslDate)
        lngParaNextWebNo   = CLng(strNextWebNo)
    End If

End Sub
'-------------------------------------------------------------------------------
'
' 機能　　 : 保存後ページ制御
'
' 引数　　 : (In)     lngParaRsvNo        予約番号
' 　　　　   (In)     dtmParaNextCslDate  (次web予約情報の)受診年月日
' 　　　　   (In)     lngParaNextWebNo    (次web予約情報の)webNo.
'
' 戻り値　 : HTML文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CreateHTMLForControlAfterSaved(lngParaRsvNo, dtmParaNextCslDate, lngParaNextWebNo)

    Dim strHTML     'HTML文字列
    Dim strURL      'ジャンプ先のURL

    'HTMLの編集開始
    strHTML = "<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.01 Transitional//EN"">"
strHTML = strHTML & vbCrLf & "<HTML lang=""ja"">"
    strHTML = strHTML & vbCrLf & "<SCRIPT TYPE=""text/javascript"">"
    strHTML = strHTML & vbCrLf & "<!--"

    '印刷制御
    Do

        '保存時でなければ不要
        If Not blnSave Then
            Exit Do
        End If

        '予約状況が保留ならば不要
        '#### 2007/04/04 張 予約状況区分追加のため修正 Start ####
        'If strRsvStatus = "1" Then
        If strRsvStatus = "1" or strRsvStatus = "2" Then
        '#### 2007/04/04 張 予約状況区分追加のため修正 End   ####
            
            Exit Do
        End If

        '印刷用メソッドの実装
        Select Case strPrtOnSave
            Case "1"
                strHTML = strHTML & vbCrLf & "top.showPrintCardDialog('" & lngParaRsvNo & "','0','" & strCardAddrDiv & "','" & strCardOutEng & "');"
            Case "2"
                strHTML = strHTML & vbCrLf & "top.showPrintFormDialog('" & lngParaRsvNo & "','0','" & strFormAddrDiv & "','" & strFormOutEng & "');"
        End Select

        Exit Do
    Loop

    'URLの編集
    strURL = "webOrgRsvMain.asp"
    strURL = strURL & "?cslDate="    & dtmParaNextCslDate
    strURL = strURL & "&webNo="      & lngParaNextWebNo
    strURL = strURL & "&strCslDate=" & dtmStrCslDate
    strURL = strURL & "&endCslDate=" & dtmEndCslDate
    strURL = strURL & "&key="        & strKey
    strURL = strURL & "&strOpDate="  & IIf(dtmStrOpDate > 0, dtmStrOpDate, "")
    strURL = strURL & "&endOpDate="  & IIf(dtmEndOpDate > 0, dtmEndOpDate, "")
    strURL = strURL & "&orgCd1="     & strOrgCd1
    strURL = strURL & "&orgCd2="     & strOrgCd2
    strURL = strURL & "&opMode="     & lngOpMode
    strURL = strURL & "&regFlg="     & lngRegFlg
    strURL = strURL & "&order="      & lngOrder
'#### 2010.10.28 SL-UI-Y0101-108 MOD START ####'
	strURL = strURL & "&mousi="      & lngMosFlg
'#### 2010.10.28 SL-UI-Y0101-108 MOD END ####'

    '「確定」ボタン押下時は保存完了フラグ成立
    If Not blnNext Then
        strURL = strURL & "&saved=1"
    End If

    '作成したURLで親フレームをreplace
    strHTML = strHTML & vbCrLf & "top.location.replace('" & strURL & "');"
    strHTML = strHTML & vbCrLf & "//-->"
    strHTML = strHTML & vbCrLf & "</SCRIPT>"
    strHTML = strHTML & vbCrLf & "</HTML>"

    '戻り値の設定
    CreateHTMLForControlAfterSaved = strHTML

End Function
'-------------------------------------------------------------------------------
'
' 機能　　 : 個人住所情報格納域の初期化
'
' 引数　　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub InitializePerAddr()

    '住所情報格納用変数を配列として初期化
    strZipCd     = Array()
    strPrefCd    = Array()
    strPrefName  = Array()
    strCityName  = Array()
    strAddress1  = Array()
    strAddress2  = Array()
    strTel1      = Array()
    strPhone     = Array()
    strTel2      = Array()
    strExtension = Array()
    strFax       = Array()
    strEMail     = Array()

    '自宅、勤務先、その他の３住所情報を格納するため、配列を拡張
    ReDim Preserve strZipCd(2)
    ReDim Preserve strPrefCd(2)
    ReDim Preserve strPrefName(2)
    ReDim Preserve strCityName(2)
    ReDim Preserve strAddress1(2)
    ReDim Preserve strAddress2(2)
    ReDim Preserve strTel1(2)
    ReDim Preserve strPhone(2)
    ReDim Preserve strTel2(2)
    ReDim Preserve strExtension(2)
    ReDim Preserve strFax(2)
    ReDim Preserve strEMail(2)

End Sub
'-------------------------------------------------------------------------------
'
' 機能　　 : 個人情報読み込み
'
' 引数　　 : (In)     strParaPerId  個人ID
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub SelectPerson(strParaPerId)

    Dim objPerson       '個人情報アクセス用

    Dim strArrAddrDiv   '住所区分
    Dim strArrZipCd     '郵便番号
    Dim strArrPrefCd    '都道府県コード
    Dim strArrPrefName  '都道府県名
    Dim strArrCityName  '市区町村名
    Dim strArrAddress1  '住所１
    Dim strArrAddress2  '住所２
    Dim strArrTel1      '電話番号1
    Dim strArrPhone     '携帯番号
    Dim strArrTel2      '電話番号2
    Dim strArrExtension '内線
    Dim strArrFax       'FAX
    Dim strArrEMail     'e-Mail
    Dim lngCount        '住所情報数

    Dim lngIndex        '格納用のインデックス
    Dim i               'インデックス

    'オブジェクトのインスタンス作成
    Set objPerson = Server.CreateObject("HainsPerson.Person")

    '個人情報読み込み
    objPerson.SelectPerson_lukes strPerId, , , , , strRomeName, , , , , strNationCd 

    '個人住所情報読み込み
    lngCount = objPerson.SelectPersonAddr( _
        strParaPerId,                      _
        strArrAddrDiv,                     _
        strArrZipCd,                       _
        strArrPrefCd,                      _
        strArrPrefName,                    _
        strArrCityName,                    _
        strArrAddress1,                    _
        strArrAddress2,                    _
        strArrTel1,                        _
        strArrPhone,                       _
        strArrTel2,                        _
        strArrExtension,                   _
        strArrFax,                         _
        strArrEMail                        _
    )

    'オブジェクトの解放
    Set objPerson = Nothing

    '読み込んだ住所情報を検索
    For i = 0 To lngCount - 1

        '住所区分値をもとに格納先のインデックスを定義
        Select Case strArrAddrDiv(i)
            Case "1"
                lngIndex = 0
            Case "2"
                lngIndex = 1
            Case "3"
                lngIndex = 2
            Case Else
                lngIndex = -1
        End Select

        '読み込んだ住所情報を格納用変数へ
        If lngIndex >= 0 Then
            strZipCd(lngIndex)     = strArrZipCd(i)
            strPrefCd(lngIndex)    = strArrPrefCd(i)
            strPrefName(lngIndex)  = strArrPrefName(i)
            strCityName(lngIndex)  = strArrCityName(i)
            strAddress1(lngIndex)  = strArrAddress1(i)
            strAddress2(lngIndex)  = strArrAddress2(i)
            strTel1(lngIndex)      = strArrTel1(i)
            strPhone(lngIndex)     = strArrPhone(i)
            strTel2(lngIndex)      = strArrTel2(i)
            strExtension(lngIndex) = strArrExtension(i)
            strFax(lngIndex)       = strArrFax(i)
            strEMail(lngIndex)     = strArrEMail(i)
        End If

    Next

End Sub
'-------------------------------------------------------------------------------
'
' 機能　　 : 実年齢計算
'
' 引数　　 : (In)     dtmParaBirth    生年月日
' 　　　　   (In)     dtmParaCslDate  受診年月日
'
' 戻り値　 : 受診日時点での年齢
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function CalcRealAge(dtmParaBirth, dtmParaCslDate)

    Dim objFree     '汎用情報アクセス用
    Dim strRealAge  '受診日時点での実年齢

    'オブジェクトのインスタンス作成
    Set objFree = Server.CreateObject("HainsFree.Free")

    '実年齢の計算
    strRealAge = objFree.CalcAge(dtmParaBirth, dtmParaCslDate)

    '小数点以下の除去
    If InStr(strRealAge, ".") > 0 Then
        strRealAge = Left(strRealAge, InStr(strRealAge, ".") - 1)
    End If

    '戻り値の設定
    CalcRealAge = strRealAge

End Function
'-------------------------------------------------------------------------------
'
' 機能　　 : 予約群セレクションボックスの編集
'
' 引数　　 : (In)     strParaRsvGrpCd  選択すべき予約群コード
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub EditRsvGrpList(strParaRsvGrpCd)

    Dim objSchedule         'スケジュール情報アクセス用
    Dim strArrRsvGrpCd      '予約群コード
    Dim strArrRsvGrpName    '予約群名称
    Dim lngRsvGrpCount      '予約群数
    Dim i                   'インデックス
%>
    <SELECT NAME="rsvGrpCd">
<%
        'オブジェクトのインスタンス作成
        Set objSchedule = Server.CreateObject("HainsSchedule.Schedule")

        '指定コースにおける有効な予約群コース受診予約群情報を元に読み込む
        lngRsvGrpCount = objSchedule.SelectCourseRsvGrpListSelCourse(strCsCd, 0, strArrRsvGrpCd, strArrRsvGrpName)

        'オブジェクトの解放
        Set objSchedule = Nothing

        '配列添字数分のリストを追加
        For i = 0 To lngRsvGrpCount - 1
%>
            <OPTION VALUE="<%= strArrRsvGrpCd(i) %>"<%= IIf(strArrRsvGrpCd(i) = strParaRsvGrpCd, " SELECTED", "") %>><%= strArrRsvGrpName(i) %>
<%
        Next
%>
    </SELECT>
<%
End Sub
'-------------------------------------------------------------------------------
'
' 機能　　 : キャンセル理由読み込み
'
' 引数　　 : (In)     strParaCancelFlg  キャンセルフラグ
'
' 戻り値　 : キャンセル理由
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function GetReason(strParaCancelFlg)

    Dim objFree     '汎用情報アクセス用
    Dim strReason   'キャンセル理由
    Dim strHTML     'HTML文字列

    'オブジェクトのインスタンス作成
    Set objFree = Server.CreateObject("HainsFree.Free")

    'キャンセル理由を読み込む
    objFree.SelectFree 0, FREECD_CANCEL & strParaCancelFlg, , , ,strReason

    If strReason = "" Then
        strReason = strParaCancelFlg
    End If

    'HTMLの編集開始
    strHTML = "<TABLE BORDER=""0"" CELLPADDING=""1"" CELLSPACING=""0"">"
    strHTML = strHTML & "<TR>"
    strHTML = strHTML & "<TD HEIGHT=""5""></TD>"
    strHTML = strHTML & "</TR>"
    strHTML = strHTML & "<TR>"
    strHTML = strHTML & "<TD NOWRAP><FONT COLOR=""#ff6600""><B>この受診情報はキャンセルされています。</B></FONT>&nbsp;&nbsp;キャンセル理由：<FONT COLOR=""#ff6600""><B>" & strReason & "</B></FONT></TD>"
    strHTML = strHTML & "</TR>"
    strHTML = strHTML & "</TABLE>"

    '戻り値の設定
    GetReason = strHTML

End Function
'-------------------------------------------------------------------------------
'
' 機能　　 : ダブルクォーテーション置換
'
' 引数　　 : (In)     strStream  対象文字列
'
' 戻り値　 : 置換後の文字列
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function RepQuot(strStream)

    RepQuot = Replace(strStream, """", "&quot;")

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>予約情報(団体)詳細</TITLE>
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<!-- #include virtual = "/webHains/includes/perGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
var winPerson;  // ウィンドウハンドル

var curOrgCd1, curOrgCd2;   // 団体検索ガイド呼び出し直前の団体退避用変数

// 団体検索ガイド呼び出し
function callOrgGuide() {

    // 他サブ画面を閉じる
    top.closeWindow( 4 );

    // ガイド呼び出し直前の日付を退避
    curOrgCd1 = document.paramForm.orgCd1.value;
    curOrgCd2 = document.paramForm.orgCd2.value;

    // 団体検索ガイド表示
    orgGuide_showGuideOrg( document.paramForm.orgCd1, document.paramForm.orgCd2, 'dispOrgName', null, null, changeOrg );

}

// 個人検索ガイド呼び出し
function callPersonGuide() {

    // 他サブ画面を閉じる
    top.closeWindow( 2 );

    // 編集用の関数定義
    perGuide_CalledFunction = setPersonInfo;

    // URLの編集
    var url = '/webHains/contents/guide/gdePersonal.asp';
    url = url + '?mode='      + '1';
    url = url + '&defPerId='  + document.paramForm.perId.value;
    url = url + '&defGender=' + document.paramForm.gender.value;

    // 個人検索ガイド画面を表示
    perGuide_openWindow( url );

}

// ドック申し込み個人情報画面呼び出し
function callEditPersonWindow() {

    var opened = false; // 画面が開かれているか
    var url;            // ドック申し込み個人情報画面のURL

    // 他サブ画面を閉じる
    top.closeWindow( 3 );

    // すでにガイドが開かれているかチェック
    if ( winPerson != null ) {
        if ( !winPerson.closed ) {
            opened = true;
        }
    }

    // ドック申し込み個人情報画面のURL編集
    url = 'webOrgRsvEditPerson.asp';
    url = url + '?cslDate=' + '<%= dtmCslDate %>';
    url = url + '&webNo='   + '<%= lngWebNo   %>';
    url = url + '&birth='   + '<%= strBirth   %>';
<%
    '登録済みの場合、読み込み専用フラグを送る
    If strRegFlg = REGFLG_REGIST Then
%>
        url = url + '&readOnly=1';
<%
End If
%>
    // 開かれている場合は画面をFOCUSし、さもなくば新規画面を開く
    if ( opened ) {
        winPerson.focus();
    } else {
        winPerson = window.open( url, '', 'width=750,height=700,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
    }

}

// ドック申し込み個人情報画面を閉じる
function closeEditPersonalWindow() {

    if ( winPerson != null ) {
        if ( !winPerson.closed ) {
            winPerson.close();
        }
    }

    winPerson = null;
}

// 受診区分変更時の処理
function changeCslDiv() {

    // 受診区分コードの格納
    document.paramForm.cslDivCd.value = document.entryForm.cslDivCd.value;

    // オプション検査画面の更新
    top.replaceOptionFrame();

}

// 団体変更時の処理
function changeOrg() {

    // 団体名称の格納
    document.paramForm.orgName.value = document.getElementById('dispOrgName').innerHTML;

    // 退避していた団体と異なる場合、オプション検査画面を更新する
    if ( document.paramForm.orgCd1.value != curOrgCd1 || document.paramForm.orgCd2.value != curOrgCd2 ) {
        top.replaceOptionFrame();
    }

    // 請求書、成績書本人家族区分がいずれも未指定の場合、請求書出力値をクリアする
    if ( orgGuide_BillCslDiv == '' && orgGuide_ReptCslDiv == '' ) {
        document.paramForm.billPrint.value = '';
    }

}

// 個人情報のセット
function setPersonInfo( perInfo ) {

    var replaceOpt = false; // オプション検査画面更新の必要性

    var paramForm    = document.paramForm;
    var personalForm = top.personal.document.entryForm;

    // 現在の個人情報を退避
    var curPerId  = paramForm.perId.value;
    var curBirth  = paramForm.birth.value;
    var curGender = paramForm.gender.value;

    // 個人情報の格納
    paramForm.perId.value      = perInfo.perId;
    paramForm.lastName.value   = perInfo.lastName;
    paramForm.firstName.value  = perInfo.firstName;
    paramForm.lastKName.value  = perInfo.lastKName;
    paramForm.firstKName.value = perInfo.firstKName;
    paramForm.birth.value      = perInfo.birth;
    paramForm.gender.value     = perInfo.gender;
    paramForm.romeName.value   = perInfo.romeName;

    // 個人情報の編集
    top.editPerson(
        perInfo.perId,
        perInfo.lastName,
        perInfo.firstName,
        perInfo.lastKName,
        perInfo.firstKName,
        perInfo.birthFull,
        null,
        null,
        perInfo.gender
    );

    // 受診付属情報の住所を編集
    for ( var i = 0; i < paramForm.zipCd.length; i++ ) {
        var objAddr = perInfo.addresses[ i ];
        paramForm.zipCd[ i ].value     = objAddr.zipCd;
        paramForm.prefCd[ i ].value    = objAddr.prefCd;
        paramForm.prefName[ i ].value  = objAddr.prefName;
        paramForm.cityName[ i ].value  = objAddr.cityName;
        paramForm.address1[ i ].value  = objAddr.address1;
        paramForm.address2[ i ].value  = objAddr.address2;
        paramForm.tel1[ i ].value      = objAddr.tel1;
        paramForm.phone[ i ].value     = objAddr.phone;
        paramForm.tel2[ i ].value      = objAddr.tel2;
        paramForm.extension[ i ].value = objAddr.extension;
        paramForm.fax[ i ].value       = objAddr.fax;
        paramForm.eMail[ i ].value     = objAddr.eMail;
    }

    // 個人情報の変更チェック
    for ( ; ; ) {

        // 個人ＩＤが変更された場合
        if ( perInfo.perId != curPerId ) {

            // 予約状況は仮IDでなければ確定、さもなくば保留
            personalForm.rsvStatus.value = perInfo.perId.substring(0, 1) == '@' ? '1' : '0';

            // 診察券発行は仮IDでなければ既存、さもなくば新規
            personalForm.issueCslTicket.value = perInfo.perId.substring(0, 1) == '@' ? '1' : '2';

            // オプション検査画面の更新が必要
            replaceOpt = true;
            break;

        }

        // 個人ＩＤは同一だが生年月日・性別のいずれかが変わった場合はオプション検査画面の更新が必要
        if ( perInfo.birth != curBirth || perInfo.gender != curGender ) {
            replaceOpt = true;
        }

        break;
    }

    // 受診歴が選択された場合
    if ( perInfo.csCd != null ) {

        // コースコードは本画面では固定なので継承しない

        // 団体が変更された場合は更新し、かつオプション検査画面の更新が必要
        if ( perInfo.lastOrgCd1 != paramForm.orgCd1.value || perInfo.lastOrgCd2 != paramForm.orgCd2.value ) {
            paramForm.orgCd1.value  = perInfo.lastOrgCd1;
            paramForm.orgCd2.value  = perInfo.lastOrgCd2;
            paramForm.orgName.value = perInfo.lastOrgName;
            document.getElementById('dispOrgName').innerHTML = perInfo.lastOrgName;
            replaceOpt = true;
        }

        // 受診区分が変更された場合は更新し、かつオプション検査画面の更新が必要
        if ( perInfo.cslDivCd != paramForm.cslDivCd.value ) {
            paramForm.cslDivCd.value = perInfo.cslDivCd;
            replaceOpt = true;
        }

        // 継承すべき項目の編集(受診付属情報)
        personalForm.cardAddrDiv.value   = perInfo.cardAddrDiv;     // 確認はがき宛先
        personalForm.formAddrDiv.value   = perInfo.formAddrDiv;     // 一式書式宛先
        personalForm.reportAddrDiv.value = perInfo.reportAddrDiv;   // 成績書宛先

        // 継承すべき項目の編集(submit用フォーム)
        paramForm.cardAddrDiv.value   = perInfo.cardAddrDiv;        // 確認はがき宛先
        paramForm.formAddrDiv.value   = perInfo.formAddrDiv;        // 一式書式宛先
        paramForm.reportAddrDiv.value = perInfo.reportAddrDiv;      // 成績書宛先
        paramForm.volunteer.value     = perInfo.volunteer;          // ボランティア
        paramForm.volunteerName.value = perInfo.volunteerName;      // ボランティア名
        paramForm.isrSign.value       = perInfo.isrSign;            // 保険証記号
        paramForm.isrNo.value         = perInfo.isrNo;              // 保険証番号
        paramForm.isrManNo.value      = perInfo.isrManNo;           // 保険者番号
        paramForm.empNo.value         = perInfo.empNo;              // 社員番号

    }

    // オプション検査画面の更新
    if ( replaceOpt ) {
        top.replaceOptionFrame();
    }

}

// 画面を閉じる
function closeWindow() {
    perGuide_closeGuidePersonal();
    closeEditPersonalWindow();
    orgGuide_closeGuideOrg();
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 0 0 20px 10px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">
<FORM NAME="entryForm" action="#">
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="464">
        <TR>
            <TD BGCOLOR="#eeeeee" NOWRAP><B><FONT COLOR="#333333">基本情報</FONT></B></TD>
        </TR>
    </TABLE>

    <SPAN ID="errMsg">
<%
    'エラーメッセージの編集
    Call EditMessage(strMessage, MESSAGETYPE_WARNING)
%>
    </SPAN>

    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
        <TR>
            <TD HEIGHT="2"></TD>
        </TR>
        <TR VALIGN="bottom">
            <TD>個人名</TD>
            <TD>：</TD>
            <TD ROWSPAN="2" VALIGN="middle" ID="perGuide"><A HREF="JavaScript:callPersonGuide()"><IMG SRC="/webhains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="個人検索ガイドを表示します"></A></TD>
            <TD WIDTH="100%">
                <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="1">
                    <TR VALIGN="bottom">
                        <TD NOWRAP ID="perPerId"></TD>
                        <TD>&nbsp;&nbsp;</TD>
                        <TD NOWRAP><FONT ID="kanaName" SIZE="1"></FONT><BR><B ID="fullName"></B></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD COLSPAN="2"></TD>
            <TD>
                <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
                    <TR>
                        <TD NOWRAP><SPAN ID="perBirth"></SPAN>生</TD>
                        <TD>&nbsp;&nbsp;</TD>
                        <TD NOWRAP><SPAN ID="perRealAge"></SPAN><SPAN ID="perAge"></SPAN></TD>
                        <TD>&nbsp;&nbsp;</TD>
                        <TD NOWRAP ID="perGender"></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD HEIGHT="5"></TD>
        </TR>
        <TR>
            <TD>団体</TD>
            <TD>：</TD>
            <!--## 団体検索ガイドは表示しない（web予約情報からデフォルト表示し固定)：修正付加   ##-->
            <TD COLSPAN="2" NOWRAP ID="dispOrgName"></TD>
        </TR>
        <TR>
            <TD HEIGHT="2"></TD>
        </TR>
        <TR>
            <TD>コース</TD>
            <TD>：</TD>
            <TD COLSPAN="2">
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
                    <TR>
                        <TD><%= EditCourseList("csCd", strCsCd, NON_SELECTED_DEL) %></TD>
                        </TD>
                        <TD NOWRAP>&nbsp;受診区分：</TD>
                        <TD><SELECT NAME="cslDivCd" STYLE="width:85;" ONCHANGE="javascript:changeCslDiv()"></SELECT></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD HEIGHT="2"></TD>
        </TR>
        <TR>
            <TD NOWRAP>受診日時</TD>
            <TD>：</TD>
            <TD COLSPAN="2">
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
                    <TR>
                        <TD><%= EditNumberList("cslYear", YEARRANGE_MIN, YEARRANGE_MAX, Year(CDate(strCslDate)), False) %></TD>
                        <TD>年</TD>
                        <TD><%= EditNumberList("cslMonth", 1, 12, Month(CDate(strCslDate)), False) %></TD>
                        <TD>月</TD>
                        <TD><%= EditNumberList("cslDay", 1, 31, Day(CDate(strCslDate)), False) %></TD>
                        <TD>日&nbsp;&nbsp;</TD>
                        <TD><% EditRsvGrpList(strRsvGrpCd) %></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
<%
    '未登録かつ予約枠無視フラグにて強制登録権限をもつユーザの場合、強制登録用のチェックボックスを表示
    If strRegFlg <> REGFLG_REGIST And (Session("IGNORE") = IGNORE_EXCEPT_NO_RSVFRA Or Session("IGNORE") = IGNORE_ANY) Then
%>
        <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
            <TR>
                <TD HEIGHT="35"><INPUT TYPE="checkbox"<%= IIf(lngIgnoreFlg = CLng(Session("IGNORE")), " CHECKED", "") %> ONCLICK="javascript:document.paramForm.ignore.value = ( this.checked ? '<%= Session("IGNORE") %>' : '' )"></TD>
                <TD NOWRAP><FONT SIZE="-1">強制登録を行う</FONT></TD>
            </TR>
        </TABLE>
<%
    End If
%>
</FORM>
<FORM NAME="paramForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<%
    'web予約情報の主キー
%>
    <INPUT TYPE="hidden" NAME="cslDate" VALUE="<%= strCslDate %>">
    <INPUT TYPE="hidden" NAME="webNo"   VALUE="<%= lngWebNo   %>">
    <INPUT TYPE="hidden" NAME="cRsvNo"  VALUE="<%= lngCRsvNo  %>">
<%
    '処理制御用
%>
    <INPUT TYPE="hidden" NAME="save"   VALUE="">
    <INPUT TYPE="hidden" NAME="next"   VALUE="">
    <INPUT TYPE="hidden" NAME="ignore" VALUE="">
<%
    '次予約情報検索用
%>
    <INPUT TYPE="hidden" NAME="strCslDate" VALUE="<%= dtmStrCslDate   %>">
    <INPUT TYPE="hidden" NAME="endCslDate" VALUE="<%= dtmEndCslDate   %>">
    <INPUT TYPE="hidden" NAME="key"        VALUE="<%= RepQuot(strKey) %>">

    <INPUT TYPE="hidden" NAME="strOpDate"  VALUE="<%= IIf(dtmStrOpDate > 0, dtmStrOpDate, "") %>">
    <INPUT TYPE="hidden" NAME="endOpDate"  VALUE="<%= IIf(dtmEndOpDate > 0, dtmEndOpDate, "") %>">

    <INPUT TYPE="hidden" NAME="opMode" VALUE="<%= lngOpMode %>">
    <INPUT TYPE="hidden" NAME="regFlg" VALUE="<%= lngRegFlg %>">
    <INPUT TYPE="hidden" NAME="order"  VALUE="<%= lngOrder  %>">
<%
    'web予約情報、受診情報共通
%>
    <INPUT TYPE="hidden" NAME="csCd"       VALUE="<%= RepQuot(strCsCd)       %>">
    <INPUT TYPE="hidden" NAME="rsvGrpCd"   VALUE="<%= strRsvGrpCd            %>">
    <INPUT TYPE="hidden" NAME="perId"      VALUE="<%= RepQuot(strPerId)      %>">
    <INPUT TYPE="hidden" NAME="lastName"   VALUE="<%= RepQuot(strLastName)   %>">
    <INPUT TYPE="hidden" NAME="firstName"  VALUE="<%= RepQuot(strFirstName)  %>">
    <INPUT TYPE="hidden" NAME="lastKName"  VALUE="<%= RepQuot(strLastKName)  %>">
    <INPUT TYPE="hidden" NAME="firstKName" VALUE="<%= RepQuot(strFirstKName) %>">
    <INPUT TYPE="hidden" NAME="gender"     VALUE="<%= strGender              %>">
    <INPUT TYPE="hidden" NAME="birth"      VALUE="<%= strBirth               %>">
<%
    'web予約情報
%>
    <INPUT TYPE="hidden" NAME="stomac" VALUE="<%= strOptionStomac %>">
    <INPUT TYPE="hidden" NAME="breast" VALUE="<%= strOptionBreast %>">
<% '#### 2013.3.11 SL-SN-Y0101-612 ADD START #### %>
    <INPUT TYPE="hidden" NAME="csloptions" VALUE="<%= strCslOptions %>">
<% '#### 2013.3.11 SL-SN-Y0101-612 ADD END   #### %>
<%
    '受診情報
%>
    <INPUT TYPE="hidden" NAME="orgCd1"   VALUE="<%= RepQuot(strOrgCd1)   %>">
    <INPUT TYPE="hidden" NAME="orgCd2"   VALUE="<%= RepQuot(strOrgCd2)   %>">
    <INPUT TYPE="hidden" NAME="orgName"  VALUE="<%= RepQuot(strOrgName)  %>">
    <INPUT TYPE="hidden" NAME="age"      VALUE="<%= strAge               %>">
    <INPUT TYPE="hidden" NAME="cslDivCd" VALUE="<%= RepQuot(strCslDivCd) %>">
    <INPUT TYPE="hidden" NAME="ctrPtCd"  VALUE="<%= strCtrPtCd           %>">
<%
    '個人情報
%>
    <INPUT TYPE="hidden" NAME="romeName" VALUE="<%= RepQuot(strRomeName) %>">
<%
    For i = 0 To UBound(strZipCd)
%>
        <INPUT TYPE="hidden" NAME="zipCd"     VALUE="<%= RepQuot(strZipCd(i))     %>">
        <INPUT TYPE="hidden" NAME="prefCd"    VALUE="<%= RepQuot(strPrefCd(i))    %>">
        <INPUT TYPE="hidden" NAME="prefName"  VALUE="<%= RepQuot(strPrefName(i))  %>">
        <INPUT TYPE="hidden" NAME="cityName"  VALUE="<%= RepQuot(strCityName(i))  %>">
        <INPUT TYPE="hidden" NAME="address1"  VALUE="<%= RepQuot(strAddress1(i))  %>">
        <INPUT TYPE="hidden" NAME="address2"  VALUE="<%= RepQuot(strAddress2(i))  %>">
        <INPUT TYPE="hidden" NAME="tel1"      VALUE="<%= RepQuot(strTel1(i))      %>">
        <INPUT TYPE="hidden" NAME="phone"     VALUE="<%= RepQuot(strPhone(i))     %>">
        <INPUT TYPE="hidden" NAME="tel2"      VALUE="<%= RepQuot(strTel2(i))      %>">
        <INPUT TYPE="hidden" NAME="extension" VALUE="<%= RepQuot(strExtension(i)) %>">
        <INPUT TYPE="hidden" NAME="fax"       VALUE="<%= RepQuot(strFax(i))       %>">
        <INPUT TYPE="hidden" NAME="eMail"     VALUE="<%= RepQuot(strEMail(i))     %>">
<%
    Next

    '
%>
    <INPUT TYPE="hidden" NAME="nationCd"    VALUE="<%= RepQuot(strNationCd)     %>">
    <INPUT TYPE="hidden" NAME="nationName"  VALUE="<%= RepQuot(strNationName)   %>">
<%

    '受診付属情報
%>
    <INPUT TYPE="hidden" NAME="rsvStatus"      VALUE="<%= strRsvStatus              %>">
    <INPUT TYPE="hidden" NAME="prtOnSave"      VALUE="<%= strPrtOnSave              %>">
    <INPUT TYPE="hidden" NAME="cardAddrDiv"    VALUE="<%= strCardAddrDiv            %>">
    <INPUT TYPE="hidden" NAME="cardOutEng"     VALUE="<%= strCardOutEng             %>">
    <INPUT TYPE="hidden" NAME="formAddrDiv"    VALUE="<%= strFormAddrDiv            %>">
    <INPUT TYPE="hidden" NAME="formOutEng"     VALUE="<%= strFormOutEng             %>">
    <INPUT TYPE="hidden" NAME="reportAddrDiv"  VALUE="<%= strReportAddrDiv          %>">
    <INPUT TYPE="hidden" NAME="reportOutEng"   VALUE="<%= strReportOutEng           %>">
    <INPUT TYPE="hidden" NAME="volunteer"      VALUE="<%= strVolunteer              %>">
    <INPUT TYPE="hidden" NAME="volunteerName"  VALUE="<%= RepQuot(strVolunteerName) %>">
    <INPUT TYPE="hidden" NAME="collectTicket"  VALUE="<%= strCollectTicket          %>">
    <INPUT TYPE="hidden" NAME="issueCslTicket" VALUE="<%= strIssueCslTicket         %>">
    <INPUT TYPE="hidden" NAME="billPrint"      VALUE="<%= strBillPrint              %>">
    <INPUT TYPE="hidden" NAME="isrSign"        VALUE="<%= RepQuot(strIsrSign)       %>">
    <INPUT TYPE="hidden" NAME="isrNo"          VALUE="<%= RepQuot(strIsrNo)         %>">
    <INPUT TYPE="hidden" NAME="isrManNo"       VALUE="<%= RepQuot(strIsrManNo)      %>">
    <INPUT TYPE="hidden" NAME="empNo"          VALUE="<%= RepQuot(strEmpNo)         %>">
    <INPUT TYPE="hidden" NAME="introductor"    VALUE="<%= RepQuot(strIntroductor)   %>">
    <INPUT TYPE="hidden" NAME="lastCslDate"    VALUE="<%= strLastCslDate            %>">
<%
    'オプション
%>
    <INPUT TYPE="hidden" NAME="optCd"  VALUE="<%= strOptCd       %>">
    <INPUT TYPE="hidden" NAME="optBNo" VALUE="<%= strOptBranchNo %>">
</FORM>
<SCRIPT TYPE="text/javascript">
<!--
<%
Set objCommon = Server.CreateObject("HainsCommon.Common")

'個人情報の編集
%>
top.editPerson(
    document.paramForm.perId.value,
    document.paramForm.lastName.value,
    document.paramForm.firstName.value,
    document.paramForm.lastKName.value,
    document.paramForm.firstKName.value,
    '<%= objCommon.FormatString(CDate(strBirth), "ge（yyyy）.m.d") %>',
    document.paramForm.age.value,
    '<%= CalcRealAge(CDate(strBirth), CDate(strCslDate)) %>',
    document.paramForm.gender.value
);
<%
Set objCommon = Nothing

'団体情報の編集
%>
document.getElementById('dispOrgName').innerHTML = document.paramForm.orgName.value;
<%
'コース、受診日、予約群は常時使用不能とする
%>
document.entryForm.csCd.disabled     = true;
document.entryForm.cslYear.disabled  = true;
document.entryForm.cslMonth.disabled = true;
document.entryForm.cslDay.disabled   = true;
document.entryForm.rsvGrpCd.disabled = true;
<%
'更に登録済みの場合
If strRegFlg = REGFLG_REGIST Then

    'ガイドボタンは表示しない
%>
    document.getElementById('perGuide').innerHTML = '';
<%
    '受診区分も選択不可とする
%>
    document.entryForm.cslDivCd.disabled = true;
<%
End If

'受診付属情報の表示

'登録済みの場合、読み込み専用フラグを送る
If strRegFlg = REGFLG_REGIST Then
%>
    top.personal.location.replace( 'webOrgRsvPersonal.asp?readOnly=1' );
<%
Else
%>
    top.personal.location.replace( 'webOrgRsvPersonal.asp' );
<%
End If

'オプション検査画面の表示
%>
top.replaceOptionFrame( document.paramForm.ctrPtCd.value, document.paramForm.optCd.value, document.paramForm.optBNo.value );
<%
'メッセージ制御

Do

    '保存完了時
    If blnSaved Then

        'Cookie値の取得
%>
        var searchStr = 'rsvDetailOnSaving=';
        var strCookie = document.cookie;
        var startPos  = strCookie.indexOf(searchStr) + searchStr.length;
        var onSaveVal = strCookie.substring(startPos, startPos + 1);

<%      '確定処理にてCookieが書かれ、かつフラグ成立時、保存完了メッセージを出す %>
        if ( onSaveVal == '1' ) {
            top.editMessage( document.getElementById('errMsg'), new Array('保存が完了しました。'), false );
        }
<%
        Exit Do
    End If

    'キャンセル者の場合
    If strCancelFlg <> "" And strCancelFlg <> CStr(CONSULT_USED) Then
%>
        document.getElementById('errMsg').innerHTML = '<%= GetReason(strCancelFlg) %>';
<%
    End If

    Exit Do
Loop
%>
document.cookie = 'rsvDetailOnSaving=0';
//-->
</SCRIPT>
</BODY>
</HTML>
