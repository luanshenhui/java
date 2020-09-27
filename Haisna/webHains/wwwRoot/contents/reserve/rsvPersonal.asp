<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       予約情報詳細(受診付属情報) (Ver0.0.1)
'       AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const FREECD_RSVINTERVAL = "RSVINTERVAL"    '汎用コード(はがきから送付案内への切り替えを行う日数)

'データベースアクセス用オブジェクト
Dim objConsult          '受診情報アクセス用
Dim objFree             '汎用情報アクセス用
Dim objOrganization     '団体情報アクセス用
Dim objPerson           '個人情報アクセス用
'## 2004.01.13 Add By T.Takagi 保存時印刷制御方法変更
Dim objCommon           '共通クラス
'## 2004.01.13 Add End

'前画面から送信されるパラメータ値(更新のみ)
Dim strRsvNo            '予約番号

'受診情報
Dim strCancelFlg        'キャンセルフラグ
Dim strCslDate          '受診日
Dim strOrgCd1           '団体コード１
Dim strOrgCd2           '団体コード２
Dim strDayId            '当日ＩＤ

'受診付属情報
Dim strRsvStatus        '予約状況
Dim	strPrtOnSave        '保存時印刷
Dim	strCardAddrDiv      '確認はがき宛先
Dim	strCardOutEng       '確認はがき英文出力
Dim	strFormAddrDiv      '一式書式宛先
Dim	strFormOutEng       '一式書式英文出力
Dim	strReportAddrDiv    '成績書宛先
Dim	strReportOutEng     '成績書英文出力
Dim	strVolunteer        'ボランティア
Dim	strVolunteerName    'ボランティア名
Dim	strCollectTicket    '利用券回収
Dim	strIssueCslTicket   '診察券発行
Dim	strBillPrint        '請求書出力
Dim	strIsrSign          '保険証記号
Dim	strIsrNo            '保険証番号
Dim	strIsrManNo         '保険者番号
Dim	strEmpNo            '社員番号
Dim	strIntroductor      '紹介者
Dim	strUpdDate          '更新日時
Dim	strUpdUserName      '更新者
Dim strCardPrintDate    '確認はがき出力日時
Dim strFormPrintDate    '一式書式出力日時
'## 2004.11.04 Add By T.Takagi@FSIT 前回受診日追加
Dim strLastCslDate      '前回受診日
'## 2004.11.04 Add End
'#### 2013.3.1 SL-SN-Y0101-612 ADD START ####
Dim strSendMailDiv      '予約確認メール送信先
Dim strSendMailDate     '予約確認メール送信日時
Dim strSendMailUserName '予約確認メール送信者名
'#### 2013.3.1 SL-SN-Y0101-612 ADD END   ####

'個人住所情報
Dim strPerId            '個人ＩＤ
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
'### 2016.09.14 張 個人情報の特記事項表示追加 STR ###
Dim strNotes            '特記事項
'### 2016.09.14 張 個人情報の特記事項表示追加 END ###

'団体情報
Dim strBillCslDiv       '請求書本人家族区分出力
'### 2016.09.14 張 団体情報の送付案内コメント表示追加 STR ###
Dim strSendComment      '送付案内コメント
'### 2016.09.14 張 団体情報の送付案内コメント表示追加 END ###

Dim strInterval         'はがきから送付案内への切り替えを行う日数
Dim lngInterval         'はがきから送付案内への切り替えを行う日数
Dim strLastName         '姓
Dim strFirstName        '名
Dim strName             '氏名
Dim strAddress(2)       '住所

'### 2016.07.28 張 受診者個人電話番号追加表示の為修正 STR ###
Dim strArrTel1(2)       '電話番号1
Dim strArrPhone(2)      '携帯番号
Dim strArrTel2(2)       '電話番号2
'### 2016.07.28 張 受診者個人電話番号追加表示の為修正 END ###

Dim i                   'インデックス

'## 2004.01.13 Add By T.Takagi 保存時印刷制御方法変更
Dim strCslYear          '受診年
Dim strCslMonth         '受診月
Dim strCslDay           '受診日
Dim strLastFormCslDate  '送付案内最新出力受診日
'## 2004.01.13 Add End

'## 2004.01.29 Add By T.Takagi@FSIT 項目追加
Dim strReptCslDiv       '成績書本人家族区分出力
'## 2004.01.29 Add End

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objFree = Server.CreateObject("HainsFree.Free")

'初期設定情報を汎用テーブルから取得
'## 2004.01.13 Mod By T.Takagi 保存時印刷制御方法変更
'objFree.SelectFree 0, FREECD_RSVINTERVAL, , , , strInterval
objFree.SelectFree 0, FREECD_RSVINTERVAL, , , strLastFormCslDate, strInterval
'## 2004.01.13 Mod End

Set objFree = Nothing

'切り替え日数の設定
If IsNumeric(strInterval) Then
    If CLng(strInterval) >= 0 Then
        lngInterval = CLng(strInterval)
    End If
End If

'引数値の取得
strRsvNo = Request("rsvNo")
'## 2004.01.13 Add By T.Takagi 保存時印刷制御方法変更
strCslYear  = Request("cslYear")
strCslMonth = Request("cslMonth")
strCslDay   = Request("cslDay")

'受診年月日が渡されていない場合、システム年月日を適用する
If strCslYear = "" Then
    strCslYear  = CStr(Year(Now))
    strCslMonth = CStr(Month(Now))
    strCslDay   = CStr(Day(Now))
End If
'## 2004.01.13 Add End

'予約番号指定時
If strRsvNo <> "" Then

    Set objConsult = Server.CreateObject("HainsConsult.Consult")

    '受診情報読み込み
    objConsult.SelectConsult strRsvNo,     strCancelFlg, strCslDate, strPerId, , , _
                             strOrgCd1,    strOrgCd2, , , , ,                      _
                             strUpdDate, , strUpdUserName, , , , , , , , , ,       _
                             strDayId

    '受診付属情報読み込み
'#### 2013.3.1 SL-SN-Y0101-612 ADD START ####
''## 2004.11.04 Mod By T.Takagi@FSIT 前回受診日追加
''	objConsult.SelectConsultDetail strRsvNo,          strRsvStatus,     strPrtOnSave,   _
''								   strCardAddrDiv,    strCardOutEng,    strFormAddrDiv, _
''								   strFormOutEng,     strReportAddrDiv, strReportOutEng, _
''								   strVolunteer,      strVolunteerName, strCollectTicket, _
''								   strIssueCslTicket, strBillPrint,     strIsrSign, _
''								   strIsrNo,          strIsrManNo,      strEmpNo, _
''								   strIntroductor
'    objConsult.SelectConsultDetail strRsvNo,          strRsvStatus,     strPrtOnSave,   _
'                                   strCardAddrDiv,    strCardOutEng,    strFormAddrDiv, _
'                                   strFormOutEng,     strReportAddrDiv, strReportOutEng, _
'                                   strVolunteer,      strVolunteerName, strCollectTicket, _
'                                   strIssueCslTicket, strBillPrint,     strIsrSign, _
'                                   strIsrNo,          strIsrManNo,      strEmpNo, _
'                                   strIntroductor, ,  strLastCslDate
''## 2004.11.04 Mod End
    objConsult.SelectConsultDetail strRsvNo,          strRsvStatus,     strPrtOnSave,   _
                                   strCardAddrDiv,    strCardOutEng,    strFormAddrDiv, _
                                   strFormOutEng,     strReportAddrDiv, strReportOutEng, _
                                   strVolunteer,      strVolunteerName, strCollectTicket, _
                                   strIssueCslTicket, strBillPrint,     strIsrSign, _
                                   strIsrNo,          strIsrManNo,      strEmpNo, _
                                   strIntroductor, ,  strLastCslDate, _
                                   strSendMailDiv,    strSendMailDate,  strSendMailUserName
'#### 2013.3.1 SL-SN-Y0101-612 ADD END   ####

    Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

'## 2004.01.29 Mod By T.Takagi@FSIT 項目追加
'	'請求書本人家族区分の取得
'	objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2, , , , , , , , , , , , , , , , , , , , , , , , , , , strBillCslDiv
    '請求書、成績書本人家族区分の取得
'### 2016.09.14 張 団体情報の送付案内コメント表示追加 STR ###
'    objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2, , , , , , , , , , , , , , , , , , , , , , , , , , , strBillCslDiv, , , , , , , , , , , , , , , , , , , , , , , strReptCslDiv
    objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2, , , , , , , , , , , , , , , , , , , , , , , , , , , strBillCslDiv, , , , , strSendComment, , , , , , , , , , , , , , , , , , strReptCslDiv
'### 2016.09.14 張 団体情報の送付案内コメント表示追加 STR ###
'## 2004.01.29 Mod End

    Set objOrganization = Nothing

    'はがき、一式書式の出力情報読み込み
    objConsult.SelectConsultPrintStatus strRsvNo, strCardPrintDate, strFormPrintDate

    '保存時印刷処理の制御
    strPrtOnSave = "0"

    Do

        'はがきが出力されている場合は送付案内の出力状態に依存
        If strCardPrintDate <> "" Then
            strPrtOnSave = IIf(strFormPrintDate <> "", "0", "2")
            Exit Do
        End If

        'はがきが出力されていない場合

        '送付案内が出力されている場合は必要なし
        If strFormPrintDate <> "" Then
            Exit Do
        End If

        'システム日付が受診日より(切り替え日数)以内であれば送付案内を、さもなくばはがきを選択
        strPrtOnSave = IIf(CDate(strCslDate) - Date <= lngInterval, "2", "1")
        Exit Do
    Loop

    Set objConsult = Nothing

    Set objPerson = Server.CreateObject("HainsPerson.Person")

    '個人住所情報読み込み
    objPerson.SelectPersonAddr strPerId, strAddrDiv, strZipCd, strPrefCd, strPrefName, strCityName, strAddress1, strAddress2, strTel1, strPhone, strTel2, strExtension, strFax, strEMail

    '住所情報が存在する場合
    If IsArray(strAddrDiv) Then
    
        i = 0
        Do Until i > UBound(strAddrDiv) Or i > 2
    
            '郵便番号を分割して編集
            strAddress(i) = Left(strZipCd(i), 3)
            If Len(strZipCd(i)) > 3 Then
                strAddress(i) = strAddress(i) & "-" & Right(strZipCd(i), Len(strZipCd(i)) - 3)
            End If
    
            '住所を連結
            strAddress(i) = strAddress(i) & "　" & strPrefName(i)
            strAddress(i) = strAddress(i) & strCityName(i)
            strAddress(i) = Trim(strAddress(i) & strAddress1(i))
            strAddress(i) = strAddress(i) & Trim(strAddress2(i))

            '### 2016.07.28 張 受診者個人電話番号追加表示の為修正 STR ###
            strArrTel1(i) = Trim(strTel1(i))
            strArrPhone(i)= Trim(strPhone(i))
            strArrTel2(i) = Trim(strTel2(i))
            '### 2016.07.28 張 受診者個人電話番号追加表示の為修正 END ###

            i = i + 1
        Loop
    
    End If

    '個人情報読み込み
    If strIntroductor <> "" Then
        objPerson.SelectPerson_Lukes strIntroductor, strLastName, strFirstName
        strName = Trim(strLastName & "　" & strFirstName)
    End If

'### 2016.09.14 張 個人情報の特記事項表示追加 STR ###
    '個人詳細情報読み込み
    objPerson.SelectPersonDetail_lukes strPerId, , , , , strNotes
'### 2016.09.14 張 個人情報の特記事項表示追加 END ###

    Set objPerson = Nothing

'予約番号未指定時
Else

    '初期値の設定
    strRsvStatus      = "0"
    strPrtOnSave      = "1"
    strCardAddrDiv    = "1"
    strCardOutEng     = "0"
    strFormAddrDiv    = "1"
    strFormOutEng     = "0"
    strReportAddrDiv  = "1"
    strReportOutEng   = "0"
    strVolunteer      = "0"
    strIssueCslTicket = "1"
'#### 2013.3.1 SL-SN-Y0101-612 ADD START ####
	strSendMailDiv    = "0"
'#### 2013.3.1 SL-SN-Y0101-612 ADD END   ####

    '請求書出力は表示しない
    strBillCslDiv = ""
'## 2004.01.29 Add By T.Takagi@FSIT 項目追加
    strReptCslDiv = ""
'## 2004.01.29 Add End

'## 2004.01.13 Add By T.Takagi 保存時印刷制御方法変更
    '受診日の編集
    strCslDate = CDate(strCslYear & "/" & strCslMonth & "/" & strCslDay)
'## 2004.01.13 Add End

End If
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Adobe GoLive 6">
<TITLE>予約情報詳細(受診付属情報)</TITLE>
<STYLE TYPE="text/css">
table#maincontents {
	margin: 5px 0 0 0;
}

table#maincontents tr {
	height: 1.4em;
}

td.tbl_spacer { height: 10px; }

</style>
<!-- #include virtual = "/webHains/includes/perGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
var winStatus;  // ウィンドウハンドル
// ## 2004.10.27 Add By T.Takagi@FSIT 更新履歴への遷移追加
var winRsvLog;  // ウィンドウハンドル
// ## 2004.10.27 Add End

// 個人検索ガイド呼び出し
function callPersonGuide() {
    perGuide_showGuidePersonal(document.entryForm.introductor, 'introductorName');
}

// 印刷状況画面呼び出し
function callPrintStatusWindow() {

    var opened = false; // 画面が開かれているか
    var url;            // 印刷状況画面のURL

    // すでにガイドが開かれているかチェック
    if ( winStatus != null ) {
        if ( !winStatus.closed ) {
            opened = true;
        }
    }

    // 印刷状況画面のURL編集
    url = 'rsvPrintStatus.asp?rsvNo=<%= strRsvNo %>';

    // 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
    if ( opened ) {
        winStatus.focus();
        winStatus.location.replace( url );
    } else {
        winStatus = open( url, '', 'width=400,height=180,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
    }

}

// 個人情報のクリア
function clearPerInfo() {
    perGuide_clearPerInfo(document.entryForm.introductor, 'introductorName');
}

// サブ画面を閉じる
function closeWindow() {

    // 個人検索ガイドを閉じる
    perGuide_closeGuidePersonal();

    // 印刷状況画面を閉じる
    if ( winStatus != null ) {
        if ( !winStatus.closed ) {
            winStatus.close();
        }
    }

    winStatus = null;

// ## 2004.10.27 Add By T.Takagi@FSIT 更新履歴への遷移追加
    // 更新履歴画面を閉じる
    if ( winRsvLog != null ) {
        if ( !winRsvLog.closed ) {
            winRsvLog.close();
        }
    }

    winRsvLog = null;
// ## 2004.10.27 Add End
}

// はがき印刷
function showPrintCardDialog() {

    var cardAddrDiv = document.entryForm.cardAddrDiv.value;
    for ( i = 0; i < document.entryForm.cardOutEng.length; i++ ) {
        if ( document.entryForm.cardOutEng[ i ].checked ) {
            var cardOutEng = document.entryForm.cardOutEng[ i ].value;
            break;
        }
    }

    top.showPrintCardDialog( '<%= strRsvNo %>', '1', cardAddrDiv, cardOutEng );

}

// 一式書式印刷
function showPrintFormDialog() {

    var formAddrDiv = document.entryForm.formAddrDiv.value;
    for ( i = 0; i < document.entryForm.formOutEng.length; i++ ) {
        if ( document.entryForm.formOutEng[ i ].checked ) {
            var formOutEng = document.entryForm.formOutEng[ i ].value;
            break;
        }
    }

    top.showPrintFormDialog( '<%= strRsvNo %>', '1', formAddrDiv, formOutEng );

}

// 「請求書出力」の表示制御
function setBillPrintVisibility( visible ) {

    // 現在の表示状態を取得
    var currentVisibility = document.getElementById('dspBillPrint1').style.visibility ? 'visible' : 'hidden';

    // 現在の表示状態と同一指定なら何もしない
    if ( visible == currentVisibility ) {
        return;
    }

    // 表示制御
    var visibility = visible ? 'visible' : 'hidden';
    document.getElementById('dspBillPrint1').style.visibility = visibility;
    document.getElementById('dspBillPrint2').style.visibility = visibility;
    document.getElementById('dspBillPrint3').style.visibility = visibility;

    // 非表示の場合
    if ( !visible ) {

        // 保持内容のクリア
        document.entryForm.billPrint.value = '';

        // 指定なしを選択状態にする
        document.entryForm.billPrintCntl.selectedIndex = 0;

    }

}
// ## 2004.10.27 Add By T.Takagi@FSIT 更新履歴への遷移追加
// 更新履歴画面呼び出し
function callConsultLogWindow() {

    var opened = false; // 画面が開かれているか
    var url;            // 更新履歴画面のURL

    // すでにガイドが開かれているかチェック
    if ( winRsvLog != null ) {
        if ( !winRsvLog.closed ) {
            opened = true;
        }
    }

    // 更新履歴画面のURL編集
    url = 'rsvLogBody.asp';
    url = url + '?strYear='     + '1970';
    url = url + '&strMonth='    + '1';
    url = url + '&strDay='      + '1';
    url = url + '&endYear='     + '2200';
    url = url + '&endMonth='    + '12';
    url = url + '&endDay='      + '31';
    url = url + '&rsvNo='       + '<%= strRsvNo %>';
    url = url + '&orderByItem=' + '0';  // 更新日の
    url = url + '&orderByMode=' + '0';  // 昇順に
    url = url + '&startPos='    + '1';  // 先頭から
    url = url + '&getCount='    + '0';  // 全件表示
    url = url + '&margin='      + '20';

    // 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
    if ( opened ) {
        winRsvLog.focus();
        winRsvLog.location.replace( url );
    } else {
        winRsvLog = open( url, '', 'width=400,height=300,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
    }

}
// ## 2004.10.27 Add End
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 0 0 0 10px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">
<FORM NAME="entryForm" action="#">
    <INPUT TYPE="hidden" NAME="billPrint" VALUE="<%= strBillPrint %>">
    <TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
        <TR>
            <TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15"><B><FONT COLOR="#333333">受診付属情報</FONT></B></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0" id="maincontents">
        <tr>
            <TD>予約状況</TD>
            <TD>：</TD>
            <TD>
                <SELECT NAME="rsvStatus">
                    <OPTION VALUE="0"<%= IIf(strRsvStatus = "0", " SELECTED", "") %>>確定
                    <OPTION VALUE="1"<%= IIf(strRsvStatus = "1", " SELECTED", "") %>>保留
                    <!--#### 2007/04/04 張 予約状況区分追加 Start ####-->
                    <OPTION VALUE="2"<%= IIf(strRsvStatus = "2", " SELECTED", "") %>>未確定
                    <!--#### 2007/04/04 張 予約状況区分追加 End   ####-->
                </SELECT>
            </TD>
        </TR>
        <TR>
            <TD class="tbl_spacer"></TD>
        </TR>
        <TR>
            <TD>保存時印刷</TD>
            <TD>：</TD>
            <TD>
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                    <TR>
<% '## 2004.01.13 Mod By T.Takagi 保存時印刷制御方法変更 %>
<!--
                        <TD><INPUT TYPE="radio" NAME="prtOnSave" VALUE="0"<%= IIf(strPrtOnSave = "0", " CHECKED", "") %>></TD>
                        <TD NOWRAP>なし</TD>
                        <TD><INPUT TYPE="radio" NAME="prtOnSave" VALUE="1"<%= IIf(strPrtOnSave = "1", " CHECKED", "") %>></TD>
                        <TD NOWRAP>はがき</TD>
                        <TD><INPUT TYPE="radio" NAME="prtOnSave" VALUE="2"<%= IIf(strPrtOnSave = "2", " CHECKED", "") %>></TD>
                        <TD NOWRAP>送付案内</TD>
-->
                        <TD><INPUT TYPE="radio" NAME="prtOnSave" VALUE="0"></TD>
                        <TD NOWRAP>なし</TD>
                        <TD><INPUT TYPE="radio" NAME="prtOnSave" VALUE="1"></TD>
                        <TD NOWRAP>はがき</TD>
                        <TD><INPUT TYPE="radio" NAME="prtOnSave" VALUE="2"></TD>
                        <TD NOWRAP>送付案内</TD>
<% '## 2004.01.13 Mod End %>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD class="tbl_spacer"></TD>
        </TR>
        <TR>
            <TD NOWRAP>宛先（確認はがき）</TD>
            <TD>：</TD>
            <TD>
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                    <TR>
                        <TD>
                            <SELECT NAME="cardAddrDiv">
                                <OPTION VALUE="1"<%= IIf(strCardAddrDiv = "1", " SELECTED", "") %>>住所（自宅）
                                <OPTION VALUE="2"<%= IIf(strCardAddrDiv = "2", " SELECTED", "") %>>住所（勤務先）
                                <OPTION VALUE="3"<%= IIf(strCardAddrDiv = "3", " SELECTED", "") %>>住所（その他）
                            </SELECT>
                        </TD>
                        <!--#### 2008.03.10 張 コールセンターからの依頼によって修正 ####-->
                        <!--TD ID="print1" NOWRAP>　<A HREF="javascript:showPrintCardDialog()">印刷</A></TD-->
                        <TD ID="print1" NOWRAP>　<FONT COLOR="#ffffff">&nbsp;</FONT></TD>
                        <TD NOWRAP>　英文出力</TD>
                        <TD><INPUT TYPE="radio" NAME="cardOutEng" VALUE="1"<%= IIf(strCardOutEng = "1", " CHECKED", "") %>></TD>
                        <TD>有</TD>
                        <TD><INPUT TYPE="radio" NAME="cardOutEng" VALUE="0"<%= IIf(strCardOutEng = "0", " CHECKED", "") %>></TD>
                        <TD>無</TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD>宛先（一式書式）</TD>
            <TD>：</TD>
            <TD>
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                    <TR>
                        <TD>
                            <SELECT NAME="formAddrDiv">
                                <OPTION VALUE="1"<%= IIf(strFormAddrDiv = "1", " SELECTED", "") %>>住所（自宅）
                                <OPTION VALUE="2"<%= IIf(strFormAddrDiv = "2", " SELECTED", "") %>>住所（勤務先）
                                <OPTION VALUE="3"<%= IIf(strFormAddrDiv = "3", " SELECTED", "") %>>住所（その他）
                            </SELECT>
                        </TD>
                        <!--#### 2008.03.10 張 コールセンターからの依頼によって修正 ####-->
                        <!--TD ID="print2" NOWRAP>　<A HREF="javascript:showPrintFormDialog()">印刷</A></TD-->
                        <TD ID="print2" NOWRAP>　<FONT COLOR="#ffffff">&nbsp;</FONT></TD>
                        <TD NOWRAP>　英文出力</TD>
                        <TD><INPUT TYPE="radio" NAME="formOutEng" VALUE="1"<%= IIf(strFormOutEng = "1", " CHECKED", "") %>></TD>
                        <TD>有</TD>
                        <TD><INPUT TYPE="radio" NAME="formOutEng" VALUE="0"<%= IIf(strFormOutEng = "0", " CHECKED", "") %>></TD>
                        <TD>無</TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD NOWRAP>宛先（成績表）</TD>
            <TD>：</TD>
            <TD>
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                    <TR>
                        <TD>
                            <SELECT NAME="reportAddrDiv">
                                <OPTION VALUE="1"<%= IIf(strReportAddrDiv = "1", " SELECTED", "") %>>住所（自宅）
                                <OPTION VALUE="2"<%= IIf(strReportAddrDiv = "2", " SELECTED", "") %>>住所（勤務先）
                                <OPTION VALUE="3"<%= IIf(strReportAddrDiv = "3", " SELECTED", "") %>>住所（その他）
                            </SELECT>
                        </TD>
                        <TD ID="print3" NOWRAP>　<FONT COLOR="#ffffff">&nbsp;</FONT></TD>
                        <TD NOWRAP>　英文出力</TD>
                        <TD><INPUT TYPE="radio" NAME="reportOutEng" VALUE="1"<%= IIf(strReportOutEng = "1", " CHECKED", "") %>></TD>
                        <TD>有</TD>
                        <TD><INPUT TYPE="radio" NAME="reportOutEng" VALUE="0"<%= IIf(strReportOutEng <> "1", " CHECKED", "") %>></TD>
                        <TD>無</TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD HEIGHT="30" ID="prtStatus" NOWRAP><A HREF="javascript:callPrintStatusWindow()">印刷状況を見る</A></TD>
        </TR>
        <TR>
            <TD HEIGHT="3" colspan=3><hr></TD>
        </TR>
<%'### 2016.07.28 張 受診者個人電話番号追加表示の為修正 STR ###%>
        <!--TR>
            <TD>住所（自宅）</TD>
            <TD>：</TD>
            <TD ID="addr1"><%= strAddress(0) %></TD>
        </TR>
        <TR>
            <TD>住所（勤務先）</TD>
            <TD>：</TD>
            <TD ID="addr2"><%= strAddress(1) %></TD>
        </TR>
        <TR>
            <TD>住所（その他）</TD>
            <TD>：</TD>
            <TD ID="addr3"><%= strAddress(2) %></TD>
        </TR-->

<%'### 電話番号が登録されている時だけ表示 %>
        <TR>
            <TD rowspan="2" valign="top">住所（自宅）</TD>
            <TD rowspan="2" valign="top">：</TD>
            <TD ID="addr1"><%= strAddress(0) %></TD>
        </TR>
        <TR>
            <TD ID="tel1">
<%  If strArrTel1(0) <> "" or strArrPhone(0) <> "" or strArrTel2(0) <> "" Then   %>
            （<%= IIf(strArrTel1(0) <> "", "　電話1：" & strArrTel1(0), "")%><%= IIf(strArrPhone(0) <> "", "　携帯：" & strArrPhone(0), "")%><%= IIf(strArrTel2(0) <> "", "　電話2：" & strArrTel2(0), "")%>&nbsp;&nbsp;）
<%  End If  %>
            </TD>
        </TR>

        <TR>
            <TD rowspan="2" valign="top">住所（勤務先）</TD>
            <TD rowspan="2" valign="top">：</TD>
            <TD ID="addr2"><%= strAddress(1) %></TD>
        </TR>
        <TR>
            <TD ID="tel2">
<%  If strArrTel1(1) <> "" or strArrPhone(1) <> "" or strArrTel2(1) <> "" Then   %>
            （<%= IIf(strArrTel1(1) <> "", "　電話1：" & strArrTel1(1), "")%><%= IIf(strArrPhone(1) <> "", "　携帯：" & strArrPhone(1), "")%><%= IIf(strArrTel2(1) <> "", "　電話2：" & strArrTel2(1), "")%>&nbsp;&nbsp;）
<%  End If  %>
            </TD>
        </TR>

        <TR>
            <TD rowspan="2" valign="top">住所（その他）</TD>
            <TD rowspan="2" valign="top">：</TD>
            <TD ID="addr3"><%= strAddress(2) %></TD>
        </TR>
        <TR>
            <TD ID="tel3">
<%  If strArrTel1(2) <> "" or strArrPhone(2) <> "" or strArrTel2(2) <> "" Then   %>
            （<%= IIf(strArrTel1(2) <> "", "　電話1：" & strArrTel1(2), "")%><%= IIf(strArrPhone(2) <> "", "　携帯：" & strArrPhone(2), "")%><%= IIf(strArrTel2(2) <> "", "　電話2：" & strArrTel2(2), "")%>&nbsp;&nbsp;）
<%  End If  %>
            </TD>
        </TR>
<%'### 2016.07.28 張 受診者個人電話番号追加表示の為修正 END ###%>

<%'### 2016.09.19 張 個人情報の特記事項・団体情報の送付案内コメント表示追加 STR ###%>
        <TR>
            <TD valign="top">特記事項</TD>
            <TD valign="top">：</TD>
            <TD ID="notes"><%= strNotes %></TD>
        </TR>

        <TR>
            <TD HEIGHT="3" colspan=3><hr></TD>
        </TR>
        <TR>
            <TD NOWRAP valign="top">送付案内コメント</TD>
            <TD valign="top">：</TD>
            <TD ID="sendCommentVal"><%= strSendComment %></TD>
        </TR>
        <TR>
            <TD HEIGHT="3" colspan=3><hr></TD>
        </TR>
<%'### 2016.09.19 張 個人情報の特記事項・団体情報の送付案内コメント表示追加 END ###%>

        <TR>
            <TD>ボランティア</TD>
            <TD>：</TD>
            <TD>
                <SELECT NAME="volunteer" ID="hoge">
                    <OPTION VALUE="0"<%= IIf(strVolunteer = "0", " SELECTED", "") %>>利用なし
                    <OPTION VALUE="1"<%= IIf(strVolunteer = "1", " SELECTED", "") %>>通訳要
                    <OPTION VALUE="2"<%= IIf(strVolunteer = "2", " SELECTED", "") %>>介護要
                    <OPTION VALUE="3"<%= IIf(strVolunteer = "3", " SELECTED", "") %>>通訳＆介護要
                    <OPTION VALUE="4"<%= IIf(strVolunteer = "4", " SELECTED", "") %>>車椅子要
                </SELECT>
            </TD>
        </TR>
        <TR>
            <TD>ボランティア名</TD>
            <TD>：</TD>
            <%'###### 2010/05/26 張 コメントも入れることによって赤字で表示（データベース変更なし） Start ####%>
            <!--TD><INPUT TYPE="text" NAME="volunteerName" SIZE="50" MAXLENGTH="25" VALUE="<%= strVolunteerName %>"></TD-->
            <TD><INPUT TYPE="text" NAME="volunteerName" SIZE="50" MAXLENGTH="25" VALUE="<%= strVolunteerName %>"  style="FONT-WEIGHT: bold;COLOR:red;ime-mode:active;"></TD>
            <%'###### 2010/05/26 張 コメントも入れることによって赤字で表示（データベース変更なし） End   ####%>
        </TR>
        <TR>
            <TD>利用券回収</TD>
            <TD>：</TD>
            <TD>
                <SELECT NAME="collectTicket">
                    <OPTION VALUE=""<%=  IIf(strCollectTicket <> "1", " SELECTED", "") %>>未回収
                    <OPTION VALUE="1"<%= IIf(strCollectTicket  = "1", " SELECTED", "") %>>回収済
                </SELECT>
            </TD>
        </TR>
        <TR>
            <TD>診察券発行</TD>
            <TD>：</TD>
            <TD>
                <SELECT NAME="issueCslTicket">
                    <OPTION VALUE="">&nbsp;
                    <OPTION VALUE="1"<%= IIf(strIssueCslTicket = "1", " SELECTED", "") %>>新規
                    <OPTION VALUE="2"<%= IIf(strIssueCslTicket = "2", " SELECTED", "") %>>既存
                    <OPTION VALUE="3"<%= IIf(strIssueCslTicket = "3", " SELECTED", "") %>>再発行
                </SELECT>
            </TD>
        </TR>
        <TR>
            <TD HEIGHT="3" colspan=3><hr></TD>
        </TR>
        <TR>
            <TD><SPAN ID="dspBillPrint1"><FONT COLOR="red"><B>請求書出力</B></FONT></SPAN></TD>
            <TD><SPAN ID="dspBillPrint2">：</SPAN></TD>
            <TD><SPAN ID="dspBillPrint3">
                <SELECT NAME="billPrintCntl" ONCHANGE="javascript:document.entryForm.billPrint.value = this.value">
                    <OPTION VALUE="">指定なし
                    <OPTION VALUE="1">本人
                    <OPTION VALUE="2">家族
                </SELECT>
                </SPAN>
            </TD>
        </TR>
        <TR style="height:3px">
            <TD HEIGHT="3"></TD>
        </TR>
        <TR>
            <TD>保険証記号</TD>
            <TD>：</TD>
            <TD><INPUT TYPE="text" NAME="isrSign" SIZE="28" MAXLENGTH="16" VALUE="<%= strIsrSign %>"></TD>
        </TR>
        <TR>
            <TD>保険証番号</TD>
            <TD>：</TD>
            <TD><INPUT TYPE="text" NAME="isrNo" SIZE="28" MAXLENGTH="16" VALUE="<%= strIsrNo %>"></TD>
        </TR>
        <TR>
            <%'#### 2008/09/22 張 保険者番号欄をコメントとして使うためにタイトル変更（データベース変更なし） Start ####%>
            <%'###### 2010/05/26 張 コメントを元の保険者番号欄に戻す（データベース変更なし） Start ####%>
            <TD>保険者番号</TD>
            <!--TD style="FONT-WEIGHT: bold;COLOR:red;">コメント</TD-->
            <TD>：</TD>
            <TD><INPUT TYPE="text" NAME="isrManNo" SIZE="28" MAXLENGTH="16" VALUE="<%= strIsrManNo %>" style="ime-mode:inactive;"></TD>
            <!--TD><INPUT TYPE="text" NAME="isrManNo" SIZE="28" MAXLENGTH="16" VALUE="<%= strIsrManNo %>" style="FONT-WEIGHT: bold;COLOR:red;ime-mode:active;"></TD-->
            <%'###### 2010/05/26 張 コメントを元の保険者番号欄に戻す（データベース変更なし） End   ####%>
            <%'#### 2008/09/22 張 保険者番号欄をコメントとして使うためにタイトル変更（データベース変更なし） End   ####%>
        </TR>
        <TR style="height:4px">
            <TD HEIGHT="4"></TD>
        </TR>
        <TR>
            <TD>社員番号</TD>
            <TD>：</TD>
            <TD><INPUT TYPE="text" NAME="empNo" SIZE="20" MAXLENGTH="12" VALUE="<%= strEmpNo %>"></TD>
        </TR>
        <TR style="height:4px">
            <TD HEIGHT="4"></TD>
        </TR>
        <TR>
            <TD>紹介者名</TD>
            <TD>：</TD>
            <TD>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
                    <TR>
                        <TD ID="gdeIntro"><A HREF="javascript:callPersonGuide()"><IMG SRC="/webHains/images/question.gif" HEIGHT="21" WIDTH="21" ALT=""></A></TD>
                        <TD ID="delIntro"><A HREF="javascript:clearPerInfo()"><IMG SRC="/webHains/images/delicon.gif" HEIGHT="21" WIDTH="21" ALT=""></A></TD>
                        <TD NOWRAP><INPUT TYPE="hidden" NAME="introductor" VALUE="<%= strIntroductor %>"><SPAN ID="introductorName"><%= strName %></SPAN></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <!--TR style="height:4px">
            <TD HEIGHT="4"></TD>
        </TR-->

<% '#### 2013.3.1 SL-SN-Y0101-612 ADD START #### %>
        <TR>
            <TD HEIGHT="3" colspan=3><hr></TD>
        </TR>
        <TR>
            <TD NOWRAP>予約確認メール</TD>
            <TD>：</TD>
            <TD>
                <SELECT NAME="sendMailDiv">
                    <OPTION VALUE="0"<%= IIf(strSendMailDiv = "0", " SELECTED", "") %>>なし
                    <OPTION VALUE="1"<%= IIf(strSendMailDiv = "1", " SELECTED", "") %>>住所（自宅）
                    <OPTION VALUE="2"<%= IIf(strSendMailDiv = "2", " SELECTED", "") %>>住所（勤務先）
                    <OPTION VALUE="3"<%= IIf(strSendMailDiv = "3", " SELECTED", "") %>>住所（その他）
                </SELECT>
            </TD>
        </TR>
        <TR>
            <TD>メール送信日時</TD>
            <TD>：</TD>
            <TD><%= strSendMailDate %></TD>
        </TR>
        <TR>
            <TD>メール送信者</TD>
            <TD>：</TD>
            <TD><%= strSendMailUserName %></TD>
        </TR>
        <TR>
            <TD HEIGHT="3" colspan=3><hr></TD>
        </TR>
<% '#### 2013.3.1 SL-SN-Y0101-612 ADD END   #### %>

<% '## 2004.11.04 Add By T.Takagi@FSIT 前回受診日追加 %>
        <!--TR style="height:5px">
            <TD HEIGHT="5"></TD>
        </TR-->
        <TR>
            <TD>変更前予約日</TD>
            <TD>：</TD>
<%
            If strLastCslDate <> "" Then

                'オブジェクトのインスタンス作成
                Set objCommon = Server.CreateObject("HainsCommon.Common")
%>
                <TD><%= objCommon.FormatString(CDate(strLastCslDate), "yyyy年m月d日") %></TD>
<%
                Set objCommon = Nothing

            End If
%>
        </TR>
        <TR style="height:10px">
            <TD HEIGHT="10"></TD>
        </TR>
<% '## 2004.11.04 Add End %>
        <TR>
            <TD>更新日時</TD>
            <TD>：</TD>
            <TD><%= strUpdDate %></TD>
        </TR>
        <TR>
            <TD>更新者</TD>
            <TD>：</TD>
            <TD><%= strUpdUserName %></TD>
        </TR>
<%
'## 2004.10.27 Add By T.Takagi@FSIT 更新履歴への遷移追加
        '予約番号指定時
        If strRsvNo <> "" Then
%>
            <TR>
                <TD><A HREF="javascript:callConsultLogWindow()">更新履歴を見る</A></TD>
            </TR>
<%
        End If
'## 2004.10.27 Add End
%>
    </TABLE>
</FORM>
<%
'イネーブル制御
%>
<SCRIPT TYPE="text/javascript">
<!--
<%
'新規、キャンセル者、または保留状態の場合「印刷する」アンカーは不要
'#### 2007/04/04 張 予約状況区分追加によって修正 Start ####
'If strRsvNo = "" Or CLng("0" & strCancelFlg) <> CONSULT_USED Or strRsvStatus = "1" Then
If strRsvNo = "" Or CLng("0" & strCancelFlg) <> CONSULT_USED Or strRsvStatus <> "0" Then
'#### 2007/04/04 張 予約状況区分追加によって修正 End   ####
%>
    document.getElementById('print1').innerHTML = '';
    document.getElementById('print2').innerHTML = '';
    document.getElementById('print3').innerHTML = '';
<%
End If

'新規の場合「印刷状況を見る」アンカーは不要
If strRsvNo = "" Then
%>
    document.getElementById('prtStatus').innerHTML = '';
<%
End If

'キャンセル者の場合、すべての入力要素を使用不能にする
If CLng("0" & strCancelFlg) <> CONSULT_USED Then
%>
    var elem = document.entryForm.elements;
    for ( var i = 0; i < elem.length; i++ ) {
        elem[i].disabled = true;
    }

    document.getElementById('gdeIntro').innerHTML = '';
    document.getElementById('delIntro').innerHTML = '';
<%
End If

'受付済みの場合、予約状況は使用不能にする
If strDayId <> "" Then
%>
    document.entryForm.rsvStatus.disabled = true;
<%
End If

'請求書出力を表示しない場合
'## 2004.01.29 Mod By T.Takagi@FSIT 項目追加
'If strBillCslDiv = "" Then
If strBillCslDiv = "" And strReptCslDiv = "" Then
'## 2004.01.29 Mod End
%>
    setBillPrintVisibility( false );
<%
'請求書出力を表示する場合
Else
%>
    for ( var i = 0; i < document.entryForm.billPrintCntl.length; i++ ) {
        if ( document.entryForm.billPrintCntl[ i ].value == document.entryForm.billPrint.value ) {
            document.entryForm.billPrintCntl.selectedIndex = i;
            break;
        }
    }
<%
End If

'## 2004.01.13 Add By T.Takagi 保存時印刷制御方法変更
'オブジェクトのインスタンス作成
Set objCommon = Server.CreateObject("HainsCommon.Common")

'送付案内最新出力受診日と受診情報読み込み直後の受診日、及びはがき、送付案内の出力状態をフレーム親に渡す
%>
top.lastFormCslDate = '<%= objCommon.FormatString(strLastFormCslDate, "yyyymmdd") %>';
top.originCslDate   = '<%= objCommon.FormatString(strCslDate,         "yyyymmdd") %>';
top.cardPrinted     = <%= IIf(strCardPrintDate <> "", "true", "false") %>;
top.formPrinted     = <%= IIf(strFormPrintDate <> "", "true", "false") %>;
<%
Set objCommon = Nothing

'保存時印刷制御
%>
top.controlPrtOnSave( top.originCslDate );
<%
'## 2004.01.13 Add End
%>
//-->
</SCRIPT>
</BODY>
</HTML>

