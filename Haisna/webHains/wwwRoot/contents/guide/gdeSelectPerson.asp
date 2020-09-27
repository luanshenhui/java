<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'        個人検索ガイド(親画面への個人情報編集) (Ver0.0.1)
'        AUTHER  : Tsutomu Takagi@FSIT
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_NOTHING, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon           '共通クラス
Dim objConsult          '受診情報アクセス用
Dim objFree             '汎用情報アクセス用
Dim objPerson           '個人情報アクセス用

'引数値
Dim strPerId            '個人ＩＤ
Dim strRsvNo            '予約番号

'個人情報
Dim strLastName         '姓
Dim strFirstName        '名
Dim strLastKName        'カナ姓
Dim strFirstKName       'カナ名
Dim strBirth            '生年月日
Dim strGender           '性別
Dim strOrgCd1           '所属団体コード１
Dim strOrgCd2           '所属団体コード２
Dim strOrgName          '団体漢字名称
Dim strOrgSName         '団体略称
Dim strOrgPostName      '所属名称
Dim strEmpNo            '従業員番号
Dim strJobName          '職名
Dim strAge              '年齢
'## 2003.12.12 Add By T.Takagi@FSIT 仮ＩＤフラグを返す
Dim strVidFlg           '仮ＩＤフラグ
'## 2003.12.12 Add End
'## 2005.03.09 Add By T.Takagi@FSIT web予約取り込み(ローマ字名追加)
Dim strRomeName         'ローマ字名
'## 2005.03.09 Add End

'個人住所情報
Dim strAddrDiv          '住所区分
Dim strZipCd            '郵便番号
Dim strPrefCd           '都道府県コード
Dim strPrefName         '都道府県名
Dim strCityName         '市区町村名
Dim strAddress1         '住所１
Dim strAddress2         '住所２
Dim strTel1             '電話番号１
Dim strPhone            '携帯
Dim strTel2             '電話番号２
Dim strExtension        '内線１
Dim strFax              'ＦＡＸ
Dim strEMail            'e-Mail
'### 2016.09.16 張 個人情報の特記事項表示追加 STR ###
Dim strNotes            '特記事項
'### 2016.09.16 張 個人情報の特記事項表示追加 END ###

'受診情報
Dim strCsCd             'コースコード
Dim strLastOrgCd1       '団体コード１
Dim strLastOrgCd2       '団体コード２
Dim strLastOrgName      '団体名称
Dim strCslDivCd         '受診区分コード

'受診付属情報
Dim strCardAddrDiv      '確認はがき宛先
Dim strFormAddrDiv      '一式書式宛先
Dim strReportAddrDiv    '成績書宛先
Dim strVolunteer        'ボランティア
Dim strVolunteerName    'ボランティア名
Dim strIsrSign          '保険証記号
Dim strIsrNo            '保険証番号
Dim strIsrManNo         '保険者番号
'#### 2013.3.1 SL-SN-Y0101-612 ADD START ####
Dim strSendMailDiv      '予約確認メール送信機能
'#### 2013.3.1 SL-SN-Y0101-612 ADD END   ####

Dim strPerName          '姓名
Dim strPerKName         'カナ姓名
Dim strEraBirth         '年齢（和暦）
Dim strFullBirth        '年齢（和暦＋西暦）
Dim strAddress          '住所
'### 2016.09.16 張 電話番号取得・編集の為追加 STR ###
Dim strTel              '電話番号
'### 2016.09.16 張 電話番号取得・編集の為追加 END ###
Dim i                   'インデックス

'## 2005.03.09 Add By T.Takagi@FSIT web予約取り込み(住所拡張)
Dim lngIndex                'インデックス
'## 2005.03.09 Add End

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon = Server.CreateObject("HainsCommon.Common")
Set objFree   = Server.CreateObject("HainsFree.Free")
Set objPerson = Server.CreateObject("HainsPerson.Person")

'引数値の取得
strPerId = Request("perId")
strRsvNo = Request("rsvNo")

'個人ＩＤが存在する場合
If strPerId <> "" Then

    '個人情報読み込み
'## 2003.12.12 Mod By T.Takagi@FSIT 仮ＩＤフラグを返す
'    objPerson.SelectPerson_Lukes strPerId, strLastName, strFirstName, strLastKName, strFirstKName, , strBirth, strGender
'## 2005.03.09 Mod By T.Takagi@FSIT web予約取り込み(ローマ字名追加)
'    objPerson.SelectPerson_Lukes strPerId, strLastName, strFirstName, strLastKName, strFirstKName, , strBirth, strGender, , , , , , , strVidFlg
    objPerson.SelectPerson_Lukes strPerId, strLastName, strFirstName, strLastKName, strFirstKName, strRomeName, strBirth, strGender, , , , , , , strVidFlg
'## 2005.03.09 Mod End
'## 2003.12.12 Mod End

    '個人住所情報読み込み
    objPerson.SelectPersonAddr strPerId, strAddrDiv, strZipCd, strPrefCd, strPrefName, strCityName, strAddress1, strAddress2, strTel1, strPhone, strTel2, strExtension, strFax, strEMail

    '年齢計算
    strAge = objFree.CalcAge(strBirth)
    If IsNumeric(strAge) Then
        strAge = Int(strAge)
    End If

    '姓名の編集
    strPerName  = Trim(strLastName  & "　" & strFirstName)
    strPerKName = Trim(strLastKName & "　" & strFirstKName)

    '生年月日の各形式編集
    strEraBirth  = objCommon.FormatString(strBirth, "ge.m.d")
    strFullBirth = objCommon.FormatString(strBirth, "ge（yyyy）.m.d")

'### 2016.09.16 張 個人情報の特記事項表示追加 STR ###
    '個人詳細情報読み込み
    objPerson.SelectPersonDetail_lukes strPerId, , , , , strNotes
'### 2016.09.14 張 個人情報の特記事項表示追加 END ###

End If

'予約番号が存在する場合
If strRsvNo <> "" Then

    Set objConsult = Server.CreateObject("HainsConsult.Consult")

    '受診情報読み込み
    objConsult.SelectConsult strRsvNo, , , , strCsCd, , strLastOrgCd1, strLastOrgCd2, strLastOrgName, , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , , strCslDivCd

    '継承項目の読み込み
'#### 2013.3.1 SL-SN-Y0101-612 UPD START ####
'    objConsult.SelectConsultDetail strRsvNo, , , strCardAddrDiv, , strFormAddrDiv, , strReportAddrDiv, , strVolunteer, strVolunteerName, , , , strIsrSign, strIsrNo, strIsrManNo, strEmpNo
    objConsult.SelectConsultDetail strRsvNo, , , strCardAddrDiv, , strFormAddrDiv, , strReportAddrDiv, , strVolunteer, strVolunteerName, , , , strIsrSign, strIsrNo, strIsrManNo, strEmpNo, , , , strSendMailDiv
'#### 2013.3.1 SL-SN-Y0101-612 UPD END   ####

    Set objConsult = Nothing

End If
%>
<SCRIPT TYPE="text/javascript">
<!--
<% '## 2005.03.09 Add By T.Takagi@FSIT web予約取り込み(住所拡張) %>
function PerAddr() {
    this.zipCd     = '';    // 郵便番号
    this.prefCd    = '';    // 都道府県コード
    this.prefName  = '';    // 都道府県名
    this.cityName  = '';    // 市区町村名
    this.address1  = '';    // 住所１
    this.address2  = '';    // 住所２
    this.tel1      = '';    // 電話番号1
    this.phone     = '';    // 携帯番号
    this.tel2      = '';    // 電話番号2
    this.extension = '';    // 内線
    this.fax       = '';    // FAX
    this.eMail     = '';    // e-Mail
}
<% '## 2005.03.09 Add End %>

// 呼び元画面に情報を渡すための個人情報クラス定義
function Person() {

    this.perId       = '';    // 個人ＩＤ
    this.lastName    = '';    // 姓
    this.firstName   = '';    // 名
    this.perName     = '';    // 姓名
    this.lastKName   = '';    // カナ姓
    this.firstKName  = '';    // カナ名
    this.perKName    = '';    // カナ姓名
    this.birth       = '';    // 生年月日
    this.birthJpn    = '';    // 生年月日(和暦)
    this.birthFull   = '';    // 生年月日(和暦＋西暦)
    this.gender      = '';    // 性別
    this.orgCd1      = '';    // 所属団体コード１
    this.orgCd2      = '';    // 所属団体コード２
    this.orgName     = '';    // 団体漢字名称
    this.orgSName    = '';    // 団体略称
    this.empNo       = '';    // 従業員番号
    this.age         = '';    // 年齢
    this.orgPostName = '';    // 所属名
    this.jobName     = '';    // 職名
// ## 2003.12.12 Add By T.Takagi@FSIT 仮ＩＤフラグを返す
    this.vidFlg      = '';    // 仮ＩＤフラグ
// ## 2003.12.12 Add End
<% '## 2005.03.09 Add By T.Takagi@FSIT web予約取り込み(ローマ字名追加) %>
    this.romeName    = '';    // ローマ字名
<% '## 2005.03.09 Add End %>

    this.address = new Array(3);    // 住所

/** 2016.09.16 張 電話番号、特記事項取得・編集の為追加 STR **/
    this.tel     = new Array(3);    // 電話番号
    this.notes   = '';              // 特記事項
/** 2016.09.16 張 電話番号、特記事項取得・編集の為追加 END **/

<% '## 2005.03.09 Add By T.Takagi@FSIT web予約取り込み(住所拡張) %>
    this.addresses = new Array(3);
    for ( var i = 0; i < this.addresses.length; i++ ) {
        this.addresses[ i ] = new PerAddr();
    }
<% '## 2005.03.09 Add End %>
<%
    '予約番号が存在する場合、クラスに要素を追加
    If strRsvNo <> "" Then
%>
        this.rsvNo         = '';    // 予約番号
        this.csCd          = '';    // コースコード
        this.lastOrgCd1    = '';    // 団体コード１
        this.lastOrgCd2    = '';    // 団体コード１
        this.lastOrgName   = '';    // 団体名称
        this.cslDivCd      = '';    // 受診区分コード
        this.cardAddrDiv   = '';    // 確認はがき宛先
        this.formAddrDiv   = '';    // 一式書式宛先
        this.reportAddrDiv = '';    // 成績書宛先
        this.volunteer     = '';    // ボランティア
        this.volunteerName = '';    // ボランティア名
        this.isrSign       = '';    // 保険証記号
        this.isrNo         = '';    // 保険証番号
        this.isrManNo      = '';    // 保険者番号
<% '#### 2013.3.1 SL-SN-Y0101-612 ADD START #### %>
        this.sendMailDiv   = '';    // 予約確認メール送信先
<% '#### 2013.3.1 SL-SN-Y0101-612 ADD END   #### %>
<%
    End If
%>
}

if ( !opener ) {
    close();
}
var perInfo = new Person();
perInfo.perId       = '<%= Replace(strPerId,       "'", "\'") %>';    // 個人ID
perInfo.lastName    = '<%= Replace(strLastName,    "'", "\'") %>';    // 姓
perInfo.firstName   = '<%= Replace(strFirstName,   "'", "\'") %>';    // 名
perInfo.perName     = '<%= Replace(strPerName,     "'", "\'") %>';    // 姓名
perInfo.lastKName   = '<%= Replace(strLastKName,   "'", "\'") %>';    // カナ姓
perInfo.firstKName  = '<%= Replace(strFirstKName,  "'", "\'") %>';    // カナ名
perInfo.perKName    = '<%= Replace(strPerKName,    "'", "\'") %>';    // カナ姓名
perInfo.birth       = '<%= Replace(strBirth,       "'", "\'") %>';    // 生年月日
perInfo.birthJpn    = '<%= Replace(strEraBirth,    "'", "\'") %>';    // 生年月日(和暦)
perInfo.birthFull   = '<%= Replace(strFullBirth,   "'", "\'") %>';    // 生年月日(和暦＋西暦)
perInfo.gender      = '<%= Replace(strGender,      "'", "\'") %>';    // 性別
perInfo.orgCd1      = '<%= Replace(strOrgCd1,      "'", "\'") %>';    // 所属団体コード１
perInfo.orgCd2      = '<%= Replace(strOrgCd2,      "'", "\'") %>';    // 所属団体コード２
perInfo.orgName     = '<%= Replace(strOrgName,     "'", "\'") %>';    // 団体漢字名称
perInfo.orgSName    = '<%= Replace(strOrgSName,    "'", "\'") %>';    // 団体略称
perInfo.orgPostName = '<%= Replace(strOrgPostName, "'", "\'") %>';    // 職名
perInfo.empNo       = '<%= Replace(strEmpNo,       "'", "\'") %>';    // 従業員番号
perInfo.age         = '<%= Replace(strAge,         "'", "\'") %>';    // 年齢
perInfo.jobName     = '<%= Replace(strJobName,     "'", "\'") %>';    // 職名
// ## 2003.12.12 Add By T.Takagi@FSIT 仮ＩＤフラグを返す
perInfo.vidFlg      = '<%= strVidFlg %>';    // 仮ＩＤフラグ
// ## 2003.12.12 Add End
<% '## 2005.03.09 Add By T.Takagi@FSIT web予約取り込み(ローマ字名追加) %>
perInfo.romeName    = '<%= Replace(strRomeName, "'", "\'") %>';    // ローマ字名
<% '## 2005.03.09 Add End %>

<% '## 2016.09.16 張 電話番号、特記事項取得・編集の為追加 STR ### %>
perInfo.notes    = '<%= Replace(Replace(strNotes, vbCrLf, ""), "'", "\'") %>';    // 特記事項
<% '## 2016.09.16 張 電話番号、特記事項取得・編集の為追加 END ### %>

<%
'住所情報が存在する場合
If IsArray(strAddrDiv) Then

    i = 0

    Do Until i > UBound(strAddrDiv) Or i > 2

        '郵便番号を分割して編集
        strAddress = Left(strZipCd(i), 3)
        If Len(strZipCd(i)) > 3 Then
            strAddress = strAddress & "-" & Right(strZipCd(i), Len(strZipCd(i)) - 3)
        End If

        '住所を連結
        strAddress = strAddress & "　" & strPrefName(i)
        strAddress = strAddress & strCityName(i)
        strAddress = Trim(strAddress & strAddress1(i))
        strAddress = strAddress & Trim(strAddress2(i))

'## 2004.07.09 Mod By T.Takagi@FSIT 住所にアプストロフィ対策が存在しなかったため修正
%>
        perInfo.address[<%= i %>] = '<%= Replace(strAddress, "'", "\'") %>';
<%
        i = i + 1
    Loop
'## 2005.03.30 Add By T.Takagi@FSIT 住所検索がおかしい
%>
        perInfo.address[0] = '';
        perInfo.address[1] = '';
        perInfo.address[2] = '';

//### 2016.09.16 張 電話番号取得・編集の為追加 STR ###
        perInfo.tel[0] = '';
        perInfo.tel[1] = '';
        perInfo.tel[2] = '';
//### 2016.09.16 張 電話番号取得・編集の為追加 END ###

<%
'## 2005.03.30 Add End
'## 2005.03.09 Add By T.Takagi@FSIT web予約取り込み(住所拡張)
%>
var objAddr;
<%
    For i = 0 To UBound(strAddrDiv)

        '住所区分値をもとに格納先のインデックスを定義
        Select Case strAddrDiv(i)
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
%>
            objAddr = perInfo.addresses[<%= lngIndex %>];
            objAddr.zipCd     = '<%= Replace(strZipCd(i),     "'", "\'") %>';    // 郵便番号
            objAddr.prefCd    = '<%= Replace(strPrefCd(i),    "'", "\'") %>';    // 都道府県コード
            objAddr.prefName  = '<%= Replace(strPrefName(i),  "'", "\'") %>';    // 都道府県名
            objAddr.cityName  = '<%= Replace(strCityName(i),  "'", "\'") %>';    // 市区町村名
            objAddr.address1  = '<%= Replace(strAddress1(i),  "'", "\'") %>';    // 住所１
            objAddr.address2  = '<%= Replace(strAddress2(i),  "'", "\'") %>';    // 住所２
            objAddr.tel1      = '<%= Replace(strTel1(i),      "'", "\'") %>';    // 電話番号1
            objAddr.phone     = '<%= Replace(strPhone(i),     "'", "\'") %>';    // 携帯番号
            objAddr.tel2      = '<%= Replace(strTel2(i),      "'", "\'") %>';    // 電話番号2
            objAddr.extension = '<%= Replace(strExtension(i), "'", "\'") %>';    // 内線
            objAddr.fax       = '<%= Replace(strFax(i),       "'", "\'") %>';    // FAX
            objAddr.eMail     = '<%= Replace(strEMail(i),     "'", "\'") %>';    // e-Mail
<%
'## 2005.03.30 Add By T.Takagi@FSIT 住所検索がおかしい
            '郵便番号を分割して編集
            strAddress = Left(strZipCd(i), 3)
            If Len(strZipCd(i)) > 3 Then
                strAddress = strAddress & "-" & Right(strZipCd(i), Len(strZipCd(i)) - 3)
            End If

            '住所を連結
            strAddress = strAddress & "　" & strPrefName(i)
            strAddress = strAddress & strCityName(i)
            strAddress = Trim(strAddress & strAddress1(i))
            strAddress = strAddress & Trim(strAddress2(i))

'### 2016.09.16 張 電話番号取得・編集の為追加 STR ###
        '電話番号編集
        strTel = ""
        If strTel1(i) <> "" or strPhone(i) <> "" or strTel2(i) <> "" Then
            strTel = "（"
            If strTel1(i) <> "" Then
                strTel = strTel & "電話1：" & strTel1(i)
            End If
            If strPhone(i) <> "" Then
                strTel = strTel & "　携帯：" & strPhone(i)
            End If
            If strTel2(i) <> "" Then
                strTel = strTel & "　電話2：" & strTel2(i)
            End If
            strTel = strTel & "）"
        End If
'### 2016.09.16 張 電話番号取得・編集の為追加 END ###

%>
            perInfo.address[<%= lngIndex %>] = '<%= Replace(strAddress, "'", "\'") %>';
            perInfo.tel[<%= lngIndex %>] = '<%= Replace(strTel, "'", "\'") %>';
<%
'## 2005.03.30 Add End
        End If

    Next
'## 2005.03.09 Add End

End If

'予約番号が存在する場合、クラスに要素を編集
If strRsvNo <> "" Then
%>
    perInfo.rsvNo       = '<%= Replace(strRsvNo,       "'", "\'") %>';    // 予約番号
    perInfo.csCd        = '<%= Replace(strCsCd,        "'", "\'") %>';    // コースコード
    perInfo.lastOrgCd1  = '<%= Replace(strLastOrgCd1,  "'", "\'") %>';    // 団体コード１
    perInfo.lastOrgCd2  = '<%= Replace(strLastOrgCd2,  "'", "\'") %>';    // 団体コード２
    perInfo.lastOrgName = '<%= Replace(strLastOrgName, "'", "\'") %>';    // 団体名称
    perInfo.cslDivCd    = '<%= Replace(strCslDivCd,    "'", "\'") %>';    // 受診区分コード

    perInfo.cardAddrDiv   = '<%= Replace(strCardAddrDiv,   "'", "\'") %>';    // 確認はがき宛先
    perInfo.formAddrDiv   = '<%= Replace(strFormAddrDiv,   "'", "\'") %>';    // 一式書式宛先
    perInfo.reportAddrDiv = '<%= Replace(strReportAddrDiv, "'", "\'") %>';    // 成績書宛先
    perInfo.volunteer     = '<%= Replace(strVolunteer,     "'", "\'") %>';    // ボランティア
    perInfo.volunteerName = '<%= Replace(strVolunteerName, "'", "\'") %>';    // ボランティア名
    perInfo.isrSign       = '<%= Replace(strIsrSign,       "'", "\'") %>';    // 保険証記号
    perInfo.isrNo         = '<%= Replace(strIsrNo,         "'", "\'") %>';    // 保険証番号
    perInfo.isrManNo      = '<%= Replace(strIsrManNo,      "'", "\'") %>';    // 保険者番号
<% '#### 2013.3.1 SL-SN-Y0101-612 ADD START #### %>
    perInfo.sendMailDiv   = '<%= Replace(strSendMailDiv, "'", "\'") %>';    // 予約確認メール送信先
<% '#### 2013.3.1 SL-SN-Y0101-612 ADD END   #### %>
<%
End If
%>
// 親画面の団体編集関数呼び出し
if ( opener.perGuide_setPerInfo ) {
    opener.perGuide_setPerInfo( perInfo );
}

// 自画面を閉じる
if ( !opener.perGuide_closeGuidePersonal ) {
    close();
}

opener.perGuide_closeGuidePersonal();
//-->
</SCRIPT>
