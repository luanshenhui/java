<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'       フォローアップ結果登録メイン (Ver0.0.1)
'       AUTHER  :
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
'パラメータ
Dim strWinMode          'ウィンドウモード
Dim lngRsvNo            '予約番号（今回分）
Dim lngJudClassCd       '判定分類コード

Dim strAct              '処理状態
Dim strUrlPara          'フレームへのパラメータ

'-------------------------------------------------------------------------------
' 先頭制御部
'-------------------------------------------------------------------------------
strWinMode          = Request("winmode")
lngRsvNo            = Request("rsvno")
lngJudClassCd       = Request("judclasscd")

'フレームへのパラメータ設定
strUrlPara = "?winmode=" & strWinMode 
strUrlPara = strUrlPara & "&rsvno=" & lngRsvNo
strUrlPara = strUrlPara & "&judclasscd=" & lngJudClassCd

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<meta http-equiv="Content-Style-Type"  content="text/css">
<meta http-equiv="Content-Script-Type" content="text/javascript">
<TITLE>フォローアップ結果登録</TITLE>
<SCRIPT TYPE="text/javascript">
<!--

    // submit処理
    function submitForm( mode ) {

        // 処理モードを設定する
//        var mainForm = main.document.resultList;    // メイン画面のフォームエレメント
//        var titleForm  = header.document.titleForm; // ヘッダ画面のフォームエレメント
//        mainForm.action.value = mode;
//        mainForm.followUpFlg.value = (titleForm.followUpFlg.checked) ? titleForm.followUpFlg.value:'0';
//        mainForm.followCardFlg.value = (titleForm.followCardFlg.checked) ? titleForm.followCardFlg.value:'0';
//        mainForm.rsvno.value = titleForm.rsvno.value;
//
//        // メイン画面をsubmit
//        mainForm.submit();

    }

var params = {
    winmode:    "<%= strWinMode %>",
    rsvno:      "<%= lngRsvNo %>",
    judclasscd: "<%= lngJudClassCd %>"
};
//-->
</SCRIPT>

</HEAD>
<FRAMESET ROWS="<%=IIf(strWinMode=1,174,80) & ",*" %> BORDER="0" FRAMESPACING="0" FRAMEBORDER="no">
    <FRAME NAME="header"    SRC="followupRslHeader.asp<%=strUrlPara%>">
    <FRAME NAME="main"      SRC="followupRslEditBody.asp<%=strUrlPara%>">
</FRAMESET>
</HTML>
