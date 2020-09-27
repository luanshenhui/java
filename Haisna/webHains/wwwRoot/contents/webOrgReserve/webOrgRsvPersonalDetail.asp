<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      web予約情報登録(受診付属情報詳細) (Ver1.0.0)
'      AUTHER  : 
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objCommon           '共通クラス
Dim objOrganization     '団体情報アクセス用
Dim objPerson           '個人情報アクセス用

'引数値
Dim	strIntroductor      '紹介者
Dim strLastCslDate      '前回受診日
Dim strOrgCd1           '団体コード1
Dim strOrgCd2           '団体コード2
Dim blnReadOnly         '読み込み専用

'団体情報
Dim strBillCslDiv       '請求書本人家族区分出力
Dim strReptCslDiv       '成績書本人家族区分出力

'個人情報
Dim strLastName     '姓
Dim strFirstName    '名
Dim strName         '氏名

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
strIntroductor = Request("introductor")
strLastCslDate = Request("lastCslDate")
strOrgCd1      = Request("orgCd1")
strOrgCd2      = Request("orgCd2")
blnReadOnly    = (Request("readOnly") <> "")
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>受診付属情報</TITLE>
<!-- #include virtual = "/webHains/includes/perGuide.inc" -->
<SCRIPT TYPE="text/javascript">
<!--
// 個人検索ガイド呼び出し
function callPersonGuide() {
    perGuide_showGuidePersonal( document.entryForm.introductor, 'introductorName' );
}

// 個人情報のクリア
function clearPerInfo() {
    perGuide_clearPerInfo( document.entryForm.introductor, 'introductorName' );
}

// 入力チェック
function checkValue() {

    var main   = opener.top;
    var myForm = document.entryForm;

    var message = new Array();
    var ret     = true;

    // ボランティア名の文字列長チェック
    if ( main.getByte( myForm.volunteerName.value ) > 50 ) {
        message[ message.length ] = 'ボランティア名の入力内容が長すぎます。';
    }

    // 保険証記号の文字列長チェック
    if ( main.getByte( myForm.isrSign.value ) > 16 ) {
        message[ message.length ] = '保険証記号の入力内容が長すぎます。';
    }

    // 保険証番号の文字列長チェック
    if ( main.getByte( myForm.isrNo.value ) > 16 ) {
        message[ message.length ] = '保険証番号の入力内容が長すぎます。';
    }

    // 保険者番号の文字列長チェック
    if ( main.getByte( myForm.isrManNo.value ) > 16 ) {
        message[ message.length ] = '保険者番号の入力内容が長すぎます。';
    }

    // 社員番号の文字列長チェック
    if ( main.getByte( myForm.empNo.value ) > 12 ) {
        message[ message.length ] = '社員番号の入力内容が長すぎます。';
    }

    // メッセージ存在時は編集
    if ( message.length > 0 ) {
        main.editMessage( document.getElementById('errMsg'), message, true );
        ret = false;
    }

    return ret;
}

// 基本情報、受診付属情報での保持値を設定
function getPersonalValue() {

    var index      = 0;
    var main       = opener.top;
    var detailForm = main.detail.paramForm;
    var myForm     = document.entryForm;
    var calledForm = opener.document.entryForm;

    // 予約状況
    myForm.rsvStatus.value = calledForm.rsvStatus.value;

    // 保存時印刷
    main.setRadioValue( myForm.prtOnSave, main.getRadioValue( calledForm.prtOnSave ) );

    // 宛先
    myForm.cardAddrDiv.value   = calledForm.cardAddrDiv.value;
    myForm.formAddrDiv.value   = calledForm.formAddrDiv.value;
    myForm.reportAddrDiv.value = calledForm.reportAddrDiv.value;
    main.setRadioValue( myForm.cardOutEng,   main.getRadioValue( calledForm.cardOutEng )   );
    main.setRadioValue( myForm.formOutEng,   main.getRadioValue( calledForm.formOutEng )   );
    main.setRadioValue( myForm.reportOutEng, main.getRadioValue( calledForm.reportOutEng ) );

    // 診察券発行
    myForm.issueCslTicket.value = calledForm.issueCslTicket.value;

    // 以下は基本情報のhidden値より取得

    // 住所
    for ( var i = 0; i < detailForm.zipCd.length; i++ ) {
        var zipCd1 = detailForm.zipCd[ i ].value.substring(0, 3);
        var zipCd2 = detailForm.zipCd[ i ].value.substring(3, 7);
        document.getElementById('zipCd' + i).innerHTML = zipCd1 + ( ( zipCd2 != '' ) ? '-' : '' ) + zipCd2;
        document.getElementById('address' + i).innerHTML = detailForm.prefName[ i ].value + detailForm.cityName[ i ].value + detailForm.address1[ i ].value + detailForm.address2[ i ].value;
    }

    // ボランティア、ホランティア名
    myForm.volunteer.value     = detailForm.volunteer.value;
    myForm.volunteerName.value = detailForm.volunteerName.value;

    // 利用券回収
    myForm.collectTicket.value = ( detailForm.collectTicket.value != '' ) ? detailForm.collectTicket.value : '0';

    // 請求書出力
    if ( myForm.billPrint ) {
        myForm.billPrint.value = ( detailForm.billPrint.value != '' ) ? detailForm.billPrint.value : '0';
    }

    // 保険証記号、保険証番号、保険者番号、社員番号
    myForm.isrSign.value  = detailForm.isrSign.value;
    myForm.isrNo.value    = detailForm.isrNo.value;
    myForm.isrManNo.value = detailForm.isrManNo.value;
    myForm.empNo.value    = detailForm.empNo.value;

    // ボランティア
    for ( var i = 0; i < myForm.volunteer.length; i++ ) {
 //       alert(myForm.volunteer.options[ index ].value);
 //       alert(detailForm.volunteer.value);
        // 選択すべき要素であれば選択状態にする
        if ( myForm.volunteer.options[ index ].value == detailForm.volunteer.value ) {
            myForm.volunteer.options[ index ].selected = true;
        }
        index++;
    }


}

// 登録処理
function regist() {

    // 入力チェックを行い、正常ならば
    if ( checkValue() ) {

        // 基本情報、付属情報での保持値を更新
        setPersonalValue();

        // 画面を閉じる
        closeWindow();

    }

}

// 基本情報、受診付属情報での保持値を更新
function setPersonalValue() {

    var main       = opener.top;
    var detailForm = main.detail.paramForm;
    var myForm     = document.entryForm;
    var calledForm = opener.document.entryForm;

    // 予約状況
    calledForm.rsvStatus.value = myForm.rsvStatus.value;

    // 保存時印刷
    main.setRadioValue( calledForm.prtOnSave, main.getRadioValue( myForm.prtOnSave ) );

    // 宛先
    calledForm.cardAddrDiv.value   = myForm.cardAddrDiv.value;
    calledForm.formAddrDiv.value   = myForm.formAddrDiv.value;
    calledForm.reportAddrDiv.value = myForm.reportAddrDiv.value;
    main.setRadioValue( calledForm.cardOutEng,   main.getRadioValue( myForm.cardOutEng )   );
    main.setRadioValue( calledForm.formOutEng,   main.getRadioValue( myForm.formOutEng )   );
    main.setRadioValue( calledForm.reportOutEng, main.getRadioValue( myForm.reportOutEng ) );

    // 診察券発行
    calledForm.issueCslTicket.value = myForm.issueCslTicket.value;

    // 以下は基本情報のhidden値を更新

    // ボランティア、ホランティア名
    detailForm.volunteer.value     = myForm.volunteer.value;
    detailForm.volunteerName.value = myForm.volunteerName.value;

    // 利用券回収
    detailForm.collectTicket.value = ( myForm.collectTicket.value != '0' ) ? myForm.collectTicket.value : '';

    // 請求書出力
    if ( myForm.billPrint ) {
        detailForm.billPrint.value = ( myForm.billPrint.value != '0' ) ? myForm.billPrint.value : '';
    } else {
        detailForm.billPrint.value = '';
    }

    // 保険証記号、保険証番号、保険者番号、社員番号
    detailForm.isrSign.value     = myForm.isrSign.value;
    detailForm.isrNo.value       = myForm.isrNo.value;
    detailForm.isrManNo.value    = myForm.isrManNo.value;
    detailForm.empNo.value       = myForm.empNo.value;
    detailForm.introductor.value = myForm.introductor.value;

}

// 画面を閉じる
function closeWindow() {
    opener.closePersonalDetailWindow();
}

// 初期処理
function initialize() {

    // 基本情報、受診付属情報での保持値を設定
    getPersonalValue();
<%
    '読み取り専用時
    If blnReadOnly Then

        'すべての入力要素を使用不能にする
%>
        opener.top.disableElements( document.entryForm );

<%      'ボタンのクリア %>
        document.getElementById('saveButton').innerHTML  = '';
        document.getElementById('guideButton').innerHTML = '';
        document.getElementById('clearButton').innerHTML = '';
<%
    End If
%>
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 10px 0 0 10px; }
</style>
</HEAD>
<BODY ONLOAD="javascript:initialize()">
<FORM NAME="entryForm" action="#">
    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">受診付属情報</FONT></B></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="3">
        <TR>
            <TD ID="saveButton"><A HREF="javascript:regist()"><IMG SRC="/webHains/images/save.gif" WIDTH="77" HEIGHT="24" ALT="入力したデータを保存します"></A></TD>
            <TD><A HREF="javascript:closeWindow()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセル"></A></TD>
        </TR>
    </TABLE>
    <SPAN ID="errMsg"></SPAN>
    <BR>
    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
        <TR>
            <TD HEIGHT="5"></TD>
        </TR>
        <TR>
            <TD>予約状況</TD>
            <TD>：</TD>
            <TD>
                <SELECT NAME="rsvStatus">
                    <OPTION VALUE="0">確定
                    <OPTION VALUE="1">保留
                    <!--#### 2007/04/04 張 予約状況区分追加 Start ####-->
                    <OPTION VALUE="2">未確定
                    <!--#### 2007/04/04 張 予約状況区分追加 End   ####-->
                </SELECT>
            </TD>
        </TR>
        <TR>
            <TD HEIGHT="5"></TD>
        <TR>
        <TR>
            <TD>保存時印刷</TD>
            <TD>：</TD>
            <TD>
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                    <TR>
                        <TD><INPUT TYPE="radio" NAME="prtOnSave" VALUE="0"></TD>
                        <TD NOWRAP>なし</TD>
                        <TD><INPUT TYPE="radio" NAME="prtOnSave" VALUE="1"></TD>
                        <TD NOWRAP>はがき</TD>
                        <TD><INPUT TYPE="radio" NAME="prtOnSave" VALUE="2"></TD>
                        <TD NOWRAP>送付案内</TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD HEIGHT="5"></TD>
        </TR>
        <TR>
            <TD NOWRAP>宛先（確認はがき）</TD>
            <TD>：</TD>
            <TD>
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                    <TR>
                        <TD>
                            <SELECT NAME="cardAddrDiv">
                                <OPTION VALUE="1">住所（自宅）
                                <OPTION VALUE="2">住所（勤務先）
                                <OPTION VALUE="3">住所（その他）
                            </SELECT>
                        </TD>
                        <TD NOWRAP>　英文出力</TD>
                        <TD><INPUT TYPE="radio" NAME="cardOutEng" VALUE="1"></TD>
                        <TD>有</TD>
                        <TD><INPUT TYPE="radio" NAME="cardOutEng" VALUE="0"></TD>
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
                                <OPTION VALUE="1">住所（自宅）
                                <OPTION VALUE="2">住所（勤務先）
                                <OPTION VALUE="3">住所（その他）
                            </SELECT>
                        </TD>
                        <TD NOWRAP>　英文出力</TD>
                        <TD><INPUT TYPE="radio" NAME="formOutEng" VALUE="1"></TD>
                        <TD>有</TD>
                        <TD><INPUT TYPE="radio" NAME="formOutEng" VALUE="0"></TD>
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
                                <OPTION VALUE="1">住所（自宅）
                                <OPTION VALUE="2">住所（勤務先）
                                <OPTION VALUE="3">住所（その他）
                            </SELECT>
                        </TD>
                        <TD NOWRAP>　英文出力</TD>
                        <TD><INPUT TYPE="radio" NAME="reportOutEng" VALUE="1"></TD>
                        <TD>有</TD>
                        <TD><INPUT TYPE="radio" NAME="reportOutEng" VALUE="0"></TD>
                        <TD>無</TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
    <BR>
    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
        <TR VALIGN="top">
            <TD>住所（自宅）</TD>
            <TD>：</TD>
            <TD NOWRAP ID="zipCd0"></TD>
            <TD>&nbsp;&nbsp;</TD>
            <TD ID="address0"></TD>
        </TR>
        <TR VALIGN="top">
            <TD NOWRAP>住所（勤務先）</TD>
            <TD>：</TD>
            <TD NOWRAP ID="zipCd1"></TD>
            <TD></TD>
            <TD ID="address1"></TD>
        </TR>
        <TR VALIGN="top">
            <TD NOWRAP>住所（その他）</TD>
            <TD>：</TD>
            <TD NOWRAP ID="zipCd2"></TD>
            <TD></TD>
            <TD ID="address2"></TD>
        </TR>
    </TABLE>
    <BR>
    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
        <TR>
            <TD>ボランティア</TD>
            <TD>：</TD>
            <TD>
                <SELECT NAME="volunteer">
                    <OPTION VALUE="0">利用なし
                    <OPTION VALUE="1">通訳要
                    <OPTION VALUE="2">介護要
                    <OPTION VALUE="3">通訳＆介護要
                    <OPTION VALUE="4">車椅子要
                </SELECT>
            </TD>
        </TR>
        <TR>
            <TD NOWRAP>ボランティア名</TD>
            <TD>：</TD>
            <TD><INPUT TYPE="text" NAME="volunteerName" SIZE="50" MAXLENGTH="25" VALUE=""></TD>
        </TR>
        <TR>
            <TD HEIGHT="4"></TD>
        </TR>
        <TR>
            <TD>利用券回収</TD>
            <TD>：</TD>
            <TD>
                <SELECT NAME="collectTicket">
                    <OPTION VALUE="0">未回収
                    <OPTION VALUE="1">回収済
                </SELECT>
            </TD>
        </TR>
        <TR>
            <TD>診察券発行</TD>
            <TD>：</TD>
            <TD>
                <SELECT NAME="issueCslTicket">
                    <OPTION VALUE="">&nbsp;
                    <OPTION VALUE="1">新規
                    <OPTION VALUE="2">既存
                    <OPTION VALUE="3">再発行
                </SELECT>
            </TD>
        </TR>
<%
        '「請求書出力」の表示制御
        Do

            '団体コード未指定時は表示しない
            If strOrgCd1 = "" Or strOrgCd2 = "" Then
                Exit Do
            End If

            'オブジェクトのインスタンス作成
            Set objOrganization = Server.CreateObject("HainsOrganization.Organization")

            '団体情報を読み、請求書、成績書本人家族区分を取得
            objOrganization.SelectOrg_Lukes strOrgCd1, strOrgCd2, , , , , , , , , , , , , , , , , , , , , , , , , , , strBillCslDiv, , , , , , , , , , , , , , , , , , , , , , , strReptCslDiv

            'オブジェクトの解放
            Set objOrganization = Nothing

            'いずれも未指定ならば表示しない
            If strBillCslDiv = "" And strReptCslDiv = "" Then
                Exit Do
            End If
%>
            <TR>
                <TD><FONT COLOR="red"><B>請求書出力</B></FONT></TD>
                <TD>：</TD>
                <TD>
                    <SELECT NAME="billPrint">
                        <OPTION VALUE="0">指定なし
                        <OPTION VALUE="1">本人
                        <OPTION VALUE="2">家族
                    </SELECT>
                    </SPAN>
                </TD>
            </TR>
<%
            Exit Do
        Loop
%>
        <TR>
            <TD HEIGHT="4"></TD>
        </TR>
        <TR>
            <TD>保険証記号</TD>
            <TD>：</TD>
            <TD><INPUT TYPE="text" NAME="isrSign" SIZE="28" MAXLENGTH="16" VALUE=""></TD>
        </TR>
        <TR>
            <TD>保険証番号</TD>
            <TD>：</TD>
            <TD><INPUT TYPE="text" NAME="isrNo" SIZE="28" MAXLENGTH="16" VALUE=""></TD>
        </TR>
        <TR>
            <TD>保険者番号</TD>
            <TD>：</TD>
            <TD><INPUT TYPE="text" NAME="isrManNo" SIZE="28" MAXLENGTH="16" VALUE=""></TD>
        </TR>
        <TR>
            <TD HEIGHT="4"></TD>
        </TR>
        <TR>
            <TD>社員番号</TD>
            <TD>：</TD>
            <TD><INPUT TYPE="text" NAME="empNo" SIZE="20" MAXLENGTH="12" VALUE=""></TD>
        </TR>
        <TR>
            <TD HEIGHT="4"></TD>
        </TR>
<%
        '紹介者指定時
        If strIntroductor <> "" Then

            'オブジェクトのインスタンス作成
            Set objPerson = Server.CreateObject("HainsPerson.Person")

            '個人情報読み込み
            objPerson.SelectPerson_Lukes strIntroductor, strLastName, strFirstName

            'オブジェクトの解放
            Set objPerson = Nothing

            '姓名の結合
            strName = Trim(strLastName & "　" & strFirstName)

        End If
%>
        <TR>
            <TD>紹介者名</TD>
            <TD>：</TD>
            <TD>
                <TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">
                    <TR>
                        <TD ID="guideButton"><A HREF="javascript:callPersonGuide()"><IMG SRC="/webHains/images/question.gif" HEIGHT="21" WIDTH="21" ALT="個人検索ガイドを表示します"></A></TD>
                        <TD ID="clearButton"><A HREF="javascript:clearPerInfo()"><IMG SRC="/webHains/images/delicon.gif" HEIGHT="21" WIDTH="21" ALT="紹介者をクリアします"></A></TD>
                        <TD NOWRAP><INPUT TYPE="hidden" NAME="introductor" VALUE="<%= strIntroductor %>"><SPAN ID="introductorName"><%= strName %></SPAN></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD HEIGHT="5"></TD>
        </TR>
        <TR>
            <TD>前回受診日</TD>
            <TD>：</TD>
<%
            '前回受診日が存在する場合
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
    </TABLE>
</FORM>
</BODY>
</HTML>
