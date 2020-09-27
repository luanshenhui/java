<%@ LANGUAGE="VBScript" %>
<% 
'-----------------------------------------------------------------------------
'		予約のキャンセル (Ver0.0.1)
'		AUTHER  : Tsutomu Takagi@fsit.fujitsu.com
'-----------------------------------------------------------------------------
Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc"       -->
<%
Call CheckSession(BUSINESSCD_RESERVE, CHECKSESSION_CLOSE)

'-------------------------------------------------------------------------------
' 共通宣言部
'-------------------------------------------------------------------------------
Const MODE_CANCEL   = "cancel"	'処理モード(受付取り消し)

Const FREECD_CANCEL = "CANCEL"	'汎用コード(キャンセル理由)

'データベースアクセス用オブジェクト
Dim objFree			'汎用情報アクセス用

'キャンセル理由
Dim strFreeCd		'汎用コード
Dim strFreeField1	'汎用フィールド1
Dim lngCount		'レコード数

Dim strCancelFlg()	'キャンセル理由
Dim i				'インデックス

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
'オブジェクトのインスタンス作成
Set objFree = Server.CreateObject("HainsFree.Free")
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<LINK REL="stylesheet" TYPE="text/css" HREF="/webHains/contents/css/default.css">
<TITLE>予約のキャンセル</TITLE>
<SCRIPT TYPE="text/javascript" LANGUAGE="JavaScript">
<!--
function cancel() {

    var myForm   = document.entryForm;					// 自画面のフォームエレメント
    var mainForm = opener.top.main.document.entryForm;	// メイン画面のフォームエレメント

    // キャンセル理由の必須チェック
    if ( myForm.cancelFlg.value == '' ) {
        alert('キャンセル理由を指定して下さい。');
        return;
    }

    // キャンセル理由及び強制フラグを指定
    mainForm.cancelFlg.value   = myForm.cancelFlg.value;
    mainForm.cancelForce.value = myForm.notCancelForce.checked ? '' : '1';

    // 予約情報詳細画面のsubmit処理
    opener.top.submitForm('<%= MODE_CANCEL %>');

    close();

}
//-->
</SCRIPT>
<style type="text/css">
	body { margin: 15px 0 0 20px; }
</style>
</HEAD>
<BODY>
<FORM NAME="entryForm" ONSUBMIT="JavaScript:return false" action="#">

    <TABLE BORDER="0" CELLPADDING="2" CELLSPACING="1" BGCOLOR="#999999" WIDTH="100%">
        <TR>
            <TD HEIGHT="15" BGCOLOR="#ffffff" NOWRAP><B><SPAN CLASS="reserve">■</SPAN><FONT COLOR="#000000">予約のキャンセル</FONT></B></TD>
        </TR>
    </TABLE>

    <BR>
<%
    '汎用テーブルからキャンセル理由を読み込む
'### 2007/02/08 張 キャンセル理由を表示する時、汎用コードではなく登録された順番(FREEFIELD3)によって表示するように変更 Start ###
    'lngCount = objFree.SelectFree(1, FREECD_CANCEL, strFreeCd, , ,strFreeField1)
    lngCount = objFree.SelectFree(3, FREECD_CANCEL, strFreeCd, , ,strFreeField1)
'### 2007/02/08 張 キャンセル理由を表示する時、汎用コードではなく登録された順番(FREEFIELD3)によって表示するように変更 End   ###

    If lngCount > 0 Then

        '汎用コードからキャンセル理由用の接頭子を削除する
        Redim Preserve strCancelFlg(lngCount - 1)
        For i = 0 To lngCount - 1
            strCancelFlg(i) = Right(strFreeCd(i), Len(strFreeCd(i)) - Len(FREECD_CANCEL))
        Next
%>
        この予約情報をキャンセルします。<BR><BR>

        <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
            <TR>
                <TD>キャンセル理由：</TD>
                <TD><%= EditDropDownListFromArray("cancelFlg", strCancelFlg, strFreeField1, Empty, Empty) %></TD>
            </TR>
        </TABLE>
<%
    Else
%>
        キャンセル理由が登録されていません。
<%
    End If
%>
    <BR>

    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="0">
        <TR>
            <TD><INPUT TYPE="checkbox" NAME="notCancelForce" CHECKED></TD>
            <TD NOWRAP>問診が入力されている場合はキャンセルを行わない</TD>
        </TR>
    </TABLE>

    <BR>

    <TABLE BORDER="0" CELLSPACING="0" CELLPADDING="3" ALIGN="right">
        <TR>
<%
            'キャンセル理由が登録されている場合のみ確定ボタンを編集する
            If lngCount > 0 Then
%>
                <TD><A HREF="JavaScript:cancel()"><IMG SRC="/webHains/images/ok.gif" WIDTH="77" HEIGHT="24" ALT="この内容で予約確定"></A></TD>
<%
            End If
%>
            <TD><A HREF="JavaScript:close()"><IMG SRC="/webHains/images/cancel.gif" WIDTH="77" HEIGHT="24" ALT="キャンセルする"></A></TD>
        </TR>
    </TABLE>

</FORM>
</BODY>
</HTML>
