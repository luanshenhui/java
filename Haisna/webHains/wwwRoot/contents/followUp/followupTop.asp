<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       フォローアップメイン (Ver0.0.1)
'       AUTHER  : T.Yaguchi@orbsys.co.jp
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<!-- #include virtual = "/webHains/includes/editCsGrp.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
'データベースアクセス用オブジェクト

'前画面から送信されるパラメータ値
Dim strWinMode          'ウィンドウモード
Dim strPubNoteDivCd     '
Dim strDispMode         '
Dim strDispKbn          '
Dim strCmtMode          '
Dim strCsCd             'コースコード
Dim strStrYear          '
Dim strStrMonth         '
Dim strStrDay           '
Dim strEndYear          '
Dim strEndMonth         '
Dim strEndDay           '
Dim lngRsvNo            '予約番号（今回分）
Dim strGrpCd            'グループコード
Dim lngPageKey          '検索条件
Dim lngJudClKey         '検索条件科分類
Dim strMotoRsvNo        '初期表示予約番号

Dim strAct              '処理状態
Dim strUrlPara          'フレームへのパラメータ
Dim strUrlPara2         'フレームへのパラメータ

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
strAct              = Request("action")
strWinMode          = Request("winmode")
strPubNoteDivCd     = Request("PubNoteDivCd")
strDispMode         = Request("DispMode")
strDispKbn          = Request("DispKbn")
strCmtMode          = Request("cmtMode")
strCscd             = Request("cscd")
strStrYear          = Request("strYear")
strStrMonth         = Request("strMonth")
strStrDay           = Request("strDay")
strEndYear          = Request("endYear")
strEndMonth         = Request("endMonth")
strEndDay           = Request("endDay")
lngRsvNo            = Request("rsvno")
strGrpCd            = Request("grpcd")
strSelCsGrp         = Request("csgrp")
lngPageKey          = IIF(Request("pageKey")="",0,Request("pageKey"))
'#### 2008.12.04 張 フォローアップ登録処理を内科と婦人科に分けて管理できるように検査条件追加）####
lngJudClKey         = IIF(Request("judClKey")="",1,Request("judClKey"))
strMotoRsvNo        = Request("motoRsvNo")

'フレームへのパラメータ設定
strUrlPara = "?winmode=" & strWinMode 
strUrlPara = strUrlPara & "&rsvno=" & lngRsvNo
strUrlPara = strUrlPara & "&grpcd=" & strGrpCd
strUrlPara = strUrlPara & "&cscd=" & strCsCd
strUrlPara = strUrlPara & "&csgrp=" & strSelCsGrp
strUrlPara = strUrlPara & "&PubNoteDivCd=" & strPubNoteDivCd
strUrlPara = strUrlPara & "&DispMode=2"
strUrlPara = strUrlPara & "&DispKbn=1"
strUrlPara = strUrlPara & "&cmtMode=1,1,0,0"
strUrlPara = strUrlPara & "&strYear=" & strStrYear
strUrlPara = strUrlPara & "&strMonth=" & strStrMonth
strUrlPara = strUrlPara & "&strDay=" & strStrDay
strUrlPara = strUrlPara & "&endYear=" & strEndYear
strUrlPara = strUrlPara & "&endMonth=" & strEndMonth
strUrlPara = strUrlPara & "&endDay=" & strEndDay
strUrlPara = strUrlPara & "&pageKey=" & lngPageKey
'#### 2008.12.04 張 フォローアップ登録処理を内科と婦人科に分けて管理できるように検査条件追加）####
strUrlPara = strUrlPara & "&judClKey=" & lngJudClKey
strUrlPara = strUrlPara & "&motoRsvNo=" & strMotoRsvNo

strUrlPara2 = "/WebHains/contents/comment/commentMainFlame.asp"
strUrlPara2 = strUrlPara2 & "?winmode=0"
strUrlPara2 = strUrlPara2 & "&PubNoteDivCd=" & strPubNoteDivCd
strUrlPara2 = strUrlPara2 & "&DispMode=2"
strUrlPara2 = strUrlPara2 & "&DispKbn=1"
strUrlPara2 = strUrlPara2 & "&cmtMode=1,1,0,0"
strUrlPara2 = strUrlPara2 & "&cscd=" & strCsCd
strUrlPara2 = strUrlPara2 & "&strYear=" & strStrYear
strUrlPara2 = strUrlPara2 & "&strMonth=" & strStrMonth
strUrlPara2 = strUrlPara2 & "&strDay=" & strStrDay
strUrlPara2 = strUrlPara2 & "&endYear=" & strEndYear
strUrlPara2 = strUrlPara2 & "&endMonth=" & strEndMonth
strUrlPara2 = strUrlPara2 & "&endDay=" & strEndDay
strUrlPara2 = strUrlPara2 & "&rsvno=" & lngRsvNo
strUrlPara2 = strUrlPara2 & "&pageKey=" & lngPageKey

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>フォローアップ</TITLE>
<SCRIPT TYPE="text/javascript">
<!--

// 入力チェック
function checkValue( mode ) {

    var mainForm = main.document.resultList;    // メイン画面のフォームエレメント
    var titleForm  = header.document.titleForm; // ヘッダ画面のフォームエレメント

    for ( var ret = false; ; ) {

        // 表示受診日の必須チェック
        if ( titleForm.rsvHistory.value == '' ) {
            alert( '表示受診日を指定して下さい。' );
            break;
        }

        ret = true;
        break;
    }

    return ret;

}

// submit処理
function submitForm( mode ) {

    // 処理モードを設定する
    var mainForm = main.document.resultList;    // メイン画面のフォームエレメント
    var titleForm  = header.document.titleForm; // ヘッダ画面のフォームエレメント
    mainForm.action.value = mode;
    mainForm.followUpFlg.value = (titleForm.followUpFlg.checked) ? titleForm.followUpFlg.value:'0';
    mainForm.followCardFlg.value = (titleForm.followCardFlg.checked) ? titleForm.followCardFlg.value:'0';
    mainForm.rsvno.value = titleForm.rsvno.value;

    // メイン画面をsubmit
    mainForm.submit();

}
// 更新者表示処理
function updUserSet(updUserName, updDateName) {

    header.document.getElementById('updUserName').innerHTML = updUserName;
    header.document.getElementById('updDateName').innerHTML = (updDateName == '') ? '': '(' + updDateName + ')';

}

//再表示
function preView() {
    var url;                    // URL文字列
    var titleForm  = header.document.titleForm; // ヘッダ画面のフォームエレメント
    var mainForm = main.document.resultList;    // メイン画面のフォームエレメント

    url = '/webHains/contents/followUp/followupTop.asp?';
    url = url + 'winmode=' + '1';
    url = url + '&rsvno=' + titleForm.rsvno.value;
    url = url + '&grpcd=' + '<%= strGrpCd %>';
    url = url + '&PubNoteDivCd=' + '<%= strPubNoteDivCd %>';
    url = url + '&DispMode=' + '<%= strDispMode %>';
    url = url + '&DispKbn=' + '<%= strDispKbn %>';
    url = url + '&cmtMode=' + '<%= strCmtMode %>';
    url = url + '&cscd=' + '<%= strCsCd %>';
    url = url + '&strYear=' + '<%= strStrYear %>';
    url = url + '&strMonth=' + '<%= strStrMonth %>';
    url = url + '&strDay=' + '<%= strStrDay %>';
    url = url + '&endYear=' + '<%= strStrYear %>';
    url = url + '&endMonth=' + '<%= strStrMonth %>';
    url = url + '&endDay=' + '<%= strStrDay %>';
    url = url + '&csgrp=' + '<%= strSelCsGrp %>';
    url = url + '&pageKey=' + titleForm.pageKey.value;
    url = url + '&judClKey=' + titleForm.judClKey.value;

//  parent.location.href(url);
}

//コメント一覧（チャート情報）呼び出し
function callCommentList() {
    var url;                        // URL文字列

    url = '/WebHains/contents/comment/commentMainFlame.asp?';
//  url = url + 'winmode=' + '<%= strWinMode %>';
    url = url + 'winmode=' + '1';
    url = url + '&rsvno=' + '<%= lngRsvNo %>';
    url = url + '&grpcd=' + '<%= strGrpCd %>';
    url = url + '&PubNoteDivCd=500';
    url = url + '&DispMode=2';
    url = url + '&DispKbn=1';
    url = url + '&cmtMode=1,1,0,0';
    url = url + '&cscd=' + '<%= strCsCd %>';
    url = url + '&strYear=' + '<%= strStrYear %>';
    url = url + '&strMonth=' + '<%= strStrMonth %>';
    url = url + '&strDay=' + '<%= strStrDay %>';
    url = url + '&endYear=' + '<%= strStrYear %>';
    url = url + '&endMonth=' + '<%= strStrMonth %>';
    url = url + '&endDay=' + '<%= strStrDay %>';

    parent.location.href(url);

}

var params = {
    action:       "<%= strAct %>",
    PubNoteDivCd: "<%= strPubNoteDivCd %>",
    DispMode:     "<%= strDispMode %>",
    DispKbn:      "<%= strDispKbn %>",
    cmtMode:      "<%= strCmtMode %>",
    cscd:         "<%= strCscd %>",
    strYear:      "<%= strStrYear %>",
    strMonth:     "<%= strStrMonth %>",
    strDay:       "<%= strStrDay %>",
    endYear:      "<%= strEndYear %>",
    endMonth:     "<%= strEndMonth %>",
    endDay:       "<%= strEndDay %>",
    rsvno:        "<%= lngRsvNo %>",
    winmode:      "<%= strWinMode %>",
    grpcd:        "<%= strGrpCd %>",
    csgrp:        "<%= strSelCsGrp %>",
    pageKey:      "<%= lngPageKey %>",
    judClKey:     "<%= lngJudClKey %>",
    motoRsvNo:    "<%=strMotoRsvNo%>"
}
//-->
</SCRIPT>
</HEAD>
<FRAMESET ROWS="<%=IIf(strWinMode=1,174,80) & ",*" %> BORDER="0" FRAMESPACING="0" FRAMEBORDER="no">
    <FRAME NAME="header"    SRC="followupHeader.asp<%=strUrlPara%>">
    <FRAME NAME="main"      SRC="followupEditBody.asp<%=strUrlPara%>">
</FRAMESET>
</HTML>
