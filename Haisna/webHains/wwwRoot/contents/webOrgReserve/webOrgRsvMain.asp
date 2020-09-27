<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      web団体予約情報登録 (Ver1.0.0)
'      AUTHER  : 
'-----------------------------------------------------------------------------
'----------------------------
'修正履歴
'----------------------------
'管理番号：SL-SN-Y0101-612
'修正日　：2013.3.11
'担当者  ：T.Takagi@RD
'修正内容：web予約受診オプションの取得方法変更

Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/webRsv.inc"       -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
'データベースアクセス用オブジェクト
Dim objWebOrgRsv        'web予約情報アクセス用

'引数値
Dim dtmCslDate          '受診年月日
Dim lngWebNo            'webNo.
Dim dtmStrCslDate       '開始受診年月日
Dim dtmEndCslDate       '終了受診年月日
Dim strKey              '検索キー
Dim dtmStrOpDate        '開始処理年月日
Dim dtmEndOpDate        '終了処理年月日
Dim strOrgCd1           '団体コード1
Dim strOrgCd2           '団体コード2
Dim lngOpMode           '処理モード(1:申込日で検索、2:予約処理日で検索)
Dim lngRegFlg           '本登録フラグ(0:指定なし、1:未登録者、2:編集済み受診者)
Dim lngOrder            '出力順(1:受診日順、2:個人ID順)
'#### 2010.10.28 SL-UI-Y0101-108 ADD START ####'
Dim lngMosFlg		'申込区分(0:指定なし、1:新規、2:キャンセル)
'#### 2010.10.28 SL-UI-Y0101-108 ADD END ####'
Dim blnSaved            '保存完了フラグ

Dim strRegFlg           '本登録フラグ

Dim strURL              'ジャンプ先のURL

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'引数値の取得
dtmCslDate    = CDate(Request("cslDate"))
lngWebNo      = CLng("0" & Request("webNo"))
dtmStrCslDate = CDate(Request("strCslDate"))
dtmEndCslDate = CDate(Request("endCslDate"))
strKey        = Request("key")
dtmStrOpDate  = CDate("0" & Request("strOpDate"))
dtmEndOpDate  = CDate("0" & Request("endOpDate"))
strOrgCd1     = Request("orgCd1")
strOrgCd2     = Request("orgCd2")
lngOpMode     = CLng("0" & Request("opMode"))
lngRegFlg     = CLng("0" & Request("regFlg"))
lngOrder      = CLng("0" & Request("order"))
'#### 2010.10.28 SL-UI-Y0101-108 ADD START ####'
'申込区分の入力がなければ1:新規をデフォルトに
lngMosFlg      = IIf(Request("mousi") = "", 1, CLng("0" & Request("mousi")))
'#### 2010.10.28 SL-UI-Y0101-108 ADD END ####'
blnSaved      = (Request("saved") <> "")

'オブジェクトのインスタンス作成
Set objWebOrgRsv = Server.CreateObject("HainsWebOrgRsv.WebOrgRsv")

'web予約情報を読み、状態を取得
If objWebOrgRsv.SelectWebOrgRsv(dtmCslDate, lngWebNo, strRegFlg) = False Then
    Err.Raise 1000, , "web予約情報が存在しません。"
End If

'オブジェクトの解放
Set objWebOrgRsv = Nothing

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>web団体予約情報登録</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// 入力チェック
function checkValue() {

    var detailForm = detail.document.paramForm;
    var optForm    = opt.document.entryForm;

    for ( var ret = false; ; ) {

        // 受診団体の必須チェック
        if ( detailForm.orgCd1.value == '' || detailForm.orgCd2.value == '' ) {
            alert( '受診団体を指定して下さい。' );
            break;
        }

        // 受診区分の必須チェック
        if ( detailForm.cslDivCd.value == '' ) {
            alert( '受診区分を指定して下さい。' );
            break;
        }

        // 契約パターンの存在チェック
        if ( optForm == null ) {
            alert('この受診条件に合致する契約情報は存在しません。');
            break;
        }

        if ( optForm.ctrPtCd.value == '' ) {
            alert('この受診条件に合致する契約情報は存在しません。');
            break;
        }

        ret = true;
        break;
    }

    return ret;
}

// 画面を閉じる
function closeWindow( exceptWindowCode ) {

    // コメント画面を閉じる
    if ( exceptWindowCode != 1 ) {
        header.noteGuide_closeGuideNote();
    }

    // 個人検索ガイド画面を閉じる
    if ( exceptWindowCode != 2 ) {
        detail.perGuide_closeGuidePersonal();
    }

    // ドック申し込み個人情報画面を閉じる
    if ( exceptWindowCode != 3 ) {
        detail.closeEditPersonalWindow();
    }

    // 団体検索ガイド画面を閉じる
    if ( exceptWindowCode != 4 ) {
        detail.orgGuide_closeGuideOrg();
    }

    // 受診付属情報詳細画面を閉じる
    if ( exceptWindowCode != 5 ) {
        personal.closePersonalDetailWindow();
    }

}

// コード＆名称のクラス
function codeAndName( code, codeName ) {
    this.code     = code;
    this.codeName = codeName;
}

// オプションコードのカンマ形式への変換
function convOptCd( objForm, arrOptCd, arrOptBranchNo ) {

    var selOptCd;   // オプションコード・枝番
    var addFlg;     // 追加フラグ

    if ( !objForm ) return;
    if ( objForm.length == null ) return;

    // 全エレメントを検索
    for ( var i = 0; i < objForm.length; i++ ) {

        // タイプを判断
        switch ( objForm.elements[ i ].type ) {

            case 'checkbox':    // チェックボックス、ラジオボタンの場合
            case 'radio':

                // 選択されていなければ追加しない
                if ( !objForm.elements[ i ].checked ) {
                    continue;
                }

                break;

            case 'hidden':      // 隠しエレメントの場合

                // ３番目の要素が受診要否
                selOptCd = objForm.elements[ i ].value.split(',');
                if ( selOptCd[ 2 ] != '1' ) {
                    continue;
                }

                break;

            default:
                continue;

        }

        // 追加が必要であればいればカンマでコードと枝番を分離して追加
        selOptCd = objForm.elements[ i ].value.split(',');
        arrOptCd[ arrOptCd.length ] = selOptCd[ 0 ];
        arrOptBranchNo[ arrOptBranchNo.length ] = selOptCd[ 1 ];

    }

}

// 年齢の編集
function editAge( age, realAge ) {

    // 年齢の編集
    if ( age != null ) {
        detail.document.getElementById('perAge').innerHTML = ( age != '' ) ? '（' + age.substring(0, age.indexOf('.')) + '歳）' : '';
    }

    // 実年齢の編集
    if ( realAge != null ) {
        detail.document.getElementById('perRealAge').innerHTML = ( realAge != '' ) ? realAge + '歳' : '';
    }

    // 年齢を基本情報のsubmitパラメータ保持エレメントに編集
    if ( age != null ) {
        detail.document.paramForm.age.value = age;
    }

}

// 受診区分セレクションボックスの編集
function editCslDiv( cslDivInfo, selCslDivCd ) {

    // セレクションボックスの編集
    editSelectionBox( detail.document.entryForm.cslDivCd, cslDivInfo, selCslDivCd );

    // hidden値の更新
    detail.document.paramForm.cslDivCd.value = detail.document.entryForm.cslDivCd.value;

}

// 性別の編集
function editGender( gender ) {

    // 性別の編集
    var genderName = '';
    switch ( gender ) {
        case '<%= GENDER_MALE %>':
            genderName = '男性';
            break;
        case '<%= GENDER_FEMALE %>':
            genderName = '女性';
        default:
    }

    return genderName;
}

// メッセージの編集
function editMessage( elem, message, isError ) {

    var html = '<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">';
    html = html + '<TR>';
    html = html + '<TD HEIGHT="5"></TD>';
    html = html + '</TR>';

    // (処理ロジックについてはeditMessage.incと同様)

    for ( var i = 0; i < message.length; i++ ) {

        html = html + '<TR>';

        if ( i == 0 ) {
            html = html + '<TD><IMG SRC="/webHains/images/' + ( isError ? 'ico_w' : 'ico_i' ) + '.gif" WIDTH="16" HEIGHT="16" ALT=""></TD>';
        } else {
            html = html + '<TD></TD>';
        }

        html = html + '<TD VALIGN="bottom"><SPAN STYLE="color:#ff9900;font-weight:bolder;font-size:14px;">' + message[ i ] + '</SPAN></TD>';

        html = html + '</TR>';

    }

    html = html + '</TABLE>';

    elem.innerHTML = html;

}

// 氏名の編集
function editName( lastName, firstName ) {

    // 姓名の結合
    var wkName = lastName;
    if ( firstName != '' ) {
        wkName = wkName + '　' + firstName;
    }

    return wkName;

}

// 個人情報の編集
function editPerson( perId, lastName, firstName, lastKName, firstKName, birth, age, realAge, gender ) {

    // 個人ID
    if ( perId != null ) {
        detail.document.getElementById('perPerId').innerHTML = ( perId != '' ) ? perId : '<%= PERID_FOR_NEW_PERSON %>';
    }

    // 姓名
    detail.document.getElementById('kanaName').innerHTML = editName( lastKName, firstKName );
    detail.document.getElementById('fullName').innerHTML = '<A HREF="javascript:callEditPersonWindow()">' + editName( lastName, firstName ) + '</A>';

    // 生年月日
    if ( birth != null ) {
        detail.document.getElementById('perBirth').innerHTML = birth;
    }

    // 性別
    if ( gender != null ) {
        detail.document.getElementById('perGender').innerHTML = editGender( gender );
    }

    // 年齢の編集
    editAge( age, realAge );

}

// セレクションボックスの編集
function editSelectionBox( selectionElement, codeNameInfo, selectedCode, needEmptyRow ) {

    var index  = 0;
    var exists = false;

    // コード情報が存在しなければ終了
    if ( !codeNameInfo ) {
        selectionElement.length = 0;
        return;
    }

    // 選択すべき要素の存在チェック
    for ( var i = 0; i < codeNameInfo.length; i++ ) {
        if ( codeNameInfo[ i ].code == selectedCode ) {
            exists = true;
            break;
        }
    }

    // 要素数の設定
    selectionElement.length = codeNameInfo.length + ( ( !exists || ( needEmptyRow != null ) ) ? 1 : 0 );

    // まず選択すべき要素が存在しない場合は空行を追加
    if ( !exists || ( needEmptyRow != null ) ) {
        selectionElement.options[ index ].value = '';
        selectionElement.options[ index ].text  = '';
        selectionElement.options[ index ].selected = true;
        index++;
    }

    // 要素の追加開始
    for ( var i = 0; i < codeNameInfo.length; i++ ) {

        // 要素の追加
        selectionElement.options[ index ].value = codeNameInfo[ i ].code;
        selectionElement.options[ index ].text  = codeNameInfo[ i ].codeName;

        // 選択すべき要素であれば選択状態にする
        if ( codeNameInfo[ i ].code == selectedCode ) {
            selectionElement.options[ index ].selected = true;
        }

        index++;
    }

}

// 文字列のバイト数を求める
function getByte( stream ) {

    var count = 0;

    // １文字ずつエンコードしつつバイト数を求める
    for ( var i = 0; i < stream.length; i++ ) {
        var token = escape( stream.charAt( i ) );
        if ( token.length < 4 ) {
            count++;
        } else {
            count += 2;
        }
    }

    return count;
}

// 基本情報での保持値を設定
function getPersonalValue() {

    var objForm   = personal.document.entryForm;
    var paramForm = detail.document.paramForm;

    // 予約状況
    objForm.rsvStatus.value = paramForm.rsvStatus.value;

    // 保存時印刷
    objForm.prtOnSave[ paramForm.prtOnSave.value ].checked = true;

    // 宛先
    objForm.cardAddrDiv.value   = paramForm.cardAddrDiv.value;
    objForm.formAddrDiv.value   = paramForm.formAddrDiv.value;
    objForm.reportAddrDiv.value = paramForm.reportAddrDiv.value;
    setRadioValue( objForm.cardOutEng,   paramForm.cardOutEng.value   );
    setRadioValue( objForm.formOutEng,   paramForm.formOutEng.value   );
    setRadioValue( objForm.reportOutEng, paramForm.reportOutEng.value );

    // 診察券発行
    objForm.issueCslTicket.value = paramForm.issueCslTicket.value;

}

// オプション検査画面読み込み
function replaceOptionFrame( ctrPtCd, optCd, optBranchNo ) {

    var detailForm = detail.document.paramForm;
    var optForm    = opt.document.entryForm;

    // URL編集
    var url = '/webHains/contents/webOrgReserve/webOrgRsvOption.asp';
    url = url + '?perId='    + detailForm.perId.value;
    url = url + '&gender='   + detailForm.gender.value;
    url = url + '&birth='    + detailForm.birth.value;
    url = url + '&orgCd1='   + detailForm.orgCd1.value;
    url = url + '&orgCd2='   + detailForm.orgCd2.value;
    url = url + '&csCd='     + detailForm.csCd.value;
    url = url + '&cslDate='  + detailForm.cslDate.value;
    url = url + '&cslDivCd=' + detailForm.cslDivCd.value;
    url = url + '&stomac='   + detailForm.stomac.value;
    url = url + '&breast='   + detailForm.breast.value;
<% '#### 2013.3.11 SL-SN-Y0101-612 ADD START #### %>
	url = url + '&csloptions=' + detailForm.csloptions.value;
<% '#### 2013.3.11 SL-SN-Y0101-612 ADD END   #### %>
<%
    '登録済みの場合、常時読み取り専用フラグを送る
    If strRegFlg = REGFLG_REGIST Then
%>
        url = url + '&readOnly=1';
<%
    End If
%>
    // 検査セット画面に全セット表示フラグのエレメントが存在する場合
    if ( optForm != null ) {
        url = url + '&showAll=' + ( optForm.showAll.checked ? optForm.showAll.value : '' );
    }

    // 契約パターンコード指定時
    if ( ctrPtCd != null ) {
        url = url + '&ctrPtCd=' + ctrPtCd;
    }

    // オプションコード指定時
    if ( optCd != null && optBranchNo != null ) {
        url = url + '&optCd='  + optCd;
        url = url + '&optBNo=' + optBranchNo;
    }

    // オプション検査画面の読み込み
    opt.location.replace( url );

}

// ラジオボタンの値取得処理
function getRadioValue( elem ) {

    var selectedValue = '';

    for ( var i = 0; i < elem.length; i++ ) {
        if ( elem[ i ].checked ) {
            selectedValue = elem[ i ].value;
            break;
        }
    }

    return selectedValue;
}

// 確定処理
function regist( next ) {

    for ( ; ; ) {

        // サブ画面を閉じる
        closeWindow();

        // 入力チェック
        if ( !checkValue() ) {
            break;
        }

        // 「次へ」ボタン押下時は確認メッセージの表示
        if ( next ) {
            if ( !confirm( 'この内容でweb予約情報を登録します。よろしいですか？') ) {
                break;
            }
        }

        // 検査セット情報の値を更新
        setOptionValue();

        // 受診付属情報の値を更新
        setPersonalValue();

        // 「確定」ボタン押下時は、ここで保存処理中状態を掌握するためのCookie値を書き込む
        if ( !next ) {
            document.cookie = 'rsvDetailOnSaving=1';
        }

        // submit
        var detailForm = detail.document.paramForm;
        detailForm.save.value = '1';
        detailForm.next.value = ( next ? '1' : '' );
        detailForm.submit();

        break;
    }

}

// 検査セット情報の値を更新
function setOptionValue() {

    var detailForm = detail.document.paramForm;
    var objForm    = opt.document.entryForm;

    // 契約パターンコード
    detailForm.ctrPtCd.value = objForm.ctrPtCd.value;

    var arrOptCd       = new Array();   // オプションコード
    var arrOptBranchNo = new Array();   // オプション枝番

    // 現在の選択オプション値を取得
    convOptCd( opt.document.optList, arrOptCd, arrOptBranchNo );

    // オプションコード・枝番
    detailForm.optCd.value  = arrOptCd;
    detailForm.optBNo.value = arrOptBranchNo;

}

// 受診付属情報の値を更新
function setPersonalValue() {

    var detailForm = detail.document.paramForm;
    var objForm    = personal.document.entryForm;

    // 予約状況
    detailForm.rsvStatus.value = objForm.rsvStatus.value;

    // 保存時印刷
    detailForm.prtOnSave.value = getRadioValue( objForm.prtOnSave );

    // 宛先
    detailForm.cardAddrDiv.value   = objForm.cardAddrDiv.value;
    detailForm.formAddrDiv.value   = objForm.formAddrDiv.value;
    detailForm.reportAddrDiv.value = objForm.reportAddrDiv.value;
    detailForm.cardOutEng.value    = getRadioValue( objForm.cardOutEng   );
    detailForm.formOutEng.value    = getRadioValue( objForm.formOutEng   );
    detailForm.reportOutEng.value  = getRadioValue( objForm.reportOutEng );

    // 診察券発行
    detailForm.issueCslTicket.value = objForm.issueCslTicket.value;

}

// ラジオボタンの選択処理
function setRadioValue( elem, selectedValue ) {
    for ( var i = 0; i < elem.length; i++ ) {
        if ( elem[ i ].value == selectedValue ) {
            elem[ i ].checked = true;
            break;
        }
    }
}

// 次へ
function showNext() {
    var detailForm = detail.document.paramForm;
    detailForm.save.value = '';
    detailForm.next.value = '1';
    detailForm.submit();
}

// はがき印刷処理
function showPrintCardDialog( rsvNo, act, cardAddrDiv, cardOutEng ) {
    showPrintDialog( 0, act, rsvNo, cardAddrDiv, cardOutEng );
}

// 送付案内印刷処理
function showPrintFormDialog( rsvNo, act, formAddrDiv, formOutEng ) {
    showPrintDialog( 1, act, rsvNo, formAddrDiv, formOutEng );
}

// 印刷処理
function showPrintDialog( mode, act, rsvNo, addrDiv, outEng ) {

    // 印刷制御用の画面を出力
    var url = '/webHains/contents/reserve/rsvPrintControl.asp';
    url = url + '?mode='    + mode;
    url = url + '&actMode=' + act;
    url = url + '&rsvNo='   + rsvNo;
    url = url + '&addrDiv=' + addrDiv;
    url = url + '&outEng='  + outEng;

// ★
    open( url );
}

// 指定フォームの全エレメントを使用不可に
function disableElements( objForm ) {

    if ( objForm ) {
        var elems = objForm.elements;
        for ( var i = 0; i < elems.length; i++ ) {
            elems[ i ].disabled = true;
        }
    }

}

//-->
</SCRIPT>
</HEAD>
<FRAMESET ROWS="76,*" BORDER="0" FRAMESPACING="0" FRAMEBORDER="no">
<%
    'ナビバー画面のURL編集
    strURL = "webOrgRsvNavi.asp"
    strURL = strURL & "?cslDate="    & dtmCslDate
    strURL = strURL & "&webNo="      & lngWebNo
    strURL = strURL & "&strCslDate=" & dtmStrCslDate
    strURL = strURL & "&endCslDate=" & dtmEndCslDate
    strURL = strURL & "&key="        & strKey
    strURL = strURL & "&strOpDate="  & IIf(dtmStrOpDate > 0, dtmStrOpDate, "")
    strURL = strURL & "&endOpDate="  & IIf(dtmEndOpDate > 0, dtmEndOpDate, "")
    strURL = strURL & "&orgcd1="     & strOrgCd1
    strURL = strURL & "&orgcd2="     & strOrgCd2
    strURL = strURL & "&opMode="     & lngOpMode
    strURL = strURL & "&regFlg="     & lngRegFlg
    strURL = strURL & "&order="      & lngOrder
    strURL = strURL & "&rsvRegFlg="  & strRegFlg
'#### 2010.10.28 SL-UI-Y0101-107 MOD START ####'
	strURL = strURL & "&mousi="     & lngMosFlg
'#### 2010.10.28 SL-UI-Y0101-107 MOD END ####'
%>
    <FRAME SRC="<%= strURL %>" NAME="header">
    <FRAMESET COLS="500,*" BORDER="0" FRAMESPACING="0" FRAMEBORDER="no">
        <FRAMESET ROWS="215,*" BORDER="0" FRAMESPACING="0" FRAMEBORDER="no">
<%
            '基本情報画面のURL編集
            strURL = "webOrgRsvDetail.asp"
            strURL = strURL & "?cslDate="    & dtmCslDate
            strURL = strURL & "&webNo="      & lngWebNo
            strURL = strURL & "&strCslDate=" & dtmStrCslDate
            strURL = strURL & "&endCslDate=" & dtmEndCslDate
            strURL = strURL & "&key="        & strKey
            strURL = strURL & "&strOpDate="  & IIf(dtmStrOpDate > 0, dtmStrOpDate, "")
            strURL = strURL & "&endOpDate="  & IIf(dtmEndOpDate > 0, dtmEndOpDate, "")
            strURL = strURL & "&orgcd1="     & strOrgCd1
            strURL = strURL & "&orgcd2="     & strOrgCd2
            strURL = strURL & "&opMode="     & lngOpMode
            strURL = strURL & "&regFlg="     & lngRegFlg
            strURL = strURL & "&order="      & lngOrder
'#### 2010.10.28 SL-UI-Y0101-107 MOD START ####'
			strURL = strURL & "&mousi="      & lngMosFlg
'#### 2010.10.28 SL-UI-Y0101-107 MOD END ####'

            If blnSaved Then
                strURL = strURL & "&saved=1"
            End If
%>
            <FRAME SRC="<%= strURL %>" NAME="detail">
            <FRAME SRC="" NAME="opt">
        </FRAMESET>
        <FRAMESET ROWS="215,*" BORDER="0" FRAMESPACING="0" FRAMEBORDER="no">
            <FRAME SRC="" NAME="personal">
<%
            '申し込み情報画面のURL編集
            strURL = "webOrgRsvReservation.asp"
            strURL = strURL & "?cslDate=" & dtmCslDate
            strURL = strURL & "&webNo="   & lngWebNo
%>
            <FRAME SRC="<%= strURL %>" NAME="reservation">
        </FRAMESET>
    </FRAMESET>
</FRAMESET>
</HTML>
