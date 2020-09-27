<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      フォローアップ検索 (Ver0.0.1)
'      AUTHER  :
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<!-- #include virtual = "/webHains/includes/editPageNavi.inc"    -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Const MODE_SAVE       = "save"      '処理モード(保存)
Const CHART_NOTEDIV   = "500"       'チャート情報ノート分類コード
Const PUBNOTE_DISPKBN = 1           '表示区分＝医療
Const PUBNOTE_SELINFO = 0           '検索情報＝個人＋受診情報

'データベースアクセス用オブジェクト
Dim objCommon               '共通クラス
Dim objConsult              '受診情報アクセス用
Dim objPubNote              'ノートクラス
Dim objFollow               'フォローアップアクセス用

Dim strWinMode              'ウィンドウモード
Dim lngRsvNo                '予約番号
Dim strMotoRsvNo            '初期表示予約番号
Dim strJudFlg               '判定結果が登録されていない検査項目表示有無

Dim strMode                 '処理モード(検索："search"、挿入:"insert"、更新:"update")
Dim strAction               '処理状態(保存ボタン押下時:"save"、保存完了後:"saveend")
Dim strMessage              'エラーメッセージ

Dim strKey                  '検索キー
Dim strArrKey               '検索キー(空白で分割後のキー）
Dim strStartCslDate         '検索条件受診年月日（開始）
Dim strStartYear            '検索条件受診年（開始）
Dim strStartMonth           '検索条件受診月（開始）
Dim strStartDay             '検索条件受診日（開始）
Dim strEndCslDate           '検索条件受診年月日（終了）
Dim strEndYear              '検索条件受診年（終了）
Dim strEndMonth             '検索条件受診月（終了）
Dim strEndDay               '検索条件受診日（終了）
Dim lngRsvHistory           '表示受診日
Dim strUpdUser              '更新者

Dim vntItemCd               'フォロー対象検査項目コード
Dim vntItemName             'フォロー対象検査項目名称

Dim strPerId                '個人ID
Dim strCslDate              '受診日
Dim vntArrHistoryRsvno      '受診歴の予約番号の配列
Dim vntArrHistoryCslDate    '受診歴の受診日の配列

Dim lngItemCount            'フォロー対象検査項目数
Dim lngAllCount
Dim lngCount
Dim i                       'カウンタ
Dim j

Dim lngStartPos             '表示開始位置
Dim lngPageKey              '検索条件
Dim lngArrPageKey()         '検索条件の配列
Dim strArrPageKeyName()     '検索条件名の配列

Dim lngArrSendMode()        '発送日確認状態の配列
Dim strArrSendModeName()    '発送日確認状態名の配列

Dim Ret                     '関数戻り値
Dim strURL                  'ジャンプ先のURL

'ノート情報件数獲得用
Dim vntNoteSeq              'seq
Dim vntPubNoteDivCd         '受診情報ノート分類コード
Dim vntPubNoteDivName       '受診情報ノート分類名称
Dim vntDefaultDispKbn       '表示対象区分初期値
Dim vntOnlyDispKbn          '表示対象区分しばり
Dim vntDispKbn              '表示対象区分
Dim vntUpdDate              '登録日時
Dim vntNoteUpdUser          '登録者
Dim vntUserName             '登録者名
Dim vntBoldFlg              '太字区分
Dim vntPubNote              'ノート
Dim vntDispColor            '表示色
Dim lngChartCnt             'チャート情報件数

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objCommon       = Server.CreateObject("HainsCommon.Common")
Set objConsult      = Server.CreateObject("HainsConsult.Consult")
Set objPubNote      = Server.CreateObject("HainsPubNote.PubNote")
Set objFollow       = Server.CreateObject("HainsFollow.Follow")

'引数値の取得
strMode             = Request("mode")
strAction           = Request("action")
strJudFlg           = Request("judFlg")

strWinMode          = Request("winmode")
lngRsvNo            = Request("rsvno")
strMotoRsvNo        = Request("motoRsvNo")
lngRsvHistory       = Request("rsvHistory")
lngPageKey          = Request("pageKey")
strUpdUser          = Session.Contents("userId")


'フォロー対象検査項目（判定分類）を取得
lngItemCount = objFollow.SelectFollowItem(vntItemCd, vntItemName )

'予約番号が指定されている場合
If lngRsvNo <> "" Then

    '受診情報読み込み
    Ret = objConsult.SelectConsult(lngRsvNo, , strCslDate, strPerId)

    '一度も表示していない場合は予約番号を退避する
    If strMotoRsvNo = "" Then
        strMotoRsvNo = lngRsvNo
    End If
    '受診歴情報読み込み
    lngCount = objFollow.SelectFollowHistory(strPerId, strMotoRsvNo, vntArrHistoryRsvno, vntArrHistoryCslDate)

    '受診歴がない場合は引数の予約番号、受診日を表示する
    If lngCount = 0 Then
        vntArrHistoryRsvno   = Array()
        vntArrHistoryCslDate = Array()
        Redim Preserve vntArrHistoryRsvno(0)
        Redim Preserve vntArrHistoryCslDate(0)
        vntArrHistoryRsvno(0)   = lngRsvNo
        vntArrHistoryCslDate(0) = strCslDate
    End If

    'チャート情報の件数取得
    lngChartCnt = objPubNote.SelectPubNote(PUBNOTE_SELINFO,  _
                                        0, "", "",           _
                                        lngRsvNo,            _
                                        "", "", "", "", 0,   _
                                        CHART_NOTEDIV,       _
                                        PUBNOTE_DISPKBN,     _
                                        strUpdUser,          _
                                        vntNoteSeq,          _
                                        vntPubNoteDivCd,     _
                                        vntPubNoteDivName,   _
                                        vntDefaultDispKbn,   _
                                        vntOnlyDispKbn,      _
                                        vntDispKbn,          _
                                        vntUpdDate,          _
                                        vntNoteUpdUser,      _
                                        vntUserName,         _
                                        vntBoldFlg,          _
                                        vntPubNote,          _
                                        vntDispColor )

End If


Set objConsult = Nothing
Set objPubNote = Nothing
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<HTML LANG="ja">

<HEAD>
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<TITLE>フォローアップ検索</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
    var winGuideFollow;     //フォローアップ画面ハンドル
    var winMenResult;       // ドック結果参照ウィンドウハンドル
    var winRslFol;          // フォロー結果登録ウィンドウハンドル

    /** 検索条件による画面リフレッシュ **/
    function preView() {
        var myForm = document.titleForm;
        var historyCsldate;

        if (document.titleForm.rsvHistory.value >= 0) {

            historyCsldate = myForm.rsvHistory.options[myForm.rsvHistory.selectedIndex].text;
            if(historyCsldate.length == 10){
                parent.params.strYear     = historyCsldate.substr(0,4);
                parent.params.strMonth    = historyCsldate.substr(5,2);
                parent.params.strDay      = historyCsldate.substr(8,2);
                parent.params.endYear     = historyCsldate.substr(0,4);
                parent.params.endMonth    = historyCsldate.substr(5,2);
                parent.params.endDay      = historyCsldate.substr(8,2);
            }

            myForm.rsvno.value = myForm.rsvHistory.value;
            parent.params.rsvno = myForm.rsvno.value;
            parent.params.motoRsvNo = myForm.motoRsvNo.value;
            parent.params.judFlg = myForm.judFlg.value;
            common.submitCreatingForm(parent.location.pathname, 'post', '_parent', parent.params);
        }
    }

    function clickCheck(obj) {
        if(obj.checked==true){
            obj.value="1";
        }else{
            obj.value="";
        }
    }

    /** フォロー登録処理 **/
    function saveFollow() {

        // 入力項目チェック
        if ( !parent.checkValue( 0 ) ) return;

        // 確認メッセージの表示
        if ( !confirm('この内容で保存します。よろしいですか？') ) return;

        parent.submitForm('<%= MODE_SAVE %>');
    }


    /** コメント一覧（チャート情報）呼び出し **/
    function callCommentList() {
        //alert("チャート情報表示画面");
        parent.callCommentList();
    }

    var winfolUpdateHistory;        // ウィンドウハンドル
    function callfolUpdateHistory() {
        var url;                    // URL文字列
        var opened = false;         // 画面が開かれているか

        url = '/WebHains/contents/follow/folUpdateHistory.asp?grpno=20';
        url = url + '&winmode=' + '1';
        url = url + '&rsvno=' + '<%= lngRsvNo %>';

        // すでにガイドが開かれているかチェック
        if ( winfolUpdateHistory ) {
            if ( !winfolUpdateHistory.closed ) {
                opened = true;
            }
        }

        // 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
        if ( opened ) {
            winfolUpdateHistory.focus();
            winfolUpdateHistory.location.replace( url );
        } else {
            winfolUpdateHistory = window.open( url, '', 'width=1010,height=600,status=no,directories=no,menubar=no,resizable=yes,toolbar=no' );
        }

    }

    var winfolReqHistory;
    function callfolReqHistory() {

        var opened = false; // 画面が開かれているか
        var url;            // URL文字列

        // 依頼状印刷履歴情報画面を表示するため
        url = '/WebHains/contents/follow/followReqHistory.asp?rsvno='+'<%= lngRsvNo %>';
        // すでに画面が開かれているかチェック
        if ( winfolReqHistory != null ) {
            if ( !winfolReqHistory.closed ) {
                opened = true;
            }
        }

        // 開かれている場合は画面をREPLACEし、さもなくば新規画面を開く
        if ( opened ) {
            winfolReqHistory.focus();
            winfolReqHistory.location.replace(url);
        } else {
            winfolReqHistory = window.open( url, '', 'width=1010,height=600,status=no,directories=no,menubar=no,resizable=no,toolbar=no, scrollbars=yes');
        }
    }

    /** ポップアップ画面アンロード時の処理 **/
    function closeGuideWindow() {

        //日付ガイドを閉じる
        calGuide_closeGuideCalendar();

        if ( winGuideFollow != null ) {
            if ( !winGuideFollow.closed ) {
                winGuideFollow.close();
            }
        }
        winGuideFollow = null;

        if ( winMenResult != null ) {
            if ( !winMenResult.closed ) {
                winMenResult.close();
            }
        }
        winMenResult = null;

        if ( winRslFol != null ) {
            if ( !winRslFol.closed ) {
                winRslFol.close();
            }
        }
        winRslFol = null;

        // 変更履歴画面を閉じる
        if ( winfolUpdateHistory != null ) {
            if ( !winfolUpdateHistory.closed ) {
                winfolUpdateHistory.close();
            }
        }
        winfolUpdateHistory = null;

        // 依頼状履歴画面を閉じる
        if ( winfolReqHistory != null ) {
            if ( !winfolReqHistory.closed ) {
                winfolReqHistory.close();
            }
        }
        winfolReqHistory = null;

        return false;
    }


//-->
</SCRIPT>
<script type="text/javascript" src="/webHains/js/common.js"></script>
<style type="text/css">
	body { margin: <%= IIF(strWinMode = 1,"12","0") %>px 0 0 20px; }
</style>
<style>
.follow-midashi {background-color:#CCCCCC;}
</style>
</HEAD>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<BODY ONUNLOAD="JavaScript:closeGuideWindow()">
<!--TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="0"-->
<TABLE WIDTH="95%" BORDER="0" CELLSPACING="0" CELLPADDING="0">
    <TR>
        <TD WIDTH="100%">
            <TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
                <TR>
                    <TD NOWRAP BGCOLOR="#ffffff" WIDTH="100%" HEIGHT="15"><B><SPAN CLASS="demand">■</SPAN><FONT COLOR="#000000">フォローアップ照会</FONT></B></TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
</TABLE>
<%
    '「別ウィンドウで表示」の場合、ヘッダー部分表示
    If strWinMode = 1 Then
%>
<!-- #include virtual = "/webHains/includes/followupHeader.inc" -->
<%
        Call followupHeader(lngRsvNo)
    End If
%>
<BR>
<FORM NAME="titleForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="post">
<INPUT TYPE="hidden" NAME="winmode"     VALUE="<%= strWinMode %>">
<INPUT TYPE="hidden" NAME="rsvno"       VALUE="<%= lngRsvNo %>">
<INPUT TYPE="hidden" NAME="motoRsvNo"   VALUE="<%=strMotoRsvNo%>">
<INPUT TYPE="hidden" NAME="action"      VALUE=""> 
<p>
<span class="follow-midashi">※フォロー対象検査項目:</span>
        <%
                '## 汎用マスターに登録されているフォロー対象健康項目（判定分類）表示
                If lngItemCount > 0 Then

                    For i = 0 To UBound(vntItemName)
                        IF i = 0 Then
        %>
                            <%= vntItemName(i)%>
        <%
                        Else
        %>
                            、<%= vntItemName(i)%>
        <%
                        End if
                    Next
                Else
        %>
                &nbsp;
        <%
                End If
        %>
</p>


<BR>
<TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="0">
    <TR>
<%
    'チャート情報あり？
    If lngChartCnt > 0 Then
%>
        <TD ALIGN="left" BGCOLOR="ffffff"><A HREF="javascript:callCommentList()"><IMG SRC="/webHains/images/chartinfo_up.gif" ALT="チャート情報を表示します" BORDER="0"></A></TD>
<%
    Else
%>
        <TD ALIGN="left" BGCOLOR="ffffff"><A HREF="javascript:callCommentList()"><IMG SRC="/webHains/images/chartinfo.gif" ALT="チャート情報を表示します" BORDER="0"></A></TD>
<%
    End If
%>
        <TD WIDTH="100" ALIGN="right">表示受診日</TD>
        <TD WIDTH="100" ALIGN="right"><%= EditDropDownListFromArray("rsvHistory", vntArrHistoryRsvno, vntArrHistoryCslDate, lngRsvNo, NON_SELECTED_DEL) %></TD>
        <TD WIDTH="170" ALIGN="right">
            <A HREF="javascript:preView()"><IMG SRC="../../images/b_search.gif" ALT="この条件で検索" HEIGHT="24" WIDTH="77" BORDER="0"></A>
            <% If Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" Then %>
                <A HREF="javascript:saveFollow()"><IMG SRC="../../images/save.gif" ALT="フォロー保存" HEIGHT="24" WIDTH="77" BORDER="0"></A>
            <% End If %>

        </TD>
        <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="240">
            <A HREF="javascript:callfolUpdateHistory()"><IMG SRC="../../images/updatehistory.gif" ALT="変更履歴画面を表示します" HEIGHT="24" WIDTH="100" BORDER="0"></A>
            <A HREF="javaScript:callfolReqHistory()"><IMG SRC="../../images/printhistory.gif" ALT="印刷履歴を表示します。"HEIGHT="24" WIDTH="100" BORDER="0"></A>
        </TD>
    </TR>
</TABLE>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
    <TR>
        <TD><INPUT TYPE="checkbox" NAME="judFlg" VALUE="<%= strJudFlg %>"  <%= IIf(strJudFlg = "1", "CHECKED", "") %> onClick="javascript:clickCheck(this)"></TD>
        <TD NOWRAP>判定結果が登録されていない検査項目も表示</TD>
    </TR>
</TABLE>
</FORM>
</BODY>
</HTML>