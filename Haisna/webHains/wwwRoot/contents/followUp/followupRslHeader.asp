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
Dim strWinMode          'ウィンドウモード
Dim lngRsvNo            '予約番号
Dim lngJudClassCd       '判定分類コード

Dim strUpdUser          '更新者
Dim strUpdUserName      '更新者名

Dim lngCount            '
Dim lngAllCount         '

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objConsult  = Server.CreateObject("HainsConsult.Consult")
Set objFollowUp = Server.CreateObject("HainsFollowUp.FollowUp")

'引数値の取得
strWinMode          = Request("winmode")
lngRsvNo            = Request("rsvno")
lngJudClassCd       = Request("judclasscd")
strUpdUser          = Session.Contents("userId")

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

        // 確認メッセージの表示
        if ( !confirm('この内容で保存します。よろしいですか？') ) return;

        // submit処理
        parent.submitForm('<%= MODE_SAVE %>');
    }


    // 再表示処理
    function preView() {

    }

    // 子ウィンドウを閉じる
    function closeWindow() {

    }

//-->
</SCRIPT>
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
<INPUT TYPE="hidden" NAME="winmode"     VALUE="<%= strWinMode %>">
<INPUT TYPE="hidden" NAME="rsvno"       VALUE="<%= lngRsvNo %>">
<INPUT TYPE="hidden" NAME="judclasscd"  VALUE="<%= lngJudClassCd %>">
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
                    <TD NOWRAP BGCOLOR="#ffffff" width="<%= IIF(strWinMode = 1,"65%","730")%>" HEIGHT="15"><B><SPAN CLASS="follow">■</SPAN><FONT COLOR="#000000">フォローアップ結果登録</FONT></B></TD>
                </TR>
            </TABLE>
        </TD>
    </TR>
</TABLE>
<TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
    <TR>
        <TD HEIGHT="3"></TD>
    </TR>
    <TR>
        <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
            <TR>
                <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="21" HEIGHT="1"></TD>
<%
                if Session("PAGEGRANT") = "2" or Session("PAGEGRANT") = "4" then
%>
                        <TD><A HREF="javascript:saveFollow()"><IMG SRC="/webHains/images/save.gif" WIDTH="80" HEIGHT="21" ALT="変更した内容を保存します"></A></TD>
<%
                end if
%>
                <TD><IMG SRC="/webHains/images/spacer.gif" WIDTH="80" HEIGHT="1"></TD>
            </TR>
        </TABLE>
    </TR>
</TABLE>


</FORM>
<SCRIPT TYPE="text/javascript">
<!--
    var myForm =    document.headerForm;
-->
</SCRIPT>
</BODY>
</HTML>
