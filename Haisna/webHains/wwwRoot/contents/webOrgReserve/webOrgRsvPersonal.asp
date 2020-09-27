<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      web予約情報登録(受診付属情報) (Ver1.0.0)
'      AUTHER  : 
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Dim blnReadOnly     '読み込み専用

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
blnReadOnly = (Request("readOnly") <> "")
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>予約情報詳細(受診付属情報)</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
var winPersonal;    // ウィンドウハンドル

// 受診付属情報詳細画面呼び出し
function callPersonalDetailWindow() {

    var detailForm = top.detail.document.paramForm;

    var opened = false;     // 画面が開かれているか
    var url;                // 受診付属情報詳細画面のURL

    // 他サブ画面を閉じる
    top.closeWindow( 5 );

    // すでにガイドが開かれているかチェック
    if ( winPersonal != null ) {
        if ( !winPersonal.closed ) {
            opened = true;
        }
    }

    // 受診付属情報詳細画面のURL編集
    url = 'webOrgRsvPersonalDetail.asp';

    // 紹介者、前回受診日を追加
    url = url + '?introductor=' + detailForm.introductor.value;
    url = url + '&lastCslDate=' + detailForm.lastCslDate.value;

    // 基本情報にて団体が指定されている場合は追加
    if ( detailForm.orgCd1.value != '' && detailForm.orgCd2.value != '' ) {
        url = url + '&orgCd1=' + detailForm.orgCd1.value;
        url = url + '&orgCd2=' + detailForm.orgCd2.value;
    }

    // 読み込み専用フラグの追加
    url = url + '&readOnly=' + '<%= IIf(blnReadOnly, "1", "") %>';

    // 開かれている場合は画面をFOCUSし、さもなくば新規画面を開く
    if ( opened ) {
        winPersonal.focus();
    } else {
        winPersonal = window.open( url, '', 'width=500,height=550,status=yes,directories=no,menubar=no,resizable=yes,toolbar=no,scrollbars=yes' );
    }

}

// 受診付属情報詳細画面を閉じる
function closePersonalDetailWindow() {

    if ( winPersonal != null ) {
        if ( !winPersonal.closed ) {
            winPersonal.close();
        }
    }

    winPersonal = null;
}

// 初期処理
function initialize() {

    // 基本情報での保持値を本画面に設定する
    top.getPersonalValue();
<%
    '読み取り専用時はすべての入力要素を使用不能にする
    If blnReadOnly Then
%>
        top.disableElements( document.entryForm );
<%
    End If
%>
}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 0 0 0 8px; }
</style>
</HEAD>
<BODY ONLOAD="javascript:initialize()" ONUNLOAD="javascript:closePersonalDetailWindow()">
<FORM NAME="entryForm" action="#">
    <TABLE WIDTH="100%" BORDER="0" CELLSPACING="1" CELLPADDING="2" BGCOLOR="#999999">
        <TR>
            <TD NOWRAP BGCOLOR="#eeeeee" HEIGHT="15"><B><FONT COLOR="#333333">受診付属情報</FONT></B></TD>
        </TR>
    </TABLE>
    <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">
        <TR>
            <TD HEIGHT="5"></TD>
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
        <TR>
            <TD HEIGHT="5"></TD>
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
    </TABLE>
</FORM>
<A HREF="javascript:callPersonalDetailWindow()">その他の付属情報を<%= IIf(blnReadOnly, "見る", "入力") %></A>
</BODY>
</HTML>
