<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'       フォローアップヘッダ表示 (Ver0.0.1)
'       AUTHER  : T.Yaguchi@ORB
'-----------------------------------------------------------------------------
Option Explicit 
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc"   -->
<!-- #include virtual = "/webHains/includes/common.inc"         -->
<!-- #include virtual = "/webHains/includes/editNumberList.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_JUDGEMENT, CHECKSESSION_BUSINESS_TOP)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const MODE_SAVE       = "save"      '処理モード(保存)
Const MODE_CANCEL     = "cancel"    '処理モード(受付取り消し)
Const MODE_DELETE     = "delete"    '処理モード(削除)
Const CHART_NOTEDIV   = "500"       'チャート情報ノート分類コード
Const PUBNOTE_DISPKBN = 1           '表示区分＝医療
Const PUBNOTE_SELINFO = 0           '検索情報＝個人＋受診情報

'データベースアクセス用オブジェクト
Dim objConsult          '受診情報アクセス用
Dim objPubNote          'ノートクラス
Dim objFollowUp         'フォローアップアクセス用

'前画面から送信されるパラメータ値
Dim	strWinMode          'ウィンドウモード
Dim lngRsvNo            '予約番号
Dim strMotoRsvNo        '初期表示予約番号
Dim lngIndex            'インデックス（画面選択コンボ）

Dim lngStrYear          '受診日(自)(年)
Dim lngStrMonth         '受診日(自)(月)
Dim lngStrDay           '受診日(自)(日)
Dim strFollowUpFlg      'フォロー対象者フラグ
Dim strFollowCardFlg    'はがき出力フラグ
Dim strUpdDate          '更新日時
Dim strUpdUserName      '更新者名
Dim lngRsvHistory       '表示受診日
Dim strUpdUser          '更新者

'ノート情報件数獲得用
Dim vntNoteSeq          'seq
Dim vntPubNoteDivCd     '受診情報ノート分類コード
Dim vntPubNoteDivName   '受診情報ノート分類名称
Dim vntDefaultDispKbn   '表示対象区分初期値
Dim vntOnlyDispKbn      '表示対象区分しばり
Dim vntDispKbn          '表示対象区分
Dim vntUpdDate          '登録日時
Dim vntNoteUpdUser      '登録者
Dim vntUserName         '登録者名
Dim vntBoldFlg          '太字区分
Dim vntPubNote          'ノート
Dim vntDispColor        '表示色
Dim lngChartCnt         'チャート情報件数

Dim Ret                 '戻り値
Dim FolRet              '戻り値
Dim strPerId            '個人ID
Dim strCslDate          '受診日
Dim vntArrHistoryRsvno  '受診歴の予約番号の配列
Dim vntArrHistoryCslDate    '受診歴の受診日の配列

Dim vntArrSeq               'フォロー出力管理のＳＥＱの配列
Dim vntArrPosCardPrintDate  'フォロー出力管理の出力日時の配列
Dim vntArrPosCardUser       'フォロー出力管理の登録者の配列
Dim strPosCardPrintDate     'フォロー出力管理の出力日時

Dim lngPageKey          '検索条件
Dim lngArrPageKey()     '検索条件の配列
Dim strArrPageKeyName() '検索条件名の配列

'#### 2008.12.04 張 フォローアップ登録処理を内科と婦人科に分けて管理できるように検査条件追加）Start ####
Dim lngJudClKey             '検索条件判定分類
Dim lngArrJudClKey()        '検索条件判定分類の配列
Dim strArrJudClKeyName()    '検索条件判定分類名の配列
'#### 2008.12.04 張 フォローアップ登録処理を内科と婦人科に分けて管理できるように検査条件追加）End   ####

Dim lngCount            '
Dim lngAllCount         '

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objConsult  = Server.CreateObject("HainsConsult.Consult")
Set objPubNote  = Server.CreateObject("HainsPubNote.PubNote")
Set objFollowUp = Server.CreateObject("HainsFollowUp.FollowUp")

'引数値の取得
strWinMode          = Request("winmode")
lngRsvNo            = Request("rsvno")
strMotoRsvNo        = Request("motoRsvNo")
lngIndex            = Request("index")
strFollowCardFlg    = Request("followCardFlg")
strFollowUpFlg      = Request("followUpFlg")
lngRsvHistory       = Request("rsvHistory")
lngPageKey          = Request("pageKey")
strUpdUser          = Session.Contents("userId")
'#### 2008.12.04 張 フォローアップ登録処理を内科と婦人科に分けて管理できるように検査条件追加）####
lngJudClKey         = Request("judClKey")

Call CreatePageKeyInfo()
'#### 2008.12.04 張 フォローアップ登録処理を内科と婦人科に分けて管理できるように検査条件追加）####
Call CreateJudClKeyInfo()

'予約番号が指定されている場合
If lngRsvNo <> "" Then

    Set objConsult      = Server.CreateObject("HainsConsult.Consult")
    Set objFollowUp     = Server.CreateObject("HainsFollowUp.FollowUp")

    '受診情報読み込み
    Ret = objConsult.SelectConsult(lngRsvNo, , strCslDate, strPerId)

    '受診情報読み込み
    FolRet = objFollowUp.SelectFollow(lngRsvNo, strFollowUpFlg, strFollowCardFlg, strUpdDate, , strUpdUserName)
    If FolRet = False Then
        strUpdDate     = ""
        strUpdUserName = ""
    End If

'   If Ret = False Then
'       Err.Raise 1000, ,"受診情報が存在しません。"
'   End If

    '一度も表示していない場合は予約番号を退避する
    If strMotoRsvNo = "" Then
        strMotoRsvNo = lngRsvNo
    End If
    '受診歴情報読み込み
    lngCount = objFollowUp.SelectFollowHistory(strPerId, strMotoRsvNo, vntArrHistoryRsvno, vntArrHistoryCslDate)

    '受診歴がない場合は引数の予約番号、受診日を表示する
    If lngCount = 0 Then
        vntArrHistoryRsvno   = Array()
        vntArrHistoryCslDate = Array()
        Redim Preserve vntArrHistoryRsvno(0)
        Redim Preserve vntArrHistoryCslDate(0)
        vntArrHistoryRsvno(0)   = lngRsvNo
        vntArrHistoryCslDate(0) = strCslDate
    End If

    'はがき印刷情報読み込み
    lngCount = objFollowUp.SelectFollow_CardPrint(lngRsvNo, _
                                                  vntArrSeq, vntArrPosCardPrintDate, _
                                                  vntArrPosCardUser _
                                                 )
    'はがき印刷情報がない場合は未出力と表示する
    If lngCount = 0 Then
        vntArrPosCardPrintDate   = Array()
        Redim Preserve vntArrPosCardPrintDate(0)
        vntArrPosCardPrintDate(0)   = "未出力"
        strPosCardPrintDate         = vntArrPosCardPrintDate(0)
    End If

    Set objConsult = Nothing

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

    'フォロー対象者管理情報を読込む
    If FolRet = True Then
        '一度保存している場合はフォロー状況管理から抽出する。
        lngAllCount = objFollowUp.SelectFollow_I(lngRsvNo)

        If lngPageKey = 1 Then
            '検索条件に従い判定結果一覧を抽出する
            lngCount = objFollowUp.SelectJudHistoryRslList(lngRsvNo)
            lngAllCount = lngAllCount + lngCount
        End If

    Else
    '一度も保存していない場合は判定結果から判定の重いものを抽出する。
        '検索条件に従い判定結果一覧を抽出する
        lngAllCount = objFollowUp.SelectJudHistoryRslList(lngRsvNo)
    End If

    Set objFollowUp     = Nothing

End If

'-------------------------------------------------------------------------------
'
' 機能　　 : 表示条件の配列作成
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub CreatePageKeyInfo()


    Redim Preserve lngArrPageKey(1)
    Redim Preserve strArrPageKeyName(1)

    lngArrPageKey(0) = 0:strArrPageKeyName(0) = "保存データ"
    lngArrPageKey(1) = 1:strArrPageKeyName(1) = "Ｃ以上全て"

End Sub


'#### 2008.12.04 張 フォローアップ登録処理を内科と婦人科に分けて管理できるように検査条件追加）Start ####
'-------------------------------------------------------------------------------
'
' 機能　　 : 表示条件判定分類（内科・婦人科）の配列作成
'
' 引数　　 :
'
' 戻り値　 :
'
' 備考　　 :
'
'-------------------------------------------------------------------------------
Sub CreateJudClKeyInfo()

    Redim Preserve lngArrJudClKey(2)
    Redim Preserve strArrJudClKeyName(2)

    lngArrJudClKey(0) = 1:strArrJudClKeyName(0) = "内科"
    lngArrJudClKey(1) = 2:strArrJudClKeyName(1) = "婦人科"
    lngArrJudClKey(2) = 0:strArrJudClKeyName(2) = "すべて"

End Sub
'#### 2008.12.04 張 フォローアップ登録処理を内科と婦人科に分けて管理できるように検査条件追加）End   ####

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>面接支援ヘッダ</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
    // 保存処理
    function saveFollow() {

        // 入力チェック
    //  if ( !top.checkValue( 0 ) ) return;
        if ( !parent.checkValue( 0 ) ) return;

        // 確認メッセージの表示
        if ( !confirm('この内容で保存します。よろしいですか？') ) return;

        // submit処理
    //  top.submitForm('<%= MODE_SAVE %>');
        parent.submitForm('<%= MODE_SAVE %>');
    }
    // チャート情報表示処理
    function chartShow() {

    //  top.callCommentList();
        parent.callCommentList();

    }
    var winfolUpdateHistory;        // ウィンドウハンドル
    //変更履歴画面呼び出し
    function callfolUpdateHistory() {
        var url;                    // URL文字列
        var opened = false;         // 画面が開かれているか

        url = '/WebHains/contents/followUp/folUpdateHistory.asp?grpno=20';
    //  url = url + '&winmode=' + '<%= strWinMode %>';
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
            winfolUpdateHistory = window.open( url, '', 'width=1000,height=600,status=no,directories=no,menubar=no,resizable=no,toolbar=no' );
        }

    //  parent.location.href(url);

    }

    // 再表示処理
    function preView() {

        var myForm = document.titleForm;

        if (document.titleForm.rsvHistory.value >= 0) {
            myForm.rsvno.value = myForm.rsvHistory.value;
    //      parent.preView();
            parent.params.rsvno = myForm.rsvno.value;
            parent.params.pageKey = myForm.pageKey.value;

            /** 2008.12.04 張 フォローアップ登録処理を内科と婦人科に分けて管理できるように検査条件追加）Start **/
            parent.params.judClKey = myForm.judClKey.value;
            /** 2008.12.04 張 フォローアップ登録処理を内科と婦人科に分けて管理できるように検査条件追加）End   **/

            parent.params.motoRsvNo = myForm.motoRsvNo.value;
            common.submitCreatingForm(parent.location.pathname, 'post', '_parent', parent.params);
        }

    }
    // 更新者表示処理
    function updUserSet(updUserName, updDateName) {
        // 処理モードを設定する
        document.getElementById('updUserName').innerHTML = updUserName;
        document.getElementById('updDateName').innerHTML = updDateName;

    }
    // 子ウィンドウを閉じる
    function closeWindow() {

        // 変更履歴画面を閉じる
        if ( winfolUpdateHistory != null ) {
            if ( !winfolUpdateHistory.closed ) {
                winfolUpdateHistory.close();
            }
        }
        winfolUpdateHistory = null;
    }

//-->
</SCRIPT>
<script type="text/javascript" src="/webHains/js/common.js"></script>
<style type="text/css">
	body { margin: <%= IIF(strWinMode = 1,"12","0") %>px 0 0 <%= IIF(strWinMode = 1,"20","5") %>px; }
</style>
<STYLE TYPE="text/css">
td.prttab  { background-color:#ffffff }
</STYLE>
</HEAD>
<!-- #include virtual = "/webHains/includes/calGuide.inc" -->
<BODY ONUNLOAD="javascript:closeWindow()">
<%
    '「別ウィンドウで表示」の場合、ヘッダー部分表示
    If strWinMode = 1 Then
%>
<!-- #include virtual = "/webHains/includes/interviewHeader.inc" -->
<%
        Call interviewHeader(lngRsvNo, 0)
    End If
%>

<FORM NAME="titleForm" ACTION="<%= Request.ServerVariables("SCRIPT_NAME") %>" METHOD="get">
<INPUT TYPE="hidden" NAME="winmode" VALUE="<%= strWinMode %>">
<INPUT TYPE="hidden" NAME="rsvno" VALUE="<%= lngRsvNo %>">
<TABLE WIDTH="900" BORDER="0" CELLSPACING="0" CELLPADDING="0">
    <TR>
<%
        '「別ウィンドウで表示」の場合はスペースは要らない
        If strWinMode <> 1 Then
%>
            <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="1"></TD>
<%
        End If
%>
        <TD WIDTH="100%">
            <TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
                <TR>
<!--                    <TD NOWRAP BGCOLOR="#ffffff" width="<%= IIF(strWinMode = 1,"65%","795")%>" HEIGHT="15"><B><SPAN CLASS="follow">■</SPAN><FONT COLOR="#000000">フォローアップ照会</FONT></B></TD>-->
                    <TD NOWRAP BGCOLOR="#ffffff" width="<%= IIF(strWinMode = 1,"65%","730")%>" HEIGHT="15"><B><SPAN CLASS="follow">■</SPAN><FONT COLOR="#000000">フォローアップ照会</FONT></B></TD>
                    <TD NOWRAP BGCOLOR="#ffffff" width="250" HEIGHT="15"><FONT COLOR="#000000">最終更新日時：<SPAN ID="updDateName"><%=IIf(strUpdDate="" Or FolRet = False, "" , "(" & strUpdDate & ")")%></SPAN></FONT></TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
</TABLE>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
    <INPUT TYPE="hidden" NAME="motoRsvNo" VALUE="<%=strMotoRsvNo%>">
    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
    <TR>
        <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
            <TR>
<%
                '「別ウィンドウで表示」の場合はスペースは要らない
                If strWinMode <> 1 Then
%>
                    <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="1"></TD>
<%
                End If
%>
<%
                'チャート情報あり？
                If lngChartCnt > 0 Then
%>
                    <TD ALIGN="center" BGCOLOR="ffffff" WIDTH="100"><A HREF="javascript:chartShow()"><FONT  SIZE="-1" COLOR="FF00FF">チャート情報</FONT></A></TD>
<%
                Else
%>
                    <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="100"><A HREF="javascript:chartShow()"><IMAGE SRC="/webHains/images/chartinfo.gif" ALT="チャート情報を表示します" HEIGHT="24" WIDTH="100" BORDER="0"></A></TD>
<%
                End If
%>
                <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="1"></TD>
<%
                'フォロー情報あり？（修正）
                If FolRet = False Then
%>
                    <TD NOWRAP WIDTH="35"><B><FONT COLOR="FF00FF">新規</FONT></B></TD>
<%
                Else
%>
                    <TD NOWRAP><IMG SRC="/webHains/images/spacer.gif" WIDTH="35" HEIGHT="1"></TD>
<%
                End If
%>
                <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="20" HEIGHT="1"></TD>
                <TD><INPUT TYPE="checkbox" NAME="followCardFlg" VALUE="1" <%= IIf(strFollowCardFlg = "1", " CHECKED","") %>></TD>
                <TD NOWRAP>フォローアップはがき出力</TD>
                <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="1"></TD>
                <TD><INPUT TYPE="checkbox" NAME="followUpFlg" VALUE="1" <%= IIf(strFollowUpFlg = "1", " CHECKED","") %>></TD>
                <TD NOWRAP>フォローアップ対象者</TD>
                <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="<%= IIF(strWinMode = 1,"100","305")%>" HEIGHT="1"></TD>
<%
                If lngAllCount > 0 Then
                    if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then
%>
                        <TD><A HREF="javascript:saveFollow()"><IMG SRC="/webHains/images/save.gif" WIDTH="80" HEIGHT="21" ALT="変更した内容を保存します"></A></TD>
<%
                    end if
                Else
%>
                <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="80" HEIGHT="1"></TD>
<%
                End If
%>
                <!--<TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="1"></TD>-->
                <TD ALIGN="right" BGCOLOR="ffffff" WIDTH="120"><A HREF="javascript:callfolUpdateHistory()"><IMAGE SRC="/webHains/images/updatehistory.gif" ALT="変更履歴画面を表示します" HEIGHT="21" WIDTH="100" BORDER="0"></A></TD>
            </TR>
        </TABLE>
    </TR>
    <TR>
        <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
            <TR>
<%
                '「別ウィンドウで表示」の場合はスペースは要らない
                If strWinMode <> 1 Then
%>
                    <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="1"></TD>
<%
                End If
%>
                <TD>分類&nbsp;：&nbsp;</TD>
                <TD COLSPAN=2><%= EditDropDownListFromArray("judClKey", lngArrJudClKey, strArrJudClKeyName, lngJudClKey, NON_SELECTED_DEL) %></TD>
                <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="10" HEIGHT="1"></TD>
                <TD COLSPAN=2><%= EditDropDownListFromArray("pageKey", lngArrPageKey, strArrPageKeyName, lngPageKey, NON_SELECTED_DEL) %></TD>
                <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="60" HEIGHT="1"></TD>
                <!--TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="96" HEIGHT="1"></TD-->
                <TD>はがき出力日</TD>
                <TD COLSPAN=2><%= EditDropDownListFromArray("posCardPrintDate", vntArrPosCardPrintDate, vntArrPosCardPrintDate, strPosCardPrintDate, NON_SELECTED_DEL) %></TD>
                <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="1"></TD>
                <TD>表示受診日</TD>
                <TD COLSPAN=2><%= EditDropDownListFromArray("rsvHistory", vntArrHistoryRsvno, vntArrHistoryCslDate, lngRsvNo, NON_SELECTED_DEL) %></TD>
<!--                <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="<%= IIF(strWinMode = 1,IIF(vntArrPosCardPrintDate(0) = "未出力","82","2"),IIF(vntArrPosCardPrintDate(0) = "未出力","287","205"))%>" HEIGHT="1"></TD>-->
                <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="<%= IIF(strWinMode = 1,IIF(vntArrPosCardPrintDate(0) = "未出力","82","2"),IIF(vntArrPosCardPrintDate(0) = "未出力","100","50"))%>" HEIGHT="1"></TD>
                <TD><A HREF="javascript:preView()"><IMG SRC="/webHains/images/b_prev.gif" WIDTH="53" HEIGHT="28" ALT="指定条件で表示"></A></TD>
                <TD NOWRAP ALIGN="right" BGCOLOR="#ffffff" width="150" HEIGHT="15"><FONT COLOR="#000000">最終更新者：<SPAN ID="updUserName"><%=strUpdUserName%></SPAN></FONT></TD>
            </TR>
        </TABLE>
    </TR>
</TABLE>


</FORM>
<SCRIPT TYPE="text/javascript">
<!--
    var myForm =    document.headerForm;

//  myForm.selecturl.selectedIndex = '<%= lngIndex %>';
//-->
</SCRIPT>
</BODY>
</HTML>
