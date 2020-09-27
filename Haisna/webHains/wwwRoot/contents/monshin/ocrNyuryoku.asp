<%@ LANGUAGE="VBScript" %>
<%
'-----------------------------------------------------------------------------
'      OCR入力結果確認  (Ver0.0.1)
'      AUTHER  : K.Kagawa@FFCS
'-----------------------------------------------------------------------------
'管理番号：SL-UI-Y0101-103
'修正日  ：2010.06.03
'担当者  ：TCS)田村
'修正内容：ＯＣＲシート変更対応
'管理番号：SL-SN-Y0101-607
'修正日  ：2011.12.13
'担当者  ：SOAR)竹野内
'修正内容：前回複写ボタン


Option Explicit
%>
<!-- #include virtual = "/webHains/includes/checkSession.inc" -->
<!-- #include virtual = "/webHains/includes/common.inc" -->
<%
'セッション・権限チェック
Call CheckSession(BUSINESSCD_MAINTENANCE, CHECKSESSION_BUSINESS_TOP)
'-----------------------------------------------------------------------------
' 共通宣言部
'-----------------------------------------------------------------------------
Dim objRslOcrSp         'OCR入力結果アクセス用
'#### 2010.06.03 SL-UI-Y0101-103 ADD START ####'
Dim objFree             'OCR入力結果アクセス用
Const CHECK_CSLDATE2    = "2010/01/01"    '汎用マスタの設定がない場合用
Const FREECLASSCD_CHG   = "CHG"           '2011年対応　変更日付取得用

dim vntArrFree1
Dim strChgDate          '2011年対応　変更日付
'#### 2010.06.03 SL-UI-Y0101-103 ADD END ####'

'### 2008.03.26 張 特定健診関連問診項目追加により、問診情報確認画面仕様変更のため
'                  特定健診開始日を基準で画面切替
Const CHECK_CSLDATE     = "2008/04/01"    '問診情報確認画面切替基準日
Const CHECK_CSCD        = "100"           '問診情報確認画面切替基準コースコード（1日人間ドック）

'### 2010.04.05 張 職員定期健康診断（ドック）コース追加により、追加
Const CHECK_CSCD_COMP   = "105"           '問診情報確認画面切替基準コースコード（職員定期健康診断（ドック））

'パラメータ
Dim strWinMode          'ウィンドウモード
Dim lngRsvNo            '予約番号（今回分）
Dim strGrpNo            'グループNo
Dim strCsCd             'コースコード
Dim lngAnchor           '表示開始位置

Dim strUrlPara          'フレームへのパラメータ

'-----------------------------------------------------------------------------
' 先頭制御部
'-----------------------------------------------------------------------------
Dim strCslDate          'フレームへのパラメータ
Dim strCheckCSCD        'コースコード取得
Set objRslOcrSp     = Server.CreateObject("HainsRslOcrSp.OcrNyuryokuSp")
'#### 2010.06.03 SL-UI-Y0101-103 ADD START ####'
Set objFree         = Server.CreateObject("HainsFree.Free")

'汎用マスタより切り替え日取得
if objFree.SelectFreeByClassCd( 0,FREECLASSCD_CHG, , , , vntArrFree1 )  > 0 then
    strChgDate = vntArrFree1(0)
End if
If strChgDate = "" Then
    strChgDate = CHECK_CSLDATE2
End If
 '#### 2010.06.03 SL-UI-Y0101-103 ADD END ####'

'引数値の取得
strWinMode      = Request("winmode")
strGrpNo        = Request("grpno")
lngRsvNo        = Request("rsvno")
strCsCd         = Request("cscd")
lngAnchor       = CLng("0" & Request("anchor"))

'フレームへのパラメータ設定
strUrlPara = "?rsvno=" & lngRsvNo

'フレームの表示開始位置設定
Select Case lngAnchor
Case 1
    strUrlPara = strUrlPara & "&anchor=Anchor-DiseaseHistory"
Case 2
    strUrlPara = strUrlPara & "&anchor=Anchor-LifeHabit1"
Case 3
    strUrlPara = strUrlPara & "&anchor=Anchor-LifeHabit2"
Case 4
    strUrlPara = strUrlPara & "&anchor=Anchor-Fujinka"
Case 5
    strUrlPara = strUrlPara & "&anchor=Anchor-Syokusyukan"
Case 6
    strUrlPara = strUrlPara & "&anchor=Anchor-Morning"
Case 7
    strUrlPara = strUrlPara & "&anchor=Anchor-Lunch"
Case 8
    strUrlPara = strUrlPara & "&anchor=Anchor-Dinner"
'### 2008.03.25 張 特定健診項目追加によって追加 Start ###
Case 9
    strUrlPara = strUrlPara & "&anchor=Anchor-Special"
'### 2008.03.25 張 特定健診項目追加によって追加 End   ###

'### 2016.03.31 張 内視鏡関連項目表示の為追加 Start ###
Case 10
    strUrlPara = strUrlPara & "&anchor=Anchor-Stomach"
'### 2016.03.31 張 内視鏡関連項目表示の為追加 End   ###

End Select

'### 2008.03.25 張 予約番号をキーにして該当受診者の受診日を取得し、該当受診日に合わせて問診登録画面表示するために追加 ###
strCslDate = objRslOcrSp.CheckCslDate(lngRsvNo,strCheckCSCD)

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<HTML LANG="ja">
<HEAD>
<META HTTP-EQUIV="content-type" CONTENT="text/html;charset=Shift_JIS">
<META NAME="generator" CONTENT="Adobe GoLive 6">
<TITLE>OCR入力結果確認</TITLE>
<SCRIPT TYPE="text/javascript">
<!--
// エラー情報は各フレームで共通
var lngErrCount;        // エラー数
var varErrNo;           // エラーNo
var varErrState;        // エラー状態
var varErrMessage;      // エラーメッセージ

// エラー情報の初期化
function initErrInfo() {

    // エラー情報の初期化
    lngErrCount = 0;
    varErrNo = new Array();
    varErrState = new Array();
    varErrMessage = new Array();
    varErrState.length = 0;
    varErrMessage.length = 0;
}

// エラー情報追加
function addErrInfo(no, state, message) {

    varErrNo.length ++;
    varErrState.length ++;
    varErrMessage.length ++;
    varErrNo[lngErrCount] = no;
    varErrState[lngErrCount] = state;
    varErrMessage[lngErrCount] = message;
    lngErrCount ++;
}

// SL-UI-Y0101-607 前回複写ボタン追加 Start
// エラー情報削除
function delErrInfo(no, state, message) {
    for(i = 0; i < varErrMessage.length; i++){
        if(varErrMessage[i] == message){
            lngErrCount --;
            varErrMessage.splice(i,1);
            varErrNo.splice(i,1); 
            varErrState.splice(i,1); 
            break;
        }
    }
}
// SL-UI-Y0101-607 前回複写ボタン追加 End

var params = {
    winmode: "<%= strWinMode %>",
    grpno:   "<%= strGrpNo %>",
    rsvno:   "<%= lngRsvNo %>",
    cscd:    "<%= strCsCd %>",
    nomsg:   ""
};
//-->
</SCRIPT>
</HEAD>
    <FRAMESET ROWS="130,*,100">
<%
'## 2012.09.11 Add by T.Takagi@RD 切替日付による画面切替
    '切替日以降の受診日であれば2012年版用の画面へ
    If IsVer201210(lngRsvNo) Then
%>
        <FRAME NAME="header" SRC="ocrNyuryokuSpHeader201210.asp<%= strUrlPara %>">
        <FRAME NAME="list"   SRC="ocrNyuryokuSpBody201210.asp<%= strUrlPara %>">
        <FRAME NAME="error"  SRC="ocrNyuryokuSpErr201210.asp<%= strUrlPara %>">
<%
    Else
'## 2012.09.11 Add End
%>
    <!--#### 2008.03.25 張 受診日によって問診情報確認画面を切り替えるように修正 Start ####-->

    <!--#### 2010.04.05 張 職員定期健康診断（ドック）コース追加により、修正 Start ####-->
    <%  'If CDate(strCslDate) >= CDate(CHECK_CSLDATE) and strCheckCSCD = CHECK_CSCD Then     %>
    <%  If CDate(strCslDate) >= CDate(CHECK_CSLDATE) and (strCheckCSCD = CHECK_CSCD or strCheckCSCD = CHECK_CSCD_COMP) Then     %>
    <!--#### 2010.04.05 張 職員定期健康診断（ドック）コース追加により、修正 End   ####-->
<% '#### 2010.06.03 SL-UI-Y0101-103 ADD START ####' %>
        <% 'OCRシート変更対応 リンク分岐追加　%>
        <%  If CDate(strCslDate) >= CDate(strChgDate)  Then     %>
            <FRAME NAME="header" SRC="ocrNyuryokuSpHeader2.asp<%= strUrlPara %>">
            <FRAME NAME="list"   SRC="ocrNyuryokuSpBody2.asp<%= strUrlPara %>">
            <FRAME NAME="error"  SRC="ocrNyuryokuSpErr2.asp<%= strUrlPara %>">
        <%  Else     %>
<% '#### 2010.06.03 SL-UI-Y0101-103 ADD END ####' %>
            <FRAME NAME="header" SRC="ocrNyuryokuSpHeader.asp<%= strUrlPara %>">
            <FRAME NAME="list"   SRC="ocrNyuryokuSpBody.asp<%= strUrlPara %>">
            <FRAME NAME="error"  SRC="ocrNyuryokuSpErr.asp<%= strUrlPara %>">
<% '#### 2010.06.03 SL-UI-Y0101-103 ADD START ####' %>
        <%  End If     %>
<% '#### 2010.06.03 SL-UI-Y0101-103 ADD END ####' %>
    <%  Else     %>
<% '#### 2011.01.05 SL-UI-Y0101-103 ADD START ####' %>
        <% 'OCRシート変更対応 リンク分岐追加　%>
        <%  If CDate(strCslDate) >= CDate(strChgDate)  Then     %>
            <FRAME NAME="header" SRC="ocrNyuryokuSpHeader2.asp<%= strUrlPara %>">
            <FRAME NAME="list"   SRC="ocrNyuryokuSpBody2.asp<%= strUrlPara %>">
            <FRAME NAME="error"  SRC="ocrNyuryokuSpErr2.asp<%= strUrlPara %>">
        <%  Else     %>
<% '#### 2011.01.05 SL-UI-Y0101-103 ADD END ####' %>
            <FRAME NAME="header" SRC="ocrNyuryokuHeader.asp<%= strUrlPara %>">
            <FRAME NAME="list"   SRC="ocrNyuryokuBody.asp<%= strUrlPara %>">
            <FRAME NAME="error"  SRC="ocrNyuryokuErr.asp<%= strUrlPara %>">
<% '#### 2011.01.05 SL-UI-Y0101-103 ADD START ####' %>
        <%  End If     %>
<% '#### 2011.01.05 SL-UI-Y0101-103 ADD END ####' %>
    <%  End If     %>
    <!--#### 2008.03.25 張 受診日によって問診情報確認画面を切り替えるように修正 End   ####-->
<%
'## 2012.09.11 Add by T.Takagi@RD 切替日付による画面切替
    End If
%>
        <NOFRAMES>
            <BODY BGCOLOR="#ffffff">
                <P></P>
            </BODY>
        </NOFRAMES>
    </FRAMESET>
</HTML>
