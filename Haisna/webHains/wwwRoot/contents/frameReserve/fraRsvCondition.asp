<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'        予約枠検索(検索条件) (Ver0.0.1)
'        AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/editMessage.inc"    -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const FREECD_FRARSVINIT = "FRARSVINIT"      '汎用コード(予約枠検索初期設定用)
Const CONDITION_COUNT   = 4                 '入力条件数

Const MODE_NORMAL       = "0"    '予約人数再帰検索モード(オーバを空きなしとして判定)
Const MODE_SAME_RSVGRP  = "1"    '予約人数再帰検索モード(オーバを空きありとして判定)

'データベースアクセス用オブジェクト
Dim objCommon           '共通クラス
Dim objFree             '汎用情報アクセス用
'Dim obj  '

'初期設定
Dim strDayAfter         'システム日付からのスライド日数
Dim lngDayAfter         'システム日付からのスライド日数
Dim strMaxCount         '一度に予約可能な受診情報の上限数
Dim lngMaxCount         '一度に予約可能な受診情報の上限数

'受診日
Dim dtmCslDate          '受診年月日
Dim strCslYear          '受診年
Dim strCslMonth         '受診月
Dim strCslDay           '受診日

'団体
Dim strOrgCd1           '団体コード１
Dim strOrgCd2           '団体コード２

Dim strCsCd             'コースコード
Dim strCslDivCd         '受診区分コード

Dim strBirthStart       '生年月日（年）開始
Dim strBirthDefault     '生年月日（年）初期値
Dim lngStartValue       '開始年
Dim lngEndValue         '終了年

Dim strArrYear          '西暦年の配列
Dim strArrEraCode       '元号(コード表記)の配列
Dim strArrEraName       '元号(日本語表記)の配列
Dim i                   'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon = Server.CreateObject("HainsCommon.Common")
Set objFree   = Server.CreateObject("HainsFree.Free")

'初期値の設定

'初期設定情報を汎用テーブルから取得
objFree.SelectFree 0, FREECD_FRARSVINIT, , , , strDayAfter, strMaxCount

Set objFree = Nothing

'スライド日数の設定
If IsNumeric(strDayAfter) Then
    If CLng(strDayAfter) >= 0 Then
        lngDayAfter = CLng(strDayAfter)
    End If
End If

'登録可能最大人数の設定
lngMaxCount = 0
If IsNumeric(strMaxCount) Then
    If CLng(strMaxCount) >= 0 Then
        lngMaxCount = CLng(strMaxCount)
    End If
End If

'初期表示受診日をシステム年月日から日数分スライド
dtmCslDate = DateAdd("d", lngDayAfter, Date())
strCslYear  = CStr(Year(dtmCslDate))
strCslMonth = CStr(Month(dtmCslDate))
strCslDay   = CStr(Day(dtmCslDate))

'個人受診用の団体コード取得
objCommon.GetOrgCd ORGCD_KEY_PERSON, strOrgCd1, strOrgCd2

'コースコードの初期値は「１日人間ドック」
strCsCd = "100"

'※（汎用テーブルより）

'受診区分コードの初期値は「指定なし」
strCslDivCd = "CSLDIV000"

'和暦タグ作成のための初期値を取得
objCommon.SelectYearsRangeBirth strBirthStart, strBirthDefault

'開始年は初期値を使用する
lngStartValue = Clng("0" & strBirthStart)

'終了年は現在年を使用する
lngEndValue = Year(Date())

'西暦、和暦年の情報を取得
objCommon.GetEraYearArray lngStartValue, lngEndValue, strArrYear, strArrEraCode, strArrEraName

Set objCommon = Nothing

'-------------------------------------------------------------------------------
'
' 機能　　 : 和暦のSELECTタグ生成
'
' 引数　　 : (In)     strElementName  エレメント名
'
' 戻り値　 : SELECTタグ
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Function EditEraYearList(strElementName)

    Dim strHtml    'HTML文字列
    Dim i        'インデックス

    'SELECTタグ編集開始
    strHtml = "<SELECT NAME=""" & strElementName & """>"

    'OPTIONタグの編集
    For i = 0 To UBound(strArrYear)

        'タグを追加
        strHtml = strHtml & "<OPTION VALUE=""" & strArrYear(i) & """>" & strArrEraName(i) & "年（" & strArrYear(i) & "）"

        '現編集年が生年月日の初期値と等しい場合は空白行を作成する
        If strArrYear(i) = CLng(strBirthDefault) Then
            strHtml = strHtml & "<OPTION VALUE="""" SELECTED>"
        End If

    Next

    'SELECTタグ編集終了
    strHtml = strHtml & "</SELECT>"

    EditEraYearList = strHtml

End Function
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 TRANSITIONAL//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>予約枠検索</TITLE>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<!-- #include virtual = "/webHains/includes/orgGuide.inc" -->
<!-- #include virtual = "/webHains/includes/perGuide.inc" -->
<!-- #include virtual = "/webHains/includes/setInfo.inc"  -->
<SCRIPT TYPE="text/javascript">
<!-- #include virtual = "/webHains/includes/date.inc"     -->
<!--
var winNote;
var curYear, curMonth, curDay;            // 現在の日付
var curPerId, selPerIndex;                // 現在の個人ＩＤとそのインデックス
var curOrgCd1, curOrgCd2, selOrgIndex;    // 現在の団体コードとそのインデックス
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 日付ガイド呼び出し
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
%>
function callCalGuide() {
    calGuide_showGuideCalendar( 'cslYear', 'cslMonth', 'cslDay', checkDateChanged );
}
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 受診日変更チェック
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
%>
function checkDateChanged() {

    var objYear  = dateForm.cslYear;
    var objMonth = dateForm.cslMonth;
    var objDay   = dateForm.cslDay;

    // 退避していた日付と同一な場合は何もしない
    if ( objYear.value == curYear && objMonth.value == curMonth && objDay.value == curDay ) return;

    for ( var ret = false; ; ) {

        // 日付チェック
        if ( !isDate( objYear.value, objMonth.value, objDay.value ) ) {
            alert('受診日の値が正しくありません。');
            break;
        }

        // 受診日が過去かをチェック
        var sysDate = new Date();
        var date1 = sysDate.getFullYear() * 10000 + ( sysDate.getMonth() + 1 ) * 100 + sysDate.getDate();
        var date2 = parseInt(objYear.value) * 10000 + parseInt(objMonth.value) * 100 + parseInt(objDay.value);
        if ( date2 < date1 ) {
            alert('過去の日付は指定できません。');
            break;
        }

        ret = true;
        break;
    }

    // エラー時は変更前の値に戻す
    if ( !ret ) {
        objYear.value  = curYear;
        objMonth.value = curMonth;
        objDay.value   = curDay;
        return;
    }

    // 現在の日付を退避
    curYear  = objYear.value;
    curMonth = objMonth.value;
    curDay   = objDay.value;

    // すべての検索条件に対する動的制御
    for ( var i = 0; i < document.entryForm.length; i++ ) {
        conditionControlChanged( i );
    }

}
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 検索処理
'
' 引数　　 : (In)     mode   検索モード
' 　　　　   (In)     index  指定された検索条件のインデックス
'
' 戻り値　 :
'
'-------------------------------------------------------------------------------
%>
function search( index ) {

    var mode;                // 検索モード
    var strIndex, endIndex;    // 検索対象フォームの開始・終了インデックス
    var i, j;                // インデックス
    var ret;                // 関数戻り値

    // 検索モードの決定
    if ( document.dateForm.nearly.checked ) {
        mode = '<%= MODE_SAME_RSVGRP %>';
    } else {
        mode = '<%= MODE_NORMAL %>';
    }

    // 全検索条件を検索する場合、指定インデックスのみを検索する場合ごとにインデックス範囲を定義
    if ( index == null ) {
        strIndex = 0;
        endIndex = document.entryForm.length - 1;
    } else {
        strIndex = index;
        endIndex = index;
    }

    // 検索条件の集合を取得
    var entries = new Array();
    if ( !getEntries( entries, strIndex, endIndex ) ) {
        return;
    }

    // 検索条件集合の関連チェック
    if ( !checkEntries( mode, entries ) ) {
        return;
    }

    // パラメータ設定
    setParam( mode, entries );

    // カレンダー検索画面呼び出し
    callCalendar();

}
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 検索条件の集合を取得
'
' 引数　　 : (In)     entries   検索条件の集合
' 　　　　   (In)     strIndex  検索対象フォームの開始インデックス
' 　　　　   (In)     endIndex  検索対象フォームの終了インデックス
'
' 戻り値　 : true   正常終了
' 　　　　   false  エラーあり
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
%>
function getEntries( entries, strIndex, endIndex ) {

    var msg = '検索条件が確定後変更されていなす。変更内容を有効にするには確定ボタンをクリックして下さい。';

    var entry;    // 検索条件情報クラス

// ## 2004.10.01 Add By T.Takagi@FSIT セット自体が存在しない場合はカレンダー検索させない
    var existsNoSetCondition = false;    // セットなし検索条件の有無
// ## 2004.10.01 Add End

    // 検索条件フォームを検索
    for ( var i = strIndex, ret = true; i <= endIndex; i++ ) {

        // 検索条件情報の取得
        entry = new top.entryInfo( i );

        // チェック
        switch ( checkEntry( i, entry ) ) {

            // 現在の入力内容と異なる場合
            case -1:

                // インデックスの指定状態によるメッセージ制御
                if ( strIndex != endIndex ) {
                    alert( ( i + 1 ) + '番目の' + msg );
                } else {
                    alert( msg );
                }

                ret = false;
                break;

            // 条件がそろっていない場合
            case 0:
                break;

            // 条件が揃っていれば追加
            default:
                entries[ entries.length ] = entry;

// ## 2004.10.01 Add By T.Takagi@FSIT セット自体が存在しない場合はカレンダー検索させない
                var objForm = document.entryForm[ i ];
                var existsOption = false;

                // 全エレメントからオプションのエレメントが存在するかを検索
                for ( var j = 0; j < objForm.elements.length; j++ ) {
                    if ( objForm.elements[ j ].name.indexOf( 'opt' ) == 0 ) {
                        existsOption = true;
                        break;
                    }
                }

                // オプションのエレメントが存在しない場合はフラグ成立
                if ( !existsOption ) {
                    existsNoSetCondition = true;
                }
// ## 2004.10.01 Add End
        }

    }

// ## 2004.10.01 Add By T.Takagi@FSIT セット自体が存在しない場合はカレンダー検索させない
    if ( existsNoSetCondition ) {
        alert( 'セットの存在しない検索条件があります。カレンダー検索はできません。' );
        return false;
    }
// ## 2004.10.01 Add End

    // 入力内容が一つでも異なれば検索条件の集合は返さない
    if ( !ret ) {

        entries.length = 0;

    } else {

        // 検索可能な条件が存在しない場合
        if ( entries.length == 0 ) {
            alert('検索可能な条件が存在しません。');
            ret = false;
        }

    }

    return ret;

}
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 検索条件のチェック
'
' 引数　　 : (In)     index  検索条件のインデックス
' 　　　　   (In)     entry  検索条件情報クラス
'
' 戻り値　 : 1   エラーなし
' 　　　　   0   検索条件が満たされていない
' 　　　　   -1  検索条件が確定後、変更されている
'
'-------------------------------------------------------------------------------
%>
function checkEntry( index, entry ) {

    // 検索条件情報の検索
    for ( var ret = -1; ; ) {

        // 検索条件が揃っていなければ終了
        if ( !entry.conditionFilled() ) {
            ret = 0;
            break;
        }

        // 個人指定であればチェック終了
        if ( entry.perId != '' ) {
            ret = 1;
            break;
        }

        // 個人指定でない場合、現在の入力内容と確定内容との比較を行う

        // 現在の入力内容をチェックし、エラーなら内容が変更されているに他ならない
        if ( checkCondition( index ) <= 0 ) {
            break;
        }

        // 正常であれば人数・性別・生年月日・年齢の内容比較を行う
        var objForm = document.entryForm[ index ];
        var manCnt  = parseInt(objForm.entManCnt.value, 10);
        var gender  = getGender( index );
        var birth   = formatDate( objForm.bYear.value, objForm.bMonth.value, objForm.bDay.value );
        var age     = parseInt(objForm.entAge.value, 10);

        // 人数・性別・生年月日のいずれかが変更されていれば終了
        if ( manCnt != entry.manCnt || gender != entry.gender || birth != entry.birth ) {
            break;
        }

        // 年齢直接指定時は年齢内容が変更されていれば終了
        if ( birth == '' ) {
            if ( age != entry.age ) {
                break;
            }
        }

        ret = 1;
        break;
    }

    return ret;
}
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 検索条件集合の関連チェック
'
' 引数　　 : (In)     mode     検索モード
' 　　　　   (In)     entries  検索条件情報の集合
'
' 戻り値　 : true   エラーなし
' 　　　　   false  エラーあり
'
' 備考　　 : ここでは個人の重複、予約最大件数、同じ群で検索する場合の群指定をチェック
'
'-------------------------------------------------------------------------------
%>
function checkEntries( mode, entries ) {

    var rsvGrpCount   = 0;
    var noRsvGrpCount = 0;
    var maxCount      = <%= lngMaxCount %>;
    var rsvCount      = 0;

    // 検索条件の集合を検索
    for ( var i = 0, ret = true; i < entries.length; i++ ) {

        // 予約群指定、未指定をそれぞれカウント
        if ( entries[ i ].rsvGrpCd != '' ) {
            rsvGrpCount++;
        } else {
            noRsvGrpCount++;
        }

        // 個人ＩＤ未指定時は予約人数のカウントのみ行う
        if ( entries[ i ].perId == '' ) {
            rsvCount = rsvCount + parseInt(entries[ i ].manCnt, 10);
            continue;
        }

        // 以下は個人ＩＤ指定時

        // 予約人数のカウント
        rsvCount++;

        // 個人ＩＤの重複チェック
        for ( var j = 0; j < i; j++ ) {
            if ( entries[ j ].perId == entries[ i ].perId ) {
                alert('同一個人が複数指定されています。検索できません。');
                ret = false;
            }
        }

        // 重複エラー時は検索を終了
        if ( !ret ) break;

    }

    // エラーがなければ
    while ( ret ) {

        // 同じ群で検索する場合、予約群指定、未指定の混在は許さない
        if ( mode == '<%= MODE_SAME_RSVGRP %>' ) {
            if ( rsvGrpCount > 0 && noRsvGrpCount > 0 ) {
                alert('より近い時間枠で検索する場合、予約群は全て設定するか、もしくは全て未指定状態で検索してください。');
                ret = false;
                break;
            }
        }

        // 上限数が設定されていなければチェック終了
        if ( maxCount == 0 )  break;

        // 上限数チェック
        if ( rsvCount > maxCount ) {
            alert('現在の条件では一度に登録可能な予約の上限数をオーバーします。検索できません。');
            ret = false;
        }

        break;
    }

    return ret;

}
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : パラメータ設定
'
' 引数　　 : (In)     mode     検索モード
' 　　　　 : (In)     entries  検索条件クラスの集合
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
%>
function setParam( mode, entries ) {

    var perId = '';
    var manCnt = '';
    var gender = '';
    var birth = '';
    var age = '';
    var romeName = '';
    var orgCd1 = '';
    var orgCd2 = '';
    var cslDivCd = '';
    var csCd = '';
    var rsvGrpCd = '';
    var ctrPtCd = '';
    var rsvNo = '';
    var optCd = '';
    var optBranchNo = '';

    var sep = '';

    // 配列への編集
    for ( var i = 0; i < entries.length; i++ ) {
        sep = ( i > 0 ) ? '\x01' : '';
        perId       = perId       + sep + entries[ i ].perId;
        manCnt      = manCnt      + sep + entries[ i ].manCnt;
        gender      = gender      + sep + entries[ i ].gender;
        birth       = birth       + sep + entries[ i ].birth;
        age         = age         + sep + entries[ i ].age;
        romeName    = romeName    + sep + entries[ i ].romeName;
        orgCd1      = orgCd1      + sep + entries[ i ].orgCd1;
        orgCd2      = orgCd2      + sep + entries[ i ].orgCd2;
        cslDivCd    = cslDivCd    + sep + entries[ i ].cslDivCd;
        csCd        = csCd        + sep + entries[ i ].csCd;
        rsvGrpCd    = rsvGrpCd    + sep + entries[ i ].rsvGrpCd;
        ctrPtCd     = ctrPtCd     + sep + entries[ i ].ctrPtCd;
        rsvNo       = rsvNo       + sep + entries[ i ].rsvNo;
        optCd       = optCd       + sep + entries[ i ].optCd;
        optBranchNo = optBranchNo + sep + entries[ i ].optBranchNo;
    }

    // エレメントへの編集
    var paraForm = document.paramForm;
    paraForm.mode.value        = mode;
    paraForm.cslYear.value     = curYear;
    paraForm.cslMonth.value    = curMonth;
    paraForm.perId.value       = perId;
    paraForm.manCnt.value      = manCnt;
    paraForm.gender.value      = gender;
    paraForm.birth.value       = birth;
    paraForm.age.value         = age;
    paraForm.romeName.value    = romeName;
    paraForm.orgCd1.value      = orgCd1;
    paraForm.orgCd2.value      = orgCd2;
    paraForm.cslDivCd.value    = cslDivCd;
    paraForm.csCd.value        = csCd;
    paraForm.rsvGrpCd.value    = rsvGrpCd;
    paraForm.ctrPtCd.value     = ctrPtCd;
    paraForm.rsvNo.value       = rsvNo;
    paraForm.optCd.value       = optCd;
    paraForm.optBranchNo.value = optBranchNo;

}
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : カレンダー検索画面呼び出し
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
%>
function callCalendar() {

    var opened = false;    // 画面が開かれているか

    // 絶対に重複しないウィンドウ名を現在時間から作成
    var d = new Date();
    var windowName = 'W' + d.getHours() + d.getMinutes() + d.getSeconds() + d.getMilliseconds()

    // 空のウィンドウを開く
    open('', windowName, 'status=yes,directories=no,menubar=no,resizable=yes,scrollbars=yes,toolbar=no,location=no,width=700,height=500');

    // ターゲットを指定してsubmit
    document.paramForm.target = windowName;
    document.paramForm.submit();

}
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 個人検索ガイド呼び出し
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
%>
function callPersonGuide( index ) {

    // 現在の個人ＩＤとそのインデックスとを退避
    curPerId = document.entryForm[ index ].perId.value;
    selPerIndex = index;

    // 編集用の関数定義
    perGuide_CalledFunction = checkPerChanged;

    // ガイド画面を表示
    perGuide_openWindow( '/webHains/contents/guide/gdePersonal.asp?mode=1' );
//    perGuide_openWindow( '/webHains/contents/guide/gdePersonal.asp?mode=1&defPerId=' + curPerId );

}
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 個人選択時の画面制御処理
'
' 引数　　 : (In)     perInfo  個人情報クラス
'
' 戻り値　 :
'
' 備考　　 : 個人情報クラスの詳細はgdeSelectPerson.aspを参照
'
'-------------------------------------------------------------------------------
%>
function checkPerChanged( perInfo ) {
    conditionControlPerson( selPerIndex, perInfo );
}
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 個人クリア時の画面制御処理
'
' 引数　　 : (In)     index  検索条件のインデックス
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
%>
function clearPerson( index ) {

    // 個人が指定されている場合のみ制御
    if ( document.entryForm[ index ].perId.value != '' ) {
        conditionControlPerson( index );
    }

}

<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 個人情報の適用および検索条件の動的制御
'
' 引数　　 : (In)     index    検索条件のインデックス
' 　　　　   (In)     perInfo  個人情報クラス
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
%>
function conditionControlPerson( index, perInfo ) {

    // 現在の団体・コース・受診区分を取得
    var objForm = document.entryForm[ index ];
    var orgCd1   = objForm.orgCd1.value;
    var orgCd2   = objForm.orgCd2.value;
    var csCd     = objForm.csCd.value;
    var cslDivCd = objForm.cslDivCd.value;

    var rsvNo    = objForm.rsvNo;

    // 制御要否のチェック
    for ( ; ; ) {

        // 個人情報がクリアされた場合は要制御
        if ( perInfo == null ) break;

        // 個人が変更されている場合は要制御
        if ( perInfo.perId != curPerId ) break;

        // 個人が変更されていない場合

        // 団体・コース・受診区分が指定されていない場合、制御処理は行わない(必ず３つ同時に指定されるので１項目のみチェック)
        if ( perInfo.lastOrgCd1 == null ) return;

        // 団体・コース・受診区分・継承すべき予約番号が変更されていない場合、制御処理は行わない
        if ( perInfo.lastOrgCd1 == orgCd1 && perInfo.lastOrgCd2 == orgCd2 && perInfo.csCd == csCd && perInfo.cslDivCd == cslDivCd && perInfo.rsvNo == rsvNo.value ) return;

        break;
    }

    // 個人指定の優先性により、確定情報としての人数・性別・生年月日・年齢はクリア
    objForm.manCnt.value = '';
    objForm.gender.value = '';
    objForm.birth.value  = '';
    objForm.age.value    = '';

    // 個人ＩＤの設定
    var perId = '';
    if ( perInfo != null ) {
        perId = perInfo.perId;
    }

    // 個人が選択された場合
    if ( perInfo != null ) {

        // 受診歴が選択された場合
        if ( perInfo.lastOrgCd1 != null ) {

            // 団体・コース・受診区分が指定されている場合はその値を適用
            orgCd1   = perInfo.lastOrgCd1;
            orgCd2   = perInfo.lastOrgCd2;
            csCd     = perInfo.csCd;
            cslDivCd = perInfo.cslDivCd;

            // 継承すべき予約番号を適用
            rsvNo.value = perInfo.rsvNo;

        // 受診歴未選択の場合
        } else {

            // 継承すべき予約番号には何もセットしない
            rsvNo.value = '';

        }

    // 個人がクリアされた場合
    } else {

        // 継承すべき予約番号もクリア
        rsvNo.value = '';

    }
    // 検索条件に対する動的制御
    conditionControl( index, perId, orgCd1, orgCd2, csCd, cslDivCd, objForm.rsvGrpCd.value, objForm.ctrPtCd.value );

}
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 受診歴一覧表示
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
%>
function callDayliListWindow( perId ) {

    if ( perId != '' ) {
        open('/webHains/contents/common/dailyList.asp?navi=1&key=ID:' + perId + '&sortKey=12&sortType=1');
    }

}
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 夫婦でセット
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
%>
function compSetControl() {

    // １番目の個人ＩＤに対する同伴者個人ＩＤで動的制御
    var perId =  document.entryForm[ 0 ].compPerId.value;

    var objForm = document.entryForm[ 1 ];

    // 現在の個人と異なる場合、まずは継承すべき予約番号をクリアする
    if ( perId != objForm.perId.value ) {
        objForm.rsvNo.value = '';
    }

    conditionControl( 1, perId, objForm.orgCd1.value, objForm.orgCd2.value, objForm.csCd.value, objForm.cslDivCd.value, objForm.rsvGrpCd.value, objForm.ctrPtCd.value );

}
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 性別、年齢直接指定時の制御
'
' 引数　　 : (In)     index  検索条件のインデックス
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
%>
function conditionControlApply( index ) {

    var objForm = document.entryForm[ index ];

    // すでに個人ＩＤが決定しているならそちらを優先するため、何もしない
    if ( objForm.perId.value != '' ) {
        return;
    }

    // 検索条件のチェック
    switch ( checkCondition( index ) ) {
        case 0:
            alert('検索条件を入力して下さい。');
            return;
        case -1:
            alert('人数を入力して下さい。');
            return;
        case -2:
            alert('人数には１以上の値を入力して下さい。');
            return;
        case -3:
            alert('性別を選択して下さい。');
            return;
        case -4:
            alert('生年月日もしくは年齢を入力して下さい。');
            return;
        case -5:
            alert('生年月日の値が正しくありません。');
            return;
        case -6:
            alert('年齢を入力して下さい。');
            return;
        case -7:
            alert('年齢の値が正しくありません。');
            return;
        case -8:
            alert('ローマ字名は半角で入力して下さい。');
            return;
        default:
    }

    // 正常であれば人数・性別・生年月日・年齢を確定情報として格納
    objForm.entManCnt.value = parseInt(objForm.entManCnt.value, 10);
    objForm.manCnt.value    = objForm.entManCnt.value;
    objForm.gender.value    = getGender( index );
    objForm.birth.value     = formatDate( objForm.bYear.value, objForm.bMonth.value, objForm.bDay.value );
    objForm.age.value       = objForm.birth.value == '' ? parseInt(objForm.entAge.value, 10) : '';

    // 検索条件に対する動的制御
    conditionControl( index, '', objForm.orgCd1.value, objForm.orgCd2.value, objForm.csCd.value, objForm.cslDivCd.value, objForm.rsvGrpCd.value, objForm.ctrPtCd.value );

}
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 検索条件(人数・性別・生年月日・年齢)のチェック
'
' 引数　　 : (In)     index  検索条件のインデックス
'
' 戻り値　 : 1   エラーなし
' 　　　　   0   何も入力されていない
' 　　　　   -1  人数未入力
' 　　　　   -2  人数の値が不正
' 　　　　   -3  性別未選択
' 　　　　   -4  生年月日・性別がともに入力されていない
' 　　　　   -5  生年月日の値が不正
' 　　　　   -6  年齢未入力
' 　　　　   -7  年齢の値が不正
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
%>
function checkCondition( index ) {

    var objForm  = document.entryForm[ index ];
    var manCnt   = objForm.entManCnt.value;
    var gender   = getGender( index );
    var bYear    = objForm.bYear.value;
    var bMonth   = objForm.bMonth.value;
    var bDay     = objForm.bDay.value;
    var age      = objForm.entAge.value;
    var romeName = objForm.romeName.value;

    var birthEntried = ( bYear != '' || bMonth != '' || bDay != '' );
    var ret;

    for ( ; ; ) {

        // 何も入力されていない場合
        if ( manCnt == '' && gender == '' && ( !birthEntried ) && age == '' ) {
            ret = 0;
            break;
        }

        // 人数チェック

        // 必須チェック
        if ( manCnt == '' ) {
            ret = -1;
            break;
        }

        // 数値チェック
        if ( !manCnt.match('^[0-9]+$') ) {
            ret = -2;
            break;
        }

        // 数値チェック
        if ( parseInt(manCnt, 10) <= 0 ) {
            ret = -2;
            break;
        }

        // 性別チェック
        if ( gender == '' ) {
            ret = -3;
            break;
        }

        // 生年月日・性別のいずれも入力されていない場合
        if ( ( !birthEntried ) && age == '' ) {
            ret = -4;
            break;
        }

        // 生年・月・日のいずれかが入力されている場合はこちらを優先
        if ( birthEntried ) {

            // 必須チェック
            if ( bYear == '' || bMonth == '' || bDay == '' ) {
                ret = -5;
                break;
            }

            // 日付チェック
            if ( !isDate( bYear, bMonth, bDay ) ) {
                ret = -5;
                break;
            }

            ret = 1;
            break;
        }

        // 年齢チェック

        // 必須チェック
        if ( age == '' ) {
            ret = -6;
            break;
        }

        // 数値チェック
        if ( !age.match('^[0-9]+$') ) {
            ret = -7;
            break;
        }

        for ( var ret2 = true, i = 0; i < romeName.length; i++ ) {
            if ( escape(romeName.charAt(i)).length >= 4 ) {
                ret2 = false;
                break;
            }
        }

        if ( !ret2 ) {
            ret = -8;
            break;
        }

        ret = 1;
        break;
    }

    return ret;
}
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 団体ガイド呼び出し
'
' 引数　　 : (In)     index  検索条件のインデックス
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
%>
function callOrgGuide( index ) {

    var objForm = document.entryForm[ index ];

    // 現在の団体コードとそのインデックスとを退避
    curOrgCd1 = objForm.orgCd1.value;
    curOrgCd2 = objForm.orgCd2.value;
    selOrgIndex = index;

    // 団体ガイド呼び出し
    orgGuide_showGuideOrg( objForm.orgCd1, objForm.orgCd2, null, null, null, checkOrgChanged );

}
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 団体変更チェック
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
%>
function checkOrgChanged() {

    var objForm = document.entryForm[ selOrgIndex ];

    // 団体が変更された場合は団体情報を編集し、かつ制御処理へ
    if ( objForm.orgCd1.value != curOrgCd1 || objForm.orgCd2.value != curOrgCd2 ) {
        conditionControlChanged( selOrgIndex );
    }

}
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : エレメント値変更時の画面制御処理
'
' 引数　　 : (In)     index  検索条件のインデックス
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
%>
function conditionControlChanged( index ) {

    var objForm = document.entryForm[ index ];

    // 検索条件に対する動的制御
    conditionControl( index, objForm.perId.value, objForm.orgCd1.value, objForm.orgCd2.value, objForm.csCd.value, objForm.cslDivCd.value, objForm.rsvGrpCd.value, objForm.ctrPtCd.value );

}
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 検索条件の動的制御処理
'
' 引数　　 : (In)     index     検索条件のインデックス
' 　　　　 : (In)     perId     個人ＩＤ
' 　　　　 : (In)     orgCd1    団体コード１
' 　　　　 : (In)     orgCd2    団体コード２
' 　　　　 : (In)     csCd      コースコード
' 　　　　 : (In)     cslDivCd  受診区分コード
' 　　　　 : (In)     rsvGrpCd  予約群コード
' 　　　　 : (In)     ctrPtCd   契約パターンコード
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
%>
function conditionControl( index, perId, orgCd1, orgCd2, csCd, cslDivCd, rsvGrpCd, ctrPtCd ) {

    // 検索条件クラスのインスタンス作成
    var ent = new top.entryInfo( index );
    // URLの編集
    var url = '/webHains/contents/frameReserve/fraRsvControl.asp';
    url = url + '?cslDate='     + curYear + '/' + curMonth + '/' + curDay;
    url = url + '&condIndex='   + index;
    url = url + '&perId='       + perId;
    url = url + '&gender='      + ent.gender;
    url = url + '&birth='       + ent.birth;
    url = url + '&age='         + ent.age;
    url = url + '&orgCd1='      + orgCd1;
    url = url + '&orgCd2='      + orgCd2;
    url = url + '&csCd='        + csCd;
    url = url + '&cslDivCd='    + cslDivCd;
    url = url + '&rsvGrpCd='    + rsvGrpCd;
    url = url + '&ctrPtCd='     + ctrPtCd;
    url = url + '&optCd='       + ent.optCd;
    url = url + '&optBranchNo=' + ent.optBranchNo;

    // フレームの更新
    top.frames[ 'ctrl' + index ].location.replace( url );

}
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 性別値の取得
'
' 引数　　 : (In)     index  検索条件のインデックス
'
' 戻り値　 : 1     男性
' 　　　　   2     女性
' 　　　　   なし  性別未選択
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
%>
function getGender( index ) {

    var objGender = document.entryForm[ index ].elements('selGender');
    for ( var i = 0, ret = ''; i < objGender.length; i++ ) {
        if ( objGender[ i ].checked ) {
            ret = objGender[ i ].value;
            break;
        }
    }

    return ret;
}
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 予約人数一覧画面を開く
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
%>
function showCapacityList() {


    var url = '/webHains/contents/maintenance/capacity/mntCapacityList.asp';
    url = url + '?cslYear='  + document.dateForm.cslYear.value;
    url = url + '&cslMonth=' + document.dateForm.cslMonth.value;
    url = url + '&cslDay='   + document.dateForm.cslDay.value;
// ## 2004.02.14 Mod By H.Ishihara@FSIT
//    url = url + '&mode='     + 'all';
    url = url + '&mode='     + 'disp';
// ## 2004.02.14 Mod End
    open( url );

}

/** コメント画面ポップアップで表示 **/
function showComment(index){

    var url = document.entryForm[ index ].hiddenUrl.value;
    var opened = false;    // 画面が開かれているか

    // すでにガイドが開かれているかチェック
    if ( winNote != null ) {
        if ( !winNote.closed ) {
            opened = true;
        }
    }

    if ( opened ) {
        winNote.focus();
        winNote.location.replace( url );
    } else {
        winNote = window.open(url, '', 'width=800,height=660,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes');
    }
}
<%
'-------------------------------------------------------------------------------
'
' 機能　　 : 各種ガイド画面を閉じる
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
%>
function closeWindow() {

    calGuide_closeGuideCalendar();
    perGuide_closeGuidePersonal();
    orgGuide_closeGuideOrg();
    closeSetInfoWindow();
   
    if ( winNote ) {
        if ( !winNote.closed ) {
            winNote.close();
        }
    }
}

//-->
</SCRIPT>
<style type="text/css">
	body { margin: 0px 0 0 25px; }
</style>
</HEAD>
<BODY ONUNLOAD="javascript:closeWindow()">
<FORM NAME="dateForm" ACTION="" STYLE="margin: 0px;">
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
        <TR>
            <TD NOWRAP HEIGHT="40">受診日：</TD>
            <TD><A HREF="javascript:callCalGuide()"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="日付ガイドを表示します"></A></TD>
            <TD><%= EditNumberList("cslYear", YEARRANGE_MIN, YEARRANGE_MAX, strCslYear, False) %></TD>
            <TD>年</TD>
            <TD><%= EditNumberList("cslMonth", 1, 12, strCslMonth, False) %></TD>
            <TD>月</TD>
            <TD><%= EditNumberList("cslDay", 1, 31, strCslDay, False) %></TD>
            <TD>日</TD>
            <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="30" HEIGHT="1" ALT=""></TD>
            <TD><A HREF="<%= Request.ServerVariables("SCRIPT_NAME") %>" ONCLICK="javascript:return confirm('画面をクリアします。よろしいですか？')"><IMG SRC="/webHains/images/newrsv.gif" WIDTH="77" HEIGHT="24" ALT="新しい予約を検索します"></A></TD>
            <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="30" HEIGHT="1" ALT=""></TD>
            <TD><A HREF="javascript:showCapacityList()"><IMG SRC="/webHains/images/rsvStat.gif" WIDTH="77" HEIGHT="24" ALT="予約状況を表示します"></A></TD>
<!--
            <TD><A HREF="javascript:search('<%= MODE_NORMAL %>')"><IMG SRC="/webHains/images/findrsv.gif" WIDTH="77" HEIGHT="24" ALT="この条件で検索"></A></TD>
            <TD NOWRAP><A HREF="javascript:search('<%= MODE_SAME_RSVGRP %>')">同じ群で検索</A></TD>
-->
            <% if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then %>
                <TD><A HREF="javascript:search()"><IMG SRC="/webHains/images/findrsv.gif" WIDTH="77" HEIGHT="24" ALT="この条件で検索"></A></TD>
                <TD><INPUT TYPE="checkbox" NAME="nearly" CHECKED></TD>
                <TD NOWRAP>より近い時間枠で検索</TD>
            <% End If %>
        </TR>
    </TABLE>
</FORM>
<%
'入力条件数分の条件入力欄を編集
For i = 0 To CONDITION_COUNT - 1
%>
<FORM NAME="entryForm" ACTION="" STYLE="margin: 0px;">
    <HR>
    <INPUT TYPE="hidden" NAME="perId"     VALUE="">
    <INPUT TYPE="hidden" NAME="compPerId" VALUE="">
    <INPUT TYPE="hidden" NAME="manCnt"    VALUE="">
    <INPUT TYPE="hidden" NAME="gender"    VALUE="">
    <INPUT TYPE="hidden" NAME="birth"     VALUE="">
    <INPUT TYPE="hidden" NAME="age"       VALUE="">
    <INPUT TYPE="hidden" NAME="ctrPtCd"   VALUE="">
    <INPUT TYPE="hidden" NAME="orgCd1"    VALUE="<%= strOrgCd1 %>">
    <INPUT TYPE="hidden" NAME="orgCd2"    VALUE="<%= strOrgCd2 %>">
    <INPUT TYPE="hidden" NAME="rsvNo"     VALUE="">
    <INPUT TYPE="hidden" NAME="hiddenUrl" VALUE="">
<%
    '２番目の条件のみ「夫婦でセット」機能を有効にさせる
%>
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1"<%= iif(i = 1, " WIDTH=""800""", "") %>>
        <TR>
            <TD WIDTH="70" NOWRAP>個人名</TD>
            <TD>：</TD>
            <TD><A HREF="javascript:callPersonGuide(<%= i %>)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="個人検索ガイドを表示します"></A></TD>
            <TD><A HREF="javascript:clearPerson(<%= i %>)"><IMG SRC="/webHains/images/delicon.gif"  WIDTH="21" HEIGHT="21" ALT="設定した値をクリア"></A></TD>
            <TD ID="perId<%= i %>" NOWRAP></TD>
            <TD>&nbsp;</TD>
            <TD NOWRAP><B ID="perName<%= i %>"></B><FONT ID="perKName<%= i %>" COLOR="#999999"></FONT></TD>
            <TD>&nbsp;</TD>
            <TD ID="birth<%= i %>" NOWRAP></TD>
            <TD>&nbsp;</TD>
            <TD ID="age<%= i %>" NOWRAP></TD>
            <TD>&nbsp;</TD>
            <TD ID="gender<%= i %>" NOWRAP></TD>
            <TD>&nbsp;</TD>
            <TD ID="showSet<%= i %>" NOWRAP></TD>
            <TD>&nbsp;</TD>
            <TD ID="showComment<%= i %>" NOWRAP></TD>
<%
            '２番目の条件のみ「夫婦でセット」機能を有効にさせる
            If i = 1 Then
%>
                <TD ID="compSet" WIDTH="100%" ALIGN="right" NOWRAP></TD>
<%
            End If
%>

        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
        <TR>
            <TD WIDTH="70"></TD>
            <TD><FONT COLOR="#ffffff">：</FONT></TD>
            <TD BGCOLOR="#dcdcdc">
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                    <TR>
                        <TD>
                            <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0" WIDTH="100%">
                                <TR>
                                    <TD NOWRAP>人数：</TD>
                                    <TD><INPUT TYPE="text" name="entManCnt" SIZE="3" MAXLENGTH="2" VALUE="" STYLE="ime-mode:disabled;"></TD>
                                    <TD>人</TD>
                                    <TD WIDTH="100%" ALIGN="right" NOWRAP>性別</TD>
                                </TR>
                            </TABLE>
                        </TD>
                        <TD>：</TD>
                        <TD COLSPAN="8">
                            <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
                                <TR>
                                    <TD><INPUT TYPE="radio" NAME="selGender" VALUE="1"></TD>
                                    <TD>男</TD>
                                    <TD><INPUT TYPE="radio" NAME="selGender" VALUE="2"></TD>
                                    <TD>女</TD>
                                </TR>
                            </TABLE>
                        </TD>
                        <TD WIDTH="300" ROWSPAN="3" ALIGN="right" VALIGN="bottom"><A HREF="javascript:conditionControlApply(<%= i %>)"><IMG SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="この入力内容で確定する"></A></TD>
                    </TR>
                    <TR>
                        <TD NOWRAP>生年月日もしくは年齢</TD>
                        <TD>：</TD>
                        <TD><%= EditEraYearList("bYear") %></TD>
                        <TD>年</TD>
                        <TD><%= EditNumberList("bMonth", 1, 12, Empty, True) %></TD>
                        <TD>月</TD>
                        <TD><%= EditNumberList("bDay", 1, 31, Empty, True) %></TD>
                        <TD>日</TD>
                        <TD><INPUT TYPE="text" NAME="entAge" SIZE="4" MAXLENGTH="3" VALUE="" STYLE="ime-mode:disabled;"></TD>
                        <TD>歳</TD>
                    </TR>
                    <TR>
                        <TD NOWRAP>ローマ字名</TD>
                        <TD>：</TD>
                        <TD COLSPAN="8"><INPUT TYPE="text" NAME="romeName" SIZE="36" MAXLENGTH="60" VALUE="" STYLE="ime-mode:disabled;"></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
        <TR>
            <TD WIDTH="70" NOWRAP>団体名</TD>
            <TD>：</TD>
            <TD><A HREF="javascript:callOrgGuide(<%= i %>)"><IMG SRC="/webHains/images/question.gif" WIDTH="21" HEIGHT="21" ALT="団体検索ガイドを表示します"></A></TD>
            <TD ID="dspOrgCd<%= i %>" NOWRAP></TD>
            <TD>&nbsp;</TD>
            <TD NOWRAP><B ID="orgName<%= i %>"></B><FONT ID="orgKName<%= i %>" COLOR="#999999"></FONT></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLSPACING="1" CELLPADDING="1">
        <TR>
            <TD WIDTH="70" NOWRAP>受診区分</TD>
            <TD>：</TD>
            <TD>
                <SELECT NAME="cslDivCd" STYLE="width:80;" ONCHANGE="javascript:conditionControlChanged(<%= i %>)">
                </SELECT>
            </TD>
        </TR>
        <TR>
            <TD>コース</TD>
            <TD>：</TD>
            <TD>
                <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="1">
                    <TR>
                        <TD>
                            <SELECT NAME="csCd" STYLE="width:170;" ONCHANGE="javascript:conditionControlChanged(<%= i %>)">
                            </SELECT>
                        </TD>
                        <TD NOWRAP>時間枠：</TD>
                        <TD>
                            <%''## 2015.12.15 張 自宅処置OPCF対応の為修正  ######################%>
                            <!--SELECT NAME="rsvGrpCd" STYLE="width:115;"-->
                            <SELECT NAME="rsvGrpCd" STYLE="width:160;">
                            </SELECT>
                        </TD>
                        <TD>&nbsp;</TD>
                        <TD ID="refCtr<%= i %>" NOWRAP></TD>
                        <TD>&nbsp;</TD>
                        <TD ID="search<%= i %>" NOWRAP></TD>
                    </TR>
                </TABLE>
            </TD>
        </TR>
        <TR>
            <TD></TD><TD></TD>
            <TD ID="optTable<%= i %>"></TD>
        </TR>
    </TABLE>
</FORM>
<%
Next
%>
<FORM NAME="paramForm" ACTION="fraRsvCalendar.asp" METHOD="post">
    <INPUT TYPE="hidden" NAME="mode">
    <INPUT TYPE="hidden" NAME="cslYear">
    <INPUT TYPE="hidden" NAME="cslMonth">
    <INPUT TYPE="hidden" NAME="perId">
    <INPUT TYPE="hidden" NAME="manCnt">
    <INPUT TYPE="hidden" NAME="gender">
    <INPUT TYPE="hidden" NAME="birth">
    <INPUT TYPE="hidden" NAME="age">
    <INPUT TYPE="hidden" NAME="romeName">
    <INPUT TYPE="hidden" NAME="orgCd1">
    <INPUT TYPE="hidden" NAME="orgCd2">
    <INPUT TYPE="hidden" NAME="cslDivCd">
    <INPUT TYPE="hidden" NAME="csCd">
    <INPUT TYPE="hidden" NAME="rsvGrpCd">
    <INPUT TYPE="hidden" NAME="ctrPtCd">
    <INPUT TYPE="hidden" NAME="rsvNo">
    <INPUT TYPE="hidden" NAME="optCd">
    <INPUT TYPE="hidden" NAME="optBranchNo">
</FORM>
<SCRIPT TYPE="text/javascript">
<!--
// 現在の日付を退避
curYear  = document.dateForm.cslYear.value;
curMonth = document.dateForm.cslMonth.value;
curDay   = document.dateForm.cslDay.value;

// イベントハンドラの設定
document.dateForm.cslYear.onchange  = checkDateChanged;
document.dateForm.cslMonth.onchange = checkDateChanged;
document.dateForm.cslDay.onchange   = checkDateChanged;

// すべての検索条件に対する動的制御
for ( var i = 0; i < <%= CONDITION_COUNT %>; i++ ) {
    conditionControl( i, '', '<%= strOrgCd1 %>', '<%= strOrgCd2 %>', '<%= strCsCd %>', '<%= strCslDivCd %>', '', '' );
}
//-->
</SCRIPT>
</BODY>
</HTML>
